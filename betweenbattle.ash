import <makemeat.ash>
import <bumcheekascend.ash>

void checkFamiliar() {
	// Don't bother using the HeBo when there's no yellow ray.
	if (my_familiar() == $familiar[He-Boulder] && have_effect($effect[Everything Looks Yellow]) > 0) {
		// If we're using the He-Bo, it's likely that there was only one set of
		// items that we care about.  So, switch to a stat familiar.
		setFamiliar("");
	}
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

void main() {
	print("BETWEEN BATTLE", "green");
	process_inventory();
	checkFamiliar();
	equipSugar();
}
