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
obtainInfo[$item[thin black candle]] = new telescopeItemLoc($location[giant's castle], true);
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
    // FIXME: If defeated the naughty sorceress, return nothing.
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

    // FIXME: Set initial level based on tower climb.
    int initialLevel = 1;
    // FIXME: This check is not wholly correct.
    if (item_amount($item[huge mirror shard]) > 0) {
        initialLevel = 2;
    }

    for level from initialLevel to telescopeUpgrades() {
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

float baseCombatFrequency(location loc) {
    foreach mob, freq in appearance_rates(loc) {
        if (mob == $monster[none]) {
            return 1.0 - (freq / 100.0);
        }
    }

    if (!loc.nocombats)
        abort("Couldn't find mob in " + loc + ", but there should be combats.");

    return 0;
}

float combatFrequency(location loc, float combatModifier) {
    float combatFreq = baseCombatFrequency(loc);
    return max(min(combatFreq + combatModifier, 1), 0);
}

int monsterCount(location loc) {
    int mobCount = 0;

    foreach mob, freq in appearance_rates(loc) {
        if (mob == $monster[none] || freq < 0)
            continue;

        mobCount += 1;
    }

    return mobCount;
}

// Monster frequency, not taking into account noncombats
float baseMonsterFrequency(location loc, int banished) {
    int mobCount = monsterCount(loc);
    int adjusted = max(mobCount - banished, 1);
    return 1.0 / adjusted;
}

// http://kol.coldfront.net/thekolwiki/index.php/On_the_Trail
float[int] trailedFreq;
trailedFreq[1] = 1.0000;
trailedFreq[2] = 0.8800;
trailedFreq[3] = 0.7763;
trailedFreq[4] = 0.6872;
trailedFreq[5] = 0.6110;
trailedFreq[6] = 0.5470;
trailedFreq[7] = 0.4927;
trailedFreq[8] = 0.4464;
trailedFreq[9] = 0.4071;

// Olfacted monster frequency, not taking into account noncombats
float monsterFrequencyOlfacted(location loc, int banished) {
    // FIXME: This doesn't handle special olfacted mobs like the astronomer.
    int mobCount = monsterCount(loc);
    int adjusted = max(mobCount - banished, 1);
    if (!(trailedFreq contains adjusted))
        abort("Unhandled number of mobs: " + adjusted);
    return trailedFreq[adjusted];
}

// Monster frequency with some other monster olfacted, not taking into account noncombats
float monsterFrequencyOlfactedOther(location loc, int banished) {
    int mobCount = monsterCount(loc);
    int adjusted = max(mobCount - banished, 1);
    if (adjusted == 1)
        return 1;
    if (!(trailedFreq contains adjusted))
        abort("Unhandled number of mobs: " + adjusted);

    float olfactFreq = trailedFreq[adjusted];
    float remainingFreq = 1.0 - olfactFreq;
    return remainingFreq / (adjusted - 1);
}

float monsterFrequency(location loc, monster target, monster olfact, int banishedCount) {
    if (olfact == target)
        return monsterFrequencyOlfacted(loc, banishedCount);
    else if (olfact != $monster[none])
        return monsterFrequencyOlfactedOther(loc, banishedCount);
    return baseMonsterFrequency(loc, banishedCount);
}

record CombatOptions {
    boolean useYellowRay;
    boolean useOlfaction;
    boolean useFax;
    int[item] items;
};

record CombatPlan {
    location loc;
    float expectedTurns;
    boolean useYellowRay;
    boolean useNonCombat;
    monster olfactTarget;
};

int maxFamiliarWeightModifier(CombatOptions options) {
    int weight = 0;
    if (have_skill($skill[amphibian sympathy]))
        weight += 5;
    if (have_skill($skill[empathy of the newt]))
        weight += 5;
    if (have_skill($skill[leash of linguini]))
        weight += 5;
    if (dispensary_available())
        weight += 5;

    // FIXME: possibly consider familiar equipment (sugar shield?)
    // FIXME: pool table buff?
    // FIXME: one-shot items
    return weight;
}

boolean noncombatSong() {
    // FIXME: implement
    return true;
}

float maxItemDrop(CombatOptions options) {
    // FIXME: Run through all potential item drop familiars
    // FIXME: Consider inventory items.
    // FIXME: Consider equipment;
    // FIXME: Consider if we're trying to subtract combat here and don't use hound

    float bonus = 0;

    float fairyDropBonus(float weight) {
        float bonus = square_root(55 * weight) + weight - 3;
        return bonus / 100.0;
    }

    if (have_familiar($familiar[hound dog])) {
        int baseWeight = familiar_weight($familiar[hound dog]);
        int weight = baseWeight + maxFamiliarWeightModifier(options);
        bonus += fairyDropBonus(weight * 1.25);
    }

    if (have_skill($skill[mad looting skillz]))
        bonus += 0.2;
    if (have_skill($skill[leon's phat loot]))
        bonus += 0.2;
    if (dispensary_available())
        bonus += 0.15;
    if (have_skill($skill[natural born scrabbler]))
        bonus += 0.05;
    if (have_skill($skill[powers of observatiogn]))
        bonus += 0.1;

    return bonus;
}

float maxPlusCombat(CombatOptions options) {
    int modifiers = 0;
    if (item_amount($item[monster bait]) > 0)
        modifiers += 1;
    if (have_skill($skill[cantata of confrontation]))
        modifiers += 1;
    if (have_skill($skill[musk of the moose]))
        modifiers += 1;
    if (noncombatSong())
        modifiers -= 1;

    float combat = modifiers * 0.05;

    if (have_familiar($familiar[hound dog])) {
        int baseWeight = familiar_weight($familiar[hound dog]);
        int weight = baseWeight + maxFamiliarWeightModifier(options);
        int cappedWeight = min(weight, 30);

        combat += floor(cappedWeight / 6.0) / 100.0;
    }

    // FIXME: one-shot items
    // FIXME: soft cap at 25%
    return combat;
}

float maxMinusCombat(CombatOptions options) {
    int modifiers = 0;
    if (item_amount($item[ring of conflict]) > 0)
        modifiers += 1;
    if (have_skill($skill[sonata of sneakiness]))
        modifiers += 1;
    if (have_skill($skill[smooth movement]))
        modifiers += 1;
    if (noncombatSong())
        modifiers += 1;

    // FIXME: one-shot items
    // FIXME: soft cap at 25%
    float noncombat = modifiers * -0.05;
    return noncombat;
}

float chanceForItemPerEncounter(monster mob, item thing, float itemModifier) {
    // FIXME: Initiative and pickpocketing.
    foreach dropIdx, rec in item_drops_array(mob) {
        float rate = rec.rate;
        if (rate <= 0) {
            abort("Negative drop rate for " + thing + " from " + mob);
            return 0;
        }

        float baseRate = rate / 100.0; 
        float adjustedRate = baseRate * (1.0 + itemModifier);
        float cappedRate = max(min(adjustedRate, 1.0), 0.0);
        return cappedRate;
    }

    abort("No drop rate for " + thing + " from " + mob);
    return 0;
}

float chancePerNonCombat(location loc, item thing) {
    if (!(obtainInfo contains thing))
        return 0;

    telescopeItemLoc info = obtainInfo[thing];
    if (info.loc != loc)
        return 0;

    if (!info.nonCombat)
        return 0;

    if (!(numberOfNonCombats contains loc))
        return 0;

    int count = numberOfNonCombats[loc];
    if (count == 0)
        return 0;

    return 1.0 / count; 
}

float turnsToGetItem(location loc, item thing, CombatOptions options) {

    int banishedCount(CombatOptions options) {
        return options.items contains $item[divine champagne popper] ? 1 : 0;
    }

    // If you get a combat in loc, what are the chances that it will be
    // a monster that will drop thing?
    float monsterChance(location loc, item thing, CombatOptions options) {
        boolean[monster] mobs = getMonstersForItem(loc, thing);
        int banished = banishedCount(options);

        float totalChance = 0;
        foreach mob in mobs {
            float mobChance = monsterFrequency(loc, mob, $monster[none], banished);
            totalChance += mobChance;
        }

        return totalChance;
    }

    float yellowRayTurns(location loc, item thing, CombatOptions options, float combatModifier, float nonCombatRate) {

        if (options.useFax)
            return 1.0;

        // When using a yellow ray, the chance to get an item per turn is the
        // chance that we get a monster or the chance that we get a noncombat
        // with that item.  These are all independent chances.

        // In reality, the odds are slightly better to get a monster given the
        // queue, but that's more complicated to model.
        // http://kol.coldfront.net/thekolwiki/index.php/Adventure_Queue
        float combatFrequency = combatFrequency(loc, combatModifier);
        float monsterChance = monsterChance(loc, thing, options) * combatFrequency;
        float nonCombatChance = nonCombatRate * (1.0 - combatFrequency);
        float totalChance = monsterChance + nonCombatChance;

        return totalChance > 0 ? 1.0 / totalChance : 0;
    }

    float combatChance(location loc, item thing, CombatOptions options, float combatModifier, float nonCombatRate, monster olfactionTarget) {
        boolean[monster] mobs = getMonstersForItem(loc, thing);

        float itemModifier = maxItemDrop(options);
        float combatFrequency = combatFrequency(loc, combatModifier);
        float combatChance = 0;
        int banished = banishedCount(options);

        foreach mob in mobs {
            float mobChance = monsterFrequency(loc, mob, olfactionTarget, banished);
            float itemChance = chanceForItemPerEncounter(mob, thing, itemModifier);
            combatChance += mobchance * itemChance * combatFrequency;
        }

        float nonCombatChance = nonCombatRate * (1.0 - combatFrequency);
        float chancePerTurn = nonCombatChance + combatChance;

        if (chancePerTurn == 0)
            abort("Illegal location/item combination.  Chance per turn should never be zero");

        return chancePerTurn;
    }

    float olfactionTurns(location loc, item thing, CombatOptions options, float combatModifier, float nonCombatRate) {
        boolean[monster] mobs = getMonstersForItem(loc, thing);

        float combatFrequency = combatFrequency(loc, combatModifier);
        float nonCombatChance = nonCombatRate * (1.0 - combatFrequency);

        // If we're trying to olfact, we can model this as x turns of chances
        // to get the item via noncombat prior to olfaction, 1 combat with the
        // monster where we olfact, and then some y turns under olfaction.
        // With a fax, x = 0.

        // Turns including the initial olfaction combat.
        float turnsThroughOlfaction;
        float monsterChance;
        if (options.useFax) {
            turnsThroughOlfaction = 1.0;
            monsterChance = 1.0;
        } else {
            monsterChance = monsterChance(loc, thing, options) * combatFrequency;
            if (monsterChance == 0)
                abort("Unexpected monster chance");

            turnsThroughOlfaction = 1.0 / monsterChance;
        }

        // FIXME: This assumes that we'll olfact the first thing that can drop
        // this item and that there's an equal chance to see any of them.

        float totalTurns = 0;
        foreach mob in mobs {
            // Item drop chance during the olfaction-gaining combat.
            float itemModifier = maxItemDrop(options);
            float itemChance = chanceForItemPerEncounter(mob, thing, itemModifier);
            float combatChance = combatChance(loc, thing, options, combatModifier, nonCombatRate, mob);

            // Average number of turns to get item while olfacting.
            float combatTurns = (1.0 - itemChance) / combatChance;
            float turns = combatTurns + turnsThroughOlfaction;

            if (nonCombatChance == 0 || turnsThroughOlfaction == 1) {
                totalTurns += turns;
                continue;
            }

            // Consider the chance of getting the item in a noncombat prior
            // to olfacting.
            float p = 1.0;
            int turnCount = 1;
            float expected = 0;
            while (p > 0.00001) {
                // Chance of noncombat with the item on this turn.
                expected += nonCombatChance * turnCount * p;
                // Chance of combat with this monster on this turn.
                expected += monsterChance * (combatTurns + turnCount) * p;

                // Remaining probability.
                p *= 1.0 - (monsterChance + nonCombatChance);

                turnCount += 1;
            }

            totalTurns += expected;
        }

        return totalTurns / count(mobs);
    }


    float turnsWithModifier(location loc, item thing, CombatOptions options, float combatModifier, float nonCombatRate) {

        if (options.useYellowRay)
            return yellowRayTurns(loc, thing, options, combatModifier, nonCombatRate);

        if (options.useOlfaction)
            return olfactionTurns(loc, thing, options, combatModifier, nonCombatRate);

        float combatChance = combatChance(loc, thing, options, combatModifier, nonCombatRate, $monster[none]);
        float combatTurns = 1.0 / combatChance;

        if (options.useFax) {
            boolean[monster] mobs = getMonstersForItem(loc, thing);
    
            float bestItemChance = 0;
    
            foreach mob in mobs {
                float itemModifier = maxItemDrop(options);
                float itemChance = chanceForItemPerEncounter(mob, thing, itemModifier);
                if (itemChance > bestItemChance)
                    bestItemChance = itemChance;
            }

            return bestItemChance + (1.0 - bestItemChance) * (combatTurns + 1.0);
        }

        return combatTurns;
    }

    float maxCombat = maxPlusCombat(options);
    float minCombat = maxMinusCombat(options);
    float nonCombatRate = chancePerNonCombat(loc, thing);

    float minTurns = turnsWithModifier(loc, thing, options, maxCombat, nonCombatRate);

    if (nonCombatRate > 0) {
        float minCombatTurns = turnsWithModifier(loc, thing, options, minCombat, nonCombatRate);
        minTurns = min(minTurns, minCombatTurns);
    }

    return minTurns;
}

boolean canYellowRay(monster mob, item thing) {
    foreach dropIdx, rec in item_drops_array(mob) {
        if (rec.drop != thing)
            continue;

        return (rec.type != "c" && rec.type != "p" && rec.type == "b");
    }

    return false;
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

            foreach mob in droppers {
                float itemDrop = chanceForItemPerEncounter(mob, thing, 0);
                if (itemDrop <= 0)
                    abort("No chance of getting " + thing + " from " + mob);
            }
        }
    }

    foreach thing in otherLairItems {
        if (!verifyItem(thing))
            abort("No information about how to obtain " + thing);
    }

    for level from 1 to telescopeUpgrades() {
        // This will abort for unknown strings.
        item thing = telescopeItemAtLevel(level);

        if (!verifyItem(thing))
            abort("Unknown telescope item: " + thing);
    }
}

void main() {
    sanityCheck();
}
