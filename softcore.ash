import <telescope.ash>
import <pcklutil.ash>

boolean[item] equip = $items[
	jewel-eyed wizard hat,
	mr. accessory jr,
	navel ring,
	little box of fireworks,
	rock and roll legend,
	leather aviator's cap,
	sword behind inappropriate prepositions,
];

boolean[item] corpseDrink = $items[
	corpsedriver,
	corpse island iced tea,
	corpse on the beach,
	corpsetini,
];

boolean[item] shcDrink = $items[
	divine,
	gimlet,
	gordon bennett,
	mae west,
	mandarina colada,
	mon tiki,
	neuromancer,
	prussian cathouse,
	tangarita,
	teqiwila slammer,
	vodka stratocaster,
	yellow brick road,
];

boolean pullItem(int count, item thing) {
	if (count <= 0)
		return true;

	int pulls = pulls_remaining();
	if (pulls == 0)
		return false;

	if (storage_amount(thing) < count)
		return false;

	try {
		debug("Pulling " + count + " " + thing);
		cli_execute("pull " + count + " " + thing);
	} finally {
		return pulls_remaining() == pulls - count;
	}

	return false;
}

boolean pullItem(item thing) {
	return pullItem(1, thing);
}

boolean pullPie() {
	foreach thing in $items[
		digital key,
		sneaky pete's key,
		richard's star key,
		boris's key,
		jarlsberg's key,
	] {
		if (haveItem(thing))
			continue;
		item pie = keyToPie[thing];
		if (haveItem(pie))
			continue;
		if (pullItem(pie))
			return true;
	}

	return false;
}

boolean pullFromList(int count, boolean[item] list) {
	int have = 0;
	foreach thing in list {
		have += item_amount(thing);
	}

	int needed = have - count;
	if (needed <= 0)
		return true;
	
	foreach thing in list {
		while (pullItem(thing)) {
			needed -= 1;

			if (needed <= 0)
				return true;
		}
	}

	return false;
}

boolean pullCorpse(int count) {
	return pullFromList(count, corpseDrink);
}

boolean pullSuperCock(int count) {
	return pullFromList(count, shcDrink);
}

void pullStageItem(string stage, int count, item thing) {
	if (bcascStage(stage))
		return;
	pullItem(count, thing);
}

void pullStageItem(string stage, item thing) {
	pullStageItem(stage, 1, thing);
}

void pullSoftcoreItems() {
	if (in_hardcore() || can_interact() || pulls_remaining() == 0)
		return;

	foreach thing in equip {
		if (item_amount(thing) + equipped_amount(thing) == 0)
			pullItem(thing);
	}
  
	if (!haveItem($item[desert bus pass])) {
		pullItem($item[solid gold bowling ball]);
		autoSell(1, $item[solid gold bowling ball]);
		buy(1, $item[desert bus pass]);
	}

	if (!haveItem($item[milk of magnesium]))
		pullItem($item[milk of magnesium]);

	if (my_level() < 6) {
		pullItem(2, $item[fettucini inconnu]);
		pullPie();
	} else {
		pullItem(2, $item[sleazy hi mein]);
		pullPie();
	}

	if (my_level() > 5 && my_level() < 10) {
		if (!haveItem($item[prismatic wad]))
			pullItem(1, $item[prismatic wad]);
	}

	pullCorpse(2);
	if (inebriety_limit() < 15) {
		pullSuperCock(2);
	} else {
		pullSuperCock(3);
	}

	pullStageItem("spookyforest", $item[spooky-gro fertilizer]);

	pullItem($item[knob goblin elite helm]);
	pullItem($item[knob goblin elite pants]);
	pullItem($item[knob goblin elite polearm]);

	// Don't really need these, but bcasc expects them.
	pullItem($item[filthy knitted dread sack]);
	pullItem($item[filthy corduroys]);

	pullItem($item[ring of conflict]);
	pullItem($item[eyepatch]);
	pullItem($item[swashbuckling pants]);
	pullItem($item[stuffed shoulder parrot]);

	pullStageItem("piratefledges", $item[frilly skirt]);
	if (bcascStage("friars"))
		pullStageItem("piratefledges", 3, $item[hot wing]);

	if (my_level() >= 8 && !bcascStage("mining")) {
		item ore = to_item(get_property("trapperOre"));
		pullItem(3 - item_amount(ore), ore);
	}

	pullStageItem("castle", $item[furry fur]);
	pullStageItem("castle", $item[giant needle]);
	pullStageItem("castle", $item[awful poetry journal]);

	pullStageItem("macguffinpalin", $item[stunt nuts]);
	pullStageItem("macguffinpalin", $item[wet stew]);
	pullStageItem("macguffinpyramid", $item[drum machine]);
	pullItem($item[cyclops eyedrops]);
	pullStageItem("macguffinpalin", $item[acoustic guitar]);

	int[item] telescopeItems = telescopeItemsNeeded();
	foreach thing in telescopeItems {
		pullItem(telescopeItems[thing], thing);
	}

	while (pulls_remaining() > 0) {
		if (!pullItem(1, $item[disassembled clover]))
			break;
	}
}

