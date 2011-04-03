import <pcklutil.ash>

record MafiaEntry {
	int fullness;
	int levelReq;
	string advRange;
	string musRange;
	string mysRange;
	string moxRange;
	//string note;
};

boolean dataFilesLoaded = false;
MafiaEntry[item] mafiaFood;
MafiaEntry[item] mafiaDrink;

boolean loadMafiaDataFiles() {
	if (dataFilesLoaded)
		return true;

	if (!file_to_map("fullness.txt", mafiaFood))
		return false;

	if (!file_to_map("fullness.txt", mafiaDrink))
		return false;
	
	dataFilesLoaded = true;
	return true;
}

record FoodInfo {
	int quantity;
	float quality;
};

record FoodList {
	int[item] foodList;
	int totalFullness;
	float totalQuality;
};

// For a given max fullness level and set of foods, return the optimal menu.
FoodList findBest(FoodInfo[item] foods, int maxFullness) {
	// Deciding what to eat is the bounded knapsack problem.  Given that
	// maxFull <= 35, we can do a dynamic programming approach considering the
	// foods at ascending levels of fullness.  Silly NP complete problems.  Try
	// to keep the food list small, because this is of complexity
	// O(maxFullness^2 * count(foods)).

	// WTF WTF WTF.  Sort destroys the association between keys and values.
	// So, create a second array of "just" the food items, so that we can
	// sort by value and not destroy the information passed into this func.
	boolean[item] foodKeys;
	foreach thing in foods {
		foodKeys[thing] = true;
	}
	sort foodKeys by -foods[index].quality;

	// Sparse array of best foods for a given fullness level.
	FoodList[int] bestFood;

	// Loop through foods at a given level of fullness.
	for foodFullness from 1 to maxFullness {
		// For all the food at that level, try to calculate the best
		// fullness at every level.

		int foodCount = 0;
		boolean lastFoodBetter = true;
		foreach thing in foodKeys {
			// If the last food of this fullness level did not result in
			// an improvement, then no other food at this fullness could.
			if (!lastFoodBetter)
				break;

			if (thing.fullness != foodFullness)
				continue;

			// We are now considering this food, so reset the flag.
			lastFoodBetter = false;

			// Optimization to cut the list of foods short.  Given that the
			// food list is sorted by quality, if we have already
			// considered a better food (of foodFullness) then we know that
			// we can't get any better except at higher fullness levels
			// where we may have run out of that better food.
			int startFullness = foodFullness * (foodCount + 1);
			foodCount += foods[thing].quantity;
			// No need to consider any more foods at foodFullness level.
			if (startFullness > maxFullness)
				break;

			// See if eating this food will improve the total quality at higher
			// levels of fullness.
			for fullness from maxFullness downto startFullness {
				float bestQuality = 0.0;
				if (bestFood contains fullness)
					bestQuality = bestFood[fullness].totalQuality;

				float foodQuality = foods[thing].quality;
				int maxQuantity = min(foods[thing].quantity, fullness / foodFullness);
				for quantity from 1 to maxQuantity {
					int remaining = fullness - quantity * foodFullness;

					float remainingQuality = 0.0;
					if (bestFood contains remaining)
						remainingQuality = bestFood[remaining].totalQuality;
					else if (remaining != 0)
						// If there is no amount of food that can add up
						// to this fullness level, then skip.
						continue;

					float quality = foodQuality * quantity + remainingQuality;
					if (quality < bestQuality)
						continue;

					bestFood[fullness].foodList.clear();
					if (remaining > 0) {
						foreach thing in bestFood[remaining].foodList {
							bestFood[fullness].foodList[thing] = bestFood[remaining].foodList[thing];
						}
					}
					if (bestFood[fullness].foodList contains thing)
						bestFood[fullness].foodList[thing] += quantity;
					else
						bestFood[fullness].foodList[thing] = quantity;

					bestFood[fullness].totalFullness = fullness;
					bestFood[fullness].totalQuality = quality;
					bestQuality = quality;
					lastFoodBetter = true;
				}
			}
		}
	}

	// All done.  Return best list of items.  The best list of food may not
	// be the highest fullness, so search for it.
	float bestQuality = 0.0;
	int bestFullness = 0;
	for fullness from 1 to maxFullness {
		if (!(bestFood contains fullness))
			continue;

		float quality = bestFood[fullness].totalQuality;
		if (quality < bestQuality)
			continue;

		bestFullness = fullness;
		bestQuality = quality;
	}

	if (bestFullness == 0) {
		FoodList empty;
		return empty;
	}

	return bestFood[bestFullness];
}

