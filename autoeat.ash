import <pcklutil.ash>

void initAutoEat() {
	set_property(propCookware, false);
}

boolean[item] fourSpleen = $items[
	agua de vida,
	coffee pixie stick,
	glimmering roc feather,
];

boolean[item] allWads = $items[
	cold wad,
	hot wad,
	sleaze wad,
	spooky wad,
	stench wad,
	twinkly wad,
];

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

	// Only use a mojo filter if it will create room for another 4 spleen item.
	boolean filterUseful = (spleenLeft() % 4 == 1 || have_skill($skill[spleen of steel]));
	if (filterUseful && my_spleen_use() > 0 && item_amount($item[mojo filter]) > 0) {
		use(1, $item[mojo filter]);
	}

	boolean usedSomething = false;

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

void autoEat(location loc) {

	if (!get_property(propCookware).to_boolean() && bcascStage("tavern") && my_meat() >= 2500) {
		string kitchen = visit_url("campground.php?action=inspectkitchen");
		if (!contains_text(kitchen, "/oven.gif")) {
			retrieve_item(1, $item[dramatic range]);
			use(1, $item[dramatic range]);
		}
		if (!contains_text(kitchen, "/cocktailkit.gif")) {
			retrieve_item(1, $item[queue du coq]);
			use(1, $item[queue du coq]);
		}
		set_property(propCookware, true);
	}

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

	// FIXME: Be smarter about when to eat fortune cookies.  No need to eat until the window is up, which may roll over.
	if (my_daycount() == 1 && my_turncount() > 5 && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount()) {
		if (my_fullness() == 0) {
			eat(1, $item[fortune cookie]);
		}
	}

	if (!get_property(propCookware).to_boolean())
		return;

	if (my_daycount() == 1 && my_level() >= 3) {
		// TODO save room for boss pie
		while (fullness_limit() - my_fullness() >= 3 && my_meat() >= 500) {
			if (item_amount($item[dry noodles]) == 0) {
				if (my_mp() < mp_cost($skill[pastamastery]) && retrieve_item(1, $item[tonic water])) {
					use(1, $item[tonic water]);
				}
				use_skill(1, $skill[pastamastery]);
			}
			if (item_amount($item[dry noodles]) == 0) {
				abort("No noodles");
			}

			hermit(1, $item[jabanero pepper]);
			create(1, $item[painful penne pasta]);
			eat(1, $item[painful penne pasta]);
		}

		if (have_effect($effect[beaten up]) > 0) {
			trySoak();
		}
	}

	if (get_property(propCookware).to_boolean() && my_level() >= 4 && bcascStage("tavern")) {
		// TODO picklish make 2-3 tavern drinks
		// TODO picklish call EatDrink.ash for the rest
	}

	autoSpleen(false);
}
