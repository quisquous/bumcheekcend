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

String danceCardCounter = "Dance Card";
String fortuneCounter = "Fortune Cookie";
String firstRomanticCounter = "Last romantic begin";
String lastRomanticCounter = "Last romantic end";
String semirareCounter = "semirareCounter";

void debug(String s) {
	print("PCKLSH: " + s, "green");
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

	if (!get_property(propCookware).to_boolean() && checkStage("tavern") && my_meat() >= 2500) {
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

		boolean trySoak() {
			if (item_amount($item[clan vip lounge key]) == 0 || get_property(propSoak).to_int() >= 5) {
				return false;
			}
			return cli_execute("soak");
		}

		if (have_effect($effect[beaten up]) > 0) {
			trySoak();
		}
	}

	if (get_property(propCookware).to_boolean() && my_level() >= 4 && checkStage("tavern")) {
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

	locationSkills();
	process_inventory();
	checkFamiliar();
	if (needOlfaction(my_location())) {
		olfactionPreparation();
	}
	useFriars();
}
