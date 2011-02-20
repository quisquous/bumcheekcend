// Attempt to get a given monster from FaxBot.  Returns true if successful.
// This will check your inventory first and will make several FaxBot attempts.
// As there's no way to explicitly get chat messages in KoLmafia, we just wait
// a reasonable amount of time and hope.  That's what return values are for.
boolean get_monster_fax(monster mon) {

    // Time to wait for FaxBot in seconds.
    int wait_time = 60;
    // Number of tries to repeat before failing.
    int faxbot_tries = 3;

    // Return the text to search for in the photocopied monster item
    // description to verify that this fax has the right monster.  Most of the
    // time this is just to_string(monster), but there are special cases due to
    // KoLmafia's naming scheme.
    string photocopy_text(monster mon) {
        switch (mon) {
            case $monster[Knight (snake)]: return "knight";
            case $monster[Somebody Else's Butt]: return "butt";
            case $monster[Slime1]: return "slime";
            case $monster[Slime2]: return "slime";
            case $monster[Slime3]: return "slime";
            case $monster[Slime4]: return "slime";
            case $monster[Slime5]: return "slime";
            case $monster[Some Bad ASCII Art]: return "bad ASCII art";
        }

        return mon;
    }

    // Return true if you have a fax and it contains this monster.
    boolean check_fax(monster mon) {
        if (item_amount($item[photocopied monster]) == 0)
            return false;

        string fax = visit_url("desc_item.php?whichitem=835898159");
        if (!contains_text(fax, "This is a sheet of copier paper"))
            return false;
        if (contains_text(fax, "grainy, blurry likeness of a monster on it."))
            return false;

        return contains_text(to_lower_case(fax), to_lower_case(photocopy_text(mon)));
    }

    // Returns true if we were able to get a fax into the inventory.
    boolean get_fax() {
        if (item_amount($item[photocopied monster]) != 0)
            return true;
        cli_execute("fax get");
        return item_amount($item[photocopied monster]) != 0;
    }

    // Returns true if we were able to remove all faxes from the inventory.
    boolean put_fax() {
        if (item_amount($item[photocopied monster]) == 0)
            return true;
        cli_execute("fax put");
        return item_amount($item[photocopied monster]) == 0;
    }

    // Return the request string that FaxBot expects for a given monster.
    // See: http://kolspading.com/forums/viewtopic.php?f=13&t=169
    string faxbot_name(monster mon) {
        switch (mon) {
            case $monster[Blooper]: return "blooper";
            case $monster[Knob Goblin Elite Guard Captain]: return "kge";
            case $monster[Lobsterfrogman]: return "lobsterfrogman";
            case $monster[Rampaging Adding Machine]: return "adding_machine";
            case $monster[Sleepy Mariachi]: return "sleepy_mariachi";
            case $monster[Some Bad ASCII Art]: return "ascii";
            case $monster[7-Foot Dwarf]: return "miner";
            case $monster[Alphabet Giant]: return "alphabet";
            case $monster[Angels of Avalon]: return "avalon";
            case $monster[Astronomer]: return "astronomer";
            case $monster[Batwinged Gremlin]: return "batwinged";
            case $monster[Blur]: return "blur";
            case $monster[Bob Racecar]: return "bob";
            case $monster[Booze Giant]: return "booze";
            case $monster[Brainsweeper]: return "brainsweeper";
            case $monster[Cleanly Pirate]: return "cleanly";
            case $monster[Creamy Pirate]: return "creamy";
            case $monster[Curmudgeonly Pirate]: return "curmudgeonly";
            case $monster[Dairy Goat]: return "dairy_goat";
            case $monster[Dirty Thieving Brigand]: return "brigand";
            case $monster[Erudite Gremlin]: return "erudite";
            case $monster[Furry Giant]: return "furry";
            case $monster[Gang of Hobo Muggers]: return "muggers";
            case $monster[Gaudy Pirate]: return "gaudy";
            case $monster[Ghost]: return "ghost";
            case $monster[Gnollish Crossdresser]: return "crossdresser";
            case $monster[Gnollish Gearhead]: return "gearhead";
            case $monster[Gnollish Tirejuggler]: return "tirejuggler";
            case $monster[Goth Giant]: return "goth";
            case $monster[Harem Girl]: return "harem_girl";
            case $monster[Hellion]: return "hellion";
            case $monster[Jilted Mistress]: return "jilted";
            case $monster[Knight (snake)]: return "knight";
            case $monster[Lemon-in-the-Box]: return "lemonbox";
            case $monster[Ninja Snowman Janitor]: return "janitor";
            case $monster[Peeved Roommate]: return "hipster";
            case $monster[Quantum Mechanic]: return "mechanic";
            case $monster[Quiet Healer]: return "healer";
            case $monster[Raver Giant]: return "raver";
            case $monster[Screambat]: return "screambat";
            case $monster[Shaky Clown]: return "shaky";
            case $monster[Skeletal Sommelier]: return "wine";
            case $monster[Skinflute]: return "skinflute";
            case $monster[Spider Gremlin]: return "spider_gremlin";
            case $monster[Swarm of Scarab Beatles]: return "beatles";
            case $monster[Tomb Rat]: return "tomb_rat";
            case $monster[Unemployed Knob Goblin]: return "beer_lens";
            case $monster[Vegetable Gremlin]: return "vegetable";
            case $monster[War Hippy Elite Fire Spinner]: return "fire_spinner";
            case $monster[White Lion]: return "white_lion";
            case $monster[White Snake]: return "white_snake";
            case $monster[Zombie Waltzers]: return "waltzers";
            case $monster[Baseball Bat]: return "baseball";
            case $monster[Big Creepy Spider]: return "spider";
            case $monster[Black Widow]: return "black_widow";
            case $monster[Plaque of Locusts]: return "locust";
            case $monster[Claw-foot Bathtub]: return "bathtub";
            case $monster[Demonic Icebox]: return "icebox";
            case $monster[Grungy Pirate]: return "grungy";
            case $monster[Handsome Mariachi]: return "handsomeness";
            case $monster[Irate Mariachi]: return "irate";
            case $monster[MagiMechTech MechaMech]: return "mech";
            case $monster[Mariachi Calavera]: return "calavera";
            case $monster[Pygmy Assault Squad]: return "pygmy_assault";
            case $monster[Sub-Assistant Knob Mad Scientist]: return "firecracker";
            case $monster[Tomb Servant]: return "tomb_servant";
            case $monster[Writing Desk]: return "writing_desk";
            case $monster[XXX pr0n]: return "pron";
            case $monster[W Imp]: return "wimp";
            case $monster[Reanimated Baboon Skeleton]: return "reanim_baboon";
            case $monster[Reanimated Bat Skeleton]: return "reanim_bat";
            case $monster[Reanimated Demon Skeleton]: return "reanim_demon";
            case $monster[Reanimated Giant Spider Skeleton]: return "reanim_spider";
            case $monster[Reanimated Serpent Skeleton]: return "reanim_serpent";
            case $monster[Reanimated Wyrm Skeleton]: return "reanim_wyrm";
            case $monster[Clod Hopper]: return "clodhopper";
            case $monster[Rockfish]: return "rockfish";
            case $monster[Toilet-Papered Tree]: return "tp_tree";
            case $monster[C. H. U. M. Chieftain]: return "chieftain";
            case $monster[Scary Pirate]: return "cursed";
            case $monster[Hustled Spectre]: return "hustled_spectre";
            case $monster[Neptune Flytrap]: return "neptune_flytrap";
            case $monster[Slime1]: return "slime";
            case $monster[Slime2]: return "slime";
            case $monster[Slime3]: return "slime";
            case $monster[Slime4]: return "slime";
            case $monster[Slime5]: return "slime";
            case $monster[Unholy Diver]: return "unholy_diver";
            case $monster[Large Kobold]: return "kobold";
            case $monster[Smarmy Pirate]: return "smarmy";
            case $monster[Spam Witch]: return "spam_witch";
            case $monster[Triffid]: return "triffid";
            case $monster[Bolt-Cuttin' Elf]: return "bolt_elf ";
            case $monster[Cement Cobbler Penguin]: return "cement_penguin";
            case $monster[Mesmerizing Penguin]: return "mesmerizing";
            case $monster[Mob Penguin Demolitionist]: return "demolitionist";
            case $monster[Monkey Wrenchin' Elf]: return "monkey_elf ";
            case $monster[Propaganda-spewin' Elf]: return "prop_elf";
            case $monster[Hobelf]: return "hobo_elf";
            case $monster[Somebody Else's Butt]: return "bigbutt";
        }

        return "";
    }

    // Attempt to request a monster from FaxBot.  Returns true if successful.
    boolean faxbot_request(monster mon) {
        string request = faxbot_name(mon);
        if (request == "")
            return false;

        if (!put_fax())
            return false;

        print("Making faxbot request for " + request + ".", "green");
        print("(Waiting for " + wait_time + " seconds.)", "green");

        chat_private("FaxBot", request);
        waitq(wait_time);

        if (!get_fax())
            return false;

        return check_fax(mon);
    }

    if (faxbot_name(mon) == "") {
        print("Unknown fax monster: " + mon, "red");
        return false;
    }

    print("Checking existing fax first.", "green");
    if (!get_fax()) {
        print("Unable to get fax.  Do you have a fax machine?", "red");
        return false;
    }
    if (check_fax(mon)) {
        print("You already have a " + mon + " fax.", "green");
        return true;
    }

    for i from 1 to faxbot_tries {
        if (faxbot_request(mon)) {
            print("Successfully got a " + mon + " fax.", "green");
            return true;
        }
    }

    print("Unable to receive fax for " + mon + " after " + faxbot_tries + " tries.", "red");
    return false;
}
