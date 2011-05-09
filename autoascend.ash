import <autoeat.ash>
import <bumcheekascend.ash>
import <pcklutil.ash>

void tryTeaParty() {
	if (teaParty($item[reinforced beaded headband]))
		return;

	if (teaParty($item[filthy dread sack]))
		return;

	if (my_primestat() == $stat[moxie] && teaParty($item[snorkel]))
		return;

	if (my_primestat() == $stat[mysticality] && teaParty($item[ravioli hat]))
		return;

	// The pail is also useful, but +20 ML is not something to get here.
}

// FIXME: Make this a real function.
boolean needTelescopeItem(item thing)
{
	return false;
}

void useSpareZaps() {
	// Mostly copypasta from an internal bumcheekascend.ash function.
	// This should be made public in the main script.
	void zapKeys() {
		if (bcascStage("lair2"))
			return;
		if (canZap()) {
			if (i_a("boris's ring") + i_a("jarlsberg's earring") + i_a("sneaky pete's breath spray") > 0 ) {
				print("BCC: Your wand is safe, so I'm going to try to zap something");
				if (i_a("boris's ring") > 0) { cli_execute("zap boris's ring"); 
				} else if (i_a("jarlsberg's earring") > 0) { cli_execute("zap jarlsberg's earring"); 
				} else if (i_a("sneaky pete's breath spray") > 0) { cli_execute("zap sneaky pete's breath spray"); 
				}
			}
		} else {
			print("BCC: You don't have a wand. No Zapping for you.", "purple");
		}
	}

	if (!canZap())
		return;

	zapKeys();

	if (!canZap())
		return;

	// Black pepper is the worst to get, so zap for it first.
	if (needTelescopeItem($item[black pepper]) && !haveItem($item[black pepper])) {
		if (haveItem($item[canopic jar]))
			use(item_amount($item[canopic jar]), $item[canopic jar]);

		if (haveItem($item[ancient spice]))
			cli_execute("zap ancient spice");
		else if (haveItem($item[dehydrated caviar]))
			cli_execute("zap dehydrated caviar");
	}

	if (!canZap())
		return;

	// Try to zap any item from the group if we have enough of it.
	void zapItemFromGroup(int[item] zapGroup) {
		foreach thing in zapGroup {
			// Don't zap if we want to keep some of this.
			if (item_amount(thing) <= zapGroup[thing])
				continue;

			cli_execute("zap " + thing);
			break;
		}
	}

	// If we need any item from the zap group for the tower, try to zap
	// from that group of items to get it.
	void zapTowerItemFromGroup(boolean[item] zapGroup) {
		boolean needed = false;
		foreach thing in zapGroup {
			if (needTelescopeItem(thing) && !haveItem(thing)) {
				needed = true;
				break;
			}
		}

		if (!needed)
			return;

		foreach thing in zapGroup {
			// Don't zap if we want to keep some of this.
			if (needTelescopeItem(thing) && item_amount(thing) <= 1)
				continue;

			if (item_amount(thing) == 0)
				continue;

			cli_execute("zap " + thing);
			break;
		}
	}

	// Gourd items are in a smaller zap group than letters so try them next.
	zapTowerItemFromGroup($items[
		knob goblin firecracker,
		razor-sharp can lid,
		spider web,
	]);

	if (!canZap())
		return;

	// Zap letters.
	if (needTelescopeItem($item[ng]) && !haveItem($item[ng]) && (item_amount($item[lowercase n]) < 2 || item_amount($item[original g]) < 2)) {

		int[item] letterItems;
		letterItems[$item[ruby w]] = 1;
		letterItems[$item[lowercase n]] = 2;
		letterItems[$item[metallic a]] = 1;
		letterItems[$item[original g]] = 1;
		letterItems[$item[heavy d]] = 1;

		zapItemFromGroup(letterItems);
	}

	if (!canZap())
		return;

	// Zap shore items.
	zapTowerItemFromGroup($items[
		barbed-wire fence,
		tropical orchid,
		stick of dynamite,
	]);

	if (!canZap())
		return;

	// Zap garnishes for better stat alignment.
	foreach thing in $items[
		coconut shell,
		little paper umbrella,
		magical ice cubes,
	] {
		if (!haveItem(thing))
			continue;

		if (garnishAlignment(thing) == my_primestat())
			continue;

		cli_execute("zap " + thing);
		break;
	}
}

void endOfDay() {
	// Force use remaining spleen items.
	while (autoSpleen(true)) {}
	while (autoEat(false, true)) {}

	useSpareZaps();

	if (stills_available() > 0) {
		retrieve_item(item_amount($item[tonic water]) + stills_available(), $item[tonic water]);
	}

	if (bcascStage("friars") && !get_property(propBlessingReceived).to_boolean()) {
		cli_execute("friars familiar");
	}

	for i from 1 to 3 {
		poolTable("mys");
	}

	harvestCampground();

	tryTeaParty();

	takeStatShower();

	cli_execute("maximize adv");

	trySoak();
}

void main() {
	if (my_inebriety() > inebriety_limit()) {
		endOfDay();
		return;
	}

	set_property(propBetweenBattleScript, "betweenbattle.ash");
	set_property(propCounterScript, "counter.ash");
	cli_execute("ccs hardcore");

	try {
		cli_execute("call bumcheekascend.ash");
	} finally {
		debug("Script failed");

		if (my_fullness() == fullness_limit() && my_inebriety() == inebriety_limit() && my_adventures() == 0) {
			drinkNightcap();
		}

		if (my_inebriety() > inebriety_limit()) {
			endOfDay();
			return;
		}
	}
}
