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

	if (!file_to_map("inebriety.txt", mafiaDrink))
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

item[int] sortByQuality(FoodInfo[item] foods) {
	item[int] sortedFoods;
	int count = 0;
	foreach thing in foods {
		sortedFoods[count] = thing;
		count = count + 1;
	}
	sort sortedFoods by -foods[value].quality;
	return sortedFoods;
}

item getOffstatSuperCockDrink() {
	return my_primestat() == $stat[moxie] ? $item[gimlet] : $item[mae west];
}

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
	item[int] foodKeys;
	int count = 0;
	foreach thing in foods {
		foodKeys[count] = thing;
		count = count + 1;
	}
	sort foodKeys by -foods[value].quality;

	// Sparse array of best foods for a given fullness level.
	FoodList[int] bestFood;

	// Loop through foods at a given level of fullness.
	for foodFullness from 1 to maxFullness {
		// For all the food at that level, try to calculate the best
		// fullness at every level.

		int foodCount = 0;
		boolean lastFoodBetter = true;
		foreach thingIdx in foodKeys {
			item thing = foodKeys[thingIdx];
			if (foods[thing].quantity <= 0)
				continue;

			// If the last food of this fullness level did not result in
			// an improvement, then no other food at this fullness could.
			if (!lastFoodBetter)
				break;

			if (thing.fullness != foodFullness && thing.inebriety != foodFullness)
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

// These ingredients require a turn to cook.
boolean[item] fancyIngredients = $items[
	boris's key lime,
	bottle of calcutta emerald,
	bottle of definit,
	bottle of domesticated turkey,
	bottle of jorge sinsonte,
	bottle of lieutenant freeman,
	bottle of pete's sake,
	boxed champagne,
	bubbling tempura batter,
	coconut shell,
	digital key lime,
	dry noodles,
	evil noodles,
	globe of deep sauce,
	grue egg,
	jarlsberg's key lime,
	knob frosting,
	little paper umbrella,
	magical ice cubes,
	mushroom fermenting solution,
	nauseating reagent,
	scrumdiddlyumptious solution,
	scrumptious reagent,
	seaode,
	secret blend of herbs and spices,
	skewered cherry,
	skewered jumbo olive,
	skewered lime,
	slug of rum,
	slug of shochu,
	slug of vodka,
	sneaky pete's key lime,
	star key lime,
	tiny plastic sword,
];

int turnsToCook(item thing)
{
	// Break infinite loop.
	if (thing == $item[flat dough])
		return 0;

	int[item] ingredientList = get_ingredients(thing);
	if (count(ingredientList) > 0) {
		int turnsToCook = 0;
		boolean fancy = false;
		foreach ingredient in ingredientList {
			if (fancyIngredients contains ingredient)
				fancy = true;
			turnsToCook += turnsToCook(ingredient);
		}

		return turnsToCook + (fancy ? 1 : 0);
	}

	return 0;
}

float baseFoodQuality(MafiaEntry entry)
{
	// FIXME: Badass pie gets more stats on average.
	float adv = rangeToAverage(entry.advrange);
	float stats = foodStats(entry);

	return adv + stats / statsPerAdventure();
}

float baseFoodQuality(item thing)
{
	if (!loadMafiaDataFiles())
		abort("Failed to load data files");

	// Pies save more turns than they give adventures, so improve quality.
	int turnsFromPie = 0;
	if (pieToKey contains thing) {
		item key = pieToKey[thing];
		if (!haveItem(key))
			turnsFromPie = 1000;
	}

	if (mafiaFood contains thing)
		return baseFoodQuality(mafiaFood[thing]) + turnsFromPie;
	else if (mafiaDrink contains thing)
		return baseFoodQuality(mafiaDrink[thing]);

	abort("Unknown item: " + thing);
	return -1000.0;
}

float foodQuality(item thing, boolean useMilk, boolean freeToCraft)
{
	float base = baseFoodQuality(thing) + (useMilk ? 1.0 : 0.0);
	float cost = turnsToCook(thing).to_float() / (thing.inebriety + thing.fullness).to_float();
	return base - cost;
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
	spaghetti con calaveras,
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
	blended frozen swill,
	booze-soaked cherry,
	caipifruta,
	calle de miel,
	corpsebite,
	cream stout,
	ducha de oro,
	fine wine,
	flute of flat champagne,
	fruity girl swill,
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
	russian ice,
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
	tropical swill,
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
	if (!bcascStage("tavern"))
		return false;

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
	if (my_meat() < 3000 || my_level() < 5)
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
npcCost[$item[fermenting powder]] = 70;
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
npcCost[$item[soda water]] = 70;
npcCost[$item[skewer]] = 80;
npcCost[$item[strawberry]] = 70;
npcCost[$item[taco shell]] = 80;
npcCost[$item[tomato]] = 70;
npcCost[$item[wad of dough]] = 50;

int[item] recipeMultiplier;
recipeMultiplier[$item[bottle of rum]] = 3;
recipeMultiplier[$item[bottle of tequila]] = 3;
recipeMultiplier[$item[bottle of whiskey]] = 3;
recipeMultiplier[$item[bottle of gin]] = 3;
recipeMultiplier[$item[bottle of vodka]] = 3;
recipeMultiplier[$item[boxed wine]] = 3;
recipeMultiplier[$item[bottle of sake]] = 3;
recipeMultiplier[$item[pumpkin beer]] = 3;

boolean[item] requiresStill = $items[
	bottle of calcutta emerald,
	bottle of definit,
	bottle of domesticated turkey,
	bottle of jorge sinsonte,
	bottle of lieutenant freeman,
	bottle of ooze-o,
	bottle of pete's sake,
	boxed champagne,
	cocktail onion,
	kiwi,
	kumquat,
	raspberry,
	tangerine,
	tonic water,
];

boolean hippyStore() {
	if (!have_outfit("filthy hippy disguise"))
		return false;

	return hippy_store_available() || my_level() >= 12 && get_property(propSideQuestOrchardCompleted) != "none";
}

int purchasableAmount(item thing) {
	if (!is_npc_item(thing))
		return 0;

	switch (thing) {
	case $item[fortune cookie]:
	case $item[fermenting powder]:
	case $item[soda water]:
		return my_meat() / npcCost[thing];

	case $item[grapes]:
	case $item[herbs]:
	case $item[lemon]:
	case $item[olive]:
	case $item[orange]:
	case $item[strawberry]:
	case $item[tomato]:
		if (!hippyStore())
			return 0;
		return my_meat() / npcCost[thing];

	case $item[peach]:
	case $item[pear]:
	case $item[plum]:
		if (!hippyStore())
			return 0;
		if (get_property(propSideQuestOrchardCompleted) == "none")
			return 0;
		if (get_property(propCurrentHippyStore) != hippyStoreHippy)
			return 0;
		return my_meat() / npcCost[thing];

	case $item[bowl of rye sprouts]:
	case $item[cob of corn]:
	case $item[juniper berries]:
		if (!hippyStore())
			return 0;
		if (get_property(propSideQuestOrchardCompleted) == "none")
			return 0;
		if (get_property(propCurrentHippyStore) != hippyStoreFrat)
			return 0;
		return my_meat() / npcCost[thing];

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

	// Break infinite loops in ingredient lists.
	if (thing == $item[flat dough])
		return item_amount(thing) + purchasableAmount(thing);

	// Maybe recursively try to create this thing?
	int[item] ingredientList = get_ingredients(thing);
	int quantity;
	if (count(ingredientList) > 0) {
		// Set to some impossible value.
		quantity = 10000;

		int stillUses = 0;

		foreach ingredient in ingredientList {
			quantity = min(quantity, couldCreateQuantity(ingredient));
			if (quantity == 0)
				break;

			// Note: currently all recipes involving multiple still ingredients
			// combine them in the same step.  If this ever changes, we'll need
			// to return something more complex from couldCreateQuantity.
			stillUses = stillUses + (requiresStill[ingredient] ? 1 : 0);
		}

		// Some recipes produce multiple items.
		int mult = recipeMultiplier[thing];
		if (mult > 0)
			quantity *= mult;

		if (stillUses > 0) {
			quantity = min(stills_available() / stillUses, quantity);
		}

	} else {
		quantity = creatable_amount(thing);
	}

	quantity += item_amount(thing) + purchasableAmount(thing);
	return quantity;
}

boolean couldCreate(item thing) {
	return couldCreateQuantity(thing) > 0;
}

boolean haveMilk() {
	return couldCreateQuantity($item[milk of magnesium]) > 0 || have_effect($effect[got milk]) >= fullness_limit() - my_fullness();
}

boolean createItem(int quantity, item thing) {
	int remaining = quantity - item_amount(thing);
	if (remaining <= 0)
		return true;

	// FIXME: use Inigo's here.

	switch (thing) {
	case $item[jabanero pepper]:
		hermit(remaining, $item[jabanero pepper]);
		break;
	case $item[dry noodles]:
		if (have_skill($skill[pastamastery])) {
			use_skill(remaining, $skill[pastamastery]);
		}
		break;
	case $item[scrumptious reagent]:
		if (have_skill($skill[advanced saucecrafting])) {
			use_skill(remaining, $skill[advanced saucecrafting]);
		}
	}

	// Maybe recursively try to create this thing?
	int[item] ingredientList = get_ingredients(thing);
	foreach ingredient in ingredientList {
		int mult = recipeMultiplier[thing] > 0 ? recipeMultiplier[thing] : 1;
		int subQuantity = (remaining + mult - 1) / mult;
		if (!createItem(ingredientList[ingredient] * subQuantity, ingredient))
			return false;
	}

	// FIXME: better heuristic, check for innabox
	if (my_meat() > 10000 && thing.inebriety > 0) {
		int turns = turnsToCook(thing) * (remaining - item_amount(thing));
		if (turns > 0) {
			debug("Casting inigo's for this drink");
			castInigos(turns);
		}
	}

	return retrieve_item(quantity, thing);
}

int createAndGetFullness(FoodList list) {
	int total = 0;
	foreach thing in list.foodList {
		// Assumption.
		if (thing.fullness > 0 && thing.inebriety > 0)
			abort("Internal error: createAndGetFullness");

		int quantity = min(list.foodList[thing], couldCreateQuantity(thing));

		// This could fail, so we'll check item_amount below.
		createItem(quantity, thing);

		int full = thing.fullness + thing.inebriety;
		total += full * min(item_amount(thing), list.foodList[thing]);
	}
	return total;
}

FoodInfo[item] getInfo(boolean[item] foodList, boolean useMilk, boolean freeToCraft) {
	FoodInfo[item] foods;

	foreach thing in foodList {
		if (!canConsume(thing))
			continue;

		int quantity = couldCreateQuantity(thing);
		if (quantity <= 0)
			continue;

		float quality = foodQuality(thing, useMilk, freeToCraft);
		if (quality <= 0)
			continue;

		foods[thing].quantity = quantity;
		foods[thing].quality = quality;
	}

	// Reserve one corpse drink for a nightcap, since it's of such
	// high drunkenness.  If there were more drinks that fit this category,
	// this could be generalized better.
	FoodInfo[item] corpseDrinks;
	int totalCorpses = 0;

	foreach thing in $items[
		corpsedriver,
		corpse island iced tea,
		corpse on the beach,
		corpsetini,
	] {
		if (!(foods contains thing))
			continue;

		corpseDrinks[thing].quantity = foods[thing].quantity;
		corpseDrinks[thing].quality = foods[thing].quality;

		totalCorpses += foods[thing].quantity;
	}

	item[int] sorted = sortByQuality(corpseDrinks);
	if (totalCorpses > 0) {
		item worst = sorted[count(corpseDrinks) - 1];
		foods[worst].quantity -= 1;
	}

	return foods;
}

boolean unsafeDrinkItem(item thing) {
	debug("Trying to drink " + thing);

	if (!createItem(1, thing))
		return false;

	return drink(1, thing);
}

boolean drinkItem(item thing) {
	if (thing.inebriety + my_inebriety() > inebriety_limit()) {
		abort("Drinking " + thing + " would go over drunkeness limit.");
	}

	return unsafeDrinkItem(thing);
}


void summonRemainingGarnishes() {
	int quantity = cocktailSummonsRemaining();

	tryTonic(quantity * 10);
	use_skill(quantity, $skill[advanced cocktailcrafting]);
}

item createNightcap() {
	summonRemainingGarnishes();
	harvestCampground();

	// Merge all drink lists, find the best item.
	boolean[item] drinkList;
	foreach thing in odeDrinkList
		drinkList[thing] = true;
	foreach thing in otherDrinkList
		drinkList[thing] = true;

	// FIXME
	boolean useOde = true;
	boolean freeToCraft = false;

	FoodInfo[item] foods = getInfo(drinkList, useOde, freeToCraft);
	item[int] sorted = sortByQuality(foods);

	// Try for a minimum of a supercock drink.
	item best = sorted[0];
	float bestQuality = foods[best].quality;
	item desired = getOffstatSuperCockDrink();
	float baselineQuality = foodQuality(desired, useOde, freeToCraft);
	if (bestQuality < baselineQuality) {
		// We couldn't make one, so are probably missing base booze?
		// This could be smarter.

		getBaseBooze();
		foods = getInfo(drinkList, useOde, freeToCraft);
		sorted = sortByQuality(foods);
	}
	
	if (haveItem(sorted[0]))
		return sorted[0];

	if (my_adventures() == 0)
		abort("FIXME: implement inigo's");

	if (stills_available() < 2)
		abort("FIXME: implement night cap without still");

	foreach key in sorted {
		item thing = sorted[key];
		debug("Creating " + thing + " for nightcap");
		if (createItem(1, thing))
			return thing;
	}

	abort("Unable to create any nightcap.");
	return $item[none];
}

boolean drinkNightcap() {
	item thing = createNightcap();
	if (thing == $item[none])
		abort("Unknown nightcap");

	debug("Drinking " + thing + " for nightcap");
	wait(60);

	castOde(thing.inebriety);
	return unsafeDrinkItem(thing);
}

boolean[item] mergeItemList(boolean[item] list1, boolean[item] list2) {
	boolean[item] itemList;
	foreach thing in list1 
		itemList[thing] = true;
	foreach thing in list2 
		itemList[thing] = true;

	return itemList;
}

boolean autoDrink(boolean needStats, boolean needAdv) {
	if (!getCock())
		return false;

	int totalDrunk = inebriety_limit() - my_inebriety();

	if (totalDrunk <= 0)
		return false;

	boolean drinkBestItem(FoodList list, boolean useOde, boolean freeToCraft) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodQuality(index, useOde, freeToCraft);

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
		debug("We need adventures, so summoning garnishes.");
		summonRemainingGarnishes();
	}

	// Don't bother drinking unless we have garnishes.
	// There's some special logic for day 1 pumpkin beer elsewhere.
	if (cocktailSummonsRemaining() > 0) {
		return false;
	}

	harvestCampground();

	// FIXME: support not using/having ode
	boolean useOde = true;
	boolean freeToCraft = false;

	boolean drinkIfExists(FoodList list, int tryDrunk) {
		if (createAndGetFullness(list) != tryDrunk)
			return false;

		debug("Found enough to drink to " + tryDrunk + " drunkenness.");
		foreach thing in list.foodList {
			debug("Considering: " + thing + "," + list.foodList[thing]);
		}
		wait(10);
		castOde(tryDrunk);

		boolean drankSomething = false;
		foreach thing in list.foodList {
			for count from 1 to list.foodList[thing]
				if (drinkItem(thing))
					drankSomething = true;
		}

		return drankSomething;
	}

	boolean tryList(FoodInfo[item] drinkList, int totalDrunk) {
		int lastDrunk = 0;
		int drunk = 0;
		FoodList result;

		repeat {
			lastDrunk = drunk;
			result = findBest(drinkList, totalDrunk);
			drunk = createAndGetFullness(result);
		} until (drunk == lastDrunk);

		// Now, using *just* the items that we've created.
		FoodInfo[item] final;
		foreach thing in result.foodList {
			final[thing].quantity = min(item_amount(thing), drinkList[thing].quantity);
			final[thing].quality = drinkList[thing].quality;
		}

		FoodList[int] bestDrinks = findAllBest(final, totalDrunk);

		if (drinkIfExists(bestDrinks[totalDrunk], totalDrunk))
			return true;

		// FIXME: maybe need to consider not having a RnR legend here.
		int maxOde = 10;
		int odeCasts = (inebriety_limit() + maxOde - 1) / maxOde;
		int minOde = inebriety_limit() / odeCasts;

		minOde = min(minOde, totalDrunk);
		maxOde = min(maxOde, totalDrunk);

		for tryDrunk from maxOde downto minOde {
			if (drinkIfExists(bestDrinks[tryDrunk], tryDrunk))
				return true;
		}

		return false;
	}

	FoodInfo[item] odeDrinks = getInfo(odeDrinkList, useOde, freeToCraft);

	// Assume that we'll be able to make as many 4-drunk awesome drinks as
	// possible.  But, pick an offstat one just in case
	boolean[item] extra;
	extra[getOffstatSuperCockDrink()] = true;
	foreach thing in extra {
		float quality = foodQuality(thing, useOde, freeToCraft);
		if (quality < 0)
			continue;

		if (thing.inebriety > totalDrunk)
			continue;

		int quantity = totalDrunk / thing.inebriety;

		odeDrinks[thing].quantity = quantity;

		// Slightly less than actual quality, in case we can actually make
		// a real supercock drink of the same quality.
		odeDrinks[thing].quality = quality - 0.1;
	}

	if (tryList(odeDrinks, totalDrunk))
		return true;

	if (!needAdv)
		return false;

	// if have hippy outfit	and are level 6
	// ...and have garnishes
	// ...and don't have every kind of bottle of booze
	// then try doing the barrel full of barrels.
	getBaseBooze();

	if (tryList(odeDrinks, totalDrunk))
		return true;

	debug("We need adventures, but couldn't drink just awesome things.");

	boolean[item] fullDrinkList = mergeItemlist(odeDrinkList, otherDrinkList);
	FoodInfo[item] fullDrinkInfo = getInfo(fullDrinkList, useOde, freeToCraft);

	if (tryList(fullDrinkInfo, totalDrunk))
		return true;

	debug("Couldn't fill an ode, so just drink anything!");

	for tryDrunk from totalDrunk downto 1 {
		if (tryList(fullDrinkInfo, totalDrunk))
			return true;
	}

	return false;
}

boolean couldEatFortuneCookie() {
	return in_hardcore() && get_property(propNeedFortuneCookie).to_boolean() && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount() && !checkPropToday(propLastFortuneCookie);
}

boolean eatItem(item thing) {
	debug("Trying to eat " + thing);
	if (createItem(1, thing)) {
		if (!eat(1, thing))
			return false;

		if (thing == $item[fortune cookie])
			setPropToday(propLastFortuneCookie);

		return true;
	}

	return false;
}

boolean autoEat(boolean needStats, boolean needAdv) {
	int totalFullness = fullness_limit() - my_fullness();

	if (totalFullness <= 0)
		return false;

	// FIXME: Don't get an oven until we need it to cook something.
	if (!getOven())
		return false;

	boolean eatBestItem(FoodList list, boolean useMilk, boolean freeToCraft) {
		boolean[item] foodKeys;
		foreach thing in list.foodList
			foodKeys[thing] = true;
		sort foodKeys by -foodQuality(index, useMilk, freeToCraft);

		foreach thing in foodKeys {
			if (!createItem(1, thing))
				continue;
			debug("Eating best item: " + thing);
			wait(20);
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

	boolean useMilk = haveMilk();
	boolean freeToCraft = false;

	FoodInfo[item] getMilkFoodInfo(boolean useMilk, boolean freeToCraft) {
		FoodInfo[item] milkFoods = getInfo(milkFoodList, useMilk, freeToCraft);

		if (couldEatFortuneCookie()) {
			milkFoods[$item[fortune cookie]].quantity = 1;
			milkFoods[$item[fortune cookie]].quality = 1000;
		}

		return milkFoods;
	}

	FoodInfo[item] milkFoods = getMilkFoodInfo(useMilk, freeToCraft);

	// Special items.  Insert them even if we can't make or eat them, under
	// the assumption that we might be able to later.
	foreach thing in $items[
		badass pie,
		delicious noodles,
		hell ramen,
		painful penne pasta,
		ravioli della hippy,
	] {
		float quality = foodQuality(thing, useMilk, freeToCraft);
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
				result = findBest(getMilkFoodInfo(useMilk, freeToCraft), totalFullness);
				fullness = createAndGetFullness(result);
			} until (fullness == lastFullness);
		}

		if (fullness == 0)
			return false;

		debug("Preparing to eat for the day with milk");
		foreach thing in result.foodList {
			debug("Considering: " + thing + "," + result.foodList[thing]);
		}
		wait(10);

		// FIXME: What if milk is going to run out?
		if (have_effect($effect[got milk]) < fullness) {
			createItem(1, $item[milk of magnesium]);
			use(1, $item[milk of magnesium]);
		}

		boolean ateSomething = false;
		foreach thing in result.foodList {
			for count from 1 to result.foodList[thing]
				if (eatItem(thing))
					ateSomething = true;
		}
		if (!ateSomething)
			abort("Used milk, but failed to eat anything!");

		return ateSomething;
	}

	if (needStats)
		return eatBestStatItem(result);
	if (needAdv && eatBestItem(result, useMilk, freeToCraft))
		return true;
	
	if (!needAdv)
		return false;

	debug("We need adventures, but couldn't eat anything awesome.");

	FoodList awesomeList = findBest(getInfo(milkFoodList, useMilk, freeToCraft), totalFullness);
	if (eatBestItem(awesomeList, useMilk, freeToCraft))
		return true;

	FoodList otherList = findBest(getInfo(otherFoodList, useMilk, freeToCraft), totalFullness);
	if (eatBestItem(otherList, useMilk, freeToCraft))
		return true;

	debug("Somehow we couldn't eat anything.");
	return false;
}

// Use spleen items.  If force is true, use at least one thing if possible.
// Returns true if spleen item was used.
boolean autoSpleen(boolean force) {
	// Assumption: all pulverization has already been done.
	// FIXME: Use malus to turn nuggets -> wads.

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
		while (item_amount(thing) > 0) {
			if (spleenLeft() < 4)
				break;
			usedSomething = true;
			use(1, thing);
		}
	}

	// Postpone wads if there's a remote chance we could get a mojo filter.
	boolean waitOnFilter = my_level() >= 10 && !bcascStage("macguffinpyramid");
	boolean useWads = force || !waitOnFilter;

	// Wads require level 6.
	if (!useWads || my_level() < 6 || spleenLeft() == 0)
		return usedSomething;

	boolean shouldUseWad() {
		return spleenLeft() % 4 != 0;
	}

	if (spleenLeft() == 3 && haveItem($item[prismatic wad])) {
		usedSomething = true;
		use(1, $item[prismatic wad]);
	}

	// FIXME: Sort wads by stat relevance
	foreach thing in allWads {
		if (!shouldUseWad() && !force || spleenLeft() == 0)
			break;
		while (item_amount(thing) > 0) {
			if (!shouldUseWad() && !force || spleenLeft() == 0)
				break;
			usedSomething = true;
			use(1, thing);
		}
	}

	return usedSomething;
}

void autoConsume(location loc) {

	if (my_daycount() == 1 && my_inebriety() == 0 && stillAvailable() && !bcascStage("pumpkinbeer")) {
		tryCast($skill[mojomuscular melody]);
		retrieve_item(4, $item[tonic water]);
		summonRemainingGarnishes();

		castOde(3);

		cli_execute("garden pick");

		if (have_skill($skill[summon alice's army cards]))
			use_skill(1, $skill[summon alice's army cards]);

		// FIXME: only drink 2 if we have three stat-aligned garnishes.
		if (have_effect($effect[ode to booze]) >= 6) {
			for count from 1 to 3
				drinkItem($item[pumpkin beer]);
			drinkItem($item[natto sake]);
		} else if (have_effect($effect[ode to booze]) >= 5) {
			for count from 1 to 2
				drinkItem($item[pumpkin beer]);
			drinkItem($item[natto sake]);
		} else {
			for count from 1 to 3
				drinkItem($item[pumpkin beer]);
		}

		// Hack: in case we levelled up, refresh current quests.
		cli_execute("council");
		setBcascStageComplete("pumpkinbeer");
	}

	if (my_daycount() == 1 && bcascStage("tavern") && !bcascStage("swill") && getCock()) {
		boolean[item] drinks = $items[
			blended frozen swill,
			fruity girl swill,
			tropical swill,
		];

		int totalDrunk = inebriety_limit() - my_inebriety();
		// Conserve ode usage.
		if (totalDrunk > 10)
			totalDrunk = 8;

		FoodList result = findBest(getInfo(drinks, false, false), totalDrunk);
		int drunk = createAndGetFullness(result);
		if (drunk == 0)
			abort("Couldn't create anything?");

		foreach thing in result.foodList {
			createItem(result.foodList[thing], thing);
		}

		castOde(drunk);

		foreach thing in result.foodList {
			int quantity = result.foodList[thing];
			quantity = min(quantity, item_amount(thing));
			for count from 1 to quantity
				drinkItem(thing);
		}

		setBcascStageComplete("swill");
	}

	boolean needAdventures() {
		return my_adventures() < 10;
	}

	autoSpleen(needAdventures());

	// If there's no milk, it's easier to scrounge up food a little at a time,
	// so it makes sense to eat first.  If we have milk, it's easier to find
	// 2-3 drinks than 15 fullness, so drink first.
	if (haveMilk()) {
		autoDrink(false, needAdventures());
		autoEat(false, needAdventures());
	} else {
		autoEat(false, needAdventures());
		autoDrink(false, needAdventures());
	}

	if (my_fullness() == fullness_limit() && my_inebriety() == inebriety_limit() && needAdventures()) {
		item drink = createNightcap();
		debug("Nightcap: " + drink);
	}

	int totalFullness = fullness_limit() - my_fullness();
	// Do this last, in case we auto-ate a fortune cookie with milk.
	if (totalFullness >= 1 && couldEatFortuneCookie() && counterWithinTurns(semirareWindowCounter, 10)) {
		eatItem($item[fortune cookie]);
	}
}
