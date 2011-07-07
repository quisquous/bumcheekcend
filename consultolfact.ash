import <betweenbattle.ash>
import <pcklutil.ash>

void consultOlfact(int round, monster mob, string combat) {
	if (have_effect($effect[on the trail]) > 0)
		return;

	skill olfact = $skill[transcendent olfaction];
	if (!have_skill(olfact))
		return;

	boolean[monster] targets = olfactionTargets(my_location());

	if (!(targets contains mob)) {
		foreach target in targets {
			if (target != $monster[none])
				debug("Want to olfact: " + target);
		}
		return;
	}

	int cost = mp_cost(olfact) + combat_mana_cost_modifier();
	if (cost > my_mp()) {
		debug("Want to olfact this monster, but not enough mp");
		return;
	}

	use_skill(olfact);
}

void main(int round, monster mob, string combat) {
	consultOlfact(round, mob, combat);
}
