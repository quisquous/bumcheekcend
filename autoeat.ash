import <pcklutil.ash>

String propCookware = "_picklishBoughtCookware";

void initAutoEat() {
	set_property(propCookware, false);
}

void autoEat(location loc) {

	if (!get_property(propCookware).to_boolean() && bcascStage("tavern") && my_meat() >= 2500) {
		retrieve_item(1, $item[dramatic range]);
		use(1, $item[dramatic range]);
		retrieve_item(1, $item[queue du coq]);
		use(1, $item[queue du coq]);
		set_property(propCookware, true);

		// FIXME: Verify that this is true before and after purchasing
	}

	if (my_daycount() == 1 && my_inebriety() == 0 && stillAvailable()) {
		tryCast($skill[mojomuscular melody]);
		retrieve_item(1, $item[tonic water]);
		use(1, $item[tonic water]);
		use_skill(1, $skill[ode to booze]);
		cli_execute("garden pick");
		cli_execute("drink 3 pumpkin beer");

		// Hack: in case we levelled up, refresh current quests.
		cli_execute("council");
	}

	// FIXME: Be smarter about when to eat fortune cookies.  No need to eat until the window is up, which may roll over.
	if (my_turncount() > 5 && !counterActive(fortuneCounter) && get_property(propSemirareCounter).to_int() != my_turncount()) {
		if (my_fullness() == 0) {
			eat(1, $item[fortune cookie]);
		}
	}

	if (!get_property(propCookware).to_boolean())
		return;

	if (my_daycount() == 1 && my_level() >= 3) {
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
}