float rangeToAverage(string range) {
	string[int] split = split_string(range, "-");
	if (count(split) == 1 || split[0] == "")
		return to_float(split[0]);

	// This wouldn't handle a range with negative numbers, but the mafia
	// data file doesn't contain any of these values (yet).
	if (count(split) > 2)
		abort("Couldn't split '" + range + "'");

	return (to_float(split[0]) + to_float(split[1])) / 2.0;
}

float foodStats(MafiaEntry entry)
{
	string statString = "0";
	switch (my_primestat()) {
	case $stat[muscle]:
		statString = entry.musrange;
		break;
	case $stat[mysticality]:
		statString = entry.mysrange;
		break;
	case $stat[moxie]:
		statString = entry.moxrange;
		break;
	}

	return rangeToAverage(statString);
}

float foodQuality(MafiaEntry entry)
{
	// FIXME: Badass pie gets more stats on average.
	float adv = rangeToAverage(entry.advrange);
	float stats = foodStats(entry);
	return adv + stats / statsPerAdventure();
}

float foodQuality(item thing)
{
	if (!loadMafiaDataFiles())
		abort("Failed to load data files");
	return foodQuality(mafiaFood[thing]);
}

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

boolean[item] awesomeFood = $items[
	asparagus lo mein,
	badass pie,
	bat wing chow mein,
	bat wing stir-fry,
	boring spaghetti,
	boris's key lime pie,
	brain-meltingly-hot chicken wings,
	candied yams,
	can-shaped gelatinous cranberry sauce,
	cold hi mein,
	crimbo pie,
	dead lights pie,
	delicious noodles,
	delicious spicy noodles,
	fettucini inconnu,
	fishy fish casserole,
	fishy fish lasagna,
	gnat lasagna,
	gnatloaf casserole,
	gnocchetti di nietzsche,
	grue egg omelette,
	hell ramen,
	herbal stuffing,
	hot hi mein,
	igloo pie,
	jarlsberg's key lime pie,
	knob ka-bobs,
	knob lo mein,
	knob pasty,
	knob sausage chow mein,
	knob sausage stir-fry,
	knoll lo mein,
	liver and let pie,
	long pork casserole,
	long pork lasagna,
	nutty organic salad,
	olive lo mein,
	packet of tofurkey gravy,
	painful penne pasta,
	peach pie,
	pear tart,
	piping organ pie,
	pr0n chow mein,
	pr0n m4nic0tti,
	pr0n stir-fry,
	rat appendix chow mein,
	rat appendix stir-fry,
	ravioli della hippy,
	retenez l'herbe pate,
	sausage wonton,
	savoy truffle,
	shoo-fish pie,
	single-serving herbal stuffing,
	sleazy hi mein,
	sneaky pete's key lime pie,
	spaghetti with skullheads,
	spicy noodles,
	spooky hi mein,
	spooky lo mein,
	stinky hi mein,
	stomach turnover,
	super ka-bob,
	tasty tart,
	throbbing organ pie,
	tofu chow mein,
	tofurkey gravy,
	tofurkey leg,
	tofurkey nugget,
	tofu stir-fry,
	tofu wonton,
	tube of cranberry go-goo,
	yam candy,
];

boolean[item] goodFood = $items[
	blackberry,
	knob jelly donut,
	knob nuts,
	manetwich,
	natto pocky,
	peach,
	pear,
	plum,
	tobiko pocky,
	wasabi pocky,
];

boolean[item] decentFood = $items[
	abominable snowcone,
	cocktail onion,
	kiwi,
	kumquat,
	raspberry,
	tangerine,
];

boolean[item] crappyFood = $items[
	bowl of cottage cheese,
	cranberries,
	grapefruit,
	grapes,
	hot wing,
	lemon,
	mug cake,
	olive,
	orange,
	royal jelly,
	strawberry,
	tomato,
	urinal cake,
];

