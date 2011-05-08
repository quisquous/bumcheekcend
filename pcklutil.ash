// Named KoLmafia properties 

string propAguaDrops = "_aguaDrops";
string propArrows = "_badlyRomanticArrows";
string propAutoHpMin = "hpAutoRecovery";
string propAutoHpTarget = "hpAutoRecoveryTarget";
string propAutoMpMin = "mpAutoRecovery";
string propAutoMpTarget = "mpAutoRecoveryTarget";
string propBarrelGoal = "barrelGoal";
string propBatTurns = "picklishBatTurns";
string propBetweenBattleScript = "betweenBattleScript";
string propBlessingReceived = "friarsBlessingReceived";
string propCampgroundCock = "picklishCampgroundCock";
string propCampgroundOven = "picklishCampgroundOven";
string propChefHave = "picklishHaveChef";
string propChefMake = "bcasc_chef";
string propClanHome = "picklishClanHome";
string propCocktailSummons = "cocktailSummons";
string propCounterScript = "counterScript";
string propDoSideQuestNuns = "bcasc_doSideQuestNuns";
string propDoSideQuestOrchard = "bcasc_doSideQuestOrchard";
string propFaxArt = "picklishFaxArt";
string propFaxBlooper = "picklishFaxBlooper";
string propFaxLobster = "picklishFaxLobster";
string propFaxUsed = "_photocopyUsed";
string propHipsterAdv = "_hipsterAdv";
string propLastFortuneCookie = "picklishFortuneCookieDay";
string propLevelMeCommand = "bcasc_preLevelMe";
string propLibramSummons = "libramSummons";
string propMineUnaccOnly = "bcasc_MineUnaccOnly";
string propNeedFortuneCookie = "picklishNeedFortuneCookie";
string propNoodleSummons = "noodleSummons";
string propOrganFinishPie = "picklishOrganFinishPie";
string propOrganTurns = "_piePartsCount";
string propPieCount = "_pieDrops";
string propPoolGames = "_poolGames";
string propPrevFamiliar = "bcasc_familiar";
string propReagentSummons = "reagentSummons";
string propRomanticEncounters = "picklishRomanticEncounters";
string propSemirareCounter = "semirareCounter";
string propSemirareKGE = "picklishSemirareKGE";
string propSemirareLast = "semirareLocation";
string propShower = "_aprilShower";
string propSideQuestLighthouseCompleted = "sidequestLighthouseCompleted";
string propSideQuestNunsCompleted = "sidequestNunsCompleted";
string propSideQuestOrchardCompleted = "sidequestOrchardCompleted";
string propSoak = "_hotTubSoaks";
string propTeaParty = "_madTeaParty";
string propTelescopeUpgrades = "telescopeUpgrades";
string propTokenDrops = "_tokenDrops";
string propWarFratDefeated = "hippiesDefeated";
string propWarFratMoney = "availableQuarters";
string propWarHippyDefeated = "fratboysDefeated";
string propWarHippyMoney = "availableDimes";
string propWarSide = "bcasc_doWarAs";

string clanBAFH = "90485";

// Named KoLmafia counters

string danceCardCounter = "Dance Card";
string fortuneCounter = "Fortune Cookie";
string semirareWindowCounter = "Semirare window begin";

// General

void debug(String s) {
	print("PCKLSH: " + s, "green");
}

// Bumcheekascend-specific

boolean bcascStage(string stage) {
	// checkStage is spammy.  This is a silent non-setting version.
	return get_property("bcasc_stage_" + stage) == my_ascensions();
}

void setBcascStageComplete(string stage) {
	set_property("bcasc_stage_" + stage, my_ascensions());
}

// Clan Swapping

boolean whitelistedBy(string id) {
	string clan = visit_url("clan_signup.php");
	return contains_text(clan, "<option value=" + id + ">");
}

boolean homeClanAvailable() {
	if (get_property(propClanHome) == "")
		return false;
	
	return whitelistedBy(get_property(propClanHome));
}

boolean changeClan(string name, string id) {
	debug("Changing clan to " + name);

	if (!whitelistedBy(id)) {
		debug("Not whitelisted, aborting");
		return false;
	}

	string result = visit_url("showclan.php?pwd&whichclan=" + id + "&action=joinclan&confirm=yes&submit=Apply to this Clan", true);

	if (!contains_text(result, "<b>Clan Hall</b>") && !contains_text(result, ">You can't apply to a clan you're already in")) {
		abort("Unknown result when trying to change clans.");
		return false;
	}

	return true;
}

