import <consulthard.ash>
import <pcklutil.ash>

// This combat script handles romantic monsters.  It will do nothing if the
// current monster is not a romantic monster.

void consultRomantic(int round, monster mob, string combat) {
    if (mob != romanticTarget())
		return;

	int encounters = get_property(propRomanticEncounters).to_int();
	if (round == 1) {
		encounters += 1;
		set_property(propRomanticEncounters, encounters);
	}

	// Only handle the first encounter specially, because we want to
	// olfact the second (like we'd do with any normal blooper).
	if (mob == $monster[blooper]) {
		if (encounters > 1)
			return;
	}

	for i from round to 30 {
		if (contains_text(consultHard(i, mob, combat), "WINWINWIN"))
			break;
	}
}

void main(int round, monster mob, string combat) {
	consultRomantic(round, mob, combat);
}
