import <autoascend.ash>
import <autoeat.ash>
import <pcklutil.ash>

void main() {
    cli_execute("pull 1000000 meat");
    cli_execute("refresh all");
    cli_execute("mood piratefarm");
    cli_execute("ccs piratefarm");
    cli_execute("familiar jitter");
    cli_execute("friars familiar");

    int spleen = spleen_limit() - my_spleen_use();
    retrieve_item(spleen, $item[hot wad]);
    use(spleen, $item[hot wad]);

    int make_gimlet = stills_available() / 2;
    castInigos(10 * make_gimlet);
    create(make_gimlet, $item[tonic water]);
    create(make_gimlet, $item[bottle of calcutta emerald]);
    create(make_gimlet, $item[gimlet]);
    retrieve_item(5, $item[gimlet]);
    while (inebriety_limit() - my_inebriety() > 4) {
        castOde(4);
        drink(1, $item[gimlet]);
    }

    retrieve_item(3, $item[hot hi mein]);

    while (autoEat(false, true)) { }
    while (autoDrink(false, true)) { }

    cli_execute("maximize meat +equip pirate fledges -melee +equip pumpkin bucket");
    adventure(my_adventures(), $location[poop deck]);
	if (my_adventures() == 0) {
		cli_execute("shrug phat");
		cli_execute("cast ode");
		cli_execute("drink gimlet");
		cli_execute("maximize adv");
		endOfDay();
	}
}