boolean changeClanBAFH() {
	return changeClan("BAFH", clanBAFH);
}

boolean changeClanHome() {
	if (!homeClanAvailable())
		return false;

	return changeClan("home", get_property(propClanHome));
}

// Items

boolean[item] combatItems = $items[
	love song of vague ambiguity,
	love song of sugary cuteness,
	divine noisemaker,
	love song of smoldering passion,
	love song of disturbing obsession,
	divine silly string,
	love song of icy revenge,
	love song of naughty innuendo,
	divine blowout,
];

stat combatItemToStat(item thing) {
	switch (thing) {
	case $item[love song of vague ambiguity]:
	case $item[love song of sugary cuteness]:
	case $item[divine noisemaker]:
		return $stat[muscle];
	case $item[love song of smoldering passion]:
	case $item[love song of disturbing obsession]:
	case $item[divine silly string]:
		return $stat[mysticality];
	case $item[love song of icy revenge]:
	case $item[love song of naughty innuendo]:
	case $item[divine blowout]:
		return $stat[moxie];
	}

	abort("Unknown item in itemToStat");
	return $stat[none];
}

boolean haveItem(item thing) {
	return available_amount(thing) > 0;
}

item classEpicWeapon(class cls) {
	switch (cls) {
		case $class[turtle tamer]: return $item[turtle totem];
		case $class[seal clubber]: return $item[mace of the tortoise];
		case $class[pastamancer]: return $item[pasta of peril];
		case $class[sauceror]: return $item[5-alarm saucepan];
		case $class[disco bandit]: return $item[disco banjo];
		case $class[accordion thief]: return $item[rock and roll legend];
	}
	return $item[none];
}

item classLegendaryWeapon(class cls) {
	switch (cls) {
		case $class[turtle tamer]: return $item[hammer of smiting];
		case $class[seal clubber]: return $item[chelonian morning star];
		case $class[pastamancer]: return $item[greek pasta of peril];
		case $class[sauceror]: return $item[17-alarm saucepan];
		case $class[disco bandit]: return $item[shagadelic disco banjo];
		case $class[accordion thief]: return $item[squeezebox of the ages];
	}
	return $item[none];
}

boolean haveEpicWeapon() {
	return haveItem(classEpicWeapon(my_class()));
}

boolean haveLegendaryWeapon() {
	return haveItem(classLegendaryWeapon(my_class()));
}

boolean haveKGEOutfit() {
	return haveItem($item[Knob Goblin elite pants]) || haveItem($item[Knob Goblin elite polearm]) || haveItem($item[Knob Goblin elite helm]);
}

boolean eatenFortuneCookieToday() {
	return get_property(propLastFortuneCookie) == today_to_string();
}

void setFortuneCookieEatenToday() {
	set_property(propLastFortuneCookie, today_to_string());
}

boolean harvestCampground() {
	int[item] campground = get_campground();
	if (campground[$item[pumpkin]] == 0)
		return false;

	return cli_execute("garden pick");
}

stat garnishAlignment(item thing) {
	switch (thing) {
	case $item[coconut shell]: return $stat[muscle];
	case $item[little paper umbrella]: return $stat[mysticality];
	case $item[magical ice cubes]: return $stat[moxie];
	}
	return $stat[none];
}

// Skills and effects

int maxCocktailSummons() {
	if (have_skill($skill[advanced cocktail crafting]))
		return have_skill($skill[superhuman cocktail crafting]) ? 5 : 3;
	return 0;
}

int cocktailSummonsRemaining() {
	return maxCocktailSummons() - get_property(propCocktailSummons).to_int();
}

int maxNoodleSummons() {
	if (have_skill($skill[pastamastery]))
		return have_skill($skill[transcendental noodlecraft]) ? 5 : 3;
	return 0;
}

int noodleSummonsRemaining() {
	return maxNoodleSummons() - get_property(propNoodleSummons).to_int();
}

int maxReagentSummons() {
	if (have_skill($skill[advanced saucecrafting]))
		return have_skill($skill[the way of sauce]) ? 5 : 3;
	return 0;
}

int reagentSummonsRemaining() {
	return maxReagentSummons() - get_property(propReagentSummons).to_int();
}

