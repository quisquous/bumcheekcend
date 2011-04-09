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
FoodList[int] findAllBest(FoodInfo[item] foods, int maxFullness) {
	// Deciding what to eat is the bounded knapsack problem.  Given that
	// maxFull <= 35, we can do a dynamic programming approach considering the
	// foods at ascending levels of fullness.  Silly NP complete problems.  Try
	// to keep the food list small, because this is of complexity
	// O(maxFullness^2 * count(foods)).

	// Note: For simplicity, the list of foods is considered to be wholly
	// independent (i.e. the quantity available of one does not affect the
	// quantity of another).  This is not true, but this function can be
	// called repeatedly until a local maximum is found.  This doesn't work
	// in any general sense, but most interdependence of ingredients is found
	// in foods of similar quality and identical fullness (e.g. garnishes)
	// so it should largely be the global maximum as well.

	// WTF WTF WTF.  Sort destroys the association between keys and values.
	// So, create a second array of "just" the food items, so that we can
	// sort by value and not destroy the information passed into this func.
	boolean[item] foodKeys;
	foreach thing in foods
		foodKeys[thing] = true;
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

	return bestFood;
}

FoodList findBest(FoodInfo[item] foods, int maxFullness) {
	FoodList[int] bestFood = findAllBest(foods, maxFullness);

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

boolean[item] milkFoodList = $items[
	asparagus lo mein,
	badass pie,
	bat wing chow mein,
	bat wing stir-fry,
	boring spaghetti,
	boris's key lime pie,
	brain-meltingly-hot chicken wings,
	bunch of square grapes,
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

boolean[item] otherFoodList = $items[
	abominable snowcone,
	blackberry,
	bowl of cottage cheese,
	cocktail onion,
	cranberries,
	grapefruit,
	grapes,
	hot wing,
	kiwi,
	knob jelly donut,
	knob nuts,
	kumquat,
	lemon,
	manetwich,
	mug cake,
	natto pocky,
	olive,
	orange,
	peach,
	pear,
	plum,
	raspberry,
	royal jelly,
	strawberry,
	tangerine,
	tobiko pocky,
	tomato,
	urinal cake,
	wasabi pocky,
];

boolean[item] odeDrinkList = $items[
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

boolean[item] otherDrinkList = $items[
	accidental cider,
	a little sump'm sump'm,
	around the world,
	bilge wine,
	booze-soaked cherry,
	caipifruta,
	calle de miel,
	corpsebite,
	cream stout,
	ducha de oro,
	fine wine,
	flute of flat champagne,
	fuzzbump,
	gibson,
	gin and tonic,
	gin-soaked blotter paper,
	grog,
	horizontal tango,
	ice-cold fotie,
	ice-cold sir schlitz,
	ice-cold willer,
	imp ale,
	kamicorpse-ee,
	mad train wine,
	margarita,
	martini,
	melted jell-o shot,
	mimosette,
	monkey wrench,
	natto-infused sake,
	ocean motion,
	overpriced imported beer,
	parisian cathouse,
	perpendicular hula,
	pink pony,
	plain old beer,
	plum wine,
	purple corpsel,
	rabbit punch,
	red-headed corpse,
	rockin' wagon,
	roll in the hay,
	salty dog,
	screwdriver,
	shot of flower schnapps,
	shot of grapefruit schnapps,
	shot of orange schnapps,
	shot of peach schnapps,
	shot of pear schnapps,
	shot of tomato schnapps,
	slap and tickle,
	slip 'n' slide,
	snifter of thoroughly aged brandy,
	strawberry daiquiri,
	strawberry wine,
	supernova champagne,
	teqiwila,
	tequila sunrise,
	tequila sunset,
	tobiko-infused sake,
	vodka and tonic,
	vodka gibson,
	vodka martini,
	wasabi-infused sake,
	whiskey and soda,
	whiskey bittersweet,
	whiskey sour,
	wine spritzer,
	zmobie,
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

boolean canConsume(item thing) {
	return thing.levelreq <= my_level();
}

int[item] npcCost;
npcCost[$item[bowl of rye sprouts]] = 300;
npcCost[$item[cob of corn]] = 300;
npcCost[$item[flat dough]] = 50;
npcCost[$item[fortune cookie]] = 40;
npcCost[$item[gnollish casserole dish]] = 150;
npcCost[$item[gnollish pie tin]] = 30;
npcCost[$item[grapes]] = 70;
npcCost[$item[herbs]] = 64;
npcCost[$item[juniper berries]] = 300;
npcCost[$item[lemon]] = 70;
npcCost[$item[olive]] = 70;
npcCost[$item[orange]] = 70;
npcCost[$item[peach]] = 300;
npcCost[$item[pear]] = 300;
npcCost[$item[plum]] = 300;
npcCost[$item[skewer]] = 80;
npcCost[$item[strawberry]] = 70;
npcCost[$item[taco shell]] = 80;
npcCost[$item[tomato]] = 70;
npcCost[$item[wad of dough]] = 50;

int purchasableAmount(item thing) {
	if (!is_npc_item(thing))
		return 0;

	switch (thing) {
	case $item[fortune cookie]:
		return my_meat() / npcCost[thing];

	case $item[grapes]:
	case $item[herbs]:
	case $item[lemon]:
	case $item[olive]:
	case $item[orange]:
	case $item[strawberry]:
	case $item[tomato]:
		if (!hippy_store_available() || !have_outfit("filthy hippy disguise"))
			return 0;
		return my_meat() / npcCost[thing];

	case $item[peach]:
	case $item[pear]:
	case $item[plum]:
		// FIXME
		return 0;

	case $item[bowl of rye sprouts]:
	case $item[cob of corn]:
	case $item[juniper berries]:
		// FIXME
		return 0;

	case $item[gnollish pie tin]:
	case $item[wad of dough]:
	case $item[flat dough]:
	case $item[skewer]:
	case $item[taco shell]:
	case $item[gnollish casserole dish]:
		if (!in_muscle_sign() && !have_outfit("bugbear costume"))
			return 0;
		return my_meat() / npcCost[thing];
	}

	return 0;
}

int couldCreateQuantity(item thing) {
	switch (thing) {
	case $item[dry noodles]:
		return noodleSummonsRemaining() + item_amount(thing);
	case $item[scrumptious reagent]:
		return reagentSummonsRemaining() + item_amount(thing);
	case $item[jabanero pepper]:
	case $item[ketchup]:
	case $item[catsup]:
		return my_meat() / 150 + item_amount(thing);
	}

	int quantity = creatable_amount(thing);

	// Break infinite loops in ingredient lists.
	if (thing == $item[flat dough])
		return item_amount(thing) + purchasableAmount(thing);

	// Maybe recursively try to create this thing?
	int[item] ingredientList = get_ingredients(thing);
	if (count(ingredientList) > 0) {
		int quantity = 10000;

		foreach ingredient in ingredientList {
			quantity = min(quantity, couldCreateQuantity(ingredient));
			if (quantity == 0)
				break;
		}
	}

	quantity += item_amount(thing) + purchasableAmount(thing);
	return quantity;
}

boolean couldCreate(item thing) {
	return couldCreateQuantity(thing) > 0;
}

boolean createItem(int quantity, item thing) {
	if (item_amount(thing) >= quantity)
		return true;

	// FIXME: use Inigo's here.

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

FoodInfo[item] getInfo(boolean[item] foodList, float milkMultiplier) {
	FoodInfo[item] foods;

	foreach thing in foodList {
		if (!canConsume(thing))
			continue;

		int quantity = couldCreateQuantity(thing);
		if (quantity <= 0)
			continue;

		float quality = foodQuality(thing) + milkMultiplier * thing.fullness;
		if (quality <= 0)
			continue;

		foods[thing].quantity = item_amount(thing) + creatable_amount(thing);
		foods[thing].quality = quality;
	}

	return foods;
}

FoodInfo[item] getInfo(boolean[item] foodList) {
	return getInfo(foodList, 0.0);
}

boolean autoDrink(boolean needStats, boolean needAdv) {
	return false;

	int totalDrunk = inebriety_limit() - my_inebriety();

	if (totalDrunk <= 0)
		return false;
	
	boolean drinkItem(item thing) {
		debug("Trying to drink" + thing);
		if (!createItem(1, thing))
			return false;

		abort("TEST DEBUG ABORT BEFORE DRINKING: " + thing);
		return drink(1, thing);
	}

	boolean drinkBestItem(FoodList list) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodQuality(index);

		foreach thing in foodKeys {
			if (drinkItem(thing))
				return true;
		}

		return false;
	}

	boolean drinkBestStatItem(FoodList list) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodStats(mafiaFood[index]);

		foreach thing in foodKeys {
			if (foodStats(mafiaFood[thing]) <= 0)
				return false;

			if (drinkItem(thing))
				return true;
		}

		return false;
	}

	if (needAdv && cocktailSummonsRemaining() > 0) {
		int quantity = cocktailSummonsRemaining();

		debug("We need adventures, so summoning garnishes.");
		tryTonic(quantity * 10);
		use_skill(quantity, $skill[advanced cocktailcrafting]);
	}

	// Don't bother drinking unless we have garnishes.
	// There's some special logic for pumpkin beer elsewhere.
	if (cocktailSummonsRemaining() > 0) {
		debug("TEMP: Still have summons remaining, no drinking: " + cocktailSummonsRemaining());
		return false;
	}

	boolean useOde = true;
	float odeMultiplier = useOde ? 1 : 0;
	FoodInfo[item] odeDrinks = getInfo(odeDrinkList, odeMultiplier);

	FoodList result = findBest(odeDrinks, totalDrunk);
	if (useOde) {
		foreach thing in result.foodList {
			if (!createItem(result.foodList[thing], thing)) {
			}
		}
	}

	if (needStats && drinkBestStatItem(result))
		return true;
	if (needAdv && drinkBestItem(result))
		return true;

	if (!needAdv)
		return false;

	debug("We need adventures, but couldn't drink anything awesome.");
	abort("Whoa there.");

	FoodList awesomeList = findBest(getInfo(odeDrinkList), totalDrunk);
	if (drinkBestItem(awesomeList))
		return true;

	FoodList otherList = findBest(getInfo(otherDrinkList), totalDrunk);
	if (drinkBestItem(otherList))
		return true;

	debug("Somehow we couldn't drink anything.");
	return false;

}

boolean couldEatFortuneCookie() {
	return get_property(propNeedFortuneCookie).to_boolean() && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount();
}

boolean eatItem(item thing) {
	debug("Trying to eat " + thing);
	if (createItem(1, thing)) {
		if (!eat(1, thing))
			return false;

		if (thing == $item[fortune cookie])
			setFortuneCookieEatenToday();

		return true;
	}

	return false;
}

boolean autoEat(boolean needStats, boolean needAdv) {
	int totalFullness = fullness_limit() - my_fullness();

	if (totalFullness <= 0)
		return false;

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
			if (foodStats(mafiaFood[thing]) <= 0)
				return false;

			if (eatItem(thing))
				return true;
		}

		return false;
	}

	boolean useMilk = couldCreateQuantity($item[milk of magnesium]) > 0;
	float milkMultiplier = useMilk ? 1 : 0;

	FoodInfo[item] getMilkFoodInfo(float milkMultiplier) {
		FoodInfo[item] milkFoods = getInfo(milkFoodList, milkMultiplier);

		if (couldEatFortuneCookie() && !eatenFortuneCookieToday()) {
			milkFoods[$item[fortune cookie]].quantity = 1;
			milkFoods[$item[fortune cookie]].quality = 1000;
		}

		return milkFoods;
	}

	FoodInfo[item] milkFoods = getMilkFoodInfo(milkMultiplier);

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

	int createAndGetFullness(FoodList list) {
		// We may not be able to create everything, so create the best items first.
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodQuality(index);

		int total = 0;
		foreach thing in foodKeys {
			total += thing.fullness * min(couldCreateQuantity(thing), list.foodList[thing]);
		}
		return total;
	}

	FoodList result = findBest(milkFoods, totalFullness);

	if (useMilk) {
		int fullness = createAndGetFullness(result);
		if (fullness != totalFullness) {
			// We want to use milk, but wait on better food items.
			if (!needAdv)
				return false;

			// Try again, but don't add special items.
			//
			// Additionally, one failure of the optimal diet algorithm is that
			// interdependence of ingredients among items isn't handled.  So,
			// if two items require something we only have one of, we may fail
			// to create the second one.  So, repeat finding the best until
			// fullness doesn't improve.
			int lastFullness;
			repeat {
				lastFullness = fullness;
				result = findBest(getMilkFoodInfo(milkMultiplier), totalFullness);
				fullness = createAndGetFullness(result);
			} until (fullness == lastFullness);
		}

		if (fullness == 0)
			return false;

		if (have_effect($effect[got milk]) == 0) {
			retrieve_item(1, $item[milk of magnesium]);
			use(1, $item[milk of magnesium]);
		}

		// FIXME: What if milk is going to run out?

		boolean ateSomething = false;
		foreach thing in result.foodList {
			for count from 1 to result.foodList[thing]
				ateSomething |= eatItem(thing);
		}
		if (!ateSomething)
			abort("Used milk, but failed to eat anything!");

		return ateSomething;
	} else {
		abort("Tried to use milk but couldn't create anything.");
	}

	if (needStats)
		return eatBestStatItem(result);
	if (needAdv && eatBestItem(result))
		return true;

	debug("We need adventures, but couldn't eat anything awesome.");
	abort("Whoa there.");

	FoodList awesomeList = findBest(getInfo(milkFoodList), totalFullness);
	if (eatBestItem(awesomeList))
		return true;

	FoodList goodList = findBest(getInfo(otherFoodList), totalFullness);
	if (eatBestItem(goodList))
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
		retrieve_item(4, $item[tonic water]);
		use(1, $item[tonic water]);
		use_skill(1, $skill[ode to booze]);
		cli_execute("garden pick");
		cli_execute("drink 3 pumpkin beer");

		// Hack: in case we levelled up, refresh current quests.
		cli_execute("council");
	}

	boolean needAdventures() {
		return my_adventures() < 10;
	}

	autoSpleen(needAdventures());
	autoEat(false, needAdventures());
	autoDrink(false, needAdventures());

	int totalFullness = fullness_limit() - my_fullness();
	// Do this last, in case we auto-ate a fortune cookie with milk.
	if (totalFullness >= 1 && couldEatFortuneCookie() && counterWithinTurns(semirareWindowCounter, 10)) {
		eatItem($item[fortune cookie]);
	}
}
