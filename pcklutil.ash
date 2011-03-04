// Named KoLmafia properties 

string propArrows = "_badlyRomanticArrows";
string propAutoHpMin = "hpAutoRecovery";
string propAutoHpTarget = "hpAutoRecoveryTarget";
string propAutoMpMin = "mpAutoRecovery";
string propAutoMpTarget = "mpAutoRecoveryTarget";
string propBatTurns = "_picklishBatTurns";
string propDoSideQuestNuns = "bcasc_doSideQuestNuns";
string propDoSideQuestOrchard = "bcasc_doSideQuestOrchard";
string propFaxUsed = "_photocopyUsed";
string propHipsterAdv = "_hipsterAdv";
string propMineUnaccOnly = "bcasc_MineUnaccOnly";
string propOrganFinishPie = "picklishOrganFinishPie";
string propOrganTurns = "_piePartsCount";
string propPieCount = "_pieDrops";
string propPoolGames = "_poolGames";
string propPrevFamiliar = "_picklishPrevFamiliar";
string propSemirareCounter = "semirareCounter";
string propSemirareKGE = "picklishSemirareKGE";
string propSemirareLast = "semirareLocation";
string propSideQuestNunsCompleted = "sidequestNunsCompleted";
string propSideQuestOrchardCompleted = "sidequestOrchardCompleted";
string propSoak = "_hotTubSoaks";

// Named KoLmafia counters

string danceCardCounter = "Dance Card";
string firstRomanticCounter = "Last romantic begin";
string fortuneCounter = "Fortune Cookie";
string lastRomanticCounter = "Last romantic end";

// General

void debug(String s) {
	print("PCKLSH: " + s, "green");
}

// Bumcheekascend-specific

boolean bcascStage(string stage) {
	// checkStage is spammy.  This is a silent non-setting version.
	return get_property("bcasc_stage_" + stage) == my_ascensions();
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
	return item_amount(thing) > 0 ||
		closet_amount(thing) > 0 ||
		equipped_amount(thing) > 0;
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

boolean stillAvailable() {
	return visit_url("guild.php?guild=t").contains_text("Nash Crosby's Still");
}

