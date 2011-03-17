import <pcklutil.ash>

void main() {
	set_property(propBetweenBattleScript, "betweenbattle.ash");

	try {
		cli_execute("call bumcheekascend.ash");
	} finally {
		debug("Script failed");
	}
}
