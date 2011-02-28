import <fax.ash>
import <makemeat.ash>
import <bumcheekascend.ash>

String propBatTurns = "_picklishBatTurns";
String propOrganTurns = "_piePartsCount";
String propPieCount = "_pieDrops";
String propPrevFamiliar = "_picklishPrevFamiliar";
String propArrows = "_badlyRomanticArrows";
String propCookware = "_picklishBoughtCookware";
String propPoolGames = "_poolGames";
String propFaxUsed = "_photocopyUsed";
String propSoak = "_hotTubSoaks";
String propMineUnaccOnly = "bcasc_MineUnaccOnly";
String danceCardCounter = "Dance Card";
String fortuneCounter = "Fortune Cookie";
String firstRomanticCounter = "Last romantic begin";
String lastRomanticCounter = "Last romantic end";
String semirareCounter = "semirareCounter";

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

void debug(String s) {
	print("PCKLSH: " + s, "green");
}

boolean bcascStage(string stage) {
	// checkStage is spammy.  This is a silent non-setting version.
	return get_property("bcasc_stage_" + stage) == my_ascensions();
}

monster olfactTarget() {
	return get_property("olfactedMonster").to_monster();
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

void checkOutOfAdventures() {
	if (my_inebriety() > inebriety_limit())
		abort("Too drunk!");
	if (my_adventures() == 0)
		abort("No adventures left!");
}

boolean counterThisTurn(string counter) {
	return get_counters(counter, 0, 0) == counter;
}

boolean counterActive(string counter) {
	// If multiple, they'll all be returned as one string, so use
	// contains_text instead of equality.
	return contains_text(get_counters(counter, 0, 1000), counter);
}

void checkCounters() {
	if (counterThisTurn(danceCardCounter)) {
		if (my_location() != $location[haunted ballroom]) {
			debug("Detouring to the Ballroom for the dance card counter");
			adventure(1, $location[haunted ballroom]);
		}
	}
	if (counterThisTurn(fortuneCounter)) {
		abort("Fortune cookie!");
	}
}

boolean tryCast(skill s) {
	effect e = skillToEffect(s);
	if (e == $effect[none] || !have_skill(s) || have_effect(e) > 0)
		return false;

	use_skill(1, s);
	return have_effect(e) > 0;
}

boolean needOlfaction(location loc) {
	// TODO(picklish) - don't depend on CSS settings here.
	switch (loc) {
	case $location[8-bit realm]:
	case $location[dungeons of doom]:
	case $location[goatlet]:
	case $location[haunted ballroom]:
		return true;
	case $location[dark neck of the woods]:
	case $location[pandamonium slums]:
		return item_amount($item[hellion cube]) <= 10;
	default:
		return false;
	}
}

void olfactionPreparation() {
	skill o = $skill[transcendent olfaction];

	tryCast($skill[fat leon's phat loot lyric]);

	if (!have_skill(o) || have_effect($effect[on the trail]) > 0)
		return;

	int cost = mp_cost(o) + combat_mana_cost_modifier();
	int needed = cost - my_mp();
	if (needed <= 0)
		return;

	if (cost > my_maxmp()) {
		tryCast($skill[mojo muscularmelody]);
		if (cost > my_maxmp())
			return;
	}

	if (needed > 10 && item_amount($item[tonic water]) > 0)
		use(1, $item[tonic water]);

	cli_execute("mood execute");
	restore_mp(cost);
}

boolean castSugar() {
	if (item_amount($item[sugar sheet]) > 0)
		return true;
	if (!have_skill($skill[summon sugar sheets]))
		return false;
	if (!use_skill(1, $skill[summon sugar sheets]))
		return false;
	return item_amount($item[sugar sheet]) > 0;
}

string consultRedRay(int round, string opp, string text) {
	if (have_effect($effect[everything looks red]) > 0) {
		return "attack";
	}
	if (contains_text(text, "red eye")) {
		return "skill point at your opponent";
	} else {
		switch (my_class()) {
			case $class[Disco Bandit] : return "skill suckerpunch"; break;
			case $class[Accordion Thief] : return "skill sing"; break;
		}
	}
	return "attack";
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

void useRedRay() {
	if (have_effect($effect[everything looks red]) > 0)
		return;
	if (!have_familiar($familiar[he-boulder]))
		return;

	familiar oldFamiliar = my_familiar();

	use_familiar($familiar[he-boulder]);
	if (item_amount($item[sugar shield]) == 0 && equipped_item($slot[familiar]) != $item[sugar shield]) {
		if (castSugar()) {
			retrieve_item(1, $item[sugar shield]);
			equip($slot[familiar], $item[sugar shield]);
		}
	}
	if (have_skill($skill[leash of linguini]) && have_effect($effect[leash of linguini]) == 0)
		use_skill(1, $skill[leash of linguini]);
	if (item_amount($item[clan vip lounge key]) > 0 && get_property("_poolGames") < 3 && have_effect($effect[billiards belligerence]) == 0) {
		poolTable("agg");
	}

	// Since the he-boulder restores a lot of MP, try to capture it.
	if (have_skill($skill[mojomuscular melody]) && have_effect($effect[mojomuscular melody]) == 0)
		use_skill(1, $skill[mojomuscular melody]);

	if (canMCD())
		cli_execute("mcd 10");

	adv1(my_location(), 0, "consultRedRay");

	use_familiar(oldFamiliar);
}

void getPresent() {
	if (visit_url("clan_viplounge.php").contains_text("a present under it"))
		visit_url("clan_viplounge.php?action=crimbotree");
}

void firstTurn() {
	debug("First turn of the run");

	if (item_amount($item[newbiesport tent]) == 0)
		retrieve_item(1, $item[newbiesport tent]);
	use(1, $item[newbiesport tent]);

	getPresent();

	cli_execute("ccs defaultattack");

	set_property(propMineUnaccOnly, true);
	set_property(propOrganTurns, 0);
	set_property(propBatTurns, 0);
	set_property(propPieCount, 0);
	set_property(propArrows, 0);
	set_property(propCookware, false);
	set_property(propPoolGames, 0);
}

// Returns true if this function has set the familiar.
boolean checkOrgan() {
	int organ = get_property(propOrganTurns).to_int();
	int pie = get_property(propPieCount).to_int();
	// Don't switch from he-boulder if we're trying to YR something.
	boolean needOrgan = (organ > 0 && pie == 0 && my_familiar() != $familiar[he-boulder]);
	if (needOrgan && my_familiar() == $familiar[organ grinder])
		return true;
	if (!needOrgan && my_familiar() != $familiar[organ grinder])
		return false;

	if (needOrgan) {
		debug("Remembering old familiar: " + my_familiar());
		set_property(propPrevFamiliar, my_familiar());
		use_familiar($familiar[organ grinder]);
		return true;
	} else {
		familiar prev = get_property(propPrevFamiliar).to_familiar();
		debug("Switching back to old familiar: " + prev);
		if (have_familiar(prev))
			use_familiar(prev);
		else
			setFamiliar("");
		return true;
	}
	return false;
}

void checkFamiliar() {
	if (my_location() == $location[hidden temple]) {
		use_familiar($familiar[mini-hipster]);
		return;
	}

	// Don't bother using the HeBo when there's no yellow ray.
	if (my_familiar() == $familiar[He-Boulder] && have_effect($effect[Everything Looks Yellow]) > 0) {
		// If we're using the He-Bo, it's likely that there was only one set of
		// items that we care about.  So, switch to a stat familiar.
		setFamiliar("");
		return;
	}

	if (my_location() == $location[boss bat's lair]) {
		int bat = get_property(propBatTurns).to_int();
		// This delay is arbitrary, but there are at least 4 bodyguard turns.
		// We want to be using the knob grinder for five turns that includes
		// the boss bat to get the stat pie.  So, wait a few turns before
		// pulling out the grinder.
		if (bat > 2) {
			use_familiar($familiar[organ grinder]);
		} else {
			use_familiar($familiar[hobo monkey]);
		}
		bat = bat + 1;
		set_property(propBatTurns, bat);
		return;
	}
	if (checkOrgan())
		return;

	// If we need olfaction, we probably should be using an item familiar.
	if (needOlfaction(my_location())) {
		// There are some times when we lots of levelling in the ballroom is
		// needed.  In these cases, filling spleen becomes more important.
		if (my_location() == $location[haunted ballroom] && my_spleen_use() < 12) {
			use_familiar($familiar[sandworm]);
		} else {
			setFamiliar("items");
		}
		return;
	}

	if (my_spleen_use() >= 12 && my_familiar() == $familiar[sandworm] && my_level() < 9)
		use_familiar($familiar[Frumious Bandersnatch]);
	if (my_level() <= 2)
		use_familiar($familiar[Frumious Bandersnatch]);
}

void equipSugar() {
	if (item_amount($item[sugar shirt]) == 0) {
		if (!have_skill($skill[torso awaregness]))
			return;
		if (equipped_item($slot[shirt]) == $item[sugar shirt])
			return;
		if (!castSugar())
			return;
		if (!retrieve_item(1, $item[sugar shirt]))
			return;
	}
	equip($slot[shirt], $item[sugar shirt]);
}

void useFriars() {
	if (get_property("friarsBlessingReceived").to_boolean())
		return;

	String bless = "";
	switch (my_location()) {
	case $location[pandamonium slums]:
	case $location[goatlet]:
		bless = "food";
		break;
	case $location[barrrney's barrr]:
	case $location[haunted wine cellar (automatic)]:
		bless = "booze";
		break;
	}

	if (my_inebriety() > inebriety_limit())
		bless = "familiar";

	if (bless != "")
		cli_execute("friars " + bless);
}

boolean stillAvailable() {
	return visit_url("guild.php?guild=t").contains_text("Nash Crosby's Still");
}

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

int getSafeMCD(location loc) {
	int maxMCD = 10 + to_int(in_mysticality_sign());
	int set = my_buffedstat(my_primestat()) - safeMox(loc) + current_mcd();
	if (set < 0)
		return 0;
	if (set > maxMCD)
		return maxMCD;
	return set;
}

int getMCD(location loc) {
	switch (loc) {
	case $location[boss bat's lair]:
		switch (my_primestat()) {
			case $stat[muscle]:
				return 8;
			case $stat[mysticality]:
				return 4;
			case $stat[moxie]:
				return 4;
		}
	case $location[throne room]:
		switch (my_primestat()) {
			case $stat[muscle]:
				return 0;
			case $stat[mysticality]:
				return 3;
			case $stat[moxie]:
				return 7;
		}
	case $location[haert of the cyrpt]:
		switch (my_primestat()) {
			case $stat[muscle]:
				return 0;
			case $stat[mysticality]:
				return 5;
			case $stat[moxie]:
				return 0;
		}
	}

	return getSafeMCD(loc);
}

void optimizeMCD(location loc) {
	if (canMCD()) {
		int mcd = getMCD(loc);
		if (mcd != current_mcd())
			change_mcd(mcd);
	}
}

string combatOffstatItems(int round, string opp, string text) {
	if (round == 1 && have_skill($skill[entangling noodles]))
		return "skill entangling noodles";

	item hand1;
	item hand2;
	foreach thing in combatItems {
		if (combatItemToStat(thing) == my_primestat())
			continue;
		if (item_amount(thing) >= 2) {
			hand1 = thing;
			hand2 = thing;
			break;
		} else if (item_amount(thing) == 1) {
			if (hand1 == $item[none]) {
				hand1 = thing;
			} else {
				hand2 = thing;
				break;
			}
		}
	}

	if (hand1 == $item[none])
		abort("You're on your own!");

	if (hand2 == $item[none]) {
		return "item " + hand1;
	}
	return "item " + hand1 + "," + hand2;
}

void endOfDay() {
	// overdrink
	// finish eating and spleening, just in case

	// zap keys
	// zap telescope items (black pepper)
	// zap other items (garnishes?)

	cli_execute("maximize adv");
	useFriars();

	for i from 1 to 3 {
		poolTable("mys");
	}
	trySoak();

	// tea party
	// 	snorkel - +10 moxie
	//  dread sack - +40% meat
	//  reinforced beaded headband - +5 weight
	//  ravioli hat - +10 myst
	//  pail - +20 ML
}

void buyHammer() {
	if (item_amount($item[tenderizing hammer]) != 0)
		return;

	// Drywall axe is the first thing worth pulverizing for a moxie class.
	if (item_amount($item[facsimile dictionary]) > 0) {
		autosell(1, $item[facsimile dictionary]);
	}
	if (my_level() >= 9 && my_meat() >= 3000) {
		retrieve_item(1, $item[tenderizing hammer]);
	}
}

void allowMining() {
	// Mining is an excellent use of burning teleportitis turns.
	// Once we've had teleportitis, no need to delay mining further.
	if (have_effect($effect[Teleportitis]) > 0)
		set_property(propMineUnaccOnly, false);
}

void killKing() {
	if (bcascStage("knobking")) {
		return;
	}

	if (my_primestat() == $stat[moxie] || my_primestat() == $stat[mysticality]) {
		if (!have_skill($skill[entangling noodles]) || !have_skill($skill[ambidextrous funkslinging])) {
			return;
		}

		int damage = 0;
		foreach thing in combatItems {
			stat st = combatItemToStat(thing);
			if (st == my_primestat())
				continue;
			damage += item_amount(thing) * my_buffedstat(st);
		}
		// 7 is the max MCD we'll ever set at the knob goblin king
		if (damage < monster_hp($monster[knob goblin king]) + 7)
			return;
	} else {
		abort("Implement shieldbutting for muscle.");
	}

	boolean haveElite = i_a($item[knob goblin elite pants]) > 0 && i_a($item[knob goblin elite polearm]) > 0 && i_a($item[knob goblin elite helm]) > 0;
	boolean haveCake = item_amount($item[knob cake]) > 0;
	boolean haveHarem = i_a($item[knob goblin harem veil]) > 0 && i_a($item[knob goblin harem pants]) > 0;

	if ((!haveElite || !haveCake) && !haveHarem) {
		return;
	}

	if (haveHarem) {
		cli_execute("maximize mainstat +outfit harem -melee -ml -tie");

		if (item_amount($item[knob goblin perfume]) > 0) {
			use(1, $item[knob goblin perfume]);
		}
		while (have_effect($effect[knob goblin perfume]) == 0) {
			adventure(1, $location[cobb's knob harem]);
		}
	} else {
		cli_execute("maximize mainstat +outfit elite -ml -tie");
	}

	use_familiar($familiar[organ grinder]);
	restore_mp(mp_cost($skill[entangling noodles]));
	optimizeMCD($location[throne room]);
	adventure(1, $location[throne room], "combatOffstatItems");

	if (contains_text(visit_url("questlog.php?which=2"), "slain the Goblin King")) {
		checkStage("knobking", true);
	} else {
		abort("Tried to kill the Goblin King, but unexpectedly failed.");
	}
}

void faxAndArrow(monster mon) {
	if (get_property(propFaxUsed).to_boolean()) {
		abort("Can't fight " + mon + " fax today.");
	}
	get_monster_fax(mon);
	familiar prevFamiliar = my_familiar();
	use_familiar($familiar[obtuse angel]);
	cli_execute("ccs obtuse");
	use(1, $item[photocopied monster]);

	cli_execute("ccs defaultattack");
	use_familiar(prevFamiliar);
}

void day1() {
	if (my_turncount() == 0) {
		firstTurn();
	}

	if (have_effect($effect[everything looks red]) == 0) {
		tryCast($skill[moxious madrigal]);
		useRedRay();
	}

	if (!get_property(propCookware).to_boolean() && bcascStage("tavern") && my_meat() >= 2500) {
		retrieve_item(1, $item[dramatic range]);
		use(1, $item[dramatic range]);
		retrieve_item(1, $item[queue du coq]);
		use(1, $item[queue du coq]);
		set_property(propCookware, true);
	}

	if (my_turncount() > 5 && !counterActive(fortuneCounter) && get_property(semirareCounter).to_int() != my_turncount()) {
		if (my_fullness() < fullness_limit()) {
			eat(1, $item[fortune cookie]);
		}
	}

	if (get_property(propCookware).to_boolean() && my_level() >= 3) {
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

	if (my_inebriety() == 0 && my_primestat() == $stat[moxie] && my_level() >= 2) {
		// Open the guild as soon as possible for tonic water.
		if (my_buffedstat(my_primestat()) > 10) {
			bcascGuild1();
		}

		if (stillAvailable()) {
			tryCast($skill[mojomuscular melody]);
			retrieve_item(1, $item[tonic water]);
			use(1, $item[tonic water]);
			use_skill(1, $skill[ode to booze]);
			cli_execute("garden pick");
			cli_execute("drink 3 pumpkin beer");
		}
	}

	boolean mosquitoQuestDone() {
		return my_level() >= 2 && !contains_text(visit_url("questlog.php?which=1"), "bring them a mosquito larva");
	}

	if (!get_property(propFaxUsed).to_boolean() && get_property(propArrows).to_int() == 0 && romanticTarget() == $monster[none] && item_amount($item[digital key]) == 0 && mosquitoQuestDone()) {
		abort("fax blooper");
		faxAndArrow($monster[blooper]);
		poolTable("mys");
		poolTable("mys");
		if (romanticTarget() == $monster[blooper]) {
			string img = "obtuseangel.gif";
			cli_execute("counters add 25 " + firstRomanticCounter + " " + img);
			cli_execute("counters add 50 " + lastRomanticCounter + " " + img);
			cli_execute("ccs defaultattack");
		}
	}

	boolean romanticWindow() {
		return !counterActive(firstRomanticCounter) && counterActive(lastRomanticCounter);
	}

	if (have_effect($effect[on the trail]) > 0 && olfactTarget() == $monster[blooper] && item_amount($item[digital key]) == 0) {
		bcasc8Bit();
	} else if (romanticWindow() && romanticTarget() == $monster[blooper]) {
		abort("romantic prep");
		olfactionPreparation();
		cli_execute("ccs hardcore");
	}
}

void locationSkills() {
	if (my_location() == $location[boss bat's lair]) {
		tryCast($skill[polka of plenty]);
		tryCast($skill[leash of linguini]);
	}

	if (my_location() == $location[wartime sonofa beach]) {
		if (have_effect($effect[hippy stench]) == 0 && item_amount($item[reodorant]) > 0)
			cli_execute("use * reodorant");
	}

	if (my_location() == $location[defiled cranny] || my_location() == $location[defiled alcove]) {
		tryCast($skill[polka of plenty]);
	}

	if (my_level() >= 6 && my_meat() > 1000)
		tryCast($skill[leash of linguini]);
}

void main() {
	checkOutOfAdventures();
	checkCounters();

	equipSugar();

	if (my_daycount() == 1)
		day1();

	buyHammer();
	allowMining();
	killKing();

	locationSkills();
	process_inventory();
	checkFamiliar();
	if (needOlfaction(my_location())) {
		olfactionPreparation();
	}
	useFriars();

	optimizeMCD(my_location());
}
