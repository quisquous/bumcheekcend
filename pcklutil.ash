// Named KoLmafia properties 

string propArrows = "_badlyRomanticArrows";
string propAutoHpMin = "hpAutoRecovery";
string propAutoHpTarget = "hpAutoRecoveryTarget";
string propAutoMpMin = "mpAutoRecovery";
string propAutoMpTarget = "mpAutoRecoveryTarget";
string propBatTurns = "picklishBatTurns";
string propCookware = "picklishBoughtCookware";
string propDoSideQuestNuns = "bcasc_doSideQuestNuns";
string propDoSideQuestOrchard = "bcasc_doSideQuestOrchard";
string propFaxUsed = "_photocopyUsed";
string propHipsterAdv = "_hipsterAdv";
string propMineUnaccOnly = "bcasc_MineUnaccOnly";
string propOrganFinishPie = "picklishOrganFinishPie";
string propOrganTurns = "_piePartsCount";
string propPieCount = "_pieDrops";
string propPoolGames = "_poolGames";
string propPrevFamiliar = "bcasc_familiar";
string propRomanticEncounters = "picklishRomanticEncounters";
string propSemirareCounter = "semirareCounter";
string propSemirareKGE = "picklishSemirareKGE";
string propSemirareLast = "semirareLocation";
string propSideQuestNunsCompleted = "sidequestNunsCompleted";
string propSideQuestOrchardCompleted = "sidequestOrchardCompleted";
string propSoak = "_hotTubSoaks";
string propTelescopeUpgrades = "telescopeUpgrades";
string propWarFratDefeated = "hippiesDefeated";
string propWarFratMoney = "availableQuarters";
string propWarHippyDefeated = "fratboysDefeated";
string propWarHippyMoney = "availableDimes";
string propWarSide = "bcasc_doWarAs";

// Named KoLmafia counters

string danceCardCounter = "Dance Card";
string fortuneCounter = "Fortune Cookie";

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

boolean haveKGEOutfit() {
	return haveItem($item[Knob Goblin elite pants]) || haveItem($item[Knob Goblin elite polearm]) || haveItem($item[Knob Goblin elite helm]);
}

// Skills and effects

monster olfactTarget() {
	return have_effect($effect[on the trail]) > 0 ? get_property("olfactedMonster").to_monster() : $monster[none];
}

monster romanticTarget() {
	return get_property("romanticTarget").to_monster();
}

effect skillToEffect(skill s) {
	switch (s) {
		case $skill[fat leon's phat loot lyric]: return $effect[fat leon's phat loot lyric];
		case $skill[leash of linguini]: return $effect[leash of linguini];
		case $skill[mojomuscular melody]: return $effect[mojomuscular melody];
		case $skill[moxious madrigal]: return $effect[moxious madrigal];
		case $skill[polka of plenty]: return $effect[polka of plenty];
	}

	return $effect[none];
}

boolean tryCast(skill s) {
	effect e = skillToEffect(s);
	if (e == $effect[none] || !have_skill(s) || have_effect(e) > 0)
		return false;

	use_skill(1, s);
	return have_effect(e) > 0;
}

boolean tryShrug(skill s) {
	effect e = skillToEffect(s);
	if (e == $effect[none] || have_effect(e) == 0)
		return true;

	return cli_execute("uneffect " + e);
}

// Adventuring

boolean canAdventure() {
	if (my_inebriety() > inebriety_limit())
		return false;
	if (my_adventures() == 0)
		return false;
	return true;
}

boolean counterThisTurn(string counter) {
	return get_counters(counter, 0, 0) == counter;
}

boolean counterActive(string counter) {
	// If multiple, they'll all be returned as one string, so use
	// contains_text instead of equality.
	return contains_text(get_counters(counter, 0, 1000), counter);
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
