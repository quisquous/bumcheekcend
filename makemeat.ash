int pulverize_value(item thing) {
	// Yes, yes, elemental wads have a 1% chance of becoming an elemental jewel.
	// ...but by the time you find anything that can become an elemental wad
	// you really don't have much need for meat anymore, so we'll ignore it.
	// You probably also want to mallsell them instead.

	int powder_value = 30;
	int nugget_value = 60;
	int wad_value = 90;

	// TODO(picklish) - doesn't return 0 for items bought from stores
	// TODO(picklish) - doesn't return 0 for antique arms and armor
	int power = get_power(thing);

	// TODO(picklish) - add a config option to prefer wads, if needed
	if (power >= 160)
		return 100000;

	if (power < 10)
		return 0;
	else if (power < 40)
		return powder_value;
	else if (power < 60)
		return 2 * powder_value;
	else if (power < 80)
		return 3 * powder_value;
	else if (power < 100)
		return (4 * powder_value + nugget_value) / 2;
	else if (power < 120)
		return (3 * powder_value + 3 * nugget_value) / 2;
	else if (power < 140)
		return 3 * nugget_value;
	else if (power < 160)
		return (4 * nugget_value + wad_value) / 2;
	else if (power < 180)
		return (3 * nugget_value + 3 * wad_value) / 2;
	else
		return 3 * wad_value;

	return 0;
}

void dispose(int amount, item thing) {
	// TODO(picklish) - need a better heuristic for when to buy the hammer.
	if (item_amount($item[tenderizing hammer]) == 0) {
		autosell(amount, thing);
	} else {
		if (pulverize_value(thing) > autosell_price(thing)) {
			cli_execute("pulverize " + amount + " " + thing);
		} else {
			autosell(amount, thing);
		}
	}
}

void dispose_all(item thing) {
	int amount = item_amount(thing);
	if (amount > 0)
		dispose(amount, thing);
}

void dispose_all_but(int keep, item thing) {
	int amount = item_amount(thing);
	if (amount > keep)
		dispose(amount - keep, thing);
}

