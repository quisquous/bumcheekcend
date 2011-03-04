import <autoeat.ash>
import <fax.ash>
import <makemeat.ash>
import <pcklutil.ash>
import <bumcheekascend.ash>

// Forward declarations
void betweenBattleInternal(location loc);

int estimatedRunDays = 5;

boolean preppedAdventure(int count, location loc) {
	// Due to the fact that this script itself is a between battle script,
	// it doesn't call between battle for adventures.  Call it ourselves.
	betweenBattleInternal(loc);
	return adventure(count, loc);
}

boolean preppedAdventure(int count, location loc, string combat) {
	betweenBattleInternal(loc);
	return adventure(count, loc, combat);
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
		return "attack";

	if (hand2 == $item[none]) {
		return "item " + hand1;
	}
	return "item " + hand1 + "," + hand2;
}

void getFortune() {
	location last = get_property(propSemirareLast).to_location();

	if (my_level() >= 9 && !bcascStage("chasm") && last != $location[orc chasm]) {
		// FIXME: Don't get this if we have all the scroll components.
		if (!contains_text(visit_url("mountains.php"), "chasm.gif")) {
			adventure(1, $location[orc chasm]);
			return;
		}
	}

	if (my_level() >= 5 && !haveKGEOutfit()) {
		if (item_amount($item[Cobb's Knob map]) > 0) {
			visit_url("council.php");
			use(1, $item[Cobb's Knob map]);
		}

		// There are two semirares.  Pick one in case the battle was lost.
		location loc = (last == $location[cobb's knob barracks]) ? $location[cobb's knob kitchens] : $location[cobb's knob barracks];

		// FIXME: find some better way to ensure victory
		setFamiliar("");
		restore_mp(mp_cost($skill[entangling noodles]));
		preppedAdventure(1, loc, "combatOffstatItems");
		return;
	}

	if (my_level() < 5 && last != $location[outskirts of the knob]) {
		adventure(1, $location[outskirts of the knob]);
		return;
	}

	if (my_buffedstat(my_primestat()) >= 21) {
		boolean needEyedrops = get_property(propDoSideQuestOrchard).to_boolean() && get_property(propSideQuestOrchardCompleted) == "none";
		boolean haveEyedrops = item_amount($item[cyclops eyedrops]) > 0 || have_effect($effect[one very clear eye]) > 0;
		if (needEyedrops && !haveEyedrops && last != $location[limerick dungeon]) {
			adventure(1, $location[limerick dungeon]);
			return;
		}
	}

	if (bcascStage("airship")) {
		boolean needInhaler = get_property(propDoSideQuestNuns).to_boolean() && get_property(propSideQuestNunsCompleted) == "none";
		boolean haveInhaler = item_amount($item[mick's icyvapohotness inhaler]) > 0 || have_effect($effect[sinuses for miles]) > 0;
		if (needInhaler && !haveInhaler && last != $location[giant's castle]) {
			adventure(1, $location[giant's castle]);
			return;
		}
	}

	if (last != $location[outskirts of the knob]) {
		adventure(1, $location[outskirts of the knob]);
	} else {
		adventure(1, $location[haunted pantry]);
	}
}

void checkCounters(location loc) {
	if (counterThisTurn(danceCardCounter)) {
		if (loc != $location[haunted ballroom]) {
			debug("Detouring to the Ballroom for the dance card counter");
			preppedAdventure(1, $location[haunted ballroom]);
		}
	}
	if (counterThisTurn(fortuneCounter)) {
		getFortune();
	}
}

boolean needOlfaction(location loc) {
	if (!have_skill($skill[transcendent olfaction]))
		return false;

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

void setAutoRestoreLevels() {
	if (my_primestat() != $stat[moxie])
		abort("FIXME for muscle classes");

	float restoreMp = 0;

	if (my_level() < 9) {
		set_property(propAutoHpMin, 0.8);
		set_property(propAutoHpTarget, 0.9);
	} else {
		set_property(propAutoHpMin, 0.9);
		set_property(propAutoHpTarget, 1.0);

		if (have_skill($skill[saucegeyser]))
			restoreMp = mp_cost($skill[saucegeyser]) * 2;
	}
		
	if (have_skill($skill[entangling noodles]))
		restoreMp += mp_cost($skill[entangling noodles]);

	float maxMp = my_maxmp();
	float restorePercent = restoreMp / maxMp;
	float restoreTarget = (restoreMp + 2.0) / maxMp;

	set_property(propAutoMpMin, restorePercent);
	set_property(propAutoMpTarget, restoreTarget);
}

void restoreSelf(location loc) {
	if (loc == $location[hidden temple]) {
		restore_hp(1);
		return;
	}

	if (have_effect($effect[beaten up]) > 0) {
		trySoak();
	}
	if (have_effect($effect[beaten up]) > 0) {
		cli_execute("uneffect beaten up");
	}

	switch (loc) {
	case $location[haert of the cyrpt]:
	case $location[throne room]:
		restore_hp(my_maxhp());
		cli_execute("mood execute; restore mp;");
		break;
	default:
		cli_execute("mood execute; restore hp; restore mp;");
		break;
	}
}

void useRedRay(location loc) {
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
	tryCast($skill[mojomuscular melody]);

	if (canMCD())
		cli_execute("mcd 10");

	preppedAdventure(1, loc, "consultRedRay");

	use_familiar(oldFamiliar);

	// Hack: in case we levelled up, refresh current quests.
	cli_execute("council");
}

void firstTurn() {
	debug("First turn of the run");

	if (item_amount($item[newbiesport tent]) == 0)
		retrieve_item(1, $item[newbiesport tent]);
	use(1, $item[newbiesport tent]);

	getPresent();

	cli_execute("ccs hardcore");

	set_property(propMineUnaccOnly, true);
	set_property(propOrganTurns, 0);
	set_property(propBatTurns, 0);
	set_property(propPieCount, 0);
	set_property(propArrows, 0);
	set_property(propPoolGames, 0);
	set_property(propOrganFinishPie, false);
	set_property(propSemirareKGE, true);

	initAutoEat();
}

// Returns true if this function has set the familiar.
boolean checkOrgan() {
	// Don't switch from he-boulder if we're trying to YR something.
	if (my_familiar() == $familiar[he-boulder])
		return false;

	if (!have_familiar($familiar[organ grinder]))
		return false;

	int organ = get_property(propOrganTurns).to_int();
	int pie = get_property(propPieCount).to_int();
	boolean needOrgan = organ > 0 && pie == 0 && get_property(propOrganFinishPie).to_boolean();
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

void checkFamiliar(location loc) {
	if (have_familiar($familiar[mini-hipster])) {
		int hipster = get_property(propHipsterAdv).to_int();
		boolean inCrypt = (
			loc == $location[defiled alcove] ||
			loc == $location[defiled cranny] ||
			loc == $location[defiled niche] ||
			loc == $location[defiled nook]);
		if (loc == $location[hidden temple] || loc == $location[spooky forest] && hipster <= 4 || inCrypt && hipster <= 6) {
			use_familiar($familiar[mini-hipster]);
			restore_mp(mp_cost($skill[entangling noodles]));
			return;
		}
	}

	// Don't bother using the HeBo when there's no yellow ray.
	if (my_familiar() == $familiar[He-Boulder] && have_effect($effect[Everything Looks Yellow]) > 0) {
		// If we're using the He-Bo, it's likely that there was only one set of
		// items that we care about.  So, switch to a stat familiar.
		setFamiliar("");
		return;
	}

	if (have_familiar($familiar[organ grinder])) {
		// FIXME: This could be smarter by killing mini-bosses and making pies,
		// but there's no easy way to track if a boss made it into the pie.
		if (loc == $location[defiled cranny] || loc == $location[defiled alcove]) {
			int parts = get_property(propOrganTurns).to_int();
			int pie = get_property(propPieCount).to_int();
			if (parts < 4 && pie == 0) {
				set_property(propOrganFinishPie, false);
				use_familiar($familiar[organ grinder]);
				return;
			} else {
				setFamiliar("");
				return;
			}
		}

		// Kill bonerdagon and make a badass pie.
		if (loc == $location[haert of the cyrpt]) {
			int parts = get_property(propOrganTurns).to_int();
			int pie = get_property(propPieCount).to_int();
			if (parts == 4 && pie == 0) {
				use_familiar($familiar[organ grinder]);
				return;
			} else {
				setFamiliar("");
				return;
			}
		}
	}

	if (have_familiar($familiar[organ grinder]) && have_familiar($familiar[hobo monkey])) {
		if (loc == $location[boss bat's lair]) {
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
			set_property(propOrganFinishPie, true);
			return;
		}
		if (checkOrgan())
			return;
	}

	// If we need olfaction, we probably should be using an item familiar.
	if (needOlfaction(loc)) {
		// There are some times when we lots of levelling in the ballroom is
		// needed.  In these cases, filling spleen becomes more important.
		if (loc == $location[haunted ballroom] && my_spleen_use() < 12) {
			setFamiliar("");
		} else {
			setFamiliar("items");
		}
		return;
	}

	if (have_familiar($familiar[frumious bandersnatch])) {
		if (my_spleen_use() >= 12 && my_familiar() == $familiar[sandworm] && my_level() < 9)
			use_familiar($familiar[Frumious Bandersnatch]);
		if (my_level() <= 2)
			use_familiar($familiar[Frumious Bandersnatch]);
	}
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

void useFriars(location loc) {
	if (get_property("friarsBlessingReceived").to_boolean())
		return;

	String bless = "";
	switch (loc) {
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

void endOfDay() {
	// overdrink
	// finish eating and spleening, just in case

	// zap keys
	// zap telescope items (black pepper)
	// zap other items (garnishes?)

	// still uses

	cli_execute("maximize adv");
	useFriars($location[none]);

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
	if (!have_skill($skill[pulverize]))
		return;

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

	boolean haveElite = haveKGEOutfit();
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
			preppedAdventure(1, $location[cobb's knob harem]);
		}
	} else {
		cli_execute("maximize mainstat +outfit elite -ml -tie");
	}

	while (haveHarem && have_effect($effect[knob goblin perfume]) > 0 || haveElite && haveCake && have_effect($effect[beaten up]) == 0) {
		betweenBattleInternal($location[throne room]);
		use_familiar($familiar[organ grinder]);
		restore_mp(mp_cost($skill[entangling noodles]));
		optimizeMCD($location[throne room]);

		adventure(1, $location[throne room], "combatOffstatItems");
	}

	if (contains_text(visit_url("questlog.php?which=2"), "slain the Goblin King")) {
		checkStage("knobking", true);
	} else {
		abort("Tried to kill the Goblin King, but unexpectedly failed.");
	}
}

void getHellionCubes() {
	if (bcascStage("friars") || olfactTarget() != $monster[hellion])
		return;

	int cubesNeeded = (estimatedRunDays - my_daycount()) * 2;
	while (olfactTarget() == $monster[hellion] && item_amount($item[hellion cube]) < cubesNeeded) {
		debug("Getting hellion cubes: " + item_amount($item[hellion cube]) + " / " + cubesNeeded);
		preppedAdventure(1, $location[dark neck of the woods]);
	}

	boolean canPerformRitual() {
		return item_amount($item[eldritch butterknife]) > 0 && item_amount($item[box of birthday candles]) > 0 && item_amount($item[dodecagram]) > 0;
	}

	void performRitual() {
		visit_url("friars.php?action=ritual&pwd");
	}

	if (canPerformRitual())
		performRitual();
}

void openDispensary() {
	if (dispensary_available() || !haveKGEOutfit())
		return;

	cli_execute("outfit save picklish");
	cli_execute("maximize mainstat +outfit elite -ml -tie");
	preppedAdventure(1, $location[cobb's knob barracks]);
	cli_execute("outfit picklish");
}

void faxAndArrow(monster mon) {
	if (get_property(propFaxUsed).to_boolean()) {
		abort("Can't fight " + mon + " fax today.");
	}
	get_monster_fax(mon);
	familiar prevFamiliar = my_familiar();
	use_familiar($familiar[obtuse angel]);
	cli_execute("ccs obtuse");

	// FIXME: the ccs has a 'use entangling noodles' call first
	// http://kolmafia.us/showthread.php?6142-CCS-for-photocopied-monster-fights
	restore_mp(mp_cost($skill[entangling noodles]));

	use(1, $item[photocopied monster]);

	cli_execute("ccs hardcore");
	use_familiar(prevFamiliar);
}

void day1() {
	if (my_turncount() == 0) {
		firstTurn();
	}

	if (my_inebriety() == 0 && my_primestat() == $stat[moxie] && my_level() >= 2) {
		// Open the guild as soon as possible for tonic water.
		if (my_buffedstat(my_primestat()) > 10) {
			bcascGuild1();
		}
	}

	boolean mosquitoQuestDone() {
		return my_level() >= 2 && !contains_text(visit_url("questlog.php?which=1"), "bring them a mosquito larva");
	}

	if (!get_property(propFaxUsed).to_boolean() && get_property(propArrows).to_int() == 0 && romanticTarget() == $monster[none] && item_amount($item[digital key]) == 0 && mosquitoQuestDone()) {
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

	if (olfactTarget() == $monster[blooper] && item_amount($item[digital key]) == 0) {
		bcasc8Bit();
	} else if (romanticWindow() && romanticTarget() == $monster[blooper]) {
		olfactionPreparation();
		cli_execute("ccs hardcore");
	}
}

void locationSkills(location loc) {
	if (loc == $location[boss bat's lair]) {
		tryShrug($skill[fat leon's phat loot lyric]);
		tryCast($skill[polka of plenty]);
		tryCast($skill[leash of linguini]);
	}

	if (loc == $location[wartime sonofa beach]) {
		if (have_effect($effect[hippy stench]) == 0 && item_amount($item[reodorant]) > 0)
			use(1, $item[reodorant]);
	}

	if (loc == $location[defiled cranny] || loc == $location[defiled alcove]) {
		tryShrug($skill[fat leon's phat loot lyric]);
		tryCast($skill[polka of plenty]);
	}

	if (my_level() >= 6 && my_meat() > 1000)
		tryCast($skill[leash of linguini]);

	if (loc == $location[hatching chamber] || loc == $location[feeding chamber] || loc == $location[guard chamber]) {
		if (have_effect($effect[one very clear eye]) == 0) {
			if (item_amount($item[cyclops eyedrops]) > 0) {
				use(1, $item[cyclops eyedrops]);
			}
		}

		boolean canSparePoolGame() {
			// Save last pool game for giant familiars, unless KGE.
			int maxGames = dispensary_available() ? 3 : 2;
			return get_property(propPoolGames).to_int() < maxGames;
		}

		if (canSparePoolGame() && have_effect($effect[hustlin']) == 0) {
			poolTable("sty");
		}
	}
}

void main() {
	// Any functions that may do adventuring should go first.
	killKing();
	if (my_level() < 6)
		useRedRay(my_location());
	getHellionCubes();
	openDispensary();

	betweenBattleInternal(my_location());
}

void betweenBattleInternal(location loc) {
	if (!canAdventure())
		abort("Out of adventures!");
	autoEat(loc);
	checkCounters(loc);

	equipSugar();

	if (my_daycount() == 1)
		day1();

	buyHammer();
	allowMining();

	locationSkills(loc);
	process_inventory();
	checkFamiliar(loc);
	if (needOlfaction(loc)) {
		olfactionPreparation();
	}
	useFriars(loc);
	optimizeMCD(loc);
	setAutoRestoreLevels();
	restoreSelf(loc);
}