int mpRegenerationByEffect(effect e) {
	switch (e) {
	case $effect[antarctic memories]: return 40;
	case $effect[florid cheeks]: return 30;
	case $effect[black tongue]: return 20;
	case $effect[purple tongue]: return 20;
	case $effect[the real deal]: return 20;
	case $effect[tiny bubbles in the cupcake]: return 20;
	case $effect[extra terrestrial]: return 20;
	case $effect[hella smart]: return 20;
	case $effect[mental a-cue-ity]: return 10;
	case $effect[blessing of squirtlcthulli]: return 10;
	case $effect[feelin' philosophical]: return 10;
	case $effect[heart of orange]: return 6;
	case $effect[in tuna]: return 5;
	}

	return 0;
}

int mpRegenerationByItem(item thing) {
	switch (thing) {
	case $item[plexiglass pith helmet]: return 12;
	case $item[energy drink iv]: return 7;
	case $item[hilarious comedy prop]: return 7;
	case $item[sugar chapeau]: return 5;
	case $item[bubblewrap bottlecap turtleban]: return 3;
	case $item[chef's hat]: return 1;
	}

	return 0;
}

int mpRegeneration() {
	int regen = 0;

	int fiery = have_effect($effect[fiery heart]);
	regen += min(fiery, 20) / 2;

	regen += mpRegenerationByItem(equipped_item($slot[hat]));
	regen += mpRegenerationByItem(equipped_item($slot[weapon]));

	foreach e in $effects[
		antarctic memories,
		florid cheeks,
		black tongue,
		purple tongue,
		the real deal,
		tiny bubbles in the cupcake,
		extra terrestrial,
		hella smart,
		mental a-cue-ity,
		blessing of squirtlcthulli,
		feelin' philosophical,
		heart of orange,
		in tuna,
	] {
		if (have_effect(e) == 0)
			continue;
		regen += mpRegenerationByEffect(e);
	}

	return regen;
}

monster olfactTarget() {
	return have_effect($effect[on the trail]) > 0 ? get_property("olfactedMonster").to_monster() : $monster[none];
}

monster romanticTarget() {
	return get_property("romanticTarget").to_monster();
}

boolean tryCast(skill s) {
	effect e = to_effect(s);
	if (e == $effect[none] || !have_skill(s) || have_effect(e) > 0)
		return false;

	// FIXME: consider accordion thief song count.

	use_skill(1, s);
	return have_effect(e) > 0;
}

boolean tryShrug(skill s) {
	effect e = to_effect(s);
	if (e == $effect[none] || have_effect(e) == 0)
		return true;

	return cli_execute("uneffect " + e);
}

boolean tryTonic(int neededMP) {
	if (my_mp() >= neededMP)
		return false;

	if (!haveItem($item[tonic water]))
		return false;

	if (my_maxmp() - my_mp() < 50) {
		tryCast($skill[mojomuscular melody]);
	}

	return use(1, $item[tonic water]);
}

// Adventuring

boolean canAdventure() {
	if (my_inebriety() > inebriety_limit())
		return false;
	if (my_adventures() == 0)
		return false;
	return true;
}

boolean canOutMoxie(monster mon) {
	return my_buffedstat(my_primestat()) >= monster_attack(mon) + 4;
}

boolean counterThisTurn(string counter) {
	return get_counters(counter, 0, 0) == counter;
}

boolean counterWithinTurns(string counter, int maxTurns) {
	// If multiple, they'll all be returned as one string, so use
	// contains_text instead of equality.
	return contains_text(get_counters(counter, 0, maxTurns), counter);
}

boolean counterActive(string counter) {
	return counterWithinTurns(counter, 1000);
}

// A rough estimate of how many mainstat per adventure we could expected
// to receive when trying to level as quickly as possible.
float statsPerAdventure() {
	// FIXME: See: http://www.houeland.com/kol/powerlevel

	if (my_primestat() != $stat[moxie])
		abort("Unhandled prime stat");

	// For now, just return a linear interpolation of expected ballroom stats.
	return 0.625 * my_basestat(my_primestat()) + 9.5;
}

int monsterLevel(location loc) {
	int ml = 0;

	// Hack: Ed doesn't appear in appearance_rates().
	if (loc == $location[lower chambers])
		ml = 300;

	foreach mob, freq in appearance_rates(loc) {
		if (freq == 0)
			continue;
		ml = max(ml, monster_attack(mob));
	}
	return ml;
}

float sombreroStats(int weight, float ml) {
	float mlAdjust = 1.0;
	if (ml >= 4.0)
		mlAdjust += square_root(ml - 4.0);
	return square_root(weight) * mlAdjust / 10.0;
}

float volleyballStats(int weight) {
	return square_root(weight);
}

float statsForFamiliar(familiar fam, location loc) {
	if (!have_familiar(fam))
		return 0.0;

	int weight = familiar_weight(fam) + weight_adjustment();
	int ml = monsterLevel(loc) + monster_level_adjustment();

	// FIXME: Handle more familiar options here.
	switch (fam) {
	case $familiar[baby sandworm]:
	case $familiar[sombrero]:
		return sombreroStats(weight, ml);
	case $familiar[bandersnatch]:
	case $familiar[volleyball]:
		return volleyballStats(weight);
	}

	abort("Unhandled familiar: " + fam);
	return 0.0;
}

void getBaseBooze() {
	// Yay, magic property numbers.
	set_property(propBarrelGoal, 2);
}

// Miscellaneous actions

void getPresent() {
	if (visit_url("clan_viplounge.php").contains_text("a present under it"))
		visit_url("clan_viplounge.php?action=crimbotree");
}

boolean poolTable(string type) {
	if (get_property(propPoolGames).to_int() >= 3) {
		return false;
	}
	return cli_execute("pool " + type);
}

boolean stillAvailable() {
	return visit_url("guild.php?guild=t").contains_text("Nash Crosby's Still");
}

boolean takeShower(string kind) {
	if (get_property(propShower).to_boolean())
		return false;

	// My kingdom for a closure.
	if (!homeClanAvailable())
		return false;

	if (!changeClanBAFH())
		return false;

	boolean result	= cli_execute("shower " + kind);
	changeClanHome();

	return result;
}

boolean takeStatShower() {
	switch (my_primestat()) {
	case $stat[muscle]:
		return takeShower("warm");
	case $stat[mysticality]:
		return takeShower("lukewarm");
	case $stat[moxie]:
		return takeShower("cool");
	}

	return false;
}

boolean takeHotShower() {
	return takeShower("hot");
}

boolean teaParty(item thing) {
	if (get_property(propTeaParty).to_boolean())
		return false;

	if (have_effect($effect[down the rabbit hole]) == 0) {
		if (!haveItem($item[clan vip lounge key]))
			return false;

		if (!haveItem($item[drink me potion]))
			visit_url("clan_viplounge.php?action=lookingglass");

		if (!haveItem($item[drink me potion]))
			return false;
	}

	if (!haveItem(thing))
		return false;

	cli_execute("checkpoint");
	if (equipped_amount(thing) == 0) {
		equip(thing);
		if (equipped_amount(thing) == 0) {
			cli_execute("outfit checkpoint");
			return false;
		}
	}

	if (have_effect($effect[down the rabbit hole]) == 0) {
		use(1, $item[drink me potion]);
		if (have_effect($effect[down the rabbit hole]) == 0) {
			cli_execute("outfit checkpoint");
			return false;
		}
	}

	debug("Visiting the tea party with " + thing);
	visit_url("rabbithole.php?action=teaparty");
	visit_url("choice.php?pwd&whichchoice=441&option=1&Try to get a seat", true);

	cli_execute("outfit checkpoint");
	return true;
}

boolean trySoak() {
	if (item_amount($item[clan vip lounge key]) == 0 || get_property(propSoak).to_int() >= 5) {
		return false;
	}
	return cli_execute("soak");
}

// War

boolean[item] canSellToHippyItems = $items[
	beer bong,
	beer helmet,
	bejeweled pledge pin,
	blue class ring,
	bottle opener belt buckle,
	distressed denim pants,
	elmley shades,
	energy drink iv,
	giant foam finger,
	keg shield,
	kick-ass kicks,
	padl phone,
	perforated battle paddle,
	red class ring,
	war tongs,
	white class ring,
];

boolean[item] canSellToFratItems = $items[
	bullet-proof corduroys,
	communications windchimes,
	didgeridooka,
	fire poi,
	flowing hippy skirt,
	gaia beads,
	green clay bead,
	hippy medical kit,
	hippy protest button,
	lead pipe,
	lockenstock sandals,
	pink clay bead,
	purple clay bead,
	reinforced beaded headband,
	round green sunglasses,
	round purple sunglasses,
	wicker shield,
];

int[item] canBuyFromFratItems;
canBuyFromFratItems[$item[beer bomb]] = 1;
canBuyFromFratItems[$item[sake bomb]] = 1;
canBuyFromFratItems[$item[gauze garter]] = 2;
canBuyFromFratItems[$item[monstar energy beverage]] = 3;
canBuyFromFratItems[$item[superamplified boom box]] = 4;
canBuyFromFratItems[$item[commemorative war stein]] = 5;
canBuyFromFratItems[$item[frat army fgf]] = 10;
canBuyFromFratItems[$item[giant foam finger]] = 15;
canBuyFromFratItems[$item[kick-ass kicks]] = 15;
canBuyFromFratItems[$item[war tongs]] = 20;
canBuyFromFratItems[$item[energy drink iv]] = 25;
canBuyFromFratItems[$item[keg shield]] = 30;
canBuyFromFratItems[$item[perforated battle paddle]] = 35;
canBuyFromFratItems[$item[beer bong]] = 40;
canBuyFromFratItems[$item[cast-iron legacy paddle]] = 50;
canBuyFromFratItems[$item[beer-a-pult]] = 50;
canBuyFromFratItems[$item[tequila grenade]] = 2;
canBuyFromFratItems[$item[molotov cocktail cocktail]] = 2;

int[item] canBuyFromHippyItems;
canBuyFromHippyItems[$item[water pipe bomb]] = 1;
canBuyFromHippyItems[$item[ferret bait]] = 1;
canBuyFromHippyItems[$item[filthy poultice]] = 2;
canBuyFromHippyItems[$item[carbonated soy milk]] = 3;
canBuyFromHippyItems[$item[macrame net]] = 4;
canBuyFromHippyItems[$item[fancy seashell necklace]] = 5;
canBuyFromHippyItems[$item[hippy army mpe]] = 10;
canBuyFromHippyItems[$item[gaia beads]] = 15;
canBuyFromHippyItems[$item[lockenstock sandals]] = 15;
canBuyFromHippyItems[$item[lead pipe]] = 20;
canBuyFromHippyItems[$item[hippy medical kit]] = 25;
canBuyFromHippyItems[$item[wicker shield]] = 30;
canBuyFromHippyItems[$item[didgeridooka]] = 35;
canBuyFromHippyItems[$item[fire poi]] = 40;
canBuyFromHippyItems[$item[giant driftwood sculpture]] = 50;
canBuyFromHippyItems[$item[massive sitar]] = 50;
canBuyFromHippyItems[$item[patchouli oil bomb]] = 2;
canBuyFromHippyItems[$item[exploding hacky-sack]] = 2;

boolean buyWarItem(int count, item thing) {
	int campId;
	int costPerItem;
	string propMoney;
	if (canBuyFromFratItems contains thing) {
		if (!outfit("frat warrior"))
			return false;
		campId = 2;
		costPerItem = canBuyFromFratItems[thing];
		propMoney = propWarFratMoney;
	} else if (canBuyFromHippyItems contains thing) {
		if (!outfit("war hippy fatigues"))
			return false;
		campId = 1;
		costPerItem = canBuyFromHippyItems[thing];
		propMoney = propWarHippyMoney;
	} else {
		return false;
	}

	int money = get_property(propMoney).to_int();
	if (costPerItem * count > money)
		return false;

	int originalAmount = item_amount(thing);
	visit_url("bigisland.php?action=getgear&pwd&whichcamp=" + campId + "&whichitem=" + to_int(thing) + "&quantity=" + count, true);

	return item_amount(thing) == originalAmount + count;
}

boolean turnInWarItem(int count, item thing) {
	if (item_amount(thing) < count || bcascStage("warboss"))
		return false;
	int campId;
	if (canSellToFratItems[thing]) {
		if (!outfit("frat warrior"))
			return false;
		campId = 2;
	} else if (canSellToHippyItems[thing]) {
		if (!outfit("war hippy fatigues"))
			return false;
		campId = 1;
	} else {
		return false;
	}

	string result = visit_url("bigisland.php?action=turnin&pwd&whichcamp=" + campId + "&whichitem=" + to_int(thing) + "&quantity=" + count, true);

	return contains_text(result, ">Results:<");
}
