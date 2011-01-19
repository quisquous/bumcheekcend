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

void main() {
	print("BETWEEN BATTLE", "green");
	process_inventory();
	checkFamiliar();
}
