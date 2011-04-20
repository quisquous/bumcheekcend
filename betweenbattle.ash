import <autoeat.ash>
import <fax.ash>
import <makemeat.ash>
import <pcklutil.ash>
import <bumcheekascend.ash>

// Forward declarations
void betweenBattleInternal(location loc);
void betweenBattlePrep(location loc);

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

// Ignore counters and spend the next adventure in this location.
boolean preppedAdv1(location loc) {
	betweenBattlePrep(loc);
	return adv1(loc, 0, "");
}

boolean preppedAdv1(location loc, string combat) {
	betweenBattlePrep(loc);
	return adv1(loc, 0, combat);
}

string combatHard(int round, string opp, string text) {
	// Because this logic gets used both from a ccs and as a combat filter,
	// it has to be a consult script.
	return "consult consulthard.ash";
}

void useWarMoney() {
	if (my_level() < 12)
		return;

	// FIXME: Use remaining money before final battle.

	string propMoney;
	string propDefeated;
	item healingItem;
	item foodItem;
	item moneyItem;
	int campId;
	if (get_property(propWarSide) == "frat") {
		propMoney = propWarFratMoney;
		propDefeated = propWarFratDefeated;
		healingItem = $item[gauze garter];
		foodItem = $item[frat army fgf];
		moneyItem = $item[commemorative war stein];
		campId = 2;
	} else if (get_property(propWarSide) == "hippy") {
		propMoney = propWarHippyMoney;
		propDefeated = propWarHippyDefeated;
		healingItem = $item[filthy poultice];
		foodItem = $item[hippy army mpe];
		moneyItem = $item[fancy seashell necklace];
		campId = 1;
	} else {
		abort("unknown side");
	}

	int money = get_property(propMoney).to_int();
	if (money == 0)
		return;

	// Don't start buying healing items until we're halfway done.
	// This lets food items get purchased first, which might be needed more.
	if (get_property(propDefeated) >= 500) {
		int numHealingItems = 0;
		foreach thing in $items[
			filthy poultice,
			gauze garter,
			red pixel potion,
		] {
			numHealingItems += item_amount(thing);
		}

		int desiredHealingItems = 6;
		if (numHealingItems < desiredHealingItems) {
			int canBuy = money / 2;
			int num = desiredHealingItems - numHealingItems;
			num = num < canBuy ? canBuy : num;
			buyWarItem(num, healingItem);
			money = get_property(propMoney).to_int();
		}
	}

	// FIXME: Stop buying food items and buy money items instead at some point.
	int numFood = money / 10;
	if (numFood > 0)
		buyWarItem(numFood, foodItem);
}

