import <pcklutil.ash>

boolean[item] fiveSpleen = $items[
	breathetastic canned air,
	instant karma,
];

boolean[item] fourSpleen = $items[
	agua de vida,
	coffee pixie stick,
	glimmering roc feather,
	not-a-pipe,
];

boolean[item] allWads = $items[
	cold wad,
	hot wad,
	sleaze wad,
	spooky wad,
	stench wad,
	twinkly wad,
];

void initAutoEat() {
	set_property(propCampgroundCock, false);
	set_property(propCampgroundOven, false);
}

boolean getCock() {
	boolean checkCock() {
		string kitchen = visit_url("campground.php?action=inspectkitchen");
		if (contains_text(kitchen, "/cocktailkit.gif")) {
			set_property(propCampgroundCock, true);
			return true;
		}
		return false;
	}

	if (get_property(propCampgroundCock) || checkCock())
		return true;
	if (my_meat() < 1000)
		return false;

	retrieve_item(1, $item[queue du coq]);
	use(1, $item[queue du coq]);
	return checkCock();
}

boolean getOven() {
	boolean checkOven() {
		string kitchen = visit_url("campground.php?action=inspectkitchen");
		if (contains_text(kitchen, "/oven.gif")) {
			set_property(propCampgroundOven, true);
			return true;
		}
		return false;
	}

	if (get_property(propCampgroundOven) || checkOven())
		return true;
	if (my_meat() < 1000)
		return false;

	retrieve_item(1, $item[dramatic range]);
	use(1, $item[dramatic range]);
	return checkOven();
}

void prepForEating() {
	// createable_amount(item) doesn't consider items you could summon or get.
	// Obtain a minimal of amount of everything we might need.

	int desiredNoodles = 1;
	int desiredReagents = 1;

	if (have_skill($skill[pastamastery])) {
		int noodles = item_amount($item[dry noodles]);
		if (noodles < desiredNoodles) {
			use_skill(desiredNoodles - noodles, $skill[pastamastery]);
		}
	}
	if (have_skill($skill[advanced saucecrafting])) {
		int reagents = item_amount($item[scrumptious reagent]);
		if (reagents < desiredReagents) {
			use_skill(desiredReagents - reagents, $skill[advanced saucecrafting]);
		}
	}
}

// 6 fullness pastas that are always good to eat.
boolean[item] reagentPasta = $items[
	hell ramen,
	fettucini inconnu,
	gnocchetti di nietzsche,
	spaghetti with skullheads,
];

