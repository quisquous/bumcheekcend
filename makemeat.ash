int pulverize_value(item thing) {
    // Yes, yes, elemental wads have a 1% chance of becoming an elemental jewel.
    // ...but by the time you find anything that can become an elemental wad
    // you really don't have much need for meat anymore, so we'll ignore it.
    // You probably also want to mallsell them instead.

    int powder_value = 30;
    int nugget_value = 60;
    int wad_value = 90;

    // TODO(picklish) - doesn't return 0 for items bought from stores
    // TODO(picklish) - doesn't return 0 for antique arms and armor
    int power = get_power(thing);
    if (power < 10)
        return 0;
    else if (power < 40)
        return powder_value;
    else if (power < 60)
        return 2 * powder_value;
    else if (power < 80)
        return 3 * powder_value;
    else if (power < 100)
        return (4 * powder_value + nugget_value) / 2;
    else if (power < 120)
        return (3 * powder_value + 3 * nugget_value) / 2;
    else if (power < 140)
        return 3 * nugget_value;
    else if (power < 160)
        return (4 * nugget_value + wad_value) / 2;
    else if (power < 180)
        return (3 * nugget_value + 3 * wad_value) / 2;
    else
        return 3 * wad_value;

    return 0;
}

void dispose(int amount, item thing) {
    // TODO(picklish) - need a better heuristic for when to buy the hammer.
    if (item_amount($item[tenderizing hammer]) == 0) {
        autosell(amount, thing);
    } else {
        if (pulverize_value(thing) > autosell_price(thing)) {
            cli_execute("pulverize " + amount + " " + thing);
        } else {
            autosell(amount, thing);
        }
    }
}

void dispose_all(item thing) {
    int amount = item_amount(thing);
    if (amount > 0)
        dispose(amount, thing);
}

void dispose_all_but(int keep, item thing) {
    int amount = item_amount(thing);
    if (amount > keep)
        dispose(amount - keep, thing);
}

void process_inventory() {

    if (item_amount($item[evil golden arch]) > 1)
        cli_execute("make * golden arches");

    // Useable
    foreach thing in $items[
        ancient vinyl coin purse,
        black pension check,
        briefcase,
        evil golden arches,
        fat wallet,
        feng shui for big dumb idiots,
        frobozz instant house,
        knob kitchen grab-bag,
        newbiesport tent,
        old coin purse,
        old leather wallet,
        penultimate fantasy chest,
        warm subject gift certificate,
    ] {
        use(item_amount(thing), thing);
    }

    // Sell all
    foreach thing in $items[
        asparagus knife,
        baconstone,
        beach glass bead,
        bowl of cottage cheese,
        brimstone chicken sandwich,
        carob chunks,
        clay peace-sign bead,
        demon skin,
        dense meat stack,
        diamond-studded cane,
        double bacon beelzeburger,
        double-barreled sling,
        dried face,
        fat stacks of cash,
        filthy pestle,
        flaming crutch,
        hamethyst,
        hemp string,
        hot katana blade,
        infernal fife,
        infernal insoles,
        jumbo dr. lucifer,
        kiss the knob apron,
        knob bugle,
        knob goblin elite shirt,
        knob goblin pants,
        knob goblin scimitar,
        knob goblin spatula,
        knob goblin tongs,
        leather mask,
        lord of the flies-sized fries,
        mad train wine,
        magicalness-in-a-can,
        meat paste,
        meat stack,
        moxie weed,
        ninja hot pants,
        patchouli incense stick,
        phat turquoise bead,
        porquoise,
        spooky shrunken head,
        spooky stick,
        strongness elixir,
        uncle jick's brownie mix,
        vampire cape,
        viking helmet,
        wooden stakes,
    ] {
        dispose_all(thing);
    }

    // Sell all but one
    foreach thing in $items[
        baseball,
        broken skull,
        disease,
        filthy corduroys,
        filthy knitted dread sack,
        firecracker,
        harem pants,
        harem veil,
        knob goblin elite helm,
        knob goblin elite pants,
        knob goblin elite polearm,
        possessed tomato,
        razor-sharp can lid,
        ruby w,
        wussiness potion,
    ] {
        dispose_all_but(1, thing);
    }

    dispose_all_but(3, $item[hot wing]);

    // Save large stat spleen items early on, because they're decent filler
    // when wads aren't available.
    if (my_level() >= 7) {
        dispose_all($item[enchanted barbell]);
        dispose_all($item[concentrated magicalness pill]);
        dispose_all($item[giant moxie weed]);
    } else if (my_primestat() == $stat[muscle]) {
        dispose_all($item[concentrated magicalness pill]);
        dispose_all($item[giant moxie weed]);
    } else if (my_primestat() == $stat[mysticality]) {
        dispose_all($item[enchanted barbell]);
        dispose_all($item[giant moxie weed]);
    } else if (my_primestat() == $stat[moxie]) {
        dispose_all($item[enchanted barbell]);
        dispose_all($item[concentrated magicalness pill]);
    }

    // Conditional items
    if (item_amount($item[dolphin king's map]) > 0 && my_meat() >= 30) {
        retrieve_item(1, $item[snorkel]);
        equip($slot[hat], $item[snorkel]);
        use(1, $item[dolphin king's map]);
        equip($slot[hat], $item[none]);
        dispose_all($item[snorkel]);
    }

    if (item_amount($item[digital key]) > 0) {
        cli_execute("make * blue pixel potion");
        cli_execute("make * green pixel potion");
        foreach thing in $items[
            black pixel,
            blue pixel,
            green pixel,
            red pixel,
            white pixel,
            finger cymbals,
        ] {
            dispose_all(thing);
        }
    }

    if (have_outfit("filthy hippy disguise")) {
        foreach thing in $items[
            decorative fountain,
            feng shui for big dumb idiots,
            windchimes,
        ] {
            dispose_all(thing);
        }
    }

    if (item_amount($item[spookyraven library key]) > 0) {
        foreach thing in $items[
            handful of hand chalk,
            pool cue,
        ] {
            dispose_all(thing);
        }
    }

    // Finally, clean up any pulverizing messes.  Don't bother selling wads,
    // because they'll likely get used and the meat isn't needed by then.
    foreach thing in $items[
        cold nuggets,
        cold powder,
        hot nuggets,
        hot powder,
        sleaze nuggets,
        sleaze powder,
        spooky nuggets,
        spooky powder,
        stench nuggets,
        stench powder,
        twinkly nuggets,
        twinkly powder,
    ] {
        // TODO(picklish) - assumes no malus access.
        dispose_all(thing);
    }
}

void main() {
    process_inventory();
}