void process_inventory() {
	if (item_amount($item[evil golden arch]) > 1)
		cli_execute("make * golden arches");

	// Spleen
	while (my_spleen_use() > 0 && (spleen_limit() - my_spleen_use()) % 4 != 0 && item_amount($item[mojo filter]) > 0)
		use(1, $item[mojo filter]);

	if (my_level() >= 4) {
		while (item_amount($item[agua de vida]) > 0 && my_spleen_use() + 4 <= spleen_limit()) {
			use(1, $item[agua de vida]);
		}
	}

	// Useable
	foreach thing in $items[
		ancient vinyl coin purse,
		black pension check,
		briefcase,
		evil golden arches,
		fat wallet,
		feng shui for big dumb idiots,
		frobozz instant house,
		knob kitchen grab-bag,
		large box,
		newbiesport tent,
		old coin purse,
		old leather wallet,
		penultimate fantasy chest,
		small box,
		warm subject gift certificate,
	] {
		use(item_amount(thing), thing);
	}

	// Sell all
	foreach thing in $items[
		1337 7r0uz0rz,
		a butt tuba,
		amulet of extreme plot significance,
		armgun,
		ascii shirt,
		asparagus knife,
		baby killer bee,
		baconstone,
		ballroom blintz,
		batblade,
		batblade,
		beach glass bead,
		black greaves,
		black helmet,
		black shield,
		black sword,
		bone flute,
		bowl of cottage cheese,
		brimstone chicken sandwich,
		bronze breastplate,
		caret,
		carob chunks,
		clay peace-sign bead,
		coffin lid,
		cornuthaum,
		demon skin,
		dense meat stack,
		desiccated apricot,
		diamond-studded cane,
		double bacon beelzeburger,
		draggin' ball hat,
		dried face,
		drywall axe,
		enormous belt buckle,
		facsimile dictionary,
		fat stacks of cash,
		filthy pestle,
		flaming crutch,
		flaming talons,
		ghuol ears,
		ghuol guolash,
		giant discarded torn-up glove,
		giant needle,
		glowing red eye,
		hamethyst,
		happiness,
		hemp string,
		hors d'oeuvre tray,
		hot katana blade,
		hot plate,
		huge spoon,
		infernal fife,
		infernal insoles,
		jumbo dr. lucifer,
		kiss the knob apron,
		knob bugle,
		knob goblin elite shirt,
		knob goblin pants,
		knob goblin scimitar,
		knob goblin spatula,
		knob goblin tongs,
		leather chaps,
		leather mask,
		lihc face,
		lord of the flies-sized fries,
		lump of diamond,
		mad train wine,
		magicalness-in-a-can,
		magic lamp,
		magic whistle,
		magilaser blastercannon,
		meat paste,
		meat stack,
		mesh cap,
		mesh cap,
		mick's icy vapohotness rub,
		mind flayer corpse,
		mohawk wig,
		moxie weed,
		ninja hot pants,
		ocarina of space,
		opera mask,
		oversized pizza cutter,
		patchouli incense stick,
		phat turquoise bead,
		pile of gold coins,
		plot hole,
		pointed stick,
		porquoise,
		pr0n legs,
		probability potion,
		procrastination potion,
		rave whistle,
		ridiculously huge sword,
		royal jelly,
		rusty grave robbing shovel,
		solid gold pegleg,
		spam witch sammich,
		spiked femur,
		spooky shrunken head,
		spooky stick,
		stone of extreme power,
		strongness elixir,
		trollhouse cookies,
		uncle jick's brownie mix,
		vampire cape,
		viking helmet,
		vorpal blade,
		wolf mask,
		wooden stakes,
		world's smallest violin,
	] {
		dispose_all(thing);
	}

	// Sell all but one
	foreach thing in $items[
		7-foot dwarven mattock,
		adder bladder,
		baseball,
		broken skull,
		chaos butterfly,
		dead guy's watch,
		dehydrated caviar,
		disease,
		eyepatch,
		filthy corduroys,
		filthy knitted dread sack,
		firecracker,
		harem pants,
		harem veil,
		jolly roger charrrm bracelet,
		knob goblin elite helm,
		knob goblin elite pants,
		knob goblin elite polearm,
		meat vortex,
		metallic a,
		miner's helmet,
		miner's pants,
		photoprotoneutron torpedo,
		possessed tomato,
		razor-sharp can lid,
		ruby w,
		safety vest,
		stuffed shoulder parrot,
		super-spiky hair gel,
		swashbuckling pants,
		tap shoes,
		tasty fun good rice candy,
		titanium assault umbrella,
		worn tophat,
		wussiness potion,
	] {
		dispose_all_but(1, thing);
	}

	dispose_all_but(2, $item[lowercase n]);
	dispose_all_but(2, $item[original g]);
	dispose_all_but(3, $item[hot wing]);

	// TODO(picklish) - smartly handle extra ore

	// Save large stat spleen items early on, because they're decent filler
	// when wads aren't available.
	if (my_level() >= 7) {
		dispose_all($item[enchanted barbell]);
		dispose_all($item[concentrated magicalness pill]);
		dispose_all($item[giant moxie weed]);
	} else if (my_primestat() == $stat[muscle]) {
		dispose_all($item[concentrated magicalness pill]);
		dispose_all($item[giant moxie weed]);
	} else if (my_primestat() == $stat[mysticality]) {
		dispose_all($item[enchanted barbell]);
		dispose_all($item[giant moxie weed]);
	} else if (my_primestat() == $stat[moxie]) {
		dispose_all($item[enchanted barbell]);
		dispose_all($item[concentrated magicalness pill]);
	}

	// Conditional items
	if (item_amount($item[dolphin king's map]) > 0 && my_meat() >= 30) {
		retrieve_item(1, $item[snorkel]);
		equip($slot[hat], $item[snorkel]);
		use(1, $item[dolphin king's map]);
		equip($slot[hat], $item[none]);
		dispose_all($item[snorkel]);
	}

	if (item_amount($item[digital key]) > 0) {
		cli_execute("make * blue pixel potion");
		cli_execute("make * green pixel potion");
		foreach thing in $items[
			black pixel,
			blue pixel,
			green pixel,
			red pixel,
			white pixel,
			finger cymbals,
		] {
			dispose_all(thing);
		}
	}

	if (have_outfit("filthy hippy disguise")) {
		foreach thing in $items[
			decorative fountain,
			feng shui for big dumb idiots,
			windchimes,
		] {
			dispose_all(thing);
		}
	}

	if (item_amount($item[spookyraven library key]) > 0) {
		foreach thing in $items[
			handful of hand chalk,
			pool cue,
		] {
			dispose_all(thing);
		}
	}

	if (my_primestat() != $stat[mysticality]) {
		foreach thing in $items[
			cookbook of the damned,
			necrotelicomnicon,
			sinful desires,
		] {
			dispose_all(thing);
		}
	}

	// Finally, clean up any pulverizing messes.  Don't bother selling wads,
	// because they'll likely get used and the meat isn't needed by then.
	foreach thing in $items[
		cold nuggets,
		cold powder,
		hot nuggets,
		hot powder,
		sleaze nuggets,
		sleaze powder,
		spooky nuggets,
		spooky powder,
		stench nuggets,
		stench powder,
		twinkly nuggets,
		twinkly powder,
	] {
		// TODO(picklish) - assumes no malus access.
		dispose_all(thing);
	}
}

void main() {
	process_inventory();
}
