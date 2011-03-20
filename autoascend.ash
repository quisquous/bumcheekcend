import <pcklutil.ash>

void main() {
	set_property(propBetweenBattleScript, "betweenbattle.ash");
	set_property(propCounterScript, "counter.ash");
	cli_execute("ccs hardcore");

	try {
		cli_execute("call bumcheekascend.ash");
	} finally {
		debug("Script failed");
	}
}