void stockUpForSoftcore(int dayCount) {
	void stock(int count, item thing) {
		int needed = closet_amount(thing) + storage_amount(thing) - count;
		if (needed <= 0)
			return;

		cli_execute("acquire " + needed + " " + thing);
		if (item_amount(thing) < needed)
			abort("Couldn't get " + needed + " " + thing);
		put_closet(needed, thing);
	}

	foreach thing in $items[
		boris's key lime pie,
		jarlsberg's key lime pie,
		sneaky pete's key lime pie,
	] {
		stock(1, thing);
	}

	stock(2, $item[digital key lime pie]);
	stock(2, $item[star key lime pie]);
	stock(2 * dayCount, $item[sleazy hi mein]);
	stock(2 * dayCount, $item[fettucini inconnu]);
	stock(3 * dayCount, $item[mae west]);
	stock(3 * dayCount, $item[corpsetini]);
	stock(5, $item[prismatic wad]);
	stock(20 * dayCount, $item[disassembled clover]);
	stock(1, $item[solid gold bowling ball]);
	stock(dayCount, $item[milk of magnesium]);

	stock(1, $item[knob goblin elite helm]);
	stock(1, $item[knob goblin elite pants]);
	stock(1, $item[knob goblin elite polearm]);

	stock(1, $item[miner's helmet]);
	stock(1, $item[7-foot dwarven mattock]);
	stock(1, $item[miner's pants]);

	stock(1, $item[filthy knitted dread sack]);
	stock(1, $item[filthy corduroys]);

	stock(1, $item[eyepatch]);
	stock(1, $item[swashbuckling pants]);
	stock(1, $item[stuffed shoulder parrot]);

    stock(1, $item[beer helmet]);
    stock(1, $item[distressed denim pants]);
    stock(1, $item[bejeweled pledge pin]);

    stock(1, $item[orcish baseball cap]);
    stock(1, $item[homoerotic frat-paddle]);
    stock(1, $item[orcish cargo shorts]);

    stock(1, $item[knob goblin harem veil]);
    stock(1, $item[knob goblin harem pants]);

    stock(1, $item[reinforced beaded headband]);
    stock(1, $item[bullet-proof corduroys]);
    stock(1, $item[round purple sunglasses]);

	stock(1, $item[ring of conflict]);
	stock(3, $item[asbestos ore]);
	stock(3, $item[chrome ore]);
	stock(3, $item[linoleum ore]);
	stock(1, $item[frilly skirt]);
	stock(3, $item[hot wing]);
	stock(1, $item[stunt nuts]);
	stock(1, $item[wet stew]);
	stock(1, $item[drum machine]);
	stock(1, $item[cyclops eyedrops]);
	stock(1, $item[acoustic guitar]);
	stock(1, $item[rock and roll legend]);
	stock(1, $item[leather aviator's cap]);
	stock(1, $item[sword behind inappropriate prepositions]);
	stock(1, $item[wand of nagamar]);

	foreach thing in $items[
		adder bladder,
		angry farmer candy,
		barbed-wire fence,
		baseball,
		black no. 2,
		black pepper,
		bronzed locust,
		chaos butterfly,
		disease,
		fancy bath salts,
		frigid ninja stars,
		gremlin juice,
		hair spray,
		heavy d,
		inkwell,
		knob goblin firecracker,
		leftovers of indeterminate origin,
		lowercase n,
		mariachi g-string,
		meat vortex,
		metallic a,
		mick's icyvapohotness rub,
		ng,
		original g,
		photoprotoneutron torpedo,
		plot hole,
		powdered organs,
		pygmy blowgun,
		pygmy pygment,
		razor-sharp can lid,
		ruby w,
		sonar-in-a-biscuit,
		spider web,
		stick of dynamite,
		super-spiky hair gel,
		thin black candle,
		tropical orchid,
		wussiness potion,
	] {
		stock(1, thing);
	}
}

void setSoftcoreOptions() {
	setBcascStageComplete("friarssteel");
	setBcascStageComplete("innaboxen");
	setBcascStageComplete("pumpkinbeer");
	setBcascStageComplete("swill");
	setBcascStageComplete("wand");
}