void getFortune() {
	location last = get_property(propSemirareLast).to_location();

	if (my_level() >= 9 && !bcascStage("chasm") && last != $location[orc chasm]) {
		boolean haveTwo334 = item_amount($item[334 scroll]) >= 2 || item_amount($item[668 scroll]) >= 1;
		boolean have30669 = haveItem($item[30669 scroll]) || haveItem($item[64067 scroll]);
		boolean have33398 = haveItem($item[33398 scroll]) || haveItem($item[64067 scroll]);
		boolean haveEverything = haveTwo334 && have30669 && have33398 || haveItem($item[64735 scroll]);
		if (!haveEverything && !contains_text(visit_url("mountains.php"), "chasm.gif")) {
			preppedAdv1($location[orc chasm]);
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
		preppedAdv1(loc, "combatHard");
		return;
	}

	if (my_level() < 5 && last != $location[outskirts of the knob]) {
		preppedAdv1($location[outskirts of the knob]);
		return;
	}

	if (my_buffedstat(my_primestat()) >= 21) {
		boolean needEyedrops = get_property(propDoSideQuestOrchard).to_boolean() && get_property(propSideQuestOrchardCompleted) == "none";
		boolean haveEyedrops = item_amount($item[cyclops eyedrops]) > 0 || have_effect($effect[one very clear eye]) > 0;
		if (needEyedrops && !haveEyedrops && last != $location[limerick dungeon]) {
			preppedAdv1($location[limerick dungeon]);
			return;
		}
	}

	if (bcascStage("airship")) {
		boolean needInhaler = get_property(propDoSideQuestNuns).to_boolean() && get_property(propSideQuestNunsCompleted) == "none";
		boolean haveInhaler = item_amount($item[mick's icyvapohotness inhaler]) > 0 || have_effect($effect[sinuses for miles]) > 0;
		if (needInhaler && !haveInhaler && last != $location[giant's castle]) {
			preppedAdv1($location[giant's castle]);
			return;
		}
	}

	// FIXME: Right now this will use one more cookie than we really need.
	set_property(propNeedFortuneCookie, false);

	if (last != $location[outskirts of the knob]) {
		preppedAdv1($location[outskirts of the knob]);
	} else {
		preppedAdv1($location[haunted pantry]);
	}
}

boolean needOlfaction(location loc) {
	if (!have_skill($skill[transcendent olfaction]))
		return false;

	if (get_property(propRomanticEncounters) == 1 && romanticTarget() == $monster[blooper] && !haveItem($item[digital key])) {
		return true;
	}

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
	}

	return false;
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

void setAutoRestoreLevels(location loc) {
	if (my_primestat() != $stat[moxie])
		abort("FIXME for muscle classes");

	float restoreMp = 0;

	if (my_level() < 9) {
		set_property(propAutoHpMin, 0.8);
		set_property(propAutoHpTarget, 0.9);
	} else {
		set_property(propAutoHpMin, 0.9);
		set_property(propAutoHpTarget, 0.95);

		if (have_skill($skill[saucegeyser]))
			restoreMp = mp_cost($skill[saucegeyser]) * 2;
	}

	if (needOlfaction(loc) && have_effect($effect[on the trail]) == 0) {
		restoreMp += mp_cost($skill[transcendent olfaction]);
	}

	if (have_skill($skill[entangling noodles]))
		restoreMp += mp_cost($skill[entangling noodles]);

	float maxMp = my_maxmp();
	float restorePercent = restoreMp / maxMp;
	float restoreTarget = restorePercent + 0.05;

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
		restore_mp(my_maxmp() * get_property(propAutoMpMin).to_float());
		cli_execute("mood execute");
		break;
	default:
		restore_hp(my_maxhp() * get_property(propAutoHpMin).to_float());
		restore_mp(my_maxmp() * get_property(propAutoMpMin).to_float());
		cli_execute("mood execute");
		break;
	}
}

void burnExcessMp(location loc)
{
	int expectedRestore = mpRegeneration();

	// "Go slowly past the drawers" => 40-50 HP and MP
	if (loc == $location[defiled cranny])
		expectedRestore += 50;

	boolean tryBurn(skill s) {
		if (!have_skill(s))
			return false;

		int minMp = get_property(propAutoMpMin).to_float() * my_maxmp();
		if (my_mp() - mp_cost(s) < minMp)
			return false;
		
		return use_skill(1, s);
	}

	// use_skill returns true even if summon has already occurred, so track
	// if we've tried this already.
	boolean triedTasteful = false;
	boolean triedAlice = false;
	boolean triedHilarious = false;

	while (expectedRestore - (my_maxmp() - my_mp()) > 0) {
		if (have_effect($effect[mojomuscular melody]) <= 1 && tryBurn($skill[mojomuscular melody]))
			continue;

		if (get_property(propCocktailSummons).to_int() < maxCocktailSummons() && tryBurn($skill[advanced cocktailcrafting]))
			continue;

		if (mp_cost($skill[summon party favor]) < 30 && tryBurn($skill[summon party favor]))
			continue;

		if (!triedTasteful && tryBurn($skill[summon tasteful items])) {
			triedTasteful = true;
			continue;
		}

		if (!triedAlice && tryBurn($skill[summon alice's army cards])) {
			triedAlice = true;
			continue;
		}

		if (!triedHilarious && tryBurn($skill[summon hilarious objects])) {
			triedHilarious = true;
			continue;
		}

		if (get_property(propNoodleSummons).to_int() < maxNoodleSummons() && tryBurn($skill[pastamastery]))
			continue;

		if (get_property(propReagentSummons).to_int() < maxReagentSummons() && tryBurn($skill[advanced saucecrafting]))
			continue;

		if (tryBurn($skill[leash of linguini]))
			continue;

		if (haveItem($item[turtle totem]) && tryBurn($skill[empathy of the newt]))
			continue;

		// FIXME: Use somebody else's auto-burn script here.
		// FIXME: Also consider setting the rebalance buffs flag.
		break;
	}
}

void useRedRay(location loc) {
	if (have_effect($effect[everything looks red]) > 0)
		return;
	if (!have_familiar($familiar[he-boulder]))
		return;

	use_familiar($familiar[he-boulder]);
	if (item_amount($item[sugar shield]) == 0 && equipped_item($slot[familiar]) != $item[sugar shield]) {
		if (castSugar()) {
			retrieve_item(1, $item[sugar shield]);
			equip($slot[familiar], $item[sugar shield]);
		}
	}
	if (have_skill($skill[leash of linguini]) && have_effect($effect[leash of linguini]) == 0)
		use_skill(1, $skill[leash of linguini]);
	if (item_amount($item[clan vip lounge key]) > 0 && get_property(propPoolGames) < 3 && have_effect($effect[billiards belligerence]) == 0) {
		poolTable("agg");
	}

	// Since the he-boulder restores a lot of MP, try to capture it.
	tryCast($skill[mojomuscular melody]);

	if (canMCD())
		cli_execute("mcd 10");

	preppedAdventure(1, loc, "consultRedRay");

	use_familiar(get_property(propPrevFamiliar).to_familiar());

	// Hack: in case we levelled up, refresh current quests.
	cli_execute("council");
}

void firstTurn() {
	if (bcascStage("firstturn"))
		return;
	debug("First turn of the run");

	string campground = visit_url("campground.php");

	if (!contains_text(campground, "rest1.gif") && !contains_text(campground, "rest1_free.gif")) {
		if (item_amount($item[newbiesport tent]) == 0)
			retrieve_item(1, $item[newbiesport tent]);
		use(1, $item[newbiesport tent]);
	}

	getPresent();

	cli_execute("ccs hardcore");
	if (get_property(propTelescopeUpgrades).to_int() > 0)
		cli_execute("telescope low");

	set_property(propMineUnaccOnly, true);
	set_property(propOrganTurns, 0);
	set_property(propBatTurns, 0);
	set_property(propPieCount, 0);
	set_property(propArrows, 0);
	set_property(propPoolGames, 0);
	set_property(propOrganFinishPie, false);
	set_property(propSemirareKGE, true);
	set_property(propNeedFortuneCookie, true);
	set_property(propFaxArt, 0);
	set_property(propFaxBlooper, 0);
	set_property(propFaxLobster, 0);

	set_property(propChefMake, true);
	set_property(propChefHave, false);
	set_property(propLevelMeCommand, "call levelup.ash");

	// This script autosells war items, so don't abort for the war boss.
	setBcascStageComplete("prewarboss");

	initAutoEat();

	setBcascStageComplete("firstturn");
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

	if (organ == 0 && pie > 0)
		set_property(propOrganFinishPie, false);

	boolean needOrgan = organ > 0 && pie == 0 || get_property(propOrganFinishPie).to_boolean() && pie == 0;
	if (needOrgan && my_familiar() == $familiar[organ grinder])
		return true;
	if (!needOrgan && my_familiar() != $familiar[organ grinder])
		return false;

	if (needOrgan) {
		use_familiar($familiar[organ grinder]);
		return true;
	} else {
		familiar prev = get_property(propPrevFamiliar).to_familiar();
		if (have_familiar(prev) && prev != $familiar[organ grinder])
			use_familiar(prev);
		else
			setFamiliar("");
		return true;
	}
	return false;
}

void checkFamiliar(location loc) {
	if (my_familiar() == $familiar[obtuse angel]) {
		return;
	}

	if (have_familiar($familiar[organ grinder])) {
		// FIXME: This could be smarter by killing mini-bosses and making pies,
		// but there's no easy way to track if a boss made it into the pie.
		if (loc == $location[defiled cranny] || loc == $location[defiled alcove]) {
			int parts = get_property(propOrganTurns).to_int();
			int pie = get_property(propPieCount).to_int();
			if (parts < 4 && pie == 0 && !get_property(propOrganFinishPie).to_boolean()) {
				set_property(propOrganFinishPie, false);
				use_familiar($familiar[organ grinder]);
				return;
			}
		}

		// Kill bonerdagon and make a badass pie.
		if (loc == $location[haert of the cyrpt]) {
			int parts = get_property(propOrganTurns).to_int();
			int pie = get_property(propPieCount).to_int();
			use_familiar($familiar[organ grinder]);

			// If this won't complete a pie, do so ourselves.
			set_property(propOrganFinishPie, parts != 4 || pie != 0);
			return;
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

	int hipster = get_property(propHipsterAdv).to_int();
	if (have_familiar($familiar[mini-hipster]) && hipster < 7) {
		boolean inCrypt = (
			loc == $location[defiled alcove] ||
			loc == $location[defiled cranny] ||
			loc == $location[defiled niche] ||
			loc == $location[defiled nook]);
		if (loc == $location[hidden temple] ||
			loc == $location[spooky forest] && hipster <= 4 ||
			inCrypt ||
			loc == $location[palindome] && have_effect($effect[everything looks yellow]) > 0 ||
			loc == $location[cobb's knob laboratory]) {
			use_familiar($familiar[mini-hipster]);
			restore_mp(mp_cost($skill[entangling noodles]));
			return;
		}
	} else if (my_familiar() == $familiar[mini-hipster]) {
		use_familiar(get_property(propPrevFamiliar).to_familiar());
	}

	void useStatFamiliar() {
		// This isn't perfect.  Arguably maybe you want to level up the bander
		// more for runaways or maybe level up the sandworm earlier to get
		// more stats later.  Still, switch to the local maximum.

		float bestStats = 0.0;
		familiar bestFamiliar = $familiar[none];

		foreach fam in $familiars[
			baby sandworm,
			bandersnatch,
			sombrero,
			volleyball,
		] {
			float stats = statsForFamiliar(fam, my_location());
			if (have_familiar(fam) && stats > bestStats) {
				bestStats = stats;
				bestFamiliar = fam;
			}
		}

		if (bestFamiliar != $familiar[none])
			use_familiar(bestFamiliar);
		else
			setFamiliar("");
	}

	void useSpleenFamiliar() {
		int agua = get_property(propAguaDrops).to_int();
		int token = get_property(propTokenDrops).to_int();
		if (have_familiar($familiar[baby sandworm]) && agua < token)
			use_familiar($familiar[baby sandworm]);
		else if (have_familiar($familiar[rogue program]))
			use_familiar($familiar[rogue program]);
		else
			setFamiliar("");
	}

	void useItemFamiliar() {
		setFamiliar("items");
	}

	// Don't bother using the HeBo when there's no yellow ray.
	if (my_familiar() == $familiar[He-Boulder] && have_effect($effect[Everything Looks Yellow]) > 0) {
		// If we're using the He-Bo, it's likely that there was only one set of
		// items that we care about.  So, switch to a stat familiar.
		useStatFamiliar();
		return;
	} else if (my_familiar() == $familiar[He-Boulder]) {
		// If we're using a hebo, there's probably a good reason.
		return;
	}

	boolean needSpleen() {
		if (!have_familiar($familiar[rogue program]) && !have_familiar($familiar[baby sandworm]))
			return false;

		if (spleen_limit() - my_spleen_use() < 4)
			return false;

		if (my_level() >= 4)
			return true;

		int quantity = 0;
		foreach thing in $items[
			agua de vida,
			coffee pixie stick,
			game grid token,
		] {
			quantity += item_amount(thing);
		}

		return spleen_limit() - my_spleen_use() - quantity * 4 >= 4;
	}

	// If we need olfaction, we probably should be using an item familiar.
	if (needOlfaction(loc)) {
		// There are some times when we lots of levelling in the ballroom is
		// needed.  In these cases, filling spleen becomes more important.
		if (loc == $location[haunted ballroom] && needSpleen())
			useSpleenFamiliar();
		else
			useItemFamiliar();
		return;
	}

	// Don't override item familiars.
	if (get_property(propPrevFamiliar).to_familiar() == $familiar[hound dog] ||
		get_property(propPrevFamiliar).to_familiar() == $familiar[slimeling]) {
		return;
	}

	if (needSpleen() && my_level() > 2)
		useSpleenFamiliar();
	else
		useStatFamiliar();
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
	if (get_property(propBlessingReceived).to_boolean())
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

void pawnHipsterItemsInto(item goal)
{
	if (my_familiar() != $familiar[mini-hipster])
		return;

	item equipped = familiar_equipped_equipment($familiar[mini-hipster]);
	if (equipped == goal)
		return;

	if (equipped != $item[none])
		retrieve_item(1, equipped);

	while (!haveItem(goal)) {
		boolean haveAny = false;

		foreach thing in $items[
			ironic moustache,
			chiptune guitar,
			fixed-gear bicycle,
		] {
			if (!haveItem(thing))
				continue;
			haveAny = true;
			if (thing != goal)
				use(1, thing);
		}
		
		if (!haveAny)
			return;
	}

	if (!haveItem(goal))
		abort("Internal error");

	equip(goal);
}

void allowMining() {
	// Mining is an excellent use of burning teleportitis turns.
	// Once we've had teleportitis, no need to delay mining further.
	if (have_effect($effect[Teleportitis]) > 0 || bcascStage("wand"))
		set_property(propMineUnaccOnly, false);
}

void killKing() {
	boolean knobKingSlain() {
		if (!contains_text(visit_url("questlog.php?which=2"), "slain the Goblin King"))
			return false;
		setBcascStageComplete("knobking");
		return true;
	}

	if (bcascStage("knobking") || knobKingSlain()) {
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

	if (haveHarem && have_effect($effect[knob goblin perfume]) > 0 || haveElite && haveCake && have_effect($effect[beaten up]) == 0) {
		betweenBattleInternal($location[throne room]);
		use_familiar($familiar[organ grinder]);
		set_property(propOrganFinishPie, true);
		restore_mp(mp_cost($skill[entangling noodles]));
		optimizeMCD($location[throne room]);

		adventure(1, $location[throne room], "combatHard");
	}

	if (!knobKingSlain()) {
		abort("Tried to kill the Goblin King, but unexpectedly failed.");
	}
}

void getHellionCubes() {
	if (bcascStage("friars") || olfactTarget() != $monster[hellion])
		return;

	int cubesNeeded = (estimatedRunDays - my_daycount() - 1) * 2 + (fullness_limit() - my_fullness()) / 6;
	
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

	if (canPerformRitual()) {
		setBcascStageComplete("friars");
		performRitual();
	}
}

void openDispensary() {
	if (dispensary_available() || !haveItem($item[cobb's knob lab key]) || !haveKGEOutfit()) {
		return;
	}

	if (guild_store_available()) {
		if (my_class() == $class[accordion thief] || my_primestat() == $stat[mysticality])
			return;
	}

	cli_execute("outfit save picklish");
	cli_execute("maximize mainstat +outfit elite -ml -tie");
	preppedAdventure(1, $location[cobb's knob barracks]);
	cli_execute("outfit picklish");

	if (!dispensary_available()) {
		abort("Adventured in the barracks, but no password?");
	}
}

void faxAndFight(monster mon) {
	if (get_property(propFaxUsed).to_boolean()) {
		abort("Can't fight " + mon + " fax today.");
	}

	if (!get_monster_fax(mon))
		abort("Failed to fax " + mon);
	betweenBattlePrep(my_location());
	restore_mp(mp_cost($skill[entangling noodles]));
	use(1, $item[photocopied monster]);
}

void faxAndArrow(monster mon) {
	if (get_property(propFaxUsed).to_boolean()) {
		abort("Can't fight " + mon + " fax today.");
	}
	if (!get_monster_fax(mon))
		abort("Failed to fax " + mon);
	use_familiar($familiar[obtuse angel]);
	cli_execute("ccs obtuse");

	// FIXME: the ccs has a 'use entangling noodles' call first
	// http://kolmafia.us/showthread.php?6142-CCS-for-photocopied-monster-fights
	restore_mp(mp_cost($skill[entangling noodles]));

	use(1, $item[photocopied monster]);

	cli_execute("ccs hardcore");
	use_familiar(get_property(propPrevFamiliar).to_familiar());

	set_property(propRomanticEncounters, 0);
}

void autoFax(boolean force) {
	if (get_property(propFaxUsed).to_boolean())
		return;

	if (!haveItem($item[digital key])) {
		boolean mosquitoQuestDone() {
			return my_level() >= 2 && bcascStage("pantry") && !contains_text(visit_url("questlog.php?which=1"), "bring them a mosquito larva");
		}

		if (!get_property(propFaxUsed).to_boolean() && get_property(propArrows).to_int() == 0 && romanticTarget() == $monster[none] && item_amount($item[digital key]) == 0 && mosquitoQuestDone()) {
			faxAndArrow($monster[blooper]);
			set_property(propFaxBlooper, 1);

			// Ease on MP requirements for olfaction.
			poolTable("mys");
			poolTable("mys");
		}

		// If no digital key, don't fax anything else yet.
		return;
	}

	if (!bcascStage("chasm") && get_property(propFaxArt).to_int() == 0) {
		monster target = $monster[bad ascii art];
		if (canOutMoxie(target) || my_adventures() < 10 || force) {
			faxAndFight(target);
			set_property(propFaxArt, 1);
		}

		return;
	}

	if (item_amount($item[barrel of gunpowder]) < 5 && get_property(propSideQuestLighthouseCompleted) == "none") {
		// FIXME: Check on divine combat items here.

		faxAndArrow($monster[lobsterfrogman]);
		set_property(propFaxLobster, get_property(propFaxLobster).to_int() + 1);
		return;
	}

	// FIXME: get telescope items
}

void openGuild() {
	if (!bcascStage("guild1") && my_inebriety() == 0 && my_primestat() == $stat[moxie] && my_level() >= 2) {
		// Open the guild as soon as possible for tonic water.
		if (my_buffedstat(my_primestat()) > 10) {
			bcascGuild1();
		}
	}
}

boolean haveChefParts() {
	return haveItem($item[chef's hat]) && (haveItem($item[spring]) || in_muscle_sign());
}

void getBoxes() {
	boolean checkChef() {
		if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "chefinbox.gif")) {
			return false;
		}

		set_property(propChefHave, true);
		return true;
	}

	if (!get_property(propChefMake).to_boolean() || get_property(propChefHave).to_boolean() || haveItem($item[box]) || checkChef()) {
		return;
	}

	// FIXME: get a chef's hat at some point?
	if (!haveChefParts())
		return;

	// Balance out clover usage by waiting on bats1 and the RnR.
	// FIXME: Probably need to wait on big rocks for other classes.
	if (!bcascStage("bats1") || !haveEpicWeapon() && !haveLegendaryWeapon())
		return;

	// Funhouse requirement.
	if (my_buffedstat(my_primestat()) < 15)
		return;

	while (!contains_text(visit_url("plains.php"), "funhouse.gif")) {
		visit_url("guild.php?place=scg");
	}
		
	if (cloversAvailable(true) == 0)
		return;

	betweenBattlePrep($location[funhouse]);
	visit_url("adventure.php?snarfblat=20&confirm=on");
}

void locationSkills(location loc) {
	boolean needPolka = false;
	if (loc == $location[boss bat's lair]) {
		tryShrug($skill[fat leon's phat loot lyric]);
		tryCast($skill[leash of linguini]);
		needPolka = true;
	}

	if (loc == $location[wartime sonofa beach]) {
		if (have_effect($effect[hippy stench]) == 0 && item_amount($item[reodorant]) > 0)
			use(1, $item[reodorant]);
	}

	if (loc == $location[defiled cranny] || loc == $location[defiled alcove]) {
		tryShrug($skill[fat leon's phat loot lyric]);
		needPolka = true;
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

	if (needPolka)
		tryCast($skill[polka of plenty]);
	else
		tryShrug($skill[polka of plenty]);
}

void main() {
	if (can_interact())
		return;

	if (my_daycount() == 1 && my_turncount() == 0) {
		firstTurn();
	}

	// Any functions that may do adventuring should go first.
	killKing();
	if (my_level() < 6)
		useRedRay(my_location());
	getHellionCubes();
	openDispensary();

	betweenBattleInternal(my_location());
}

// This function should do minimal adventuring.
void betweenBattleInternal(location loc) {
	if (!canAdventure())
		abort("Out of adventures!");

	useWarMoney();

	autoConsume(loc);

	autoFax(false);
	openGuild();
	getBoxes();

	if (olfactTarget() == $monster[blooper] && item_amount($item[digital key]) == 0) {
		bcasc8Bit();
	}

	betweenBattlePrep(loc);
}

// This function should not do any adventuring.
void betweenBattlePrep(location loc) {
	equipSugar();

	buyHammer();
	allowMining();

	locationSkills(loc);
	process_inventory();
	optimizeMCD(loc);
	checkFamiliar(loc);
	pawnHipsterItemsInto($item[fixed-gear bicycle]);
	if (needOlfaction(loc) && have_effect($effect[on the trail]) == 0) {
		olfactionPreparation();
	}
	useFriars(loc);
	setAutoRestoreLevels(loc);
	restoreSelf(loc);
	burnExcessMp(loc);
}