boolean[item] awesomeDrinks = $items[
	bottle of realpagne,
	bottle of single-barrel whiskey,
	corpsedriver,
	corpse island iced tea,
	corpse on the beach,
	corpsetini,
	distilled fortified wine,
	divine,
	gimlet,
	gordon bennett,
	mae west,
	mandarina colada,
	mon tiki,
	morlock's mark bourbon,
	neuromancer,
	prussian cathouse,
	pumpkin beer,
	tangarita,
	teqiwila slammer,
	thermos full of knob coffee,
	vodka stratocaster,
	yellow brick road,
];

boolean[item] goodDrinks = $items[
	a little sump'm sump'm,
	around the world,
	caipifruta,
	calle de miel,
	corpsebite,
	cream stout,
	ducha de oro,
	fuzzbump,
	gibson,
	gin and tonic,
	grog,
	horizontal tango,
	kamicorpse-ee,
	melted jell-o shot,
	mimosette,
	natto-infused sake,
	ocean motion,
	parisian cathouse,
	perpendicular hula,
	pink pony,
	plum wine,
	purple corpsel,
	rabbit punch,
	red-headed corpse,
	rockin' wagon,
	roll in the hay,
	shot of peach schnapps,
	shot of pear schnapps,
	slap and tickle,
	slip 'n' slide,
	supernova champagne,
	teqiwila,
	tequila sunset,
	tobiko-infused sake,
	vodka and tonic,
	vodka gibson,
	wasabi-infused sake,
	whiskey bittersweet,
	zmobie,
];

boolean[item] decentDrinks = $items[
	accidental cider,
	bilge wine,
	booze-soaked cherry,
	fine wine,
	flute of flat champagne,
	gin-soaked blotter paper,
	margarita,
	martini,
	monkey wrench,
	overpriced imported beer,
	salty dog,
	screwdriver,
	shot of flower schnapps,
	shot of grapefruit schnapps,
	shot of orange schnapps,
	shot of tomato schnapps,
	snifter of thoroughly aged brandy,
	strawberry daiquiri,
	strawberry wine,
	tequila sunrise,
	vodka martini,
	whiskey and soda,
	whiskey sour,
	wine spritzer,
];

