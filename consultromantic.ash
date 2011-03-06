import <pcklutil.ash>

// This combat script handles romantic monsters.  It will do nothing if the
// current monster is not a romantic monster.

void main(int round, monster mob, string combat) {
    if (mob != romanticTarget())
		return;

	int encounters = get_property(propRomanticEncounters).to_int() + 1;
	set_property(propRomanticEncounters, encounters);

	if (mob == $monster[blooper]) {
		// Only handle the first encounter specially.
		if (encounters > 1)
			return;

		steal();
	
		// FIXME: Can't actually kill the first blooper with attacking.
		abort();
	} else {
		abort("Unknown romantic monster");
	}
}
