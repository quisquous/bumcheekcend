import <betweenbattle.ash>
import <bumcheekascend.ash>
import <consulttelescope.ash>
import <pcklutil.ash>
import <telescope.ash>

boolean executePlan(CombatPlan plan) {
	string fam = plan.useNonCombat ? "items" : "items";
	string mood = plan.useNonCombat ? "-" : "+";
	string conditions = plan.quantity + " " + plan.thing;
    string describe = "Getting " + conditions;
    string equip = "";

	storePlan(plan);

    if (plan.options.useYellowRay)
        fam = "hebo";

	if (plan.options.useFax) {
		setMood(mood);
		setFamiliar(fam);
		buMax(equip);
		betweenBattlePrep(my_location());

		monster mob;
		foreach target in plan.targets {
			mob = target;
			break;
		}
		if (mob == $monster[none])
			abort("Invalid targets for fax");

		if (get_monster_fax(mob)) {
			use(1, $item[photocopied monster]);
			buffer combat = steal();
			for i from 2 to 30 {
				buffer combat = consultTelescope(plan, i, mob, combat);
				if (contains_text(combat, "WINWINWIN"))
					break;
			}
		} else {
			abort("Couldn't fax " + mob);
		}
	}

	while (item_amount(plan.thing) < plan.quantity) {
		if (my_adventures() == 0)
			break;
		bumAdv(plan.loc, equip, fam, conditions, describe, mood);
	}

	clearPlan();
	return item_amount(plan.thing) >= plan.quantity;
}

CombatPlan[int] getPlan(int[item] required) {
	boolean haveFax = get_property(propFaxUsed).to_boolean();
	boolean haveRay = have_familiar($familiar[he-boulder]) && have_effect($effect[everything looks yellow]) == 0;
	int softGreen = item_amount($item[soft green]);

	return makePlan(required, haveFax, haveRay, softGreen);
}

void getEasyItems(int[item] required) {
	if (required contains $item[hair spray]) {
		retrieve_item(required[$item[hair spray]], $item[hair spray]);
	}

	// FIXME: buy from gnomads
	// FIXME: clover for candy
}

boolean acquireTelescopeItems() {
	int[item] required = telescopeComponentsNeeded();
	getEasyItems(required);

	int step = 1;

	while (count(required) > 0) {
		debug("Replanning...");
		required = telescopeComponentsNeeded();
		CombatPlan[int] plans = getPlan(required);
		CombatPlan plan = plans[1];

		debug("Step " + step + ": Get " + plan.quantity + " " + plan.thing);

		if (have_effect($effect[on the trail]) > 0 && plan.options.useOlfaction && haveItem($item[soft green]) && !(plan.targets contains olfactTarget())) {
			cli_execute("uneffect on the trail");
			if (have_effect($effect[on the trail]) > 0)
				abort("Unable to remove on the trail, unexpectedly.");
		}

		if (!executePlan(plan)) {
			debug("Failed to execute plan");
			return false;
		}
	}

	required = telescopeComponentsNeeded();
	if (count(required) > 0)
		debug("Failed to get all telescope items");
	else
		debug("Success!");
	return count(required) == 0;
}
