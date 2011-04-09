import <autoeat.ash>
import <pcklutil.ash>

void main(int goal, boolean needBaseStat) {
	
	boolean hitGoal() {
		return my_basestat(my_primestat()) >= goal;
	}

	while (!hitGoal() && autoSpleen(true)) {
		debug("Used spleen item to try to level up to " + goal);
	}

	while (!hitGoal() && autoEat(true, false)) {
		debug("Ate food to try to level up to " + goal);
	}

	while (!hitGoal() && autoDrink(true, false)) {
		debug("Drank something to try to level up to " + goal);
	}
}
