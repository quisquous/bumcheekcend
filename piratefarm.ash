void main() {
    cli_execute("pull 1000000 meat");
    cli_execute("refresh all");
    cli_execute("mood piratefarm");
    cli_execute("familiar jitter");
    cli_execute("friars familiar");
    cli_execute("maximize meat +equip pirate fledges -melee +equip pumpkin bucket");
    adventure(my_adventures(), $location[poop deck]);
	if (my_adventures() == 0) {
		cli_execute("shrug phat");
		cli_execute("cast ode");
		cli_execute("drink gimlet");
	}
}