// Eat food.  If force is true, use at least one thing if possible.
// Returns true if something was eaten.
boolean autoEat(boolean force) {
	int fullnessLeft() {
		return fullness_limit() - my_fullness();
	}

	boolean haveMilk() {
		// Assumption: reagents already summoned.
		return haveItem($item[milk of magnesium]) || haveItem($item[glass of goat's milk]) && haveItem($item[scrumptious reagent]);
	}

	boolean couldEatFortuneCookie() {
		return get_property(propNeedFortuneCookie).to_boolean() && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount();
	}

	int foodAmount(item thing) {
		return creatable_amount(thing) + item_amount(thing);
	}

	if (fullnessLeft() == 0)
		return false;

	boolean consumed = false;

	if (contains_text(get_counters(semirareWindowCounter, 0, 10), semirareWindowCounter) && couldEatFortuneCookie()) {
		eat(1, $item[fortune cookie]);
		consumed = true;
	}

	if (my_level() < 2 || my_meat() < 1500 || !getOven())
		return consumed;

	// Eat when we get low on adventures
	if (my_adventures() < 5)
		force = true;

	if (haveMilk()) {
		int remaining = fullnessLeft();

		int[item] toEat;
		foreach thing in reagentPasta {
			int couldMake = foodAmount(thing);
			if (couldMake == 0)
				continue;
			
			while (couldMake > 0 && remaining >= 6) {
				if (toEat contains thing) {
					toEat[thing] += 1;
				} else {
					toEat[thing] = 1;
				}
				couldMake -= 1;
				remaining -= 6;
			}
		}

		// If we have milk, wait on big pasta
		if (!force && remaining >= 6)
			return consumed;

		int[item] consider;
		consider[$item[badass pie]] = 2;
		consider[$item[knob pasty]] = 1;
		consider[$item[tasty tart]] = 1;
		consider[$item[painful penne pasta]] = 3;
		foreach thing in consider {
			if (foodAmount(thing) == 0)
				continue;
			
			int couldMake = remaining / consider[thing];
			if (toEat contains thing) {
				toEat[thing] += 1;
			} else {
				toEat[thing] = 1;
			}
			couldMake -= 1;
			remaining -= consider[thing];
		}

		// FIXME: Consider eating more food

		if (remaining == 0) {
			foreach thing in toEat {
				retrieve_item(toEat[thing], thing);
			}
			retrieve_item(1, $item[milk of magnesium]);
			use(1, $item[milk of magnesium]);
			foreach thing in toEat {
				eat(toEat[thing], thing);
			}
		}
	} else {
		if (!force)
			return consumed;

		boolean saveRoomForPasta() {
			return my_level() >= 6 && fullnessLeft() >= 6;
		}

		boolean haveRoomFor(int amount) {
			return fullnessLeft() >= amount && (!saveRoomForPasta() || fullnessLeft() % 6 >= amount);
		}

		prepForEating();
		if (saveRoomForPasta()) {
			// FIXME: sort reagent pasta by stat
			foreach thing in reagentPasta {
				if (fullnessLeft() < 6)
					break;
				if (foodAmount(thing) == 0)
					continue;
				retrieve_item(1, thing);
				eat(1, thing);
				return true;
			}
		}

		// FIXME: use mafia's food tables
		int[item] awesomeFood;
		if (my_level() >= 4)
			awesomeFood[$item[badass pie]] = 2;
		awesomeFood[$item[knob pasty]] = 1;
		awesomeFood[$item[tasty tart]] = 1;

		foreach thing in awesomeFood {
			if (!haveItem(thing))
				continue;
			int foodFull = awesomeFood[thing];
			if (!haveRoomFor(foodFull))
				continue;
			eat(1, thing);
			return true;
		}

		if (haveItem($item[dry noodles]) && haveRoomFor(3)) {
			hermit(1, $item[jabanero pepper]);
			retrieve_item(1, $item[painful penne pasta]);
			eat(1, $item[painful penne pasta]);

			trySoak();

			return true;
		}

		abort("Need to eat food, but don't know what to eat.  :(");
	}

	return consumed;
}

// Use spleen items.  If force is true, use at least one thing if possible.
// Returns true if spleen item was used.
boolean autoSpleen(boolean force) {
	// Assumption: all pulverization has already been done.
	// FIXME: Use malus to turn nuggets -> wads.
	// FIXME: Consider prismatic wads.

	int spleenLeft() {
		return spleen_limit() - my_spleen_use();
	}

	// FIXME: Consider using stat-increasing spleen items (giant moxie weed)
	// if the level is so low that wads will never be possible.

	if (my_level() < 4 || spleenLeft() == 0)
		return false;

	// Prep.
	while (item_amount($item[game grid token]) > 0) {
		visit_url("arcade.php?action=skeeball&pwd");
	}
	if (haveItem($item[game grid ticket])) {
		retrieve_item(item_amount($item[game grid ticket]) / 10, $item[coffee pixie stick]);
	}

	boolean usedSomething = false;

	if (my_level() >= 9) {
		foreach thing in fiveSpleen {
			if (spleenLeft() < 5)
				break;
			if (item_amount(thing) == 0)
				continue;
			usedSomething = true;
			use(1, thing);
		}
	}

	// Only use a mojo filter if it will create room for another 4 spleen item.
	boolean filterUseful = (spleenLeft() % 4 == 1 || have_skill($skill[spleen of steel]));
	if (filterUseful && my_spleen_use() > 0 && item_amount($item[mojo filter]) > 0) {
		use(1, $item[mojo filter]);
	}

	// If there's room for any of these spleen items, use them immediately.
	foreach thing in fourSpleen {
		if (spleenLeft() < 4)
			break;
		if (item_amount(thing) == 0)
			continue;
		usedSomething = true;
		use(1, thing);
	}

	// Postpone wads if there's a remote chance we could get a mojo filter.
	boolean waitOnFilter = my_level() >= 10 && !bcascStage("macguffinpyramid");
	boolean useWads = force || !waitOnFilter;

	// Wads require level 6.
	if (!useWads || my_level() < 6 || spleenLeft() == 0)
		return usedSomething;

	// FIXME: Sort wads by stat relevance
	foreach thing in allWads {
		if (spleenLeft() == 0 || spleenLeft() % 4 == 0)
			break;
		if (item_amount(thing) == 0)
			continue;
		usedSomething = true;
		use(1, thing);
	}

	return usedSomething;
}

void autoConsume(location loc) {

	if (my_daycount() == 1 && my_inebriety() == 0 && stillAvailable()) {
		tryCast($skill[mojomuscular melody]);
		retrieve_item(1, $item[tonic water]);
		use(1, $item[tonic water]);
		use_skill(1, $skill[ode to booze]);
		cli_execute("garden pick");
		cli_execute("drink 3 pumpkin beer");

		// Hack: in case we levelled up, refresh current quests.
		cli_execute("council");
	}

	autoSpleen(false);
	autoEat(false);
}
