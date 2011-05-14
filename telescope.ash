item[string] telescopeText;
telescopeText["a banana peel"] = $item[gremlin juice];
telescopeText["a coiled viper"] = $item[adder bladder];
telescopeText["a cowardly-looking man"] = $item[wussiness potion];
telescopeText["a glum teenager"] = $item[thin black candle];
telescopeText["a hedgehog"] = $item[super-spiky hair gel];
telescopeText["an armchair"] = $item[pygmy pygment];
telescopeText["a raven"] = $item[black no. 2];
telescopeText["a rose"] = $item[angry farmer candy];
telescopeText["a smiling man smoking a pipe"] = $item[mick's icyvapohotness rub];
telescopeText["catch a glimpse of a flaming katana"] = $item[frigid ninja stars];
telescopeText["catch a glimpse of a translucent wing"] = $item[spider web];
telescopeText["see a fancy-looking tophat"] = $item[sonar-in-a-biscuit];
telescopeText["see a flash of albumen"] = $item[black pepper];
telescopeText["see a formidable stinger"] = $item[tropical orchid];
telescopeText["see a giant white ear"] = $item[pygmy blowgun];
telescopeText["see a huge face made of meat"] = $item[meat vortex];
telescopeText["see a large cowboy hat"] = $item[chaos butterfly];
telescopeText["see a pair of horns"] = $item[barbed-wire fence];
telescopeText["see a periscope"] = $item[photoprotoneutron torpedo];
telescopeText["see a slimy eyestalk"] = $item[fancy bath salts];
telescopeText["see a strange shadow"] = $item[inkwell];
telescopeText["see a wooden beam"] = $item[stick of dynamite];
telescopeText["see moonlight reflecting off of what appears to be ice"] = $item[hair spray];
telescopeText["see part of a tall wooden frame"] = $item[disease];
telescopeText["see some amber waves of grain"] = $item[bronzed locust];
telescopeText["see some long coattails"] = $item[knob goblin firecracker];
telescopeText["see some pipes with steam shooting out of them"] = $item[powdered organs];
telescopeText["see some sort of bronze figure holding a spatula"] = $item[leftovers of indeterminate origin];
telescopeText["see the neck of a huge bass guitar"] = $item[mariachi g-string];
telescopeText["see the tip of a baseball bat"] = $item[baseball];
telescopeText["see what appears to be the north pole"] = $item[ng];
telescopeText["see what looks like a writing desk"] = $item[plot hole];
telescopeText["see what seems to be a giant cuticle"] = $item[razor-sharp can lid];

effect[string] gateText;
gateText["gate of flame"] = $effect[spicy mouth];
gateText["gate of hilarity"] = $effect[comic violence];
gateText["gate of humility"] = $effect[wussiness];
gateText["gate of intrigue"] = $effect[mysteriously handsome];
gateText["gate of light"] = $effect[izchak's blessing];
gateText["gate of machismo"] = $effect[engorged weapon];
gateText["gate of morose morbidity and moping"] = $effect[rainy soul miasma];
gateText["gate of mystery"] = $effect[mystic pickleness];
gateText["gate of slack"] = $effect[extreme muscle relaxation];
gateText["gate of spirit"] = $effect[woad warrior];
gateText["gate of that which is hidden"] = $effect[object detection];
gateText["gate of the dead"] = $effect[hombre muerto caminando];
gateText["gate of the mind"] = $effect[strange mental acuity];
gateText["gate of the ogre"] = $effect[strength of ten ettins];
gateText["gate of the porcupine"] = $effect[spiky hair];
gateText["gate of the viper"] = $effect[deadly flashing blade];
gateText["gate of torment"] = $effect[tamarind torment];
gateText["gate of zest"] = $effect[spicy limeness];
gateText["gates of the suc rose"] = $effect[sugar rush];
gateText["gate that is not a gate"] = $effect[teleportitis];
gateText["locked gate"] = $effect[locks like the raven];

boolean[item] otherLairItems = $items[wand of nagamar];

// For a given effect, all the items that always give that effect.
// If an effect is not listed, it must be specially handled (e.g. DoD).
// Yummy Tummy Bean can give wussiness and rainy soul miasma, but it's not
// guaranteed.
boolean[effect, item] gateItems;
gateItems[$effect[comic violence]] = $items[gremlin juice];
gateItems[$effect[deadly flashing blade]] = $items[adder bladder];
gateItems[$effect[engorged weapon]] = $items[meleegra pills];
gateItems[$effect[extreme muscle relaxation]] = $items[mick's icyvapohotness rub];
gateItems[$effect[hombre muerto caminando]] = $items[marzipan skull];
gateItems[$effect[locks like the raven]] = $items[black no. 2];
gateItems[$effect[mysteriously handsome]] = $items[handsomeness potion];
gateItems[$effect[mystic pickleness]] = $items[pickle-flavored chewing gum];
gateItems[$effect[rainy soul miasma]] = $items[thin black candle, picture of a dead guy's girlfriend];
gateItems[$effect[spicy limeness]] = $items[lime-and-chile-flavored chewing gum];
gateItems[$effect[spicy mouth]] = $items[jabañero-flavored chewing gum];
gateItems[$effect[spiky hair]] = $items[super-spiky hair gel];
gateItems[$effect[sugar rush]] = $items[angry farmer candy, marzipan skull, tasty fun good rice candy, yummy tummy bean, stick of gum, breath mint, daffy taffy];
gateItems[$effect[tamarind torment]] = $items[tamarind-flavored chewing gum];
gateItems[$effect[woad warrior]] = $items[pygmy pygment];
gateItems[$effect[wussiness]] = $items[wussiness potion];

boolean[item, item] multipartItems;
multipartItems[$item[wand of nagamar]] = $items[wa, nd];
multipartItems[$item[wa]] = $items[ruby w, metallic a];
multipartItems[$item[nd]] = $items[lowercase n, heavy d];
multipartItems[$item[ng]] = $items[lowercase n, original g];

// Information to help adventure for a given item.
record telescopeItemLoc {
    location loc;
    // Whether the item can be obtained in a non-combat adventure.
    boolean nonCombat;
};

telescopeItemLoc[item] obtainInfo;
obtainInfo[$item[adder bladder]] = new telescopeItemLoc($location[black forest]);
obtainInfo[$item[angry farmer candy]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[barbed-wire fence]] = new telescopeItemLoc($location[moxie vacation], true);
obtainInfo[$item[baseball]] = new telescopeItemLoc($location[guano junction]);
obtainInfo[$item[black no. 2]] = new telescopeItemLoc($location[black forest]);
obtainInfo[$item[black pepper]] = new telescopeItemLoc($location[black forest]);
obtainInfo[$item[bronzed locust]] = new telescopeItemLoc($location[desert (ultrahydrated)]);
obtainInfo[$item[chaos butterfly]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[disease]] = new telescopeItemLoc($location[knob harem]);
obtainInfo[$item[fancy bath salts]] = new telescopeItemLoc($location[haunted bathroom]);
obtainInfo[$item[frigid ninja stars]] = new telescopeItemLoc($location[ninja snowmen]);
obtainInfo[$item[gremlin juice]] = new telescopeItemLoc($location[post-war junkyard]);
obtainInfo[$item[hair spray]] = new telescopeItemLoc();
obtainInfo[$item[handsomeness potion]] = new telescopeItemLoc($location[south of the border], false);
obtainInfo[$item[heavy d]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[inkwell]] = new telescopeItemLoc($location[haunted library]);
obtainInfo[$item[jabanero-flavored chewing gum]] = new telescopeItemLoc($location[south of the border], true);
obtainInfo[$item[knob goblin firecracker]] = new telescopeItemLoc($location[outskirts of the knob]);
obtainInfo[$item[leftovers of indeterminate origin]] = new telescopeItemLoc($location[haunted kitchen]);
obtainInfo[$item[lime-and-chile-flavored chewing gum]] = new telescopeItemLoc($location[south of the border], true);
obtainInfo[$item[lowercase n]] = new telescopeItemLoc($location[orc chasm]);
obtainInfo[$item[mariachi g-string]] = new telescopeItemLoc($location[south of the border]);
obtainInfo[$item[marzipan skull]] = new telescopeItemLoc($location[south of the border]);
obtainInfo[$item[meat vortex]] = new telescopeItemLoc($location[orc chasm]);
obtainInfo[$item[meleegra pills]] = new telescopeItemLoc($location[south of the border], true);
obtainInfo[$item[metallic a]] = new telescopeItemLoc($location[fantasy airship]);
obtainInfo[$item[mick's icyvapohotness rub]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[original g]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[photoprotoneutron torpedo]] = new telescopeItemLoc($location[fantasy airship]);
obtainInfo[$item[pickle-flavored chewing gum]] = new telescopeItemLoc($location[south of the border], true);
obtainInfo[$item[plot hole]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[powdered organs]] = new telescopeItemLoc($location[middle chamber]);
obtainInfo[$item[pygmy blowgun]] = new telescopeItemLoc($location[hidden city]);
obtainInfo[$item[pygmy pygment]] = new telescopeItemLoc($location[hidden city]);
obtainInfo[$item[razor-sharp can lid]] = new telescopeItemLoc($location[haunted pantry]);
obtainInfo[$item[ruby w]] = new telescopeItemLoc($location[pandamonium slums]);
obtainInfo[$item[sonar-in-a-biscuit]] = new telescopeItemLoc($location[guano junction]);
obtainInfo[$item[spider web]] = new telescopeItemLoc($location[back alley]);
obtainInfo[$item[stick of dynamite]] = new telescopeItemLoc($location[muscle vacation], true);
obtainInfo[$item[super-spiky hair gel]] = new telescopeItemLoc($location[fantasy airship]);
obtainInfo[$item[tamarind-flavored chewing gum]] = new telescopeItemLoc($location[south of the border], true);
obtainInfo[$item[thin black candle]] = new telescopeItemLoc($location[giant's castle]);
obtainInfo[$item[tropical orchid]] = new telescopeItemLoc($location[mysticality vacation], true);
obtainInfo[$item[wussiness potion]] = new telescopeItemLoc($location[pandamonium slums]);

// bcascStage holds the stage that must be completed before a location is
// available.  This array must contain all locations referenced in obtainInfo.
string[location] bcascStage;
bcascStage[$location[back alley]] = "toot";
bcascStage[$location[black forest]] = "macguffinprelim";
bcascStage[$location[desert (ultrahydrated)]] = "macguffinpyramid";
bcascStage[$location[fantasy airship]] = "castle";
bcascStage[$location[giant's castle]] = "castle";
bcascStage[$location[guano junction]] = "bats1";
bcascStage[$location[harem]] = "knobking";
bcascStage[$location[haunted bathroom]] = "manorbedroom";
bcascStage[$location[haunted kitchen]] = "pantry";
bcascStage[$location[haunted library]] = "manorbilliards";
bcascStage[$location[haunted pantry]] = "toot";
bcascStage[$location[hidden city]] = "macguffinhiddencity";
bcascStage[$location[middle chamber]] = "macguffinfinal";
bcascStage[$location[moxie vacation]] = "dinghy";
bcascStage[$location[muscle vacation]] = "dinghy";
bcascStage[$location[mysticality vacation]] = "dinghy";
bcascStage[$location[ninja snowmen]] = "trapper";
bcascStage[$location[orc chasm]] = "chasm";
bcascStage[$location[outskirts of the knob]] = "toot";
bcascStage[$location[pandamonium slums]] = "friarssteel";
bcascStage[$location[post-war junkyard]] = "warboss";
bcascStage[$location[south of the border]] = "dinghy";

// For any item that can be obtained in a non-combat adventure, specify
// the number of non-skippable non-combats for a given area.  This is used
// to calculated the likelihood of obtaining that item.
int[location] numberOfNonCombats;
numberOfNonCombats[$location[giant's castle]] = 2;
numberOfNonCombats[$location[moxie vacation]] = 1;
numberOfNonCombats[$location[muscle vacation]] = 1;
numberOfNonCombats[$location[mysticality vacation]] = 1;
numberOfNonCombats[$location[south of the border]] = 5;

boolean[item] bangPotions = $items[
    bubbly potion,
    cloudy potion,
    dark potion,
    effervescent potion,
    fizzy potion,
    milky potion,
    murky potion,
    smoky potion,
    swirly potion,
];

// Usable items contains any item that can trivially be used to turn into other
// items.
boolean[item, item] usableItems;
usableItems[$item[black picnic basket]] = $items[black pepper];
usableItems[$item[canopic jar]] = $items[powdered organs];
usableItems[$item[large box]] = bangPotions;
usableItems[$item[pile of candy]] = $items[angry farmer candy, marzipan skull, tasty fun good rice candy, yummy tummy bean];
usableItems[$item[small box]] = bangPotions;

boolean[monster] getMonstersForItem(location loc, item thing) {
    boolean[monster] droppers;

    boolean[item] drop;
    drop[thing] = true;

    foreach useItem in usableItems {
        foreach useResult in usableItems[useItem] {
            if (useResult != thing)
                continue;
            drop[useItem] = true;
        }
    }

    foreach mobIdx, mob in get_monsters(loc) {
        foreach dropIdx, rec in item_drops_array(mob) {
            if (!(drop contains rec.drop))
                continue;
            droppers[mob] = true;
        }
    }

    return droppers;
}

int telescopeUpgrades() {
    return get_property("telescopeUpgrades").to_int();
}

string telescopeTextAtLevel(int level) {
    return to_lower_case(get_property("telescope" + level));
}

item telescopeItemAtLevel(int level) {
    string str = telescopeTextAtLevel(level);
    if (!(telescopeText contains str))
        abort("Unknown telescope string: " + str);
    return telescopeText[str];
}

boolean locationAvailable(location loc) {
    // FIXME: implement
    string stage = bcascStage[loc];
    if (stage == "")
        abort("Internal error: stage not recorded for location: " + loc);

    return false;
}

int[item] telescopeItemsNeeded() {
    int[item] needed;

    void needItem(int quantity, item thing) {
        if (needed contains thing)
            needed[thing] = needed[thing] + quantity;
        else
            needed[thing] = quantity - item_amount(thing);

        // Because we can't modify the keys of an array during a foreach, add
        // all the keys for subitems ahead of time in case we need to break
        // down an item into its needed components.
        void setSubItemsNeeded(item thing) {
            if (!(multipartItems contains thing))
                return;
            foreach subItem in multipartItems[thing] {
                if (needed contains subItem)
                    continue;
                needItem(0, subItem);
            }
        }
        setSubItemsNeeded(thing);
    }

    for level from 1 to telescopeUpgrades() {
        item thing = telescopeItemAtLevel(level);
        needItem(1, thing);
    }

    foreach thing in otherLairItems {
        needItem(1, thing);
    }

    // Break into subitems, if not already acquired.
    foreach thing in needed {
        void processSubItems(item thing) {
            if (!(multipartItems contains thing))
                return;
            if (needed[thing] <= 0)
                return;

            int subItemQuantity = needed[thing];
            needed[thing] = 0;
            foreach subItem in multipartItems[thing] {
                needItem(subItemQuantity, subItem);
                processSubItems(subItem);
            }
        }
        processSubItems(thing);
    }

    foreach thing in needed {
        if (needed[thing] > 0)
            continue;
        remove needed[thing];
    }

    return needed;
}

boolean needTelescopeItem(item thing) {
    return telescopeItemsNeeded() contains thing;
}

void sanityCheck() {
    boolean verifyItem(item thing) {
        if (obtainInfo contains thing)
            return true;
        if (!(multipartItems contains thing))
            return false;

        foreach subItem in multipartItems[thing] {
            if (!verifyItem(subItem))
                return false;
        }

        return true;
    }

    foreach str in telescopeText {
        item thing = telescopeText[str];
        if (!verifyItem(thing))
            abort("No information about how to obtain " + thing);
    }

    foreach e in gateItems {
        item needed;
        boolean obtainInfoExists = false;
        foreach thing in gateItems[e] {
            if (obtainInfo contains thing)
                needed = thing;
        }
        if (needed == $item[none])
            abort("No way to get any item for effect " + e);
    }

    foreach thing in obtainInfo {
        location loc = obtainInfo[thing].loc;
        if (loc == $location[none])
            continue;

        if (!(bcascStage contains loc))
            abort("No bcascStage for " + loc);

        if (obtainInfo[thing].nonCombat) {
            if (!(numberOfNonCombats contains loc))
                abort("No noncombat info for " + loc);
        } else {
            boolean[monster] droppers = getMonstersForItem(loc, thing);
            if (count(droppers) == 0)
                abort("Couldn't find any monsters for " + thing + " in " + loc);
        }
    }

    foreach thing in otherLairItems {
        if (!verifyItem(thing))
            abort("No information about how to obtain " + thing);
    }

    telescopeItemsNeeded();
}

void main() {
    sanityCheck();
}