boolean[item] crappyDrinks = $items[
	ice-cold fotie,
	ice-cold sir schlitz,
	ice-cold willer,
	imp ale,
	mad train wine,
	plain old beer,
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
	// creatable_amount(item) doesn't consider items you could summon or get.
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

boolean canEat(item thing) {
	int quantity = item_amount(thing) + creatable_amount(thing);
	if (quantity == 0)
		return false;

	if (thing.levelreq > my_level())
		return false;

	return true;
}

FoodInfo[item] getInfo(boolean[item] foodList, float milkMultiplier) {
	FoodInfo[item] foods;

	foreach thing in foodList {
		if (!canEat(thing))
			continue;

		float quality = foodQuality(thing) + milkMultiplier * thing.fullness;
		if (quality < 0)
			continue;

		foods[thing].quantity = item_amount(thing) + creatable_amount(thing);
		foods[thing].quality = quality;
	}

	return foods;
}

FoodInfo[item] getInfo(boolean[item] foodList) {
	return getInfo(foodList, 0.0);
}
// Eat food.  If force is true, use at least one thing if possible.
// Returns true if something was eaten.
boolean autoEat(boolean needStats, boolean needAdv) {
	int totalFullness = fullness_limit() - my_fullness();

	boolean couldEatFortuneCookie() {
		return get_property(propNeedFortuneCookie).to_boolean() && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount();
 	}

	if (totalFullness >= 1 && couldEatFortuneCookie() && counterWithinTurns(semirareWindowCounter, 10)) {
		if (eat(1, $item[fortune cookie]))
			totalFullness -= 1;
	}

	if (totalFullness <= 0)
		return false;

	boolean couldCreate(item thing) {
		// Noodle summoning, etc...
		return canEat(thing);
	}

	boolean createItem(int quantity, item thing) {
		if (item_amount(thing) >= quantity)
			return true;

		switch (thing) {
		case $item[jabanero pepper]:
			hermit(quantity, $item[jabanero pepper]);
			break;
		case $item[dry noodles]:
			if (have_skill($skill[pastamastery])) {
				int noodles = item_amount($item[dry noodles]);
				if (noodles < quantity) {
					use_skill(quantity - noodles, $skill[pastamastery]);
				}
			}
			break;
		case $item[scrumptious reagent]:
			if (have_skill($skill[advanced saucecrafting])) {
				int reagents = item_amount($item[scrumptious reagent]);
				if (reagents < quantity) {
					use_skill(quantity - reagents, $skill[advanced saucecrafting]);
				}
			}
		}

		// Maybe recursively try to create this thing?
		int[item] ingredientList = get_ingredients(thing);
		foreach ingredient in ingredientList {
			if (!createItem(ingredientList[ingredient], ingredient))
				return false;
		}

		return retrieve_item(quantity, thing);
	}

	boolean eatItem(item thing) {
		debug("Trying to eat " + thing);
		if (createItem(1, thing)) {
			abort("TEST DEBUG ABORT BEFORE EATING: " + thing);
			return eat(1, thing);
		}

		return false;
	}

	boolean eatBestItem(FoodList list) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodQuality(index);

		foreach thing in foodKeys {
			if (eatItem(thing))
				return true;
		}

		return false;
	}

	boolean eatBestStatItem(FoodList list) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodStats(mafiaFood[index]);

		foreach thing in foodKeys {
			if (eatItem(thing))
				return true;
		}

		return false;
	}

	boolean useMilk = haveItem($item[milk of magnesium]) || haveItem($item[glass of goat's milk]);
	if (useMilk)
		abort("TEST DEBUG PICKLISH MILK");
	float milkMultiplier = useMilk ? 1 : 0;

	FoodInfo[item] milkFoods = getInfo(awesomeFood, milkMultiplier);

	// Special items.  Insert them even if we can't make or eat them, under
	// the assumption that we might be able to later.
	foreach thing in $items[
		badass pie,
		delicious noodles,
		hell ramen,
		painful penne pasta,
		ravioli della hippy,
	] {
		float quality = foodQuality(thing) + milkMultiplier * thing.fullness;
		if (quality < 0)
			continue;

		if (thing.fullness > totalFullness)
			continue;

		int quantity = totalFullness / thing.fullness;
		if (thing == $item[badass pie])
			quantity = 1;

		milkFoods[thing].quantity = quantity;
		milkFoods[thing].quality = quality;
	}

	// FIXME: need to sort out when to eat fortune cookies and when to wait.
/*
	if (couldEatFortuneCookie()) {
		milkFoods[$item[fortune cookie]].quantity = 1;
		milkFoods[$item[fortune cookie]].quality = 1000;
	}
*/

	FoodList result = findBest(milkFoods, totalFullness);
	if (useMilk) {
		int fullness;
		foreach thing in result.foodList {
			if (!couldCreate(thing))
				fullness -= thing.fullness;
		}

		if (fullness != totalFullness && !needAdv)
			return false;

		if (fullness < 10)
			useMilk = false;
	}

	if (useMilk) {
		boolean createdSomething = false;
		foreach thing in result.foodList {
			createdSomething |= createItem(result.foodList[thing], thing);
		}

		if (createdSomething) {
			retrieve_item(1, $item[milk of magnesium]);
			use(1, $item[milk of magnesium]);

			boolean ateSomething = false;
			foreach thing in result.foodList {
				if (item_amount(thing) > 0)
					ateSomething |= eatItem(thing);
			}
			if (!ateSomething)
				abort("Used milk, but failed to eat anything!");

			return ateSomething;
		} else {
			abort("Tried to use milk but couldn't create anything.");
		}
	}

	if (needStats && eatBestStatItem(result))
		return true;
	else if (needAdv && eatBestItem(result))
		return true;

	if (!needAdv)
		return false;

	debug("We need adventures, but couldn't eat anything awesome.");
	abort("Whoa there.");

	FoodList awesomeList = findBest(getInfo(awesomeFood), totalFullness);
	if (eatBestItem(awesomeList))
		return true;

	FoodList goodList = findBest(getInfo(goodFood), totalFullness);
	if (eatBestItem(goodList))
		return true;

	FoodList decentList = findBest(getInfo(decentFood), totalFullness);
	if (eatBestItem(decentList))
		return true;
	
	FoodList crappyList = findBest(getInfo(crappyFood), totalFullness);
	if (eatBestItem(crappyList))
		return true;

	debug("Somehow we couldn't eat anything.");
	return false;
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
	boolean filterUseful = (spleenLeft() % 4 == 3 || have_skill($skill[spleen of steel]));
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

	boolean needAdv = my_adventures() < 10;
	autoEat(false, needAdv);
}
