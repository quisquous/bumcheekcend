import <makemeat.ash>
import <bumcheekascend.ash>

String propBatTurns = "_picklishBatTurns";
String propOrganTurns = "_piePartsCount";
String propPieCount = "_pieDrops";
String danceCardCounter = "Dance Card";
String fortuneCounter = "Fortune Cookie";

void debug(String s) {
	print("PCKLSH: " + s, "green");
}

monster olfactTarget() {
	return get_property("olfactedMonster").to_monster();
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

void checkCounters() {
	if (get_counters(danceCardCounter, 0, 0) == danceCardCounter) {
		if (my_location() != $location[haunted ballroom]) {
			debug("Detouring to the Ballroom for the dance card counter");
			adventure(1, $location[haunted ballroom]);
		}
	}
	if (get_counters(fortuneCounter, 0, 0) == fortuneCounter) {
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
	if (!needOlfaction(my_location()))
		return;

	// If we need olfaction, we probably should be using an item familiar.
	setFamiliar("items");
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
	if (item_amount($item[clan vip lounge key]) > 0 && get_property("_poolGames") < 3 && have_effect($effect[billiards belligerence]) == 0)
		cli_execute("pool agg");

	// Since the he-boulder restores a lot of MP, try to capture it.
	if (have_skill($skill[mojomuscular melody]) && have_effect($effect[mojomuscular melody]) == 0)
		use_skill(1, $skill[mojomuscular melody]);

	if (canMCD())
		cli_execute("mcd 10");

	adv1(my_location(), 0, "consultRedRay");

	use_familiar(oldFamiliar);
}

void firstTurn() {
	if (item_amount($item[newbiesport tent]) == 0)
		retrieve_item(1, $item[newbiesport tent]);
	use(1, $item[newbiesport tent]);

	if (visit_url("clan_viplounge.php").contains_text("a present under it"))
		visit_url("clan_viplounge.php?action=crimbotree");

	set_property(propOrganTurns, 0);
	set_property(propBatTurns, 0);
	set_property(propPieCount, 0);
}

void checkOrgan() {
	int organ = get_property(propOrganTurns).to_int();
	int pie = get_property(propPieCount).to_int();
	if (organ > 0 && pie == 0)
		use_familiar($familiar[organ grinder]);
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

void main() {
	checkOutOfAdventures();
	checkCounters();

	// Override for faxed in/arrowed blooper.
	// TODO(picklish) - do day 1 fax, arrow #1, pool after #2, olfact #3
	if (have_effect($effect[on the trail]) > 0 && olfactTarget() == $monster[blooper] && item_amount($item[digital key]) == 0) {
		bcasc8Bit();
	}

	if (my_turncount() == 0)
		firstTurn();
	equipSugar();
	if (my_daycount() == 1 && have_effect($effect[everything looks red]) == 0) {
		tryCast($skill[moxious madrigal]);
		useRedRay();
	}
	if (my_daycount() == 1 && my_inebriety() == 0) {
		if (my_primestat() == $stat[moxie] && visit_url("guild.php?guild=t").contains_text("Nash Crosby's Still")) {
			tryCast($skill[mojomuscular melody]);
			retrieve_item(1, $item[tonic water]);
			use(1, $item[tonic water]);
			use_skill(1, $skill[ode to booze]);
			cli_execute("garden pick");
			cli_execute("drink 3 pumpkin beer");
		}
	}

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

	process_inventory();
	checkFamiliar();
	olfactionPreparation();
	checkOrgan();
	useFriars();
}
