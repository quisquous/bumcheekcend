import <pcklutil.ash>

// This combat script handles difficult monsters by attempting to use combat
// items or spells.  It will only automate one round.

buffer consultHard(int round, monster mob, string combat) {
	if (round == 1 && have_skill($skill[entangling noodles])) {
		return use_skill(1, $skill[entangling noodles]);
	}

	// FIXME: It'd be nice if this were more general.
	if (round == 2 && mob == $monster[blooper]) {
		return steal();
	}

	boolean shouldUsePrimeCombatItems = false;

	if (mob != $monster[none]) {
		if (canOutMoxie(mob) && !will_usually_miss()) {
			return attack();
		}
			
		// FIXME: Make this more general, maybe using expected_damage()
		if (mon == $monster[lobsterfrogman])
			shouldUsePrimeCombatItems = true;
	}

	item hand1;
	item hand2;
	foreach thing in combatItems {
		if (!considerPrimeStat && combatItemToStat(thing) == my_primestat())
			continue;
		if (item_amount(thing) >= 2) {
			hand1 = thing;
			hand2 = thing;
			break;
		} else if (item_amount(thing) == 1) {
			if (hand1 == $item[none]) {
				hand1 = thing;
			} else {
				hand2 = thing;
				break;
			}
		}
	}

	if (hand1 == $item[none]) {
		// FIXME: accordion thief or mysticality only
		if (my_level() >= 9 && have_skill($skill[saucegeyser]) && my_mp() >= mp_cost($skill[saucegeyser])) {
			return use_skill(1, $skill[saucegeyser]);
		} else {
			return attack();
		}
	} else if (hand2 == $item[none]) {
		return throw_item(hand1);
	} else {
		return throw_items(hand1, hand2);
	}
}

void main(int round, monster mob, string combat) {
	consultHard(round, mob, combat);
}
