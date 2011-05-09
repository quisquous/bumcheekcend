/*
	bumcheekascend.ash v0.23
	A script to ascend a character from start to finish.
	
	0.1 - Spun initial release. Gets up to about level 10, haphazardly. 
	0.2 - Added checking for the trapper after the goat cheese.
	    - Fixed bug where it wouldn't get the teleportitis choiceadv immediately after the plus sign. 
		- Added majority of pirate quest.
	0.3 - Implemented Zarqon's excellent scripts for the Level 11 and 12 quests.
		- Fixed bug where it would continue to adventure in the Billiards Room even after you got the key.
		- Fixed bug where it'd get the sonar-in-a-biscuits even if you had them. 
	0.4 - Fixed bug whereby it wouldn't account for Game Grid tokens if you had them, when switching familiars. 
		- Going to start to use a lot more clovers since the change. Levelling post-10 will be done with clovers, as will getting 2 sonars. 
		- Various other small bugs. 
		- Moved all of Zarqon's Level 11 script to this, extensively modified. 
		- Moved some of Zarqon's Level 12 script to this, but unfinished. 
		- Level 13 now completely automated, though a litle buggy. 
		- He-Boulder use now basically supported.
	0.5 - Making both innaboxen post-bonerdagon. 
		- Automating beer pong.
		- Moved the hidden city to being inside the script rather than being called from outside it. 
		- Changed to the full version of bumAdv() moving the goals, etc. to the function rather than calling them individually. 2032 lines before I started this. 
		- Do the Daily Dungeon and zap legend items as appropriate.
	0.6 - Moved (some of) the level 12 script to here, rather than making people run Wossname.ash
		- Moved the billiards room to the part at Level 7.
		- Open the guild store at level 9.
		- Fixed bug whereby it would continue to try to adventure to get insults when you had no adventures. 
		- Fixed bug whereby it would try to get the swashbuckling outfit even if you had the fledges and had sold an outfit piece.
		- Made the script automatically fight the Defiled area bosses.
		- Use noncombat in the > Sign and DoD.
		- Sort problem where it would attempt to level in the Temple immediately even if you couldn't.
		- Added aborts to the spooky sapling and tavern areas as mafia support for those is currently in the pipeline. 
		- Throw a visit to trapper.php when we use the black paint at Level 11, just in case we haven't got cold resistance yet. 
		- Make DB Epic Weapon if applicable. 
		- Only adventure in the DoD to get the wand if you have > 6000 meat.
	0.7 - Fix issue where it wouldn't stop adventuring in the HitS.
		- Fix issue with not turning in the arena adventure. 
		- Fix bug where it wouldn't do the Sonofa Beach quest at all. 
		- Add support for 100% familiars.
		- Added support for pumpkin bombs where we don't have a he-boulder or are on a 100% run. 
		- Changed a lot of IFs to WHILEs to account for sugar items breaking. 
		- Actually adventure at the shore instead of breaking. 
		- Fixed issue where the script would break if you didn't get Minniesota Indoodlywhatatis from the Billiards Room in 5 advs.
		- Every time we change the MCD, we must check if we can using the canMCD() function which I've added. 
		- Added support for a cloverless option. 
		- Used Riff's scripts to add support for Beer Pong
		- Use spleen items automatically (aguas, coffee pixie sticks) including turning tokens into tickets using the skeeball machine.
		- Some more testing on completing the war as a Hippy, which has now been tested. 
		- Don't adventure in the Knoll if you have no adventures. 
		- Fix problem where it wouldn't equip stench resistance to adventure in Guano junction.
		- Sort out the spooky sapling thing, finally!
		- There's now an items mood, which will be expanded on shortly. 
	0.8 - Accommodated change to Mr. Alarm
		- Made sure that there weren't any maximize commands without -melee added
		- Check for meat when shoreing.
		- Other misc. issues. 
		- Update the Boss Bat quest to account for Nov 2010 Changes. 
		- Added support for phat/leash when you need item drops. 
		- Added default options, so that this is ACTUALLY zero setup again. 
	0.9 - Fix problem with moods +-combat moods that cancel each other out. 
		- Set wheel choiceadventures in the Castle
		- Fix bug whereby it'd adventure in the goatlet even once you gave the cheese back. 
		- Change "f" to "familiar". 
		- Make it not crash on DB chars when making boxen. 
		- Made making a bartender an opt-in preference. 
		- Do GMoB instead of Cyrus. Figuring out the Cyrus logic is too hard. 
	0.10- Open ballroom by going through bedroom. NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE NOT YET DONE 
		- Check for the He-Boulder BEFORE making the pumpkin bomb. Not after. That would be a stupid idea. 
		- Force MCD=0 in Junkyard. Maximize DR/DA as well. Force MCD=4,7 in Boss Bat, Throne Room.
		- Fix bug where it'd continue to get the steel items. 
		- Made a slight change to the way the script checks for clovers. 
		- Set the library choice adventures. 
		- Also set moods if we have >100MP or >7000 meat.
		- Start moving things into separate functions per quests.
		- Set moods when trying to level.
	0.11- Fixed bug with trapzor quest where it wouldn't get the goat cheese at all. 
		- Only adventure in the Upper Chamber if you DON'T have the wheel. And use tomb ratchets if one drops. 
		- Don't mark the guild tests as being done if they haven't been done.
		- Don't worry about safe moxie in the starting areas.
		- Adventure in the haunted pantry during levelMe when still level 1.
		- Visit Toot and use the letter. 
		- Check for if you're cloverless and hence can't get an EW. 
		- Use Spleen items on change of familiar. 
		- Beaten up check in Hidden City added.
		- Don't try to make Epic weapons if you don't have meat or the tenderizing hammer. 
		- Add tavern code. Thanks, picklish!
	0.12- Added option to fight the NS. 
		- Don't get innaboxen if you're cloverless.
		- Add -melee -ML to the default maximize command.
		- Fix bug with levelling not working with buffed moxie. 
		- Add mining command.
		- Use an item drop familiar in the gremlins (to solve problems with snatch and DB attacks).
	0.13- If you don't have an accordion, get one. 
		- Don't abort if you don't have a big rock for the Epic Weapon(s)
		- Don't think you can shop in the KGE store if you don't have the lab key. Because you can't. 
		- Use a spanglerack if possible. 
		- Move the Level 11 quest into sub-functions. 
		- Make sure to set familiars when levelling. Also don't use your last clover on levelling. 
		- Don't make a meatcar if you have a pumpkin carriage or desert bus pass.
		- Do the Bedroom. Yay!
	0.14- Fix bug with using clovers to level in cloverless runs. 
		- Don't cast Mojo if you want NCs or items. This solves problems with setting 4 songs. 
		- Create a new mood called "bumcheekascend" to use.
		- Fixed bug whereby it would mark the bats1 as done when it wasn't. 
		- Let's not equip the pool cue, eh? Also, moved the Billiards Room to earlier. 
		- Only set skills in your mood if you can use them.
		- Add some fixes by picklish for burning teleportitis. 
		- Fix Hole in the Sky for about the zillionth time. 
		- Add a check for a one-handed item during the 8-bit. 
		- Improved logic for Level 13, which will now correctly get a DoD potion as well as a couple other items. 
	0.15- Add red ray use. Fix potion of blessing for Level 13. Thanks, picklish!
		- Add telescope checking. 
		- Fix bug where it wouldn't do the DD.
		- Change maximize commands for mus/mys compatibility. 
		- Add basic support for muscle classes.
	0.16- Various fixes for muscle ascensions. 
		- Fix some telescope stuff, expand on options there. 
		- Added some "base" entries to the maximizer, which are always on. Melee and shield for Mus, ranged for Mox.
		- It's probably best if muscle classes DON'T attack the gremlins.
		- Hit the questlog to see if you've completed the Hidden City for (pah!) SOFTcore players...
		- Added new Azazel quest.
	0.17- Fixed bug where muscle classes basically wouldn't fight the Bonerdagon
		- Use the hipster for the temple.
		- No need to hit the guild for the meatcar quest anymore. 
		- Continued muscle fixes. 
		- Don't abort at Yossarian if you have the outfit on already.
		- Don't abort at the 8bit for muscle classes.
		- Start the steel quest properly now. 
	0.18- Only make an RNR Legend if you have relevant skills. Thanks, St. Doodle!
		- Don't switch to the hipster if you're on a 100% run. 
		- Fix "try" now being a reserved word. 
		- Dont cast Mojo if you can't. 
	0.19- Change for Cobb's Knob changes. 
		- Don't go to the chasm if you already have the scroll. Important now with faxbot.
		- Remove the eyedrops from use.
		- Option to NOT get your stuff from Hagnks
		- Only get the 1-handed weapon if you're moxie. And get a disco ball.
		- Get the AT epic weapon last. 
		- Major tavern fix from picklish. 
		- Revamped Level 5 quest. 
		- Open Gallery as Muscle class.
	0.20- Some better Sven logic.
		- Fixed detection of Cyrpt, KnobKing, Steel Item and Innaboxen stages if they were done out-of-script. Thanks, Winterbay!
		- Improved Tavern handling from picklish. 
		- Stuff. Various actually quite large fixes that I forgot to mention. 
		- Ability to set default familiar. Check your relay scripts.
	0.21- Get mariachi instruments. Thanks, picklish!
		- Add option to NOT level in the temple.
		- Get meelgra pills, more tavern fixes. Another picklish addition. 
		- Fix bug with Sven and failing to get the Unicorn. 
		- Fix bug with getting a box if you can't access the Fun House. Thanks, gruddlefitt!
		- Don't use the scope if you've passed the mariachis.
		- Added default options for those who can't work out the relay script. This is finally zero-setup again!
		- Don't remove goals when getting a firecracker for pumpkin bomb. 
	0.22- Allow 2-handed weapons or DFSS when you don't have a shield. 
		- Use your CCS actions and be more robust to wandering monsters thanks to picklish.
		- Dont fight the Boss Bat if there's rubble there. 
		- Don't open the prok sack if you don't want to autosell the gems. 
		- Myst ascension. Oh yes.
	0.23- Myst fixes ranging from minor to major. Added various sauce spells.
		- Set choiceadvs on levelMe()
		- Set a while rather than an if for the level 9 quest.
		- Should zap legend keys if you have MORE than one of them. Also move zapKeys() into the global space. 
		- Have myst consult script fire in all appropriate locations. 
		- Don't equip hippy outfit in Hidden City as myst. 
		- Don't use the hipster in the temple if you're on a 100% run. 
		- New Cyrpt added. 
*/

script "bumcheekascend.ash";
notify bumcheekcity;

string bcasc_doWarAs = get_property("bcasc_doWarAs"), bcasc_100familiar = get_property("bcasc_100familiar"), bcasc_warOutfit;
boolean bcasc_bartender = get_property("bcasc_bartender").to_boolean(), bcasc_bedroom = get_property("bcasc_bedroom").to_boolean(), bcasc_chef = get_property("bcasc_chef").to_boolean(), bcasc_cloverless = get_property("bcasc_cloverless").to_boolean(), bcasc_doSideQuestArena = get_property("bcasc_doSideQuestArena").to_boolean(), bcasc_doSideQuestJunkyard = get_property("bcasc_doSideQuestJunkyard").to_boolean(), bcasc_doSideQuestBeach = get_property("bcasc_doSideQuestBeach").to_boolean(), bcasc_doSideQuestOrchard = get_property("bcasc_doSideQuestOrchard").to_boolean(), bcasc_doSideQuestNuns = get_property("bcasc_doSideQuestNuns").to_boolean(), bcasc_doSideQuestDooks = get_property("bcasc_doSideQuestDooks").to_boolean(), bcasc_fightNS = get_property("bcasc_fightNS").to_boolean(), bcasc_MineUnaccOnly = get_property("bcasc_MineUnaccOnly").to_boolean();

/***************************************
* DO NOT EDIT ANYTHING BELOW THIS LINE *
***************************************/

if (bcasc_doWarAs == "frat") {
	bcasc_warOutfit = "frat warrior";
} else if (bcasc_doWarAs == "hippy") {
	bcasc_warOutfit = "war hippy";
} else {
	//abort("Please specify whether you would like to do the war as a frat or hippy by downloading the relay script at http://kolmafia.us/showthread.php?t=5470 and setting the settings for the script.");
	bcasc_doWarAs = "frat";
	bcasc_warOutfit = "frat warrior";
	bcasc_doSideQuestArena = true;
	bcasc_doSideQuestJunkyard = true;
	bcasc_doSideQuestBeach = true;
	print("BCC: IMPORTANT - You have not specified whether you would like to do the war as a frat or a hippy. As a result, the script is assuming you will be doing it as a frat, doing the Arena, Junkyard and Beach. Visit the following page to download a script to help you change these settings. http://kolmafia.us/showthread.php?t=5470");
	wait(5);
}

record lairItem {
	string gatename;
	string effectname;
	string a; //Item name 1
	string b;
	string c;
	string d;
	string e;
};
lairItem [int] lairitems;
string councilhtml, html;

/******************
* BEGIN FUNCTIONS *
******************/

int i_a(string name) {
	item i = to_item(name);
	int a = item_amount(i) + closet_amount(i) + equipped_amount(i);
	
	//Make a check for familiar equipment NOT equipped on the current familiar. 
	foreach fam in $familiars[] {
		if (have_familiar(fam) && fam != my_familiar()) {
			if (name == to_string(familiar_equipped_equipment(fam)) && name != "none") {
				a = a + 1;
			}
		}
	}
	
	//print("Checking for item "+name+", which it turns out I have "+a+" of.", "fuchsia");
	return a;
}


boolean isExpectedMonster(string opp) {
	location loc = my_location();

	boolean haveOutfitEquipped(string outfit) {
		boolean anyEquipped = false;
		boolean allEquipped = true;
		foreach key, thing in outfit_pieces(outfit) {
			if (have_equipped(thing)) {
				anyEquipped = true;
			} else {
				allEquipped = false;
				break;
			}
		}

		return anyEquipped && allEquipped;
	}

	//Fix up location appropriately. :(
	if (loc == $location[wartime frat house]) {
		if (haveOutfitEquipped("hippy disguise") || haveOutfitEquipped("war hippy fatigues"))
			loc = $location[wartime frat house (hippy disguise)];
	} else if (loc == $location[wartime hippy camp]) {
		if (haveOutfitEquipped("frat boy ensemble") || haveOutfitEquipped("frat boy fatigues"))
		loc = $location[wartime hippy camp (frat disguise)];
	}

	monster mon = opp.to_monster();
	boolean expected = appearance_rates(loc) contains mon;
	return expected;
}

string safe_visit_url(string url) {
    string response;
    try { response = visit_url( url ); }
    finally { return response; }
    return response;
}

//Thanks to Bale and slyz here!
effect [item] allBangPotions() {
	effect [item] potion;
	for id from 819 to 827 {
		switch( get_property("lastBangPotion"+id) ) {
			case "sleepiness": potion[id.to_item()] = $effect[ Sleepy ]; break;
			case "confusion": potion[id.to_item()] = $effect[ Confused ]; break;
			case "inebriety": potion[id.to_item()] = $effect[ Antihangover ]; break;
			case "ettin strength": potion[id.to_item()] = $effect[ Strength of Ten Ettins ]; break;
			case "blessing": potion[id.to_item()] = $effect[ Izchak's Blessing ]; break;
			case "healing": break;
			default: potion[id.to_item()] = get_property("lastBangPotion"+id).to_effect();
		}
	}
	return potion;
}

//Returns true if we have a shield and Hero of the Halfshell.
boolean anHero() {
	if (!have_skill($skill[Hero of the Half-Shell])) return false;
	if (!(my_primestat() == $stat[Muscle])) return false;
	if (get_property("bcasc_lastShieldCheck") == today_to_string()) return true;
	
	cli_execute("maximize +shield");
	if (item_type(equipped_item($slot[off-hand])) == "shield") {
		cli_execute("set bcasc_lastShieldCheck = "+today_to_string());
		print("BCC: You appear to have a shield. If you autosell your last shield, this script is going to behave very strangely and you're an idiot.", "purple");
		return true;
	}
	
	print("BCC: You don't have a shield. It might be better to get one. ", "purple");
	return false;
}

//Returns a string of "dark potion", or whatever. 
string bangPotionWeNeed() {
	effect effectWeNeed() {
		string html = visit_url("lair1.php?action=gates");
		effect e = $effect[none];
		
		if (contains_text(html, "Gate of Light")) { e = $effect[Izchak's Blessing]; }
		if (contains_text(html, "Gate of That Which is Hidden")) { e = $effect[Object Detection]; }
		if (contains_text(html, "Gate of the Mind")) { e = $effect[Strange Mental Acuity]; }
		if (contains_text(html, "Gate of the Ogre")) { e = $effect[Strength of Ten Ettins]; }
		if (contains_text(html, "Gate that is Not a Gate")) { e = $effect[Teleportitis]; }
		print("BCC: The effect we need for the gate is "+e.to_string(), "purple");
		if (e == $effect[none]) abort("Error determining effect needed to pass the gates!");
		return e;
	}
	
	effect e = effectWeNeed();
	foreach pot, eff in allBangPotions() {
		if (e == eff) {
			print("BCC: The potion we need is the "+pot, "purple");
			return pot;
		}
	}
	print("BCC: We could not yet determine which potion gives us the necessary effect.", "purple");
	return "";
}

string bcCouncil() {
	if (get_property("lastCouncilVisit") != my_level() || councilhtml == "") {
		councilhtml = visit_url("council.php");
	}
	return councilhtml;
}

//Thanks, Riff!
string beerPong(string page) {
	record r {
		string insult;
		string retort;
	};

	r [int] insults;
	insults[1].insult="Arrr, the power of me serve'll flay the skin from yer bones!";
	insults[1].retort="Obviously neither your tongue nor your wit is sharp enough for the job.";
	insults[2].insult="Do ye hear that, ye craven blackguard?  It be the sound of yer doom!";
	insults[2].retort="It can't be any worse than the smell of your breath!";
	insults[3].insult="Suck on <i>this</i>, ye miserable, pestilent wretch!";
	insults[3].retort="That reminds me, tell your wife and sister I had a lovely time last night.";
	insults[4].insult="The streets will run red with yer blood when I'm through with ye!";
	insults[4].retort="I'd've thought yellow would be more your color.";
	insults[5].insult="Yer face is as foul as that of a drowned goat!";
	insults[5].retort="I'm not really comfortable being compared to your girlfriend that way.";
	insults[6].insult="When I'm through with ye, ye'll be crying like a little girl!";
	insults[6].retort="It's an honor to learn from such an expert in the field.";
	insults[7].insult="In all my years I've not seen a more loathsome worm than yerself!";
	insults[7].retort="Amazing!  How do you manage to shave without using a mirror?";
	insults[8].insult="Not a single man has faced me and lived to tell the tale!";
	insults[8].retort="It only seems that way because you haven't learned to count to one.";

	while (!page.contains_text("victory laps"))
	{
		string old_page = page;

		if (!page.contains_text("Insult Beer Pong")) abort("You don't seem to be playing Insult Beer Pong.");

		if (page.contains_text("Phooey")) {
			print("Looks like something went wrong and you lost.", "lime");
			return page;
		}
	
		foreach i in insults {
			if (page.contains_text(insults[i].insult)) {
				if (page.contains_text(insults[i].retort)) {
					print("Found appropriate retort for insult.", "lime");
					print("Insult: " + insults[i].insult, "lime");
					print("Retort: " + insults[i].retort, "lime");
					page = visit_url("beerpong.php?value=Retort!&response=" + i);
					break;			
				} else {
					print("Looks like you needed a retort you haven't learned.", "red");
					print("Insult: " + insults[i].insult, "lime");
					print("Retort: " + insults[i].retort, "lime");
	
					// Give a bad retort
					page = visit_url("beerpong.php?value=Retort!&response=9");
					return page;
				}
			}
		}

		if (page == old_page) abort("String not found. There may be an error with one of the insult or retort strings."); 
	}

	print("You won a thrilling game of Insult Beer Pong!", "lime");
	return page;
}

boolean betweenBattle() {
	cli_execute("mood execute; uneffect beaten up;");
	if (to_float(my_hp()) / my_maxhp() < to_float(get_property("hpAutoRecovery"))) restore_hp(0); 
	if (to_float(my_mp()) / my_maxmp() < to_float(get_property("mpAutoRecovery"))) restore_mp(0);  

	if (have_effect($effect[Beaten Up]) > 0) abort("Script could not remove Beaten Up.");
	if (my_adventures() == 0) abort("No adventures left");
}

void callBetweenBattleScript() {
	string script = get_property("betweenBattleScript");
	if (script != "")
		cli_execute("call " + script);
}

//Use instead of visit_url if visiting the url has a chance of causing a combat.
string bumAdvUrl(string url) {
	betweenBattle();
	callBetweenBattleScript();
	return visit_url(url);
}

boolean bumFamiliar(familiar fam) {
	if (fam != $familiar[none] && !have_familiar(fam)) return false;
	//Record desired familiar so between battle script can use that info.
	set_property("bcasc_familiar", fam);
	return use_familiar(fam);
}

boolean buMax(string maxme) {
	//We should sell these to avoid hassle when muscle classes.
	foreach i in $items[antique helmet, antique shield, antique greaves, antique spear] {
		autosell(item_amount(i), i);
	}

	//Just a quick check for this.
	if (contains_text(maxme, "continuum transfunctioner") && my_primestat() == $stat[Muscle]) {
		cli_execute("maximize mainstat "+maxme+" +melee -ml -tie"); 
		return true;
	}
	if (contains_text(maxme, "knob goblin elite")) {
		if (my_basestat($stat[Muscle]) < 15) abort("You need 15 base muscle to equip the KGE outfit.");
		if (my_basestat($stat[Moxie]) < 15) abort("You need 15 base moxie to equip the KGE outfit.");
		cli_execute("maximize mainstat "+maxme+" -ml -tie"); 
		return true;
	}
	if (maxme.contains_text("item") && have_familiar($familiar[Mad Hatrack])) {
		maxme += " -equip spangly sombrero";
	}
	
	//Basically, we ALWAYS want -tie and -ml, for ALL classes. Otherwise we let an override happen. 
	switch (my_primestat()) {
		case $stat[Muscle] : 		cli_execute("maximize mainstat "+maxme+" +melee "+((anHero()) ? "+shield" : "")+" -10 ml -tie +muscle experience"); break;
		case $stat[Mysticality] : 	cli_execute("maximize mainstat "+maxme+" +10spell damage +5 mp regen min +5 mp regen max -10 ml -tie +mysticality experience"); break;
		case $stat[Moxie] : 		cli_execute("maximize mainstat "+maxme+" -melee -10 ml -tie +moxie experience"); break;
	}
	return true;
	/*
	if (maxme == "") {
		//If we don't say anything, assume we want the following set of EXTRA defaults over and above the "normal" -tie -ml
		switch (my_primestat()) {
			case $stat[Muscle] : maxme2 = "+melee +shield"; break;
			case $stat[Mysticality] : abort("ZOMG NO MYST"); break;
			case $stat[Moxie] : maxme2 = "-melee"; break;
		}
	}
	cli_execute("maximize mainstat "+maxme+" -ml -tie");
	return true;
	*/
}
boolean buMax() { buMax(""); }

boolean bumMiniAdv(int adventures, location loc, string override) {
	betweenBattle();

	if (my_primestat() == $stat[Mysticality] && override == "")
		return bumMiniAdv(adventures, loc, "consultMyst");

	try {
		if (loc.nocombats) {
			for i from 1 to adventures {
				callBetweenBattleScript();
				if (override == "")
					adventure(1, loc);
				else
					adventure(1, loc, override);
			}
		} else
			if (override == "")
				adventure(1, loc);
			else
				adventure(1, loc, override);
		boolean success = true;
	} finally {
		return success;
	}
}
boolean bumMiniAdv(int adventures, location loc) { return bumMiniAdv(adventures, loc, ""); }

string bumRunCombat() {
	if (my_primestat() == $stat[Mysticality]) {
		print("BCC: This isn't actually adventuring at the noob cave. Don't worry. ", "purple");
		adv1($location[noob cave], -1, "consultMyst");
	}
	return to_string(run_combat());
}

boolean canMCD() {
	return ((in_muscle_sign() || in_mysticality_sign()) || (in_moxie_sign() && item_amount($item[bitchin' meatcar]) > 0));
}

boolean canZap() {
	int wandnum = 0;
	if (item_amount($item[dead mimic]) > 0) use(1, $item[dead mimic]);
	for wand from  1268 to 1272 {
		if (item_amount(to_item(wand)) > 0) {
			wandnum = wand;
		}
	}
	if (wandnum == 0) { return false; }
	return (!(contains_text(visit_url("wand.php?whichwand="+wandnum), "warm") || contains_text(visit_url("wand.php?whichwand="+wandnum), "careful")));
}

//Returns true if we've completed this stage of the script. 
boolean checkStage(string what, boolean setAsWell) {
	if (setAsWell) {
		print("BCC: We have completed the stage ["+what+"] and need to set it as so.", "navy");
		set_property("bcasc_stage_"+what, my_ascensions());
	}
	if (get_property("bcasc_stage_"+what) == my_ascensions()) {
		print("BCC: We have completed the stage ["+what+"].", "navy");
		return true;
	}
	print("BCC: We have not completed the stage ["+what+"].", "navy");
	return false;
}
boolean checkStage(string what) { return checkStage(what, false); }

int cloversAvailable(boolean makeOneTenLeafClover) {
	if (bcasc_cloverless) {
		if (item_amount($item[ten-leaf clover]) > 0) use(item_amount($item[ten-leaf clover]), $item[ten-leaf clover]);
		print("BCC: You have the option for a cloverless ascention turned on, so we won't be using them.", "purple");
		return 0;
	}
	
	if (get_property("bcasc_lastHermitCloverGet") != today_to_string()) {
		print("BCC: Getting Clovers", "purple");
		while (hermit(1, $item[Ten-leaf clover])) {}
		set_property("bcasc_lastHermitCloverGet", today_to_string());
	} else {
		//print("BCC: We've already got Clovers Today", "purple");
	}
	
	if (makeOneTenLeafClover && (item_amount($item[ten-leaf clover]) + item_amount($item[disassembled clover])) > 0) {
		print("BCC: We're going to end up with one and exactly one ten leaf clover", "purple");
		if (item_amount($item[ten-leaf clover]) > 0) {
			cli_execute("use * ten-leaf clover; use 1 disassembled clover;");
		} else {
			cli_execute("use 1 disassembled clover;");
		}
	}
	
	return item_amount($item[ten-leaf clover]) + item_amount($item[disassembled clover]);
}
int cloversAvailable() { return cloversAvailable(false); }

string consultMyst(int round, string opp, string text) {
	boolean [skill] allMySkills() {
		boolean [skill] allmyskills;
		
		foreach s in $skills[Spaghetti Spear, Ravioli Shurikens, Cannelloni Cannon, Stuffed Mortar Shell, Weapon of the Pastalord, Fearful Fettucini,
			Salsaball, Stream of Sauce, Saucestorm, Wave of Sauce, Saucegeyser, K&auml;seso&szlig;esturm, Surge of Icing] {
			if (have_skill(s)) { allmyskills[s] = true; }
		}
		return allmyskills;
	}
	
	//Returns the element of the cookbook we have on, if we have one. 
	element cookbook(boolean isPasta) {
		//These two work for all classes spells.
		if (equipped_amount($item[Gazpacho's Glacial Grimoire]) > 0) return $element[cold];
		if (equipped_amount($item[Codex of Capsaicin Conjuration]) > 0) return $element[hot];
		if (!isPasta) return $element[none];
		//Else the following three work for only pasta spells.
		if (equipped_amount($item[Cookbook of the Damned]) > 0) return $element[stench];
		if (equipped_amount($item[Necrotelicomnicon]) > 0) return $element[spooky];
		if (equipped_amount($item[Sinful Desires]) > 0) return $element[sleaze];
		return $element[none];
	}
	
	element elOfSpirit(effect e) {
		switch (e) {
			case $effect[Spirit of Cayenne]: return $element[hot]; break;
			case $effect[Spirit of Peppermint]: return $element[cold]; break;
			case $effect[Spirit of Garlic]: return $element[stench]; break;
			case $effect[Spirit of Wormwood]: return $element[spooky]; break;
			case $effect[Spirit of Bacon Grease]: return $element[sleaze]; break;
		}
		return $element[none];
	}
	
	//Checks if the monster we're fighting is weak against element e. For sauce spells, if called directly. 
	int isWeak(element e) {
		boolean [element] weakElements;
 
		switch (monster_element()) {
		   case $element[cold]:   weakElements = $elements[spooky, hot];    break;
		   case $element[spooky]: weakElements = $elements[hot, stench];    break;
		   case $element[hot]:    weakElements = $elements[stench, sleaze]; break;
		   case $element[stench]: weakElements = $elements[sleaze, cold];   break;
		   case $element[sleaze]: weakElements = $elements[cold, spooky];   break;
		   default: return 1;
		}
		
		if (weakElements contains e) {
			print("BCC: Weak Element to our pasta tuning.", "olive");
			return 2;
		} else if (monster_element() == e) {
			print("BCC: Strong Element to our pasta tuning.", "olive");
			return 0.01;
		} else {
			print("BCC: Neutral Element to our pasta tuning.", "olive");
			return 1;
		}
		return 1;
	}
	//Checks if the monster we're fighting is weak against the Flavor of Magic element. For pasta spells. 
	int isWeak() {
		foreach e in $effects[Spirit of Cayenne, Spirit of Peppermint, Spirit of Garlic, Spirit of Wormwood, Spirit of Bacon Grease] {
			if (have_effect(e) > 0) {
				print("BCC: We are under the effect of "+to_string(e), "olive");
				return isWeak(elOfSpirit(e));
			}
		}
		return 1;
	}
	//Checks if the monster is weak against whatever Sauce element would be appropriate. The actual string is ignored.
	int isWeak(string ignored) {
		if (have_skill($skill[Immaculate Seasoning])) {
			if ($elements[spooky, stench, sleaze, cold] contains monster_element()) return 2;
		}
		return isWeak($element[none]);
	}
	
	//Returns which skill has the lowest MP in a given range of skills. 
	skill lowestMP(boolean [skill] ss) {
		int lowestMPCostSoFar = 999999;
		skill skillToReturn = $skill[none];
		
		foreach s in ss {
			if (mp_cost(s) < lowestMPCostSoFar) {
				lowestMPCostSoFar = mp_cost(s);
				skillToReturn = s;
			}
		}
		return skillToReturn;
	}
	
	float wtfpwnageExpected(skill s) {
		float bAbs = numeric_modifier("Spell Damage");
		float bPer = numeric_modifier("Spell Damage Percent")/100 + 1;
		//Should multiply the bonuses below by bonus spell damage. 
		float bCol = numeric_modifier("Cold Spell Damage");
		float bHot = numeric_modifier("Hot Spell Damage");
		float bSte = numeric_modifier("Stench Spell Damage");
		float bSle = numeric_modifier("Sleaze Spell Damage");
		float bSpo = numeric_modifier("Spooky Spell Damage");
		float bElm = bCol+bHot+bSte+bSle+bSpo;
		float myst = my_buffedstat($stat[Mysticality]);
		print("BCC: These are the figures for "+to_string(s)+": Bonus: "+bAbs+" and "+bPer+"%//"+bCol+"/"+bHot+"/"+bSte+"/"+bSle+"/"+bSPo+"/El: "+bElm+"/Myst: "+myst, "purple");
		
		//Uses the above three functions to estimate the wtfpwnage from a given skill. 
		switch (s) {
			case $skill[Spaghetti Spear] :
				return (2.5*bPer + min(5, bAbs))*isWeak();
			break;
			case $skill[Ravioli Shurikens] :
				return (5.5*bPer + 0.07*myst*bPer + min(25, bAbs) + bElm)*isWeak();
			break;
			case $skill[Cannelloni Cannon] :
				return (12*bPer + 0.15*myst*bPer + min(40, bAbs) + bElm)*isWeak();
			break;
			case $skill[Stuffed Mortar Shell] :
				return (40*bPer + 0.35*myst*bPer + min(55, bAbs) + bElm)*isWeak();
			break;
			case $skill[Weapon of the Pastalord] :
				int weak = isWeak();
				if (weak == 2) weak = 1.5;
				return (48*bPer + 0.35*myst*bPer + bAbs + bElm)*weak;
			break;
			case $skill[Fearful Fettucini] :
				return (48*bPer + 0.35*myst*bPer + bAbs + bElm)*isWeak($element[spooky]);
			break;
			case $skill[Salsaball] :
				return (2.5*bPer + min(5, bAbs))*isWeak($element[hot]);
			break;
			case $skill[Stream of Sauce] :
				return (3.5*bPer + 0.10*myst*bPer + min(10, bAbs) + bElm)*isWeak("");
			break;
			case $skill[Saucestorm] :
				return (16*bPer + 0.20*myst*bPer + min(15, bAbs) + bElm)*isWeak("");
			break;
			case $skill[Wave of Sauce] :
				return (22*bPer + 0.30*myst*bPer + min(25, bAbs) + bElm)*isWeak("");
			break;
			case $skill[Saucegeyser] :
				return (40*bPer + 0.35*myst*bPer + min(10, bAbs) + bElm)*isWeak("");
			break;
			case $skill[K&auml;seso&szlig;esturm] :
				return (16*bPer + 0.20*myst*bPer + min(15, bAbs) + bElm)*isWeak($element[stench]);
			break;
			case $skill[Surge of Icing] :
				//Sugar Rush has an effect on this skill. 
				return (16*bPer + 0.20*myst*bPer + min(15, bAbs) + bElm);
			break;
			default:
				return 0;
			break;
		}
		return -1;
	}

	int hp = monster_hp();
	print("BCC: Monster HP is "+hp, "purple");
	int isWeak = isWeak();
	int wtfpwn;
	boolean [skill] oneShot;
	boolean [skill] twoShot;
	boolean [skill] threeShot;
	boolean [skill] fourShot;
	boolean oneShotHim = true;
	string cast;
	
	foreach s in allMySkills() {
		wtfpwn = wtfpwnageExpected(s);
		
		print("BCC: I expect "+wtfpwn+" damage from "+to_string(s), "purple");
		if (wtfpwn > hp) {
			//Then we can one-shot the monster with this skill.
			oneShot[s] = true;
		} else if (wtfpwn > hp/2) {
			twoShot[s] = true;
		} else if (wtfpwn > hp/3) {
			threeShot[s] = true;
		}else if (wtfpwn > hp/5) {
			fourShot[s] = true;
		}
	}
	
	//If we can one-shot AND noodles/twoshot isn't cheaper, do that. 
	if (count(oneShot) > 0) {
		if (have_skill($skill[Entangling Noodles])) {
			if (count(twoShot) > 0) {
				int mpOneShot = mp_cost(lowestMP(oneShot));
				int mpTwoShot = mp_cost(lowestMP(twoShot));
				if (mpOneShot > 3+2*mpTwoShot) {
					print("BCC: We're actually NOT going to one-shot because noodles and then two shotting would be cheaper.", "purple");
					oneShotHim = false;
				}
			}
		}
	}
	
	if (oneShotHim && count(oneShot) > 0) {
		cast = to_string(lowestMP(oneShot));
		print("BCC: We are going to one-shot with "+cast, "purple");
		return "skill "+cast;
	} else {
		//Basically, we should cast noodles if we haven't already done this, and we're not going to one-shot the monster. 
		if (contains_text(text, ">Entangling Noodles (")) {
			return "skill Entangling Noodles";
		}
		if (count(twoShot) > 0) {
			cast = to_string(lowestMP(twoShot));
			print("BCC: We are going to two-shot with "+cast, "purple");
			return "skill "+cast;
		}
		if (count(threeShot) > 0) {
			cast = to_string(lowestMP(threeShot));
			print("BCC: We are going to three-shot with "+cast, "purple");
			return "skill "+cast;
		}
		if (count(fourShot) > 0) {
			cast = to_string(lowestMP(fourShot));
			print("BCC: We are going to three-shot with "+cast, "purple");
			return "skill "+cast;
		}
	}
	abort("Please fight the remainder of the fight yourself. You will be seeing this because you do not have a spell powerful enough to even four-shot the monster. ");
	return "";
}

string consultBarrr(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	if (round == 1) {
		return "item the big book of pirate insults";
	}
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

string consultCyrus(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	if (round == 1) {
		if (bcasc_doWarAs == "frat") {
			if(item_amount(to_item("antique hand mirror")) == 0)
				return "item rock band flyers";
			else
				return "item rock band flyers;item antique hand mirror";
		} else {
			if(item_amount(to_item("antique hand mirror")) == 0)
				return "item jam band flyers";
			else
				return "item jam band flyers;item antique hand mirror";
		}
	}
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

//This consult script is just to be used to sling !potions against 
string consultDoD(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	foreach pot, eff in allBangPotions() {
		if (item_amount(pot) > 0) {
			if (eff == $effect[none]) return "item "+pot;
			print("BCC: We've identified "+pot+" already.", "purple");
		}
	}
	print("BCC: We've identified all the bang potions we have to hand.", "purple");
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

string consultGMOB(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	if (contains_text(text, "Guy Made Of Bees")) {
		print("BCC: We are fighting the GMOB!", "purple");
		if (bcasc_doWarAs == "frat") {
			return "item rock band flyers";
		} else {
			return "item jam band flyers";
		}
	}
	print("BCC: We are not fighting the GMOB!", "purple");
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

string consultHeBo(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	//If we're under the effect "Everything Looks Yellow", then ignore everything and attack.
	if (have_effect($effect[Everything Looks Yellow]) > 0) {
		print("BCC: We would LIKE to use a Yellow Ray somewhere in this zone, but we can't because Everything Looks Yellow.", "purple");
		return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
	}

	boolean isGremlin = contains_text(text, "A.M.C. gremlin") || contains_text(text, "batwinged gremlin") || contains_text(text, "erudite gremlin") || contains_text(text, "spider gremlin") || contains_text(text, "vegetable gremlin");
	
	//Let's check that the monster IS the correct one
	if (contains_text(text, "Harem Girl") || contains_text(text, "y hippy") || contains_text(text, "War Hippy") || contains_text(text, "Foot Dwarf") || contains_text(text, "bobrace.gif") || contains_text(text, "Frat Warrior") || contains_text(text, "War Pledge") || isGremlin) {
		if (my_familiar() == $familiar[He-Boulder]) {
			print("BCC: We are using the hebo against the right monster.", "purple");
			if (contains_text(text, "yellow eye")) {
				return "skill point at your opponent";
			} else {
				switch (my_class()) {
					case $class[turtle tamer] : return "skill toss"; break;
					case $class[seal clubber] : return "skill clobber"; break;
					case $class[Disco Bandit] : return "skill suckerpunch"; break;
					case $class[Accordion Thief] : return "skill sing"; break;
					default: abort("unsupported class"); break;
				}
			}
		} else if (item_amount($item[pumpkin bomb]) > 0) {
			print("BCC: We are trying to use the HeBoulder, but you don't have one (or perhaps are on a 100% run), so I'm using a pumpkin bomb.", "purple");
			return "item pumpkin bomb";
		} else {
			print("BCC: We are trying to use the HeBoulder, but you don't have one (nor a pumpkin bomb), so I'm attacking.", "purple");
			return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
		}
	}
	print("BCC: We are trying to use the HeBoulder, but this is not the right monster, so I'm attacking.", "purple");
	
	if (my_familiar() == $familiar[He-Boulder] && have_effect($effect[Everything Looks Red]) == 0 && contains_text(text, "red eye"))
		return "skill point at your opponent";
	
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

string consultJunkyard(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	boolean isRightMonster = false;
	
	//AMC Gremlins are useless. 
	if (opp == $monster[a.m.c. gremlin]) {
		if (item_amount($item[divine champagne popper]) > 0) return "item divine champagne popper";
		return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
	} else {
		//Check to see if the monster CAN carry the item we want. This comes straight from Zarqon's SmartStasis.ash. 
		if (my_location() == to_location(get_property("currentJunkyardLocation"))) {
			print("BCC: Right location.", "purple");
			isRightMonster = (item_drops() contains to_item(get_property("currentJunkyardTool")));
		} else {
			print("BCC: Wrong location.", "purple");
			isRightMonster = (!(item_drops() contains to_item(get_property("currentJunkyardTool"))));
		}
	}
	
	if (isRightMonster) {
		print("BCC: We have found the correct monster, so will stasis until the item drop occurrs.", "purple");
		if (contains_text(text, "It whips out a hammer") || contains_text(text, "He whips out a crescent") || contains_text(text, "It whips out a pair") || contains_text(text, "It whips out a screwdriver")) {
			print("BCC: The script is trying to use the moly magnet. This may be the cause of the NULL errors here.", "purple");
			return "item molybdenum magnet";
		} else {
			if (my_hp() < 100) {
				return "skill lasagna bandages";
			} else {
				switch (my_class()) {
					case $class[turtle tamer] : return "skill toss"; break;
					case $class[seal clubber] : return "skill clobber"; break;
					case $class[Pastamancer] : return "skill Spaghetti Spear"; break;
					case $class[Sauceror] : return "skill Salsaball"; break;
					case $class[Disco Bandit] : return "skill suckerpunch"; break;
					case $class[Accordion Thief] : return "skill sing"; break;
				}
			}
		}
	} else {
		print("BCC: This is the wrong monster.", "purple");
	}
	return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round)); 
}

string consultRunaway(int round, string opp, string text) {
	if (!isExpectedMonster(opp)) return ((my_primestat() == $stat[Mysticality]) ? consultMyst(round, opp, text) : get_ccs_action(round));
	if (round == 1 && have_skill($skill[Entangling Noodles])) { return "skill entangling noodles"; }
	return "try to run away";
}

void defaultMood(boolean castMojo) {
	cli_execute("mood bumcheekascend; mood clear");
	switch (my_primestat()) {
		case $stat[Muscle] :
			if (my_level() > 5) { cli_execute("trigger lose_effect, Tiger!, use 5 Ben-Gal Balm"); }
			if (my_level() < 7 && castMojo && have_skill($skill[The Magical Mojomuscular Melody])) cli_execute("trigger lose_effect, The Magical Mojomuscular Melody, cast 1 The Magical Mojomuscular Melody");
			if (anHero()) {
				if (have_skill($skill[The Power Ballad of the Arrowsmith])) cli_execute("trigger lose_effect, Power Ballad of the Arrowsmith, cast 1 The Power Ballad of the Arrowsmith");
			} else {
				if (have_skill($skill[The Moxious Madrigal])) cli_execute("trigger lose_effect, The Moxious Madrigal, cast 1 The Moxious Madrigal");
			}
			if (have_skill($skill[Patience of the Tortoise])) cli_execute("trigger lose_effect, Patience of the Tortoise, cast 1 Patience of the Tortoise");
			if (have_skill($skill[Seal Clubbing Frenzy])) cli_execute("trigger lose_effect, Seal Clubbing Frenzy, cast 1 Seal Clubbing Frenzy");
			if (my_level() > 9 && have_skill($skill[Rage of the Reindeer])) cli_execute("trigger lose_effect, Rage of the Reindeer, cast 1 Rage of the Reindeer");
		break;
		
		case $stat[Mysticality] :
			if (my_level() > 5) { cli_execute("trigger lose_effect, Butt-Rock Hair, use 5 hair spray"); }
			if (my_level() > 5) { cli_execute("trigger lose_effect, Glittering Eyelashes, use 5 glittery mascara"); }
			if (my_level() < 7 && castMojo && have_skill($skill[The Moxious Madrigal])) cli_execute("trigger lose_effect, The Moxious Madrigal, cast 1 The Moxious Madrigal");
			if (my_level() < 7  && have_skill($skill[Springy Fusilli])) cli_execute("trigger lose_effect, Springy Fusilli, cast 1 Springy Fusilli");
			if (have_skill($skill[The Magical Mojomuscular Melody])) cli_execute("trigger lose_effect, The Magical Mojomuscular Melody, cast 1 The Magical Mojomuscular Melody");
			if (have_skill($skill[Moxie of the Mariachi])) cli_execute("trigger lose_effect, Mariachi Mood, cast 1 Moxie of the Mariachi");
			if (have_skill($skill[Disco Aerobics])) cli_execute("trigger lose_effect, Disco State of Mind, cast 1 Disco Aerobics");
		break;
		
		case $stat[Moxie] :
			if (my_level() > 5) { cli_execute("trigger lose_effect, Butt-Rock Hair, use 5 hair spray"); }
			if (have_skill($skill[The Moxious Madrigal])) cli_execute("trigger lose_effect, The Moxious Madrigal, cast 1 The Moxious Madrigal");
			if (my_level() < 7 && castMojo && have_skill($skill[The Magical Mojomuscular Melody])) cli_execute("trigger lose_effect, The Magical Mojomuscular Melody, cast 1 The Magical Mojomuscular Melody");
			if (have_skill($skill[Moxie of the Mariachi])) cli_execute("trigger lose_effect, Mariachi Mood, cast 1 Moxie of the Mariachi");
			if (have_skill($skill[Disco Aerobics])) cli_execute("trigger lose_effect, Disco State of Mind, cast 1 Disco Aerobics");
		break;
	}
}
void defaultMood() { defaultMood(true); }

//Returns true if we have the elite guard outfit. 
boolean haveElite() {
	if (get_property("lastDispensaryOpen") != my_ascensions()) return false;
	int a,b,c;
	if (i_a("Knob Goblin elite helm") > 0) { a = 1; }
	if (i_a("Knob Goblin elite polearm") > 0) { b = 1; }
	if (i_a("Knob Goblin elite pants") > 0) { c = 1; }
	return (a+b+c==3)&&(i_a("Cobb's Knob lab key")>0);
}

//identifyBangPotions will be true if we've identified them all out of {blessing, detection, acuity, strength, teleport}, false if there are still some left to identify. 
boolean identifyBangPotions() {
	//Returns the number of the 5 important potions we've found. 
	int numPotionsFound() {
		int i = 0;
		foreach pot, eff in allBangPotions() {
			switch (eff) {
				case $effect[Izchak's Blessing] :
				case $effect[Object Detection] :
				case $effect[Strange Mental Acuity] :
				case $effect[Strength of Ten Ettins] :
				case $effect[Teleportitis] :
					i = i + 1;
				break;
			}
		}
		return i;
	}
	
	//Returns true if there are some unknown potions that we should find out about by throwing them against monsters. (i.e. we HAVE them)
	boolean somePotionsUnknown() {
		foreach pot, eff in allBangPotions() {
			if (eff == $effect[none] && item_amount(pot) > 0) return true;
		}
		return false;
	}
	
	while (numPotionsFound() < 5 && somePotionsUnknown()) {
		bumMiniAdv(1, $location[Hole in the Sky], "consultDoD");
	}
	
	print("BCC: We have found "+numPotionsFound()+"/5 important DoD potions", "purple");
	return (numPotionsFound() >= 5);
}

boolean load_current_map(string fname, lairItem[int] map) {
	string domain = "http://bumcheekcity.com/kol/maps/";
	string curr = visit_url("http://bumcheekcity.com/kol/maps/index.php?name="+fname);
	file_to_map(fname+".txt", map);
	
	//If the map is empty or the file doesn't need updating
	if ((count(map) == 0) || (curr != "" && get_property(fname+".txt") != curr)) {
		print("Updating "+fname+".txt from '"+get_property(fname+".txt")+"' to '"+curr+"'...");
		
		if (!file_to_map(domain + fname + ".txt", map) || count(map) == 0) return false;
		
		map_to_file(map, fname+".txt");
		set_property(fname+".txt", curr);
		print("..."+fname+".txt updated.");
	}
	
	return true;
}

boolean load_current_map(string fname, string[int] map) {
	string domain = "http://bumcheekcity.com/kol/maps/";
	string curr = visit_url("http://bumcheekcity.com/kol/maps/index.php?name="+fname+"&username="+my_name());
	file_to_map(fname+".txt", map);
	
	//If the map is empty or the file doesn't need updating
	if ((count(map) == 0) || (curr != "" && get_property(fname+".txt") != curr)) {
		print("Updating "+fname+".txt from '"+get_property(fname+".txt")+"' to '"+curr+"'...");
		
		if (!file_to_map(domain + fname + ".txt", map) || count(map) == 0) return false;
		
		map_to_file(map, fname+".txt");
		set_property(fname+".txt", curr);
		print("..."+fname+".txt updated.");
	}
	
	return true;
}

int numPirateInsults() {
	int t = 0, i = 1;
	while (i <= 8) {
		if (get_property("lastPirateInsult"+i) == "true") {
			t = t + 1;
		}
		i = i + 1;
	}
	return t;
}

int numOfWand() {
	if (item_amount($item[dead mimic]) > 0) use(1, $item[dead mimic]);
	for wandcount from  1268 to 1272 {
		if (item_amount(to_item(wandcount)) > 0) {
			return wandcount;
		}
	}
	return 0;
}

int numUniqueKeys() {
	int keyb, keyj, keys;
	if (i_a("boris's key") > 0) { keyb = 1; }
	if (i_a("jarlsberg's key") > 0) { keyj = 1; }
	if (i_a("sneaky pete's key") > 0) { keys = 1; }
	return keyb+keyj+keys;
}

string runChoice( string page_text )
{
	while( contains_text( page_text , "choice.php" ) ) {
		## Get choice adventure number
		int begin_choice_adv_num = ( index_of( page_text , "whichchoice value=" ) + 18 );
		int end_choice_adv_num = index_of( page_text , "><input" , begin_choice_adv_num );
		string choice_adv_num = substring( page_text , begin_choice_adv_num , end_choice_adv_num );
		
		string choice_adv_prop = "choiceAdventure" + choice_adv_num;
		string choice_num = get_property( choice_adv_prop );
		
		if( choice_num == "" ) abort( "Unsupported Choice Adventure!" );
		
		string url = "choice.php?pwd&whichchoice=" + choice_adv_num + "&option=" + choice_num;
		page_text = visit_url( url );
	}
	return page_text;
}

void sellJunk() {
	foreach i in $items[meat stack, dense meat stack, meat paste, magicalness-in-a-can, moxie weed, strongness elixir] {
		if (item_amount(i) > 0) autosell(item_amount(i), i);
	}
}

//Returns the safe Moxie for given location, by going through all the monsters in it.
int safeMox(location loc) {
	if (loc == $location[primordial soup]) return 0;
	int ret = 0;
	
	//Find the hardest monster. 
	foreach mob, freq in appearance_rates(loc) {
		if (freq >= 0 && mob != $monster[Guy Made of Bees]) ret = max(ret, monster_attack(mob));
	}
	//Note that monster_attack() takes into account ML. So just add something to account for this.
	return ret + 4;
}

//Changes the familiar based on a string representation of what we want. 
boolean setFamiliar(string famtype) {
	//The very first thing is to check 100% familiars
	if(bcasc_100familiar != "") {
		print("BCC: Your familiar is set to a 100% "+bcasc_100familiar, "purple");
		cli_execute("familiar "+bcasc_100familiar);
		return true;
	}
	
	if (famtype == "nothing") {
		bumFamiliar($familiar[none]);
		return true;
	}
	
	//Then a quick check for if we have Everything Looks Yellow
	if (have_effect($effect[Everything Looks Yellow]) > 0 && famtype == "hebo") { famtype = "items"; }
	
	//THEN a quick check for a spanglerack
	if (i_a("spangly sombrero") > 0 && have_familiar($familiar[Mad Hatrack]) && (contains_text(famtype, "item") || contains_text(famtype, "equipment"))) {
		print("BCC: We are going to be using a spanglerack for items. Yay Items!", "purple");
		
		bumFamiliar($familiar[Mad Hatrack]);
		if (equipped_item($slot[familiar]) != $item[spangly sombrero]) equip($slot[familiar], $item[spangly sombrero]);
		if (equipped_item($slot[familiar]) == $item[spangly sombrero]) return true;
		print("BCC: There seemed to be a problem and you don't have a spangly sombrero equipped. I'll use a 'normal' item drop familiar.", "purple");
	}
	
	//Finally, actually start getting familiars.
	if (famtype != "") {
		string [int] famlist;
		load_current_map("bcs_fam_"+famtype, famlist);
		foreach x in famlist {
			//print("Checking for familiar '"+famlist[x]+"' where x="+x, "purple");
			if (have_familiar(famlist[x].to_familiar())) {
				bumFamiliar(famlist[x].to_familiar());
				return true;
			}
		}
	}

	print("BCC: Switching Familiar for General Use", "aqua");
	int maxspleen = 12;
	if (have_skill($skill[Spleen of Steel])) maxspleen = 20;
	
	if (have_familiar($familiar[Rogue Program]) || have_familiar($familiar[Baby Sandworm])) {
		//Before we do anything, let's check if there's any spleen to do. May as well do this as we go along.
		if (my_spleen_use() <= maxspleen-4 && my_level() >= 4) {
			print("BCC: Going to try to use some spleen items if you have them.", "purple");
			
			while (my_spleen_use()  <= maxspleen-4 && item_amount($item[agua de vida]) > 0) {
				use(1, $item[agua de vida]);
			}
			
			visit_url("town_wrong.php");
			while (my_spleen_use()  <= maxspleen-4 && (available_amount($item[coffee pixie stick]) > 0 || item_amount($item[Game Grid token]) > 0)) {
				if (available_amount($item[coffee pixie stick]) == 0) {
					visit_url("arcade.php?action=skeeball&pwd="+my_hash());
				}
				use (1, $item[coffee pixie stick]);
			}
		}
		
		//If they have these, then check for spleen items that we have. 
		if (my_spleen_use() + (i_a("agua de vida") + i_a("coffee pixie stick") + i_a("Game Grid token") + i_a("Game Grid ticket")/10) * 4 < maxspleen + 4) {
			print("Spleen: "+my_spleen_use()+" Agua: "+i_a("agua de vida")+" Stick: "+i_a("coffee pixie stick")+" Token: "+i_a("Game Grid token"), "purple");
			print("Total Spleen: "+(my_spleen_use() + (i_a("agua de vida") + i_a("coffee pixie stick") + i_a("Game Grid token")) * 4), "purple");
			
			//Then we have space for some spleen items.
			if (have_familiar($familiar[Rogue Program]) && have_familiar($familiar[Baby Sandworm])) {
				//Alternate spleen familiars, starting with the rogue.
				int agua = get_property("_aguaDrops").to_int();
				int token = get_property("_tokenDrops").to_int();
				if (agua + 1 <= token)
					bumFamiliar($familiar[Baby Sandworm]);
				else
					bumFamiliar($familiar[Rogue Program]);
				return true;
			} else if (have_familiar($familiar[Rogue Program])) {
				bumFamiliar($familiar[Rogue Program]);
				return true;
			} else {
				bumFamiliar($familiar[Baby Sandworm]);
				return true;
			}
		}
	}
	
	//If we set a familiar as default, use it. 
	if (get_property("bcasc_defaultFamiliar") != "") {
		print("BCC: Setting the default familiar to your choice of '"+get_property("bcasc_defaultFamiliar")+"'.", "purple");
		return bumFamiliar(to_familiar(get_property("bcasc_defaultFamiliar")));
	}
	
	//Now either we have neither of the above, or we have enough spleen today.
	if (have_familiar($familiar[Frumious Bandersnatch])) {
		bumFamiliar($familiar[Frumious Bandersnatch]);
		return true;
	} else {
		bumFamiliar($familiar[Blood-Faced Volleyball]);
		return true;
	}
}

boolean setMCD(int moxie, int sMox) {
	//Can't be bothered to deal with this for other classes. 
	//if (!(my_primestat() == $stat[Moxie])) return false;
	
	
	if (canMCD()) {
		print("BCC: We CAN set the MCD.", "purple");
		//We do. Check maxMCD value
		int maxmcd = 10 + to_int(in_mysticality_sign());
		int mcdval = my_buffedstat(my_primestat()) - sMox;
		
		if (mcdval > maxmcd) {
			mcdval = maxmcd;
		}
		cli_execute("mcd "+mcdval);
		return true;
	}
	return false;
}

//Thanks, Riff!
string tryBeerPong() {
	string page = bumAdvUrl("adventure.php?snarfblat=157");
	
	if (contains_text(page, "Combat")) {
		//The way I use this, we shouldn't ever have a combat with this script, but there's no harm in a check for a combat. 
		if ((numPirateInsults() < 8) && (contains_text(page, "Pirate"))) throw_item($item[The Big Book of Pirate Insults]);
		while(!page.contains_text("You win the fight!")) page = bumRunCombat();
	} else if (contains_text(page, "Arrr You Man Enough?")) {
		int totalInsults = numPirateInsults();
		if (totalInsults > 6) {
			print("You have learned " + to_string(totalInsults) + "/8 pirate insults.", "blue");
			page = beerPong( visit_url( "choice.php?pwd&whichchoice=187&option=1" ) );
		} else {
			print("You have learned " + to_string(totalInsults) + "/8 pirate insults.", "blue");
			print("Arrr You Man Enough?", "red");
			page = visit_url( "choice.php?pwd&whichchoice=187&option=2" );
		}
	} else if (contains_text(page, "Arrr You Man Enough?")) {
		//Doesn't this do just the same as above? Riff has it like this, so I'll leave it like this for the moment. 
		page = beerPong(page);
	} else {
		page = runChoice(page);
	}

	return page;
}

boolean willMood() {
	return (haveElite() || my_meat() > 5000 || my_mp() > 100);
}

void zapKeys() {
	if (canZap()) {
		if (i_a("boris's ring") + i_a("jarlsberg's earring") + i_a("sneaky pete's breath spray") > 0 ) {
			print("BCC: Your wand is safe, so I'm going to try to zap something");
			if (i_a("boris's ring") > 0) { cli_execute("zap boris's ring"); 
			} else if (i_a("jarlsberg's earring") > 0) { cli_execute("zap jarlsberg's earring"); 
			} else if (i_a("sneaky pete's breath spray") > 0) { cli_execute("zap sneaky pete's breath spray"); 
			} else if (i_a("boris's key") > 1) { cli_execute("zap boris's key");  
			} else if (i_a("jarlsberg's key") > 1) { cli_execute("zap jarlsberg's key");  
			} else if (i_a("sneaky pete's key") > 1) { cli_execute("zap sneaky pete's key"); 
			}
		}
	} else {
		print("BCC: You don't have a wand. No Zapping for you.", "purple");
	}
}

/***********************************************
* BEGIN FUNCTIONS THAT RELY ON OTHER FUNCTIONS *
***********************************************/

boolean bumAdvClover(int snarfblat) {
	if (i_a($item[ten-leaf clover]) == 0) {
		if (cloversAvailable(true) == 0)
			return false;
	}

	int clovers = i_a($item[ten-leaf clover]);
	if (clovers == 0)
		return false;

	//Adventure.php can get interrupted by wandering monsters, so
	//retry until we get the clover adventure.
	while (i_a($item[ten-leaf clover]) == clovers) {
		bumAdvUrl("adventure.php?snarfblat=" + snarfblat + "&confirm=on");
		run_combat();
	}
	return true;
}

void setMood(string combat) {
	defaultMood(combat == "");
	if (contains_text(combat,"+")) {
		if (my_level() >= 9 || willMood()) {
			print("BCC: Need moar combat! WAAARGH!", "purple");
			if (have_skill($skill[Musk of the Moose])) cli_execute("trigger lose_effect, Musk of the Moose, cast 1 Musk of the Moose");
			if (have_skill($skill[Carlweather's Cantata of Confrontation])) cli_execute("trigger lose_effect, Carlweather's Cantata of Confrontation, cast 1 Carlweather's Cantata of Confrontation");
			cli_execute("trigger gain_effect, The Sonata of Sneakiness, uneffect sonata of sneakiness");
		}
	} 
	if (contains_text(combat,"-")) {
		if (my_level() >= 9 || willMood()) {
			print("BCC: Need less combat, brave Sir Robin!", "purple");
			if (have_skill($skill[Smooth Movement])) cli_execute("trigger lose_effect, Smooth Movements, cast 1 smooth movement");
			if (have_skill($skill[The Sonata of Sneakiness])) cli_execute("trigger lose_effect, The Sonata of Sneakiness, cast 1 sonata of sneakiness");
			cli_execute("trigger gain_effect, Carlweather's Cantata of Confrontation, uneffect Carlweather's Cantata of Confrontation");
		}
	}
	if (contains_text(combat,"i")) {
		if (my_level() >= 9 || willMood()) {
			print("BCC: Need items!", "purple");
			if (have_skill($skill[Fat Leon's Phat Loot Lyric])) cli_execute("trigger lose_effect, Fat Leon's Phat Loot Lyric, cast 1 Fat Leon's Phat Loot Lyric");
			if (have_skill($skill[Leash of Linguini])) cli_execute("trigger lose_effect, Leash of Linguini, cast 1 Leash of Linguini");
			//if (haveElite() && my_meat() > 3000) cli_execute("trigger lose_effect, Peeled Eyeballs, use 1 Knob Goblin eyedrops");
		}
	}
	if (contains_text(combat,"s") && !have_skill($skill[Diminished Gag Reflex])) {
		if (have_skill($skill[Astral Shell])) {
			while (i_a("turtle totem") == 0) use(1, $item[chewing gum on a string]);
			cli_execute("trigger lose_effect, Astral Shell, cast 1 astral shell");
		} else if (have_skill($skill[Elemental Saucesphere])) {
			while (i_a("saucepan") == 0) use(1, $item[chewing gum on a string]);
			cli_execute("trigger lose_effect, Elemental Saucesphere, cast 1 elemental saucesphere");
		}
	}
}

boolean levelMeInnerLoop(int sMox);
boolean levelMe(int sMox, boolean needBaseStat) {
	print("BCC: levelMe("+sMox+", "+to_string(needBaseStat)+") called.", "fuchsia");
	if (have_effect($effect[Beaten Up]) > 0) {
		cli_execute("uneffect beaten up");
	}
	if (have_effect($effect[Beaten Up]) > 0) { abort("Please cure beaten up"); }
	
	if (needBaseStat) {
		if (my_basestat(my_primestat()) >= sMox) return true;
		print("Need to Level up a bit to get at least "+sMox+" base Primestat", "fuchsia");
	} else {		
		//buMax();
		setMood("");
		cli_execute("mood execute");

		int extraMoxieNeeded = sMox - my_buffedstat(my_primestat());
		if (extraMoxieNeeded <= 0) return true;
		print("Need to Level up a bit to get at least "+sMox+" buffed Primestat. This means getting "+extraMoxieNeeded+" Primestat.", "fuchsia");
		sMox = my_basestat(my_primestat()) + extraMoxieNeeded;
		
		if (my_primestat() == $stat[Mysticality]) {
			//Don't level for buffed stat AT ALL above level 10
			if (my_level() >= 10) {
				print("BCC: But, we're a myst class and at or over level 10, so we won't bother with buffed stats.", "fuchsia");
				return true;
			}
			
			//Because of the lack of need of +mainstat, we'll only care if we need 20 or more. 
			extraMoxieNeeded = extraMoxieNeeded - 20;
			print("BCC: But, we're a myst class, so we don't really mind about safe moxie that much. We'll only try to get "+sMox+" instead.", "fuchsia");
			if (extraMoxieNeeded <= 0) return true;
		}
	}

	string command = get_property("bcasc_preLevelMe");
	if (command != "") {
		cli_execute(command + " " + sMox + " " + needBaseStat);
		if (my_basestat(my_primestat()) >= sMox)
			return true;
	}

	// Adventuring can abort sometimes, so recheck if conditions were met.
	while (my_basestat(my_primestat()) < sMox) {
		levelMeInnerLoop(sMox);
	}
}

boolean levelMeInnerLoop(int sMox) {
	cli_execute("goal clear; goal set "+sMox+" "+to_string(my_primestat()));

	switch (my_primestat()) {
		case $stat[Muscle] :
			if (my_buffedstat($stat[Muscle]) < 120) {
				//If we're not level 2, then woods.php DEFINITELY won't be available. 
				print("I need "+sMox+" base muscle (going to Temple)", "fuchsia");
				if (my_level() >= 2) {
					//Check for temple.gif, or we're not getting in. 
					if (contains_text(visit_url("woods.php"), "temple.gif")) {
						if (get_property("bcasc_dontLevelInTemple") == "true") abort("You don't want to level in the temple.");
						setFamiliar("hipster");
						bumMiniAdv(my_adventures(), $location[Hidden Temple]);
					} else {
						bumMiniAdv(my_adventures(), $location[Haunted Pantry]);
					}
				}
			} else {
				setMood("-");
				setFamiliar("");
				print("I need "+sMox+" base muscle (going to Gallery)", "fuchsia");
				
				//Get as many clovers as possible. The !capture is so that it doesn't abort on failure. 
				print("BCC: Attempting to get clovers to level with.", "purple");
				cloversAvailable();
				
				//If we're above level 11, then use clovers as necessary. 
				if (my_level() >= 10) {
					if (cloversAvailable() > 1) {
						print("BCC: Going to use clovers to level.", "purple");
						//First, just quickly use all ten-leaf clovers we have. 
						if (item_amount($item[ten-leaf clover]) > 0) {
							cli_execute("use * ten-leaf clover");
						}
					
						while (my_basestat($stat[Muscle]) < sMox && item_amount($item[disassembled clover]) > 1) {
							print("BCC: We have "+item_amount($item[disassembled clover])+" clovers and are using one to level.", "purple");
							use(1, $item[disassembled clover]);
							bumAdvClover(106);
						}
					}
				}
			
				bumMiniAdv(my_adventures(), $location[Haunted Gallery]);
			}
		break;
		
		case $stat[Mysticality] :
			if (my_buffedstat($stat[Mysticality]) < 80) {
				//If we're not level 2, then woods.php DEFINITELY won't be available. 
				print("I need "+sMox+" base Mysticality (going to Temple)", "fuchsia");
				if (my_level() >= 2) {
					//Check for temple.gif, or we're not getting in. 
					if (contains_text(visit_url("woods.php"), "temple.gif")) {
						if (get_property("bcasc_dontLevelInTemple") == "true") abort("You don't want to level in the temple.");
						setFamiliar("hipster");
						adventure(my_adventures(), $location[Hidden Temple]);
					} else {
						adventure(my_adventures(), $location[Haunted Pantry], "consultMyst");
					}
				}
			} else {
				setMood("-");
				setFamiliar("");
				print("I need "+sMox+" base Mysticality (going to Bathroom)", "fuchsia");
				
				//Get as many clovers as possible. The !capture is so that it doesn't abort on failure. 
				print("BCC: Attempting to get clovers to level with.", "purple");
				cloversAvailable();
				
				//If we're above level 11, then use clovers as necessary. 
				if (my_level() >= 10) {
					set_property("choiceAdventure105","1");
					if (cloversAvailable() > 1) {
						print("BCC: Going to use clovers to level.", "purple");
						//First, just quickly use all ten-leaf clovers we have. 
						if (item_amount($item[ten-leaf clover]) > 0) {
							cli_execute("use * ten-leaf clover");
						}
					
						while (my_basestat($stat[Mysticality]) < sMox && item_amount($item[disassembled clover]) > 1) {
							print("BCC: We have "+item_amount($item[disassembled clover])+" clovers and are using one to level.", "purple");
							use(1, $item[disassembled clover]);
							visit_url("adventure.php?snarfblat=107&confirm=on");
						}
					}
				}
			
				bumMiniAdv(my_adventures(), $location[Haunted Bathroom]);
			}
		break;
		
		case $stat[Moxie] :
			if (my_buffedstat($stat[Moxie]) < 90) {
				//If we're not level 2, then woods.php DEFINITELY won't be available. 
				if (my_level() >= 2) {
					//Check for temple.gif, or we're not getting in. 
					if (contains_text(visit_url("woods.php"), "temple.gif")) {
						if (get_property("bcasc_dontLevelInTemple") == "true") abort("You don't want to level in the temple.");
						setFamiliar("hipster");
						bumMiniAdv(my_adventures(), $location[Hidden Temple]);
					} else {
						bumMiniAdv(my_adventures(), $location[Haunted Pantry]);
					}
				}
			} else if (my_buffedstat($stat[Moxie]) < 120) {
				setMood("-i");
				setFamiliar("");
				//There's pretty much zero chance we'll get here without the swashbuckling kit, so we'll be OK.
				buMax("+outfit swash");
				bumMiniAdv(my_adventures(), $location[Barrrney's Barrr]);
			} else {
				setMood("-i");
				setFamiliar("itemsnc");
				print("I need "+sMox+" base moxie", "fuchsia");
				
				//Get as many clovers as possible. The !capture is so that it doesn't abort on failure. 
				print("BCC: Attempting to get clovers to level with.", "purple");
				cloversAvailable();
				
				//If we're above level 11, then use clovers as necessary. 
				if (my_level() >= 10) {
					if (my_adventures() == 0) abort("No Adventures to level :(");
					if (cloversAvailable() > 1) {
						print("BCC: Going to use clovers to level.", "purple");
						//First, just quickly use all ten-leaf clovers we have. 
						if (item_amount($item[ten-leaf clover]) > 0) {
							cli_execute("use * ten-leaf clover");
						}
					
						while (my_basestat($stat[Moxie]) < sMox && item_amount($item[disassembled clover]) > 1) {
							if (my_adventures() == 0) abort("No Adventures to level :(");
							print("BCC: We have "+item_amount($item[disassembled clover])+" clovers and are using one to level.", "purple");
							use(1, $item[disassembled clover]);
							bumAdvClover(109);
						}
					}
				}
			
				cli_execute("goal clear");
				setFamiliar("itemsnc");
				while (my_basestat($stat[Moxie]) < sMox) {
					if (my_adventures() == 0) abort("No Adventures to level :(");
					if ((my_buffedstat($stat[Moxie]) < 130) && canMCD()) cli_execute("mcd 0");
					if (item_amount($item[dance card]) > 0) {
						use(1, $item[dance card]);
						bumMiniAdv(4, $location[Haunted Ballroom]);
					} else {
						bumMiniAdv(1, $location[Haunted Ballroom]);
					}
				}
			}
		break;
	}
}
boolean levelMe(int sMox) { levelMe(sMox, false); }

boolean bumAdv(location loc, string maxme, string famtype, string goals, string printme, string combat, string consultScript) {
	int sMox = safeMox(loc);
	buMax(maxme);
	
	sellJunk();
	setFamiliar(famtype);
	
	//Do we have a HeBo, and are we blocked from using it by a 100% run? Have to do this first, because we re-set the goals below.
	if ((consultScript == "consultHeBo") && (my_familiar() != $familiar[He-Boulder]) && have_effect($effect[Everything Looks Yellow]) == 0) {
		print("BCC: We don't have the HeBo equipped, so we're either on a 100% run or you just don't have one. Trying a pumpkin bomb. If you have one, we'll use it.", "purple");
		//Hit the pumpkin patch
		visit_url("campground.php?action=garden&pwd="+my_hash());
		
		//Have a quick check for a KGF first. 
		if (i_a("pumpkin") > 0 && i_a("knob goblin firecracker") == 0) {
			cli_execute("conditions clear; conditions set 1 knob goblin firecracker");
			adventure(my_adventures(), $location[Outskirts of the Knob]);
		}
		
		if (((i_a("pumpkin") > 0 && i_a("knob goblin firecracker") > 0)) || i_a("pumpkin bomb") > 0) {
			if (i_a("pumpkin bomb") == 0) { cli_execute("make pumpkin bomb"); }
		}
		//That's it. It's just about getting a pumpkin bomb in your inventory. Nothing else.
	}

	//We initially set the MCD to 0 just in case we had it turned on before. 
	if (my_adventures() == 0) { abort("No Adventures. How Sad."); }
	if (canMCD()) cli_execute("mcd 0");
	cli_execute("goal clear");
	if (length(goals) > 0) {
		cli_execute("goal set "+goals);
		//print("BCC: Setting goals of '"+goals+"'...", "lime");
	}
	
	if (length(printme) > 0) {
		print("BCC: "+printme, "purple");
	}
	
	cli_execute("trigger clear");
	setMood(combat);

	cli_execute("mood execute");
	
	if (my_buffedstat(my_primestat()) < sMox && loc != $location[Haunted Bedroom])	{
		//Do something to get more moxie.
		print("Need to Level up a bit to get "+sMox+" Mainstat", "fuschia");
		levelMe(sMox);
	}
	cli_execute("mood execute");
	
	//Finally, check for and use the MCD if we can. No need to do this in 
	if (my_buffedstat(my_primestat()) > sMox) {
		print("BCC: We should set the MCD if we can.", "purple");
		//Check if we have access to the MCD
		setMCD(my_buffedstat(my_primestat()), sMox);
	}
	//Force to 0 in Junkyard
	if (loc == $location[Next to that Barrel with Something Burning in it] || loc == $location[Near an Abandoned Refrigerator] || loc == $location[Over Where the Old Tires Are] || loc == $location[Out By that Rusted-Out Car]) {
		print("BCC: We're adventuring in the Junkyard. Let's turn the MCD down...", "purple");
		if (canMCD()) cli_execute("mcd 0");
	}
	//Force to correct MCD levels in Boss Bat, Knob King
	int b, k;
	switch (my_primestat()) {
		case $stat[muscle]: b = 8; k = 0; break;
		case $stat[mysticality]: b = 4; k = 3; break;
		case $stat[moxie]: b = 4; k = 7; break;
	}
	if (canMCD() && loc == $location[Boss Bat's Lair]) { cli_execute("mcd "+b); }
	if (canMCD() && loc == $location[Throne Room]) { cli_execute("mcd "+k); }

	if (loc.nocombats)
		callBetweenBattleScript();

	//Because between battle scripts aren't called reliably, adventure one adventure at a time in a non-combat zone.
	int numAdv = loc.nocombats ? 1 : my_adventures();
	if (consultScript != "") {
		if (adventure(my_adventures(), loc, consultScript)) {}
	} else if (my_primestat() == $stat[Mysticality]) {
		if (adventure(my_adventures(), loc, "consultMyst")) {}
	} else {
		if (adventure(numAdv, loc)) {}
	}

	return true;
}
boolean bumAdv(location loc, string maxme, string famtype, string goals, string printme, string combat) { bumAdv(loc, maxme, famtype, goals, printme, combat, ""); }
boolean bumAdv(location loc, string maxme, string famtype, string goals, string printme) { bumAdv(loc, maxme, famtype, goals, printme, ""); }
boolean bumAdv(location loc, string maxme, string famtype, string goals) { bumAdv(loc, maxme, famtype, goals, ""); }
boolean bumAdv(location loc, string maxme, string famtype) { bumAdv(loc, maxme, famtype, "", ""); }
boolean bumAdv(location loc, string maxme) { bumAdv(loc, maxme, "", "", ""); }
boolean bumAdv(location loc)               { bumAdv(loc, "", "", "", ""); }

boolean bumUse(int n, item i) {
	if (n > item_amount(i)) n = item_amount(i);
	if (n > 0) use(n, i);
}

/**********************************
* START THE ADVENTURING FUNCTIONS *
**********************************/

boolean bcasc8Bit() {
	if (checkStage("8bit")) return true;
	if (i_a("digital key") > 0) { 	
		checkStage("8bit", true);
		return true;
	}
	
	//Crude check for a one-handed weapon. Removed in 0.19 as muscle classes will almost certainly have a 1-handed weapon anyway, and the slingshot is 2-handed. 
	/*
	if (!maximize("1 hand " + my_primestat() == $stat[Muscle] ? " +melee" : " -melee", true)) {
		(my_primestat() == $stat[Muscle] ? cli_execute("buy cool whip") : cli_execute("buy slingshot"));
	}
	*/
	
	//Guarantee that we have an equippable 1-handed ranged weapon.
	if (my_primestat() == $stat[Moxie]) {
		while (i_a("disco ball") == 0) use(1, $item[chewing gum on a string]); 
	}
	
	while (i_a("digital key") == 0) {
		//First, we have to make sure we have at least one-handed moxie weapon to do this with. 	
		if (i_a("continuum transfunctioner") == 0) visit_url("mystic.php?action=crackyes3");
		bumAdv($location[8-Bit Realm], "+equip continuum transfunctioner", "items", "1 digital key", "Getting the Digital Key");
	}
	checkStage("8bit", true);
	return true;
}

boolean bcascAirship() {
	if (checkStage("airship")) return true;
	while (index_of(visit_url("plains.php"), "beanstalk.gif") == -1) {
		if (i_a("enchanted bean") == 0)
			bumAdv($location[Beanbat Chamber], "", "items", "1 enchanted bean", "Getting an Enchanted Bean");
		cli_execute("use 1 enchanted bean");
	}
	
	cli_execute("set choiceAdventure182 = 2");
	while (index_of(visit_url("beanstalk.php"), "castle.gif") == -1)
		bumAdv($location[Fantasy Airship], "", "itemsnc", "1 metallic A, 1 S.O.C.K.", "Opening up the Castle by adventuring in the Airship", "-i");
	
	cli_execute("use * fantasy chest");
	checkStage("airship", true);
	return true;
}

boolean bcascBats1() {
	if (checkStage("bats1")) return true;
	//Guano
	if (!contains_text(visit_url("questlog.php?which=2"), "slain the Boss Bat")) {
		boolean haveStenchSkill() {
			return (have_skill($skill[Diminished Gag Reflex]) || have_skill($skill[Astral Shell]) || have_skill($skill[Elemental Saucesphere]));
		}

		//There's no need to get the air freshener if you have the Stench Resist Skill
		if (elemental_resistance($element[stench]) == 0) {
			buMax("+1000 stench res");
			//Check it NOW (i.e. see if we have stench resistance at all, and get an air freshener if you don't.
			if (elemental_resistance($element[stench]) == 0 && !haveStenchSkill()) {
				while (i_a("Pine-Fresh air freshener") == 0)
					bumAdv($location[Entryway], "", "items", "1 Pine-Fresh air freshener", "Getting a pine-fresh air freshener.");
			}
			buMax("+1000 stench res");
			if (elemental_resistance($element[stench]) == 0 && !haveStenchSkill()) abort("There is some error getting stench resist - perhaps you don't have enough Myst to equip the air freshener? Please manually sort this out.");
		}
	
		print("BCC: Getting Sonars", "purple");
		
		buMax("+10stench res");
		setMood("si");
		cli_execute("mood execute");
		while (item_amount($item[sonar-in-a-biscuit]) < 1 && contains_text(visit_url("bathole.php"), "action=rubble")) {
			//Let's use a clover if we can.
			if (i_a("sonar-in-a-biscuit") == 0 && cloversAvailable(true) > 0) {
				bumAdvClover(31);
			} else {
				// Adventure 1 turn at a time in case of screambats.
				buMax("+10 stench res");
				setFamiliar("items");
				bumMiniAdv(1, $location[Guano Junction]);
			}
			if (cli_execute("use * sonar-in-a-biscuit")) {}
		}
		if (cli_execute("use * sonar-in-a-biscuit")) {}
	}
		
	if (!contains_text(visit_url("bathole.php"), "action=rubble")) {
		checkStage("bats1", true);
		return true;
	}
}

boolean bcascBats2() {
	if (checkStage("bats2")) return true;
	while (index_of(visit_url("questlog.php?which=1"), "I Think I Smell a Bat") > 0) {
		if (cli_execute("use 3 sonar")) {}
		
		if (contains_text(visit_url("bathole.php"), "action=rubble")) {
			cli_execute("set bcasc_stage_bats1 = 0");
			bcascBats1();
		}
		
		if (canMCD()) cli_execute("mcd 4");
		bumAdv($location[Boss Bat's Lair], "", "meatboss", "1 Boss Bat bandana", "WTFPWNing the Boss Bat");
		visit_url("council.php");
	}
	checkStage("bats1", true);
	checkStage("bats2", true);
	return true;
}

boolean bcascCastle() {
	if (checkStage("castle")) return true;
	if (cli_execute("make 1 intragalactic rowboat")) {}
	if (checkStage("castle")) return true;
	while (index_of(visit_url("beanstalk.php"), "hole.gif") == -1) {
		string goalsForCastle = "";
		switch (get_property("currentWheelPosition")) {
			case "muscle" : goalsForCastle = "2 choiceadv, "; break;
			case "mysticality" :
			case "moxie" :
				goalsForCastle = "1 choiceadv, ";
			break;
		}
		cli_execute("set choiceAdventure9 = 2");
		cli_execute("set choiceAdventure10 = 1");
		cli_execute("set choiceAdventure11 = 3");
		cli_execute("set choiceAdventure12 = 2");
		bumAdv($location[Giant's Castle], "", "itemsnc", goalsForCastle+"castle map items", "Opening up the HitS by adventuring in the Castle", "-i");
		if (cli_execute("use giant castle map")) {}
		if (cli_execute("make 1 intragalactic rowboat")) {}
	}
	checkStage("castle", true);
	return true;
}

boolean bcascChasm() {
	if (checkStage("chasm")) return true;
	if (index_of(visit_url("mountains.php"), "chasm.gif") > 0) {
		cli_execute("outfit swash");
		if (i_a("bridge") + i_a("abridged dictionary") == 0) {
			cli_execute("buy 1 abridged dictionary");
		}
		print("BCC: Using the dictionary.", "purple");
		//The below seems to exit the script on successful completion. I'm going to try capturing the output.
		visit_url("forestvillage.php?action=screwquest&submit=&quot;Sure Thing.&quot;");
		visit_url("forestvillage.php?place=untinker&action=screwquest");
		visit_url("forestvillage.php?action=screwquest&submit=&quot;Sure Thing.&quot;");
		safe_visit_url("knoll.php?place=smith");
		if (visit_url("mountains.php?orcs=1&pwd="+my_hash()).to_string() != "") {}
	}
	
	while (contains_text(visit_url("questlog.php?which=1"), "A Quest, LOL")) {
		if (index_of(visit_url("questlog.php?which=1"), "to the Valley beyond the Orc Chasm") > 0) {
			cli_execute("set addingScrolls = 1");
			if (i_a("64735 scroll") == 0 || i_a("lowercase N") == 0) bumAdv($location[Orc Chasm], "", "items", "1 64735 scroll, 1 lowercase N", "Get me the 64735 Scroll", "i");
			if (cli_execute("use 64735 scroll")) {}
		} else {
			abort("For some reason we haven't bridged the chasm.");
		}
	}
	checkStage("chasm", true);
	return true;
}

boolean bcascCyrpt() {
	boolean stageDone(string name) {
		if (get_revision() < 9260 && get_revision() > 0) abort("You need to update your Mafia to handle the cyrpt. A revision of at least 9260 is required. This script is only ever supported for a latest daily build.");
		print("The "+name+" is at "+get_property("cyrpt"+name+"Evilness")+"/50 Evilness...", "purple");
		return (get_property("cyrpt"+name+"Evilness") == 0);
	}

	if (checkStage("cyrpt")) return true;
	set_property("choiceAdventure523", "4");
	
	while (!stageDone("Nook")) {
		if (item_amount($item[evil eye]) > 0) use(1, $item[evil eye]);
		bumAdv($location[Defiled Nook], "", "items", "1 evil eye", "Un-Defiling the Nook (1/4)", "i");
		if (item_amount($item[evil eye]) > 0) use(1, $item[evil eye]);
	}
	while (!stageDone("Alcove")) bumAdv($location[Defiled Alcove], "", "", "", "Un-Defiling the Alcove (2/4)");
	while (!stageDone("Niche")) bumAdv($location[Defiled Niche], "", "", "", "Un-Defiling the Niche (3/4)");
	while (!stageDone("Cranny")) bumAdv($location[Defiled Cranny], "", "", "", "Un-Defiling the Cranny (4/4)");
	
	if (!contains_text(visit_url("questlog.php?which=2"), "defeated the Bonerdagon")) {
		if (my_buffedstat(my_primestat()) > 101) {
			set_property("choiceAdventure527", "1");
			bumAdv($location[Haert of the Cyrpt], "", "meatboss");
			visit_url("council.php");
			if (item_amount($item[chest of the Bonerdagon]) > 0) {
				cli_execute("use chest of the Bonerdagon");
				checkStage("cyrpt", true);
				return true;
			}
		}
	} else {
		checkStage("cyrpt", true);
		return true;
	}
}

void bcascDailyDungeon() {
	zapKeys();
	if (numUniqueKeys() >= 2) return;
	
	int amountKeys;
	//Make skeleton keys if we can.
	if (i_a("skeleton bone") > 1 && i_a("loose teeth") > 1) {
		if (i_a("skeleton bone") > i_a("loose teeth")) {
			amountKeys = i_a("loose teeth") - 1;
		} else {
			amountKeys = i_a("skeleton bone") - 1;
		}
		cli_execute("make "+amountKeys+" skeleton key");
	}
	setFamiliar("");
	while (!contains_text(visit_url("dungeon.php"), "reached the bottom")) {
		bumMiniAdv(1, $location[daily dungeon]);
	}
	zapKeys();
}


boolean bcascDinghyHippy() {
	if (checkStage("dinghy")) return true;
	//We shore first so that we can get the hippy outfit ASAP.
	if (item_amount($item[dingy dinghy]) == 0) {
		if (index_of(visit_url("beach.php"), "can't go to Desert Beach") > 0)
			visit_url("guild.php?place=paco");
		
		if (item_amount($item[dinghy plans]) == 0) {
			print("BCC: Getting plans.", "purple");
			cli_execute("goal clear");
			
			matcher shore = create_matcher("You have taken (.+?) trip(s?) so far",  visit_url("shore.php"));
			if(shore.find()) {
				string numTripsTaken = shore.group(1);
				if (numTripsTaken == "no") numTripsTaken = "0";
				if (numTripsTaken < 5 && (my_meat() > 500*(5-to_int(numTripsTaken))))
					cli_execute("adv "+(5-numTripsTaken.to_int())+" moxie vacation");
			}
			if (item_amount($item[dinghy plans]) == 0) abort("Unable to check shore progress (99% of the time, this is because you lack meat). I recommend you make the Dinghy manually.");
		}
		if (item_amount($item[dingy planks]) == 0) {
			print("BCC: Getting planks.", "purple");
			hermit(1, $item[dingy planks]);
		}
		print("BCC: Making the dinghy.", "purple");
		cli_execute("use dinghy plans");
	}
	
	while ((i_a("filthy knitted dread sack") == 0 || i_a("filthy corduroys") == 0) && have_effect($effect[Everything Looks Yellow]) == 0)
		bumAdv($location[Hippy Camp], "", "hebo", "1 filthy knitted dread sack, 1 filthy corduroys", "Getting Hippy Kit", "", "consultHeBo");
	
	if (i_a("filthy knitted dread sack") > 0 && i_a("filthy corduroys") > 0) {
		checkStage("dinghy", true);
		return true;
	}
}

boolean bcascEpicWeapons() {
	if (bcasc_cloverless) return false;
	
	boolean getEpic(string className, string baseWeapon, string theOtherThingYouNeed, string theEpicWeaponYouWantToGet) {
		print("BCC: Getting the "+className+" Epic Weapon", "purple");
		
		while (i_a(baseWeapon) == 0) use(1, $item[chewing gum on a string]);
		if (i_a(theOtherThingYouNeed) == 0) {
			if (cli_execute("hermit "+theOtherThingYouNeed)) {}
		}
		
		if (i_a("big rock") == 0 && cloversAvailable(true) > 0) {
			print("BCC: Getting the Big Rock", "purple");
			visit_url("casino.php?action=slot&whichslot=11&confirm=on");
		}
		
		visit_url("guild.php?place=sgc");
		if (my_meat() < 1000 && i_a("tenderizing hammer") == 0 && !in_muscle_sign()) return false;
		if (cli_execute("make "+theEpicWeaponYouWantToGet)) {}
		return true;
	}
	
	boolean requireRNR() {
		float n = 0;
		if (have_skill($skill[ The Moxious Madrigal ])) n += 0.1 + (0.1 * to_float(my_primestat() == $stat[Moxie]));
		if (have_skill($skill[ The Magical Mojomuscular Melody ])) n += 0.1 + (0.3 * to_float(my_primestat() == $stat[Mysticality]));
		if (have_skill($skill[ Cletus's Canticle of Celerity ])) n += 0.1;
		if (have_skill($skill[ The Power Ballad of the Arrowsmith ])) n += (0.5 * to_float(my_primestat() == $stat[Muscle]));
		if (have_skill($skill[ The Polka of Plenty ])) n += 0.1;
		if (have_skill($skill[ Jackasses' Symphony of Destruction ])) n += 0.2;
		if (have_skill($skill[ Fat Leon's Phat Loot Lyric ])) n += 0.8;
		if (have_skill($skill[ Brawnee's Anthem of Absorption ])) n += 0.1;
		if (have_skill($skill[ The Psalm of Pointiness ])) n += 0.1;
		if (have_skill($skill[ Stevedave's Shanty of Superiority ])) n += 0.2;
		if (have_skill($skill[ Aloysius' Antiphon of Aptitude ])) n += 0.2;
		if (have_skill($skill[ The Ode to Booze ])) n += 0.6;
		if (have_skill($skill[ The Sonata of Sneakiness ])) n += 0.5;
		if (have_skill($skill[ Ur-Kel's Aria of Annoyance ])) n += 0.4;
		if (have_skill($skill[ Dirge of Dreadfulness ])) n += 0.1;
		if (have_skill($skill[ Inigo's Incantation of Inspiration ])) n+= 0.7;
		return (n >= 1.0);
	}
	
	if (my_class() == $class[Disco Bandit] && my_basestat(my_primestat()) > 10 && i_a("Disco Banjo") == 0 && i_a("Shagadelic Disco Banjo") == 0 && i_a("Seeger's Unstoppable Banjo") == 0) {
		getEpic("DB", "disco ball", "banjo strings", "disco banjo");
	}
	
	if (my_class() == $class[Turtle Tamer] && my_basestat(my_primestat()) > 10 && i_a("Mace of the Tortoise") == 0 && i_a("Chelonian Morningstar") == 0 && i_a("Flail of the Seven Aspects") == 0) {
		getEpic("TT", "turtle totem", "chisel", "Mace of the Tortoise");
	}
	
	if (my_class() == $class[Seal Clubber] && my_basestat(my_primestat()) > 10 && i_a("Bjorn's Hammer") == 0 && i_a("Hammer of Smiting") == 0 && i_a("Sledgehammer of the Vælkyr") == 0) {
		getEpic("SC", "seal-clubbing club", "seal tooth", "Bjorn's Hammer");
	}
	
	if (my_basestat(my_primestat()) > 10 && i_a("Rock and Roll Legend") == 0 && i_a("Squeezebox of the Ages") == 0 && i_a("The Trickster's Trikitixa") == 0 && requireRNR()) {
		getEpic("AT", "stolen accordion", "hot buttered roll", "rock and roll legend");
	}
}

boolean bcascFriars() {
	if (checkStage("friars")) return true;
	if (index_of(visit_url("friars.php"), "friars.gif") > 0) {
		print("BCC: Gotta get the Friars' Items", "purple");
		while (item_amount($item[eldritch butterknife]) == 0)
			bumAdv($location[Dark Elbow of the Woods], "", "", "1 eldritch butterknife", "Getting butterknife from the Elbow (1/3)");
			
		while (item_amount($item[box of birthday candles]) == 0)
			bumAdv($location[Dark Heart of the Woods], "", "", "1 box of birthday candles", "Getting candles from the Heart (2/3)");
			
		while (item_amount($item[dodecagram]) == 0 && !checkStage("friars"))
			bumAdv($location[Dark Neck of the Woods], "", "", "1 dodecagram", "Getting dodecagram from the Neck (3/3)");
			
		print("BCC: Yay, we have all three items. I'm off to perform the ritual!", "purple");
		if (visit_url("friars.php?action=ritual&pwd="+my_hash()).to_string() != "") {}
	}
	checkStage("friars", true);
	return true;
}

boolean bcascFriarsSteel() {
	boolean logicPuzzleDone() {
		/*    
			* Jim the sponge cake or pillow
			* Flargwurm the cherry or sponge cake
			* Blognort the marshmallow or gin-soaked paper
			* Stinkface the teddy bear or gin-soaked paper 
		*/
		if (item_amount($item[sponge cake]) + item_amount($item[comfy pillow]) + item_amount($item[gin-soaked blotter paper]) + item_amount($item[giant marshmallow]) + item_amount($item[booze-soaked cherry]) + item_amount($item[beer-scented teddy bear]) == 0) return false;
		
		int j = 0, f = 0, b = 0, s = 0, jf, bs;
		string sven = visit_url("pandamonium.php?action=sven");
		if (contains_text(sven, "<option>Bognort")) b = 1;
		if (contains_text(sven, "<option>Flargwurm")) f = 1;
		if (contains_text(sven, "<option>Jim")) j = 1;
		if (contains_text(sven, "<option>Stinkface")) s = 1;
		jf = j+f;
		bs = b+s;
		
		boolean x, y;
		x = ((item_amount($item[sponge cake]) >= jf) || (item_amount($item[sponge cake]) + item_amount($item[comfy pillow]) >= jf) || (item_amount($item[sponge cake]) + item_amount($item[booze-soaked cherry]) >= jf) || (item_amount($item[comfy pillow]) + item_amount($item[booze-soaked cherry]) >= jf));
		y = ((item_amount($item[gin-soaked blotter paper]) >= bs) || (item_amount($item[gin-soaked blotter paper]) + item_amount($item[giant marshmallow]) >= bs) || (item_amount($item[gin-soaked blotter paper]) + item_amount($item[beer-scented teddy bear]) >= bs) || (item_amount($item[beer-scented teddy bear]) + item_amount($item[giant marshmallow]) >= bs));
		print("BCC: x is "+x+" and y is "+y+". j, f, b, s are "+j+", "+f+", "+b+", "+s+".", "purple");
		return x && y;
	}
	
	if (to_string(visit_url("pandamonium.php")) != "") {}
	if (to_string(visit_url("pandemonium.php")) != "") {}
	if (checkStage("friarssteel")) return true;
	//Let's do this check now to get it out the way. 
	if (!contains_text(visit_url("questlog.php?which=1"), "this is Azazel in Hell")) {
		return false;
	} else if (contains_text(visit_url("questlog.php?which=2"), "this is Azazel in Hell")) {
		checkStage("friarssteel", true);
		return true;
	}
	
	string steelName() {
		if (!can_drink() && !can_eat()) { return "steel-scented air freshener"; }
		if (!can_drink()) { return "steel lasagna"; }
		return "steel margarita";
	}
	string steelWhatToDo() {
		if (!can_drink() && !can_eat()) { return "use steel-scented air freshener"; }
		if (!can_drink()) { return "eat steel lasagna"; }
		return "drink steel margarita";
	}
	string steelLimit() {
		if (!can_drink() && !can_eat()) { return spleen_limit(); }
		if (!can_drink()) { return fullness_limit(); }
		return inebriety_limit();
	}
	
	if (steelLimit() > 16) return true;
	if (i_a(steelName()) > 0) {
		cli_execute(steelWhatToDo());
		if (steelLimit() > 16) {
			checkStage("friarssteel", true);
			return true;
		} else {
			abort("There was some problem using the steel item. Perhaps use it manually?");
		}
	}
	
	while (item_amount($item[Azazel's unicorn]) == 0) {
		//I'm hitting this page a couple times quietly because I'm fairly sure that the first time you visit him,
		//there's no drop-downs and this makes the script act screwy.
		visit_url("pandamonium.php?action=sven");
		visit_url("pandamonium.php?action=sven");
	
		//Solve the logic puzzle in the Hey Deze Arena to receive Azazel's unicorn
		cli_execute("mood execute");
		buMax();
		levelMe(70, false);
		print("BCC: Getting Azazel's unicorn", "purple");
		setFamiliar("itemsnc");
		cli_execute("mood execute; conditions clear");
		visit_url("pandamonium.php?action=sven");
		while (!logicPuzzleDone()) {
			bumMiniAdv(1, $location[Hey Deze Arena]);
		}
		int bog = 0, sti = 0, fla = 0, jim = 0;
		if (item_amount($item[giant marshmallow]) > 0) { bog = to_int($item[giant marshmallow]); }
		if (item_amount($item[beer-scented teddy bear]) > 0) { sti = to_int($item[beer-scented teddy bear]); }
		if (item_amount($item[booze-soaked cherry]) > 0) { fla = to_int($item[booze-soaked cherry]); }
		if (item_amount($item[comfy pillow]) > 0) { jim = to_int($item[comfy pillow]); }
		if (bog == 0) bog = to_int($item[gin-soaked blotter paper]);
		if (sti == 0) sti = to_int($item[gin-soaked blotter paper]);
		if (fla == 0) fla = to_int($item[sponge cake]);
		if (jim == 0) jim = to_int($item[sponge cake]);
		if (contains_text(visit_url("pandamonium.php?action=sven"), "<option>Bognort")) visit_url("pandamonium.php?action=sven&bandmember=Bognort&togive="+bog+"&preaction=try");
		if (contains_text(visit_url("pandamonium.php?action=sven"), "<option>Stinkface")) visit_url("pandamonium.php?action=sven&bandmember=Stinkface&togive="+sti+"&preaction=try");
		if (contains_text(visit_url("pandamonium.php?action=sven"), "<option>Flargwurm")) visit_url("pandamonium.php?action=sven&bandmember=Flargwurm&togive="+fla+"&preaction=try");
		if (contains_text(visit_url("pandamonium.php?action=sven"), "<option>Jim")) visit_url("pandamonium.php?action=sven&bandmember=Jim&togive="+jim+"&preaction=try");
		if (item_amount($item[Azazel's unicorn]) == 0) abort("The script doesn't have the unicorn, but it should have. Please do this part manually.");
	}

	buMax();
	while (item_amount($item[Azazel's lollipop]) == 0) {
		levelMe(77, false);
		void tryThis(item i, string preaction) {
			if (item_amount(i) > 0) { 
				equip(i);
				visit_url("pandamonium.php?action=mourn&preaction="+preaction); 
			}
		}
	
		//Adventure in Belilafs Comedy Club until you encounter Larry of the Field of Signs. Equip the observational glasses and Talk to Mourn. 
		print("BCC: Getting Azazel's lollipop", "purple");
		while (item_amount($item[observational glasses]) == 0) bumAdv($location[Belilafs Comedy Club], "", "items", "1 observational glasses", "Getting the Observational Glasses");
		cli_execute("unequip weapon");
		tryThis($item[Victor, the Insult Comic Hellhound Puppet], "insult");
		tryThis($item[observational glasses], "observe");
		tryThis($item[hilarious comedy prop], "prop");
	}
	
	while (item_amount($item[Azazel's tutu]) == 0) {
		//After collecting 5 cans of imp air and 5 bus passes from the comedy blub and backstage, go the Moaning Panda Square to obtain Azazel's tutu. 
		print("BCC: Getting Azazel's tutu", "purple");
		while (item_amount($item[bus pass]) < 5) bumAdv($location[Hey Deze Arena], "", "items", "5 bus pass", "Getting the 5 Bus Passes");
		while (item_amount($item[imp air]) < 5)  bumAdv($location[Belilafs Comedy Club], "", "items", "5 imp air", "Getting the 5 Imp Airs");
		visit_url("pandamonium.php?action=moan");
	}
	
	visit_url("pandamonium.php?action=temp");
	cli_execute(steelWhatToDo());
	if (steelLimit() > 16) {
		checkStage("friarssteel", true);
		return true;
	} else {
		abort("There was some problem using the steel item. Perhaps use it manually?");
	}
	abort("There was some problem using the steel item. Perhaps use it manually or something?");
}

boolean bcascGuild1() {
	if (checkStage("guild1")) return true;
	if (index_of(visit_url("guild.php?place=challenge"), "game of 11-Card Monte") + index_of(visit_url("guild.php?place=challenge"), "pot of baked beans over there") > 0) {
		if (my_buffedstat(my_primestat()) > 10) {
			print("BCC: Doing the First Challenge...", "purple");
			if (my_adventures() == 0) abort("You are out of adventures.");
			visit_url("guild.php?action=chal");
			//Then sell the "wrong" reward and use the other two.
			switch (my_class()) {
				case $class[disco bandit] : cli_execute("use 2 giant moxie weed; sell enchanted barbell"); break;
				case $class[accordion thief] : cli_execute("use 2 giant moxie weed; sell concentrated magicalness pill"); break;
			}
			checkStage("guild1", true);
		}
	}
	return true;
}

boolean bcascGuild2() {
	if (checkStage("guild2")) return true;
	if (my_basestat(my_primestat()) > 15) {
		visit_url("guild.php?place=ocg");
		visit_url("guild.php?place=ocg");
		visit_url("guild.php?place=scg");
		visit_url("guild.php?place=scg");
		checkStage("guild2", true);
		return true;
	}
}

boolean bcascHoleInTheSky() {
	if (checkStage("hits")) return true;
	
	setFamiliar("items");
	setMood("i");
	buMax();
	cli_execute("conditions clear");
	levelMe(safeMox($location[Hole in the Sky]));
	cli_execute("conditions clear");
	
	while (i_a("star hat") == 0 || i_a("star crossbow") == 0 || i_a("richard's star key") == 0) {
		bumMiniAdv(1, $location[Hole in the Sky]);
		if (item_amount($item[star chart]) > 0) {
			if (equipped_item($slot[hat]) != $item[star hat]) { (!retrieve_item(1, $item[star hat])); }
			if (equipped_item($slot[weapon]) != $item[star crossbow]) { (!retrieve_item(1, $item[star crossbow])); }
			(!retrieve_item(1, $item[richards star key]));
		}
	}
	checkStage("hits", true);
	return true;
}

boolean bcascInnaboxen() {
	if (bcasc_cloverless) return false;
	if (checkStage("innaboxen")) return true;
	
	int[item] campground = get_campground();
	if((bcasc_bartender && campground contains to_item("bartender-in-the-box")) && (bcasc_chef && campground contains to_item("chef-in-the-box"))) {
		checkStage("innaboxen", true);
		return true;
	} else if((bcasc_bartender && !bcasc_chef) && campground contains to_item("bartender in-the-box")) {
		checkStage("innaboxen", true);
		return true;
	} else if((!bcasc_bartender && bcasc_chef) && campground contains to_item("chef-n-the-box")) {
		checkStage("innaboxen", true);
		return true;
	} else if(!bcasc_bartender && !bcasc_chef) {
		checkStage("innaboxen", true);
		return true;
	}
	
	//Thanks, gruddlefitt!
	item bcascWhichEpic() {
		item [class] epicMap;
		epicMap[$class[Seal Clubber]] = $item[Bjorn's Hammer];
		epicMap[$class[Turtle Tamer]] = $item[Mace of the Tortoise];
		epicMap[$class[Pastamancer]] = $item[Pasta of Peril];
		epicMap[$class[Sauceror]] = $item[5-Alarm Saucepan];
		epicMap[$class[Disco Bandit]] = $item[Disco Banjo];
		epicMap[$class[Accordion Thief]] = $item[Rock and Roll Legend];
		return epicMap[my_class()];
	}
	
	boolean getBox() {
		//I know, we should already have run this, but what's a visit to the hermit between friends?
		if (i_a("box") > 0) { return true; }
		item epicWeapon = bcascWhichEpic();
		if (item_amount(epicWeapon) == 0) { return false; }
		
		//Then hit the guild page until we see the clown thingy.
		while (!contains_text(visit_url("plains.php"), "funhouse.gif")) {
			print("BCC: Visiting the guild to unlock the funhouse", "purple");
			visit_url("guild.php?place=scg");
		}
		
		if (cloversAvailable(true) > 0) {
			bumAdvClover(20);
			return true;
		}
		
		return false;
	}
	
	if (index_of(visit_url("questlog.php?which=2"), "defeated the Bonerdagon") > 0) {
		//At this point, we can clover the Cemetary for innaboxen. 
		cloversAvailable();
		
		//Apart from the brain/skull, we need a box and spring and the chef's hat/beer goggles.
		if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "Chef-in-the-Box") && bcasc_chef) {
			//We're not even going to bother to try if we don't have a chef's hat. 
			if (i_a("chef's hat") > 0 && (i_a("spring") > 0 || in_muscle_sign())) {
				print("BCC: Going to try to make a chef", "purple");
				if (getbox()) {
					if (creatable_amount($item[chef-in-the-box]) == 0) {
						//Then the only thing we could need would be brain/skull, as we've checked for all the others. 
						if (cloversAvailable(true) > 0) {
							bumAdvClover(58);
							cli_execute("use chef-in-the-box");
						} else {
							print("BCC: Uhoh, we don't have enough clovers to get the brain/skull we need.", "purple");
						}
					} else {
						cli_execute("use chef-in-the-box");
					}
				} else {
					print("BCC: There was a problem getting the box.", "purple");
				}
			}
		}
		
		if (bcasc_bartender) {
			if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "Bartender-in-the-Box")) {
				if (i_a("spring") > 0 || in_muscle_sign()) {
					print("BCC: Going to try to get a bartender.", "purple");
					if (getBox()) {
						if (creatable_amount($item[bartender-in-the-box]) == 0) {
							if (creatable_amount($item[brainy skull]) + available_amount($item[brainy skull]) == 0) {
								if (cloversAvailable(true) > 0) {
									bumAdvClover(58);
								} else {
									print("BCC: Uhoh, we don't have enough clovers to get the brain/skull we need.", "purple");
								}
							}
							
							while (creatable_amount($item[beer goggles]) + available_amount($item[beer goggles]) == 0) {
								bumAdv($location[A Barroom Brawl], "", "items", "1 beer goggles", "Getting the beer goggles");
							}
							
							if (creatable_amount($item[bartender-in-the-box]) > 0) {
								cli_execute("use bartender-in-the-box");
							}
						} else {
							cli_execute("use bartender-in-the-box");
						}
					} else {
						print("BCC: There was a problem getting the box.", "purple");
					}
				}
			}
		}
		
		//Now we 
		//checkStage("innaboxen", true);
		//return true;
	}
}

boolean bcascKnob() {
	if (checkStage("knob")) return true;
	while (contains_text(visit_url("plains.php"), "knob1.gif") && item_amount($item[knob goblin encryption key]) == 0) {
		bumAdv($location[Outskirts of the Knob], "", "", "1 knob goblin encryption key", "Let's get the Encryption Key");
	}
	checkStage("knob", true);
	return true;
}

boolean bcascKnobKing() {
	if (checkStage("knobking")) return true;
	//Before we go into the harem, we gotta use the map. 
	if (item_amount($item[Cobb's Knob map]) > 0) {
		use(1, $item[Cobb's Knob map]);
	}

	if (get_property("picklishSemirareKGE").to_boolean()) {
		if (i_a($item[Knob Goblin elite pants]) == 0 || i_a($item[Knob Goblin elite polearm]) == 0 || i_a($item[Knob Goblin elite helm]) == 0) {
			print("PCKLSH: Skipping KGE until semi-rare.", "purple");
			return false;
		}
	}
	
	if (!contains_text(visit_url("questlog.php?which=2"), "slain the Goblin King")) {
		//First we need the KGE outfit. 
		while (i_a($item[Knob Goblin elite pants]) == 0 || i_a($item[Knob Goblin elite polearm]) == 0 || i_a($item[Knob Goblin elite helm]) == 0) {
			bumAdv($location[Cobb's Knob Barracks], "", "items", "1 Knob Goblin elite pants, 1 Knob Goblin elite polearm, 1 Knob Goblin elite helm", "Getting the KGE Outfit");
		}
		
		//Then we need the cake. 
		if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "Dramatic")) {
			if (!use(1, to_item("Dramatic range")))
			if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "Dramatic")) abort("You need a dramatic oven for this to work.");
		}
		
		while (available_amount($item[Knob cake]) + creatable_amount($item[Knob cake]) == 0) {
			while (item_amount($item[Knob frosting]) == 0) {
				bumAdv($location[Cobb's Knob Kitchens], "+outfit knob goblin elite", "", "1 knob frosting", "Getting the Knob Frosting");
			}
			
			while (available_amount($item[unfrosted Knob cake]) + creatable_amount($item[unfrosted Knob cake]) == 0) {
				bumAdv($location[Cobb's Knob Kitchens], "+outfit knob goblin elite", "", "1 Knob cake pan, 1 knob batter", "Getting the Knob Pan and Batter");
			}
		}
		if (item_amount($item[Knob cake]) == 0) {
			if (cli_execute("make knob cake")) {}
		}
	
		//Now the Knob Goblin King has 55 Attack, and we'll be fighting him with the MCD set to 7. So that's 55+7+7=69 Moxie we need. 
		//Arbitrarily using 75 because will need the harem outfit equipped. 
		if (item_amount($item[Knob cake]) > 0) {
			buMax();
			if (my_buffedstat(my_primestat()) >= 75) {
				if (canMCD()) cli_execute("mcd 7");
				bumAdv($location[Throne Room], "+outfit knob goblin elite", "meatboss", "", "Killing the Knob King");
				checkStage("knobking", true);
				return true;
			}
		}
	} else {
		checkStage("knobking", true);
		return true;
	}
}

boolean bcascLairFightNS() {
	print("BCC: Fighting the NS", "purple");
	if (canMCD()) cli_execute("mcd 0");
	buMax();
	cli_execute("uneffect beaten up; restore hp; restore mp");

	if (item_amount($item[wand of nagamar]) == 0) {
		if (!retrieve_item(1, $item[wand of nagamar])) {
			abort("Failed to create the wand!");
		}
	}
	
	if (my_primestat() == $stat[Mysticality]) abort("We're not automatically fighting the NS as a Myst class at all. For obvious reasons.");
	
	if (bcasc_fightNS) {
		visit_url("lair6.php?place=5");
		for i from 1 to 3 {
			if (!contains_text(bumRunCombat(), "You win the fight!")) {
				abort("Maybe you should fight Her Naughtiness yourself...");
			}
		}
		if (!contains_text(visit_url("trophy.php"), "not currently entitled to")) abort("You're entitled to some trophies!");
		print("BCC: Hi-keeba!", "purple");
		visit_url("lair6.php?place=6");
		if (get_property("bcasc_getItemsFromStorage") == "true") {
			print("BCC: Getting all your items out of Storage. Not all bankers are evil, eh?", "purple");
			visit_url("storage.php?action=takeall&pwd");
		}
		abort("Tada! Thankyou for using bumcheekascend.ash.");
	} else {
		abort("Bring it on.");
	}
}

boolean bcascLairFirstGate() {
	if (checkStage("lair1")) return true;
	load_current_map("bumrats_lairitems", lairitems);
	html = visit_url("lair1.php?action=gates");
	int numGatesWeHaveItemFor = 0;
	
	foreach x in lairitems {
		if (contains_text(html, lairitems[x].gatename)) {
			print("BCC: We see "+lairitems[x].gatename, "purple");
			
			if (i_a(lairitems[x].a) > 0 || have_effect(to_effect(lairitems[x].effectname)) > 0) {
				print("BCC: We have the effect/item, for that gate.", "purple");
				numGatesWeHaveItemFor = numGatesWeHaveItemFor + 1;
			} else {
				print("BCC: We do not have the item for that gate. (We need a "+lairitems[x].a+" for that.)", "purple");
				
				//So get the item, using a clover for the gum.  
				if (contains_text(lairitems[x].a, "chewing gum") && cloversAvailable(true) > 0) {
					print("BCC: I'm going to get the chewing gum using a clover.", "purple");
					if (i_a("pack of chewing gum") == 0) {
						if (cloversavailable(true) > 0) {
							bumAdvClover(45);
							cli_execute("use pack of chewing gum");
							numGatesWeHaveItemFor = numGatesWeHaveItemFor + 1;
						} else {
							print("BCC: I dont have a clover, so am going to adventure to get the gum. .", "purple");
							abort("this isn't done yet");
						}
					} else {
						cli_execute("use pack of chewing gum");
						numGatesWeHaveItemFor = numGatesWeHaveItemFor + 1;
					}
				} else if (lairitems[x].a == "dod") {
					if (item_amount(bangPotionWeNeed().to_item()) == 0) {
						cli_execute("use * dead mimic; use * large box; use * small box");
						
						setFamiliar("items");
						setMood("i+");
						while (!identifyBangPotions() && (bangPotionWeNeed() == "")) {
							bumMiniAdv(1, $location[Dungeons of Doom]);
							cli_execute("use * dead mimic; use * large box; use * small box");
						}
							
						//So at this point, we at least know WHICH bang potion we need, though we don't know whether we have it or not.
						while (item_amount(bangPotionWeNeed().to_item()) == 0) {
							bumMiniAdv(1, $location[Dungeons of Doom]);
							cli_execute("use * dead mimic; use * large box; use * small box");
						}
					}
					
					if (item_amount(bangPotionWeNeed().to_item()) > 0) { numGatesWeHaveItemFor = numGatesWeHaveItemFor + 1; }
				} else {
					//Now check for any other item(s).
					switch (lairitems[x].a) {
						case "marzipan skull" :
							if (in_moxie_sign()) {
								cli_execute("buy marzipan skull");
								numGatesWeHaveItemFor = numGatesWeHaveItemFor + 1;
							} else {
								abort("We need a "+lairitems[x].a+", but the script cannot yet get that item!");
							}
						break;
						
						case "Meleegra pills" :
							while (item_amount($item[Meleegra pills]) == 0) {
								bumAdv($location[South of the Border], "", "items", "1 Meleegra pills", "Getting some Meelegra pills", "-i");
							}
						break;
						
						case " gremlin juice" :
							bumAdv($location[post-war junkyard], "", "hebo", "1 gremlin juice", "Getting gremlin juice", "", "consultHeBo");
						break; 
						
						default :
							if (lairitems[x].a != "") {
								abort("We need a "+lairitems[x].a+", but the script cannot yet get that item!");
							} else {
								//abort("Due to the way the gates are handled, the script aborts here. Please re-run it.");
							}
						break;
					}
				}
			}
		}
	}
	
	print("BCC: The number of gates for which we have items is "+numGatesWeHaveItemFor, "purple");
	//When we get to this point, check if we have all the items. 
	if (numGatesWeHaveItemFor == 3) {
		if (entryway()) {
			print("BCC: We got through the whole entryway. That's fairly unlikely at this point....", "purple");
		} else {
			//Check that lair2.php appears, because we should have got through the gates and at least be in the Mariachi bit.
			if (!contains_text(visit_url("lair1.php"), "lair2.php")) {
				print("We successfully got through lair1.php and probably a section of lair2.php as well.", "purple");
			} else {
				abort("We did not successfully get to lair2.php. This is a major error. You should probably do the rest of this manually.");
			}
		}
	} else {
		abort("We do not have all the items for the gates. This script cannot yet get them. ");
	}
	
	checkStage("lair1", true);
	return true;
}

boolean bcascLairMariachis() {
	if (checkStage("lair2")) return true;
	print("BCC: We are doing the Mariachi part.", "purple");
	cli_execute("maximize hp");
	
	//Before we do anything, we must ensure we have the instruments. 
	
	
	//We should have two keys. Two DISTINCT keys.
	if (numUniqueKeys() >= 2) {
		if (i_a("makeshift SCUBA gear") == 0) {
			if (i_a("boris's key") > 0 && i_a("fishbowl") == 0 && i_a("hosed fishbowl") == 0) {
				print("BCC: We have boris's key, but no fishbowl. Do the entryway.", "purple");
				if (entryway()) {}
			}
			if (i_a("jarlsberg's key") > 0 && i_a("fishtank") == 0 && i_a("hosed tank") == 0) {
				print("BCC: We have jarlsberg's key, but no fisktank. Do the entryway.", "purple");
				if (entryway()) {}
			}
			if (i_a("sneaky pete's key") > 0 && i_a("fish hose") == 0 && i_a("hosed tank") == 0 && i_a("hosed fishbowl") == 0) {
				print("BCC: We have sneaky pete's key, but no fish hose. Do the entryway.", "purple");
				if (entryway()) {}
			}
		
			if (numOfWand() > 0) {
				if (canZap()) {
					//At this point, we haven't used our wand and have two distinct keys. 
					if (numUniqueKeys() >= 3) {
						print("BCC: You had all three keys. You don't need to zap them.", "purple");
					} else {
						//abort("za");
						if (i_a("boris's key") > 0) {
							cli_execute("zap boris's key");
						} else {
							cli_execute("zap jarlsberg's key");
						}
					}
				} else {
					print("BCC: Your wand is not perfectly safe to zap, and as such we will not attempt to do so.", "purple");
				}
			} else {
				abort("You don't have a wand. No Zapping for you.");
			}
			
			boolean armed() {
				return contains_text(visit_url("lair2.php"), "lair3.php");
			}

			if (entryway()) {}
			if (!armed()) {
				print("BCC: Maybe we're missing an instrument.", "purple");
				boolean haveAny(boolean[item] array) {
					foreach thing in array {
						if (i_a(thing) > 0) return true;
					}
					return false;
				}

				boolean[item] strings = $items[
					acoustic guitarrr,
					heavy metal thunderrr guitarrr,
					stone banjo,
					Disco Banjo,
					Shagadelic Disco Banjo,
					Seeger's Unstoppable Banjo,
					Crimbo ukelele,
					Massive sitar,
					4-dimensional guitar,
					plastic guitar,
					half-sized guitar,
					out-of-tune biwa,
					Zim Merman's guitar,
				];
				boolean[item] squeezings = $items[stolen accordion,calavera concertina,Rock and Roll Legend,Squeezebox of the Ages,The Trickster's Trikitixa,];
				boolean[item] drums = $items[tambourine,big bass drum,black kettle drum,bone rattle,hippy bongo,jungle drum,];

				if (!haveAny(strings))
					bumAdv($location[Belowdecks], "+equip pirate fledges", "items", "1 acoustic guitarrr", "Getting a guitar", "i");
					
				if (!haveAny(squeezings))
					while (i_a("stolen accordion") == 0) use(1, $item[chewing gum on a string]);
					
				if (!haveAny(drums))
					abort("You need a drum, but this script can't get any"); 
				
				if (entryway()) {}
			}
			
			if (armed()) {
				checkStage("lair2", true);
				return true;
			} else {
				abort("Failed to arm the mariachis"); 
			}
		}
	} else {
		abort("You don't have two distinct legend keys. This script will not attempt to zap anything.");
	}
	abort("There has been a problem in the mariachi section. Please report this issue and complete the mariachi bit manually.");
}

boolean bcascLairTower() {
	//Firstly, maximize HP and make sure we have a sugar shield to get through the shadow/familiars. 
	cli_execute("maximize hp; restore hp");
	if (i_a("sugar shield") == 0) { if (cli_execute("cast summon sugar; make sugar shield")) {} }
	
	//Then get through the place.
	cli_execute("use * canopic jar");
	cli_execute("use * black picnic basket");
	item missing = guardians();
	if (missing == $item[none]) {
		if (contains_text(visit_url("lair6.php"), "?place=5")) {
			bcascLairFightNS();
		} else {
			abort("You are stuck at the top of the tower.");
		}
	} else {
		abort("You need a "+ missing +" to continue.");
	}
}

boolean bcascMacguffinFinal() {
	if (checkStage("macguffinfinal")) return true;

	if (contains_text(visit_url("questlog.php?which=1"),"A Pyramid Scheme")) {
		if (!contains_text(visit_url("beach.php"),"pyramid.php")) visit_url("beach.php?action=woodencity");
		
		//Set to turn the wheel. 134 is the initial and 135 subsequent visits. 
		set_property("choiceAdventure134","1");
		set_property("choiceAdventure135","1");
		if (!contains_text(visit_url("pyramid.php"),"pyramid3b.gif")) {
			if (i_a("carved wooden wheel") == 0) bumAdv($location[Upper Chamber], "", "items", "carved wooden wheel", "Getting the Carved Wooden Wheel", "i");
			bumAdv($location[Middle Chamber], "", "", "choiceadv", "Getting the initial choice adventure", "-");
		}
		
		if (get_property("pyramidBombUsed") != "true") {
			boolean pyrstep(string stepname,string posnum) {
				print("BCC: "+stepname+" (image "+posnum+")", "purple");
				while (get_property("pyramidPosition") != posnum) {
					if (item_amount($item[tomb ratchet]) > 0) {
						use(1, $item[tomb ratchet]);
					} else {
						bumAdv($location[Middle Chamber], "", "", "choiceadv", "Getting another choice adventure", "-");
					}
				}
				return bumMiniAdv(1,$location[lower chambers]);
			}
			
			if (item_amount($item[ancient bronze token]) == 0 && item_amount($item[ancient bomb]) == 0 && !pyrstep("Step 1 / 3: get a token.","4"))
				abort("Unable to get a token.");
			
			if (item_amount($item[ancient bronze token]) > 0 && item_amount($item[ancient bomb]) == 0 && !pyrstep("Step 2 / 3: exchange token for a bomb.","3"))
				abort("Unable to exchange token for bomb.");
			
			if (item_amount($item[ancient bomb]) > 0)
				if (!pyrstep("Step 3 / 3: reveal Ed's chamber.","1")) abort("Unable to use bomb");
		}
		
		//Fight Ed
		if (my_adventures() < 7) { abort("You don't have enough adventures to fight Ed."); }
		print("BCC: Fighting Ed", "purple");
		visit_url("pyramid.php?action=lower");
		bumRunCombat();
		while (item_amount($item[Holy MacGuffin]) == 0) {
			if (my_hp() == 0) abort("Oops, you died. Probably better fight this one yourself.");
			visit_url("fight.php");
			bumRunCombat();
		}
	}
	checkStage("macguffinfinal", true);
	return true;
}

boolean bcascMacguffinHiddenCity() {
	if (checkStage("macguffinhiddencity")) return true;
	
	while (contains_text(visit_url("questlog.php?which=1"), "Gotta Worship Them All")) {
		string[int] citymap;
		string urldata;
		int altarcount = 0, squareNum;
		boolean sphereID = false;
		
		//Hippy outfit is +8 stench damage. I don't use bumAdv() in this function, so it won't unequip this. 
		if (my_primestat() != $stat[Mysticality]) buMax("+outfit Filthy Hippy Disguise");
		
		//Return true if we know where all the altars are and temple is.
		boolean altar_check() {
			return (altarcount == 4 && contains_text(urldata, "map_temple"));
		}
		
		//Returns the stone you need for a given temple. 
		item give_appropriate_stone(string page) {
			item this_stone(string desc) {
				for i from 2174 to 2177
				if (get_property("lastStoneSphere"+i) == desc) return to_item(i);
				abort("Unable to deduce correct stone.  You may have to identify them yourself.");
				return $item[none];
			}
			if (contains_text(page, "altar1.gif")) return this_stone("lightning");
			if (contains_text(page, "altar2.gif")) return this_stone("water");
			if (contains_text(page, "altar3.gif")) return this_stone("fire");
			if (contains_text(page, "altar4.gif")) return this_stone("nature");
			return $item[none];
		}
		
		//Searches for a given string and updates the citymap for a given image.
		void find_generic(string type, string imgname) {
			if (type == "altar") altarcount = 0;
			
			for i from 0 upto 24 {
				if (contains_text(urldata,"hiddencity.php?which="+i+"'><img src=\"IMAGES/hiddencity/"+imgname)) {
					if (type == "altar") { altarcount = altarcount + 1; }
					citymap[i] = type;
				}
			}
		}
		
		//Updates the citymap.
		void find_all() {
		   if (my_adventures() == 0) abort("Out of adventures.");
		   urldata = visit_url("hiddencity.php");
		   if (contains_text(urldata, "Combat!")) abort("You're still in the middle of a combat!");
		   if (!contains_text(urldata, "ruin")) abort("No ruins found!");
		   urldata = replace_string(urldata,"http://images.kingdomofloathing.com/otherimages", "IMAGES");
		   find_generic("altar","map_altar");
		   find_generic("explored ruin","map_ruins");
		   find_generic("unexplored ruin","map_unruins");
		   find_generic("unexplored spirit","map_spirit");
		   find_generic("smallish temple","map_temple");
		}
		
		//Unlike Zarqon, I'm going to do this in order. Saves code.
		int get_next_unexplored() {
			for i from 0 to 24 if (contains_text(citymap[i],"unexplored")) return i;
			return -1;
		}
		
		//Simple shortcut function. 
		int sphere_count() {
			return item_amount($item[mossy stone sphere]) + item_amount($item[rough stone sphere]) + item_amount($item[smooth stone sphere]) + item_amount($item[cracked stone sphere]);
		}
		
		//Finish function and start the actual adventuring code bit.
		find_all();
		setFamiliar("meatboss");
		while (!(item_amount($item[triangular stone]) + sphere_count() == 4 && altar_check())) {
			print("BCC: Continuing to adventure in the Hidden City.", "purple");
			if (my_adventures() == 0) abort("You're out of adventures.");
			squareNum = get_next_unexplored();
			
			if (squareNum != -1) {
				//Then there's something to find. If squareNum==-1 then we've explored all the squares. 
				
				//Explore the square in question
				print("Exploring square : "+(squareNum + 1)+" / 25");
				string url = bumAdvUrl("hiddencity.php?which="+squareNum);
				bumRunCombat();
				print("BCC: Finished the combat. Let's carry on.", "purple");
				find_all();
				
				//After every adventure, print some debugging information. 
				print("spheres : "+ sphere_count() + " / 4","maroon");
				print("altars : " + altarcount + " / 4","maroon");
				if (altar_check()) print("Altars and temple all found!");
			} else {
				print("BCC: We've explored all the squares.", "purple");
			}
		}
		
		//Now we've found it, we have to finish off the city. First get the triangular stones. 
		print("BCC: We have to get the triangular stones.", "purple");
		if (item_amount(to_item("triangular stone")) < 4) {
			for i from 0 upto 24 {
				if (citymap[i] == "altar") {
					string url = visit_url("hiddencity.php?which="+i);
					if (!contains_text(url, "the altar doesn't really do anything but look neat")) {
						item stone = give_appropriate_stone(url);
						url = visit_url("hiddencity.php?action=roundthing&whichitem="+to_int(stone));
						if (contains_text(url, "tristone.gif")) print("Successfully inserted "+stone+".");
						else abort("Error inserting '"+stone+"' into altar.");
					}
				}
			}
		}
		
		//Now find the smallish temple
		int i = 0;
		while (citymap[i] != "smallish temple" && i < 30) i = i + 1;
		if (i == 30) abort("Major problem locating the smallish temple!");
		print("BCC: The smallish temple is located at square " + i + ".  Going there...", "purple");
		
		//Visit the smallish temple and kill the protector spirit. 
		switch (my_primestat()) {
			case $stat[Muscle] :
				//This used to set the bandersnatch, but there's no real point. 
			break;
			
			case $stat[Moxie] :
				print("BCC: Off to fight the final protector spirit!", "purple");
			break;
		}
		visit_url("hiddencity.php?which=" + i);
		bumAdvUrl("hiddencity.php?action=trisocket");
		string url = visit_url("hiddencity.php?which="+i);
		if (index_of(bumRunCombat(), "WINWINWIN") == -1) abort("Failed to kill the last spectre!\n");
		
		print("BCC: Finished exploring the Hidden City.", "purple");
	}
	
	checkStage("macguffinhiddencity", true);
	return true;
}

boolean bcascMacguffinPalindome() {
	if (checkStage("macguffinpalin")) return true;
	
	while (contains_text(visit_url("questlog.php?which=1"), "Never Odd")) {
		while (contains_text(visit_url("questlog.php?which=1"), "Palindome") && item_amount(to_item("i love me")) == 0)
			bumAdv($location[Palindome], "+equip talisman o' nam", "hebo", "1 stunt nuts, 1 I Love Me Vol I", "Getting the 'I Love Me' from the Palindome", "", "consultHeBo"); 
		
		while (my_adventures() > 0 && contains_text(visit_url("questlog.php?which=1"), "Fats, but then you lost it"))
			bumAdv($location[Cobb's Knob Laboratory], "", "", "1 choiceadv", "Meeting Mr. Alarm", "-");
		
		while(contains_text(visit_url("questlog.php?which=1"), "lion oil, a bird rib, and some stunt nuts")) {
			while (item_amount($item[wet stunt nut stew]) < 1) {
				while (item_amount($item[wet stew]) == 0 && (item_amount($item[bird rib]) == 0 || item_amount($item[lion oil]) == 0)) {
					visit_url("guild.php?place=paco");
					bumAdv($location[whitey's grove], "", "items", "1 lion oil, 1 bird rib", "Getting the wet stew items from Whitey's Grove", "+i"); 
				}
				
				//Note that we probably already have the stunt nuts
				while (i_a("stunt nuts") == 0)
					bumAdv($location[Palindome], "", "items", "1 stunt nuts", "Getting the stunt nuts from the Palindome, which you should probably already have");
				create(1, $item[wet stunt nut stew]);
			}
			if (item_amount($item[wet stunt nut stew]) == 0) abort("Unable to cook up some tasty wet stunt nut stew.");
			
			//Get the Mega Gem
			while (i_a("mega gem") == 0 && my_adventures() > 0)
				bumMiniAdv(1, $location[laboratory]);
		}
		
		if (i_a("mega gem") == 0) abort("That's weird. You don't have the Mega Gem.");
		
		//Fight Dr. Awkward
		betweenBattle();
		cli_execute("conditions clear;");
		buMax("+equip Talisman o' Nam +equip Mega Gem");
		setFamiliar("meatboss");
		bumMiniAdv(1, $location[palindome]);
		if (item_amount($item[Staff of Fats]) == 0) abort("Looks like Dr. Awkward opened a can of whoop-ass on you. Try fighting him manually.");
	}
	
	checkStage("macguffinpalin", true);
	return true;
}

boolean bcascMacguffinPrelim() {
	if (checkStage("macguffinprelim")) return true;
	
	while (!black_market_available()) {
		if (i_a("sunken eyes") > 0 && i_a("broken wings") > 0) cli_execute("use reassembled blackbird");
		if (have_familiar($familiar[reassembled blackbird])) {
			bumAdv($location[Black Forest], "", "items", "1 black market map", "Finding the black market");
		} else {
			bumAdv($location[Black Forest], "", "items", "1 black market map, 1 sunken eyes, 1 broken wings", "Finding the black market");
		}
		use(1,$item[black market map]);
	}
	
	if (item_amount($item[your fathers macguffin diary]) == 0) {
		print("BCC: Obtaining and Reading the Diary", "purple");
		retrieve_item(1,$item[forged identification documents]);
		bumMiniAdv(1, to_location(to_string(my_primestat()) + " vacation"));
		use(1, $item[your fathers macguffin diary]);
	}
	
	while (!contains_text(visit_url("beach.php"),"oasis.gif")) {
		print("BCC: Revealing the Oasis", "purple");
		bumAdv($location[desert (unhydrated)], "", "hipster", "1 choiceadv", "Revealing the Oasis");
	}
	
	while (!contains_text(visit_url("woods.php"),"hiddencity.gif")) {
		setFamiliar("hipster");
		bumAdv($location[hidden temple], "", "hipster", "1 choiceadv", "Getting another ChoiceAdv to open the Temple");
	}
	
	//At this point, Zarqon opens up the bedroom. But I'd like to do this earlier. 
	//Setting an abort() here to make sure we can get in. 
	if (item_amount($item[ballroom key]) == 0) abort("You'll need to open the Ballroom");
	while (!contains_text(visit_url("manor.php"),"sm8b.gif")) {
		print("BCC: Opening the Spookyraven Cellar", "purple");
		bumMiniAdv(my_adventures(), $location[haunted ballroom]);
		betweenBattle();
	}

	boolean needFledges() { return my_primestat() != $stat[Moxie]; }
	boolean canEquipFledges() { return my_basestat($stat[Mysticality]) >= 60; }

	while (needFledges() && !canEquipFledges()) {
		//Gotta level somewhere, don't we?
		bumAdv($location[Haunted Bathroom], "", "", "60 mysticality", "Getting 60 myst to equip the fledges");
	}
	if (cli_execute("use 2 gaudy key")) {}
	if (cli_execute("make talisman o nam")) {}
	while (i_a("Talisman o' Nam") == 0) {
		//We will almost certainly have the fledges equipped due to maximizing our Moxie. We re-equip them if we don't have them. 
		string maxme = canEquipFledges() ? "+equip pirate fledges" : "+outfit swash";
		if (!contains_text(visit_url("cove.php"), "cove3_5x2b.gif")) bumAdv($location[Poop Deck], maxme, "", "", "Opening Belowdecks");
		bumAdv($location[Belowdecks], maxme, "", "2 gaudy key", "Getting the Talisman");
		if (cli_execute("use 2 gaudy key")) {}
		if (cli_execute("make talisman o nam")) {}
	}
	
	checkStage("macguffinprelim", true);
	return true;
}

boolean bcascMacguffinSpooky() {
	if (checkStage("macguffinspooky")) return true;
	
	if (contains_text(visit_url("questlog.php?which=1"),"Spooking")) {
		if (!contains_text(visit_url("questlog.php?which=1"),"secret black magic laboratory")) {
			//Get the Spectacles if you don't have them already. 
			if (i_a("Lord Spookyraven's spectacles") == 0) {
				//Correctly set Ornate Nightstand
				set_property("choiceAdventure84", 3);
				bumAdv($location[Haunted Bedroom], "", "", "Lord Spookyraven's spectacles", "Getting the Spectacles");
			}
			
			//Refresh dusty bottle information.
			cli_execute("dusty");
			
			cli_execute("equip lord spookyraven's spec");
			string[int] blar = split_string(visit_url("manor3.php?place=goblet"),"/otherimages/manor/glyph");
			if (count(blar) != 4) abort("Error parsing wine puzzle.");
			
			//Straight from Zarqon. I have really no idea how this works. 
			item get_this_wine(int wine_no) {
				for i from 2271 to 2276
					if (get_property("lastDustyBottle"+i) == wine_no) {
						return to_item(i);
					}
				return $item[none];
			}
			
			//Actually get the wines.
			item[int] wines;
			for i from 1 to 3 {
				wines[i] = get_this_wine(to_int(substring(blar[i],0,1)));
			}
			if (cli_execute("friars booze")) {}
			bumAdv($location[Haunted Wine Cellar (Automatic)], "", "items", "1 "+wines[1]+", 1 "+wines[2]+", 1 "+wines[3], "Getting the three wines ("+wines[1]+", "+wines[2]+", "+wines[3]+")");
			
			if (equipped_amount($item[Lord Spookyraven's spectacles]) > 0 || equip($slot[acc3],$item[Lord Spookyraven's spectacles])) {}
			//Pour the wines
			for i from 1 to 3 {
				blar[1] = visit_url("manor3.php?action=pourwine&whichwine="+to_int(wines[i]));
				print("BCC: Pouring Wine "+wines[i], "purple");
				if (!contains_text(blar[1],"glow more brightly") && !contains_text(blar[1],"reveal a hidden passage")) abort("Problem with pouring the wines");
			}
		}
		
		if (contains_text(visit_url("manor3.php"), "chambera.gif")) {
			buMax();
			print("BCC: Fighting Spookyraven", "purple");
			restore_hp(my_maxhp());
			betweenBattle();
			if (have_skill($skill[Elemental Saucesphere])) {
				cli_execute("cast Elemental Saucesphere");
			} else {
				cli_execute("use can of black paint");
			}
			//The below is "just in case" we haven't done the trapper's cold bit yet. It doesn't harm anyone to hit trapper.php here.
			visit_url("trapper.php");
			setFamiliar("meatboss");
			visit_url("manor3.php?place=chamber");
			bumRunCombat();
			if (item_amount($item[eye of ed]) == 0) abort("The Spooky man pwned you with his evil. Fight him yourself.");
		}
	}
	
	checkStage("macguffinspooky", true);
	return true;
}

boolean bcascMacguffinPyramid() {
	if (checkStage("macguffinpyramid")) return true;
	
	if (!contains_text(visit_url("questlog.php?which=1"),"A Pyramid Scheme") || contains_text(visit_url("questlog.php?which=1"),"found the little pyramid") || contains_text(visit_url("questlog.php?which=1"),"found the hidden buried pyramid")) {
		//We've done the pyramid
	} else {
		while (contains_text(visit_url("questlog.php?which=1"),"your desert explorations"))
			bumAdv($location[desert (ultrahydrated)], "", "", "", "Meeting Gnasir for the First Time");
		
		while ((contains_text(visit_url("questlog.php?which=1"), "stone rose") && i_a("stone rose") == 0) || i_a("drum machine") == 0)
			bumAdv($location[Oasis], "", "items", "1 drum machine, 1 stone rose", "Getting the stone rose and/or drum machine");
		
		print("BCC: Turning in the stone rose", "purple");
		while (item_amount($item[stone rose]) > 0) {
			if (i_a("can of black paint") == 0) {
				if (my_meat() < 1000) abort("You need 1000 meat for a can of black paint");
				cli_execute("buy can of black paint");
			}
			bumMiniAdv(1, $location[desert (ultrahydrated)]);
		}
		
		//This part deals with meeting Gnasir for the second time and/or using the black paint if you didn't do it the first time. 
		while ((contains_text(visit_url("questlog.php?which=1"), "prove your honor and dedication")) || contains_text(visit_url("questlog.php?which=1"), "Gnasir seemed satisfied")) {
			if (i_a("can of black paint") == 0 && contains_text(visit_url("questlog.php?which=1"), "prove your honor and dedication")) {
				cli_execute("buy can of black paint");
			}
			print("BCC: Painting Gnasir's Door", "purple");
			bumMiniAdv(1, $location[desert (ultrahydrated)]);
		}
		
		//Now we need the worm riding manual. So get it.
		if (i_a("worm-riding manual pages 3-15") == 0) {
			if (contains_text(visit_url("questlog.php?which=1"), "worm-riding manual") || contains_text(visit_url("questlog.php?which=1"), "missing manual pages"))
				bumAdv($location[Oasis], "", "", "worm-riding manual pages 3-15", "Getting the pages of the worm-riding manual");
		}
		
		while (contains_text(visit_url("questlog.php?which=1"), "found all of Gnasir's missing manual pages"))
			bumAdv($location[desert (ultrahydrated)], "", "", "worm-riding hooks", "Giving Gnasir his pages back");
		
		if (item_amount($item[worm-riding hooks]) == 0) abort("Unable to get worm-riding hooks.");
		cli_execute("checkpoint; equip worm-riding hooks; use drum machine; outfit checkpoint");
	}
	
	checkStage("macguffinpyramid", true);
	return true;
}

boolean bcascManorBedroom() {
	if (checkStage("manorbedroom")) return true;
	set_property("choiceAdventure82", "1"); //White=Wallet
	set_property("choiceAdventure83", "1"); //Mahog=Coin Purse
	set_property("choiceAdventure84", "3"); //Ornate=Spectacles
	set_property("choiceAdventure85", "5"); //Wooden=Key
	if (contains_text(visit_url("manor2.php"), "?place=ballroom")) {
		while (i_a("Spookyraven ballroom key") == 0) {
			bumAdv($location[Haunted Bedroom], "", "", "Spookyraven ballroom key", "Getting the Ballroom Key", "-", "consultRunaway");
		}
		while (i_a("Lord Spookyraven's spectacles") == 0) {
			bumAdv($location[Haunted Bedroom], "", "", "Lord Spookyraven's spectacles", "Getting Lord Spookyraven's spectacles", "-", "consultRunaway");
		}
	}
	checkStage("manorbedroom", true);
	return true;
}

boolean bcascManorBilliards() {
	if (checkStage("manorbilliards")) return true;
	//Billiards Room
	while (item_amount($item[Spookyraven library key]) == 0) {
		while (i_a("pool cue") == 0) {
			bumAdv($location[Haunted Billiards Room], "+100000 elemental dmg", "", "1 pool cue", "Getting the Pool Cue");
		}
		
		print("BCC: Getting the Key", "purple");
		while (item_amount($item[Spookyraven library key]) == 0) {
			if (i_a("handful of hand chalk") > 0 || have_effect($effect[Chalky Hand]) > 0) {
				if (my_adventures() == 0) abort("No adventures."); 
				print("BCC: We have either a hand chalk or Chalky Hands already, so we'll use the hand chalk (if necessary) and play some pool!", "purple");
				if (i_a("handful of hand chalk") > 0 && have_effect($effect[Chalky Hand]) == 0) {
					use(1, $item[handful of hand chalk]);
				}
				cli_execute("goal clear");
				cli_execute("goal set 1 Spookyraven library key");
				buMax();
				if (bumMiniAdv(have_effect($effect[Chalky Hand]), $location[Haunted Billiards Room])) {}
			} else {
				bumMiniAdv(1, $location[Haunted Billiards Room]);
			}
		}
	}
	checkStage("manorbilliards", true);
	return true;
}

boolean bcascManorLibrary() {
	if (checkStage("manorlibrary")) return true;
	set_property("choiceAdventure80", "2"); //(Rise) - this always needs to be set. It's Fall that has the conservatory adventure.
	set_property("choiceAdventure87", "2");  //(Read Fall) - May as well always set this to read Chapter 2.
	
	if (my_primestat() == $stat[Muscle]) {
		//If you're a muscle class, then you'll need to open the conservatory. It's an auto-stop.
		while (get_property("lastGalleryUnlock") != my_ascensions()) {
			set_property("choiceAdventure81", "1"); //(Fall) Get the Gallery adventure.
			bumAdv($location[Haunted Library], "", "", "1 choiceadv", "Unlocking the Gallery Adventure thingymajig", "-");
		}
		while (contains_text(visit_url("manor.php"), "place=gallery")) {
			bumAdv($location[Haunted Conservatory], "", "", "1 Spookyraven Gallery Key", "Getting the Gallery Key", "-");
		}
	}
	
	//Open up the second floor of the manor. 
	set_property("choiceAdventure81", "99"); //(Fall)
	while (index_of(visit_url("manor.php"), "place=stairs") + index_of(visit_url("manor.php"), "sm2b.gif") > 0) {
		bumAdv($location[Haunted Library], "", "", "1 choiceadv", "Opening Second floor of the Manor", "-");
	}
	checkStage("manorlibrary", true);
	return true;
}

boolean bcascMeatcar() {
	if (checkStage("meatcar")) return true;
	//Degrassi Knoll. Like the billiards room, we don't have to check Mox here. 
	//It's before the boss bat so we can set the MCD.
	if (item_amount($item[bitchin' meatcar]) + item_amount($item[pumpkin carriage]) + item_amount($item[desert bus pass]) == 0) {
		print("BCC: Getting the Meatcar", "purple");
		//Gotta hit up paco.
		visit_url("guild.php?place=paco");
		if (item_amount($item[sweet rims]) + item_amount($item[dope wheels]) == 0)
			cli_execute("hermit sweet rims");
		
		if (!in_muscle_sign()) {
			print("BCC: Making the meatcar, getting the stuff from the Gnolls. Damned Gnolls...", "purple");
            visit_url("forestvillage.php?action=screwquest&submit=&quot;Sure Thing.&quot;");
			buMax();
			use(item_amount($item[gnollish toolbox]), $item[gnollish toolbox]);
			while (creatable_amount($item[bitchin' meatcar]) == 0) {
				use(item_amount($item[gnollish toolbox]), $item[gnollish toolbox]);
				if (my_adventures() == 0) abort("No Adventures");
				bumMiniAdv(1, $location[Degrassi Knoll]);
			}
		}
		cli_execute("make meatcar");
		visit_url("guild.php?place=paco");
	}
	checkStage("meatcar", true);
	return true;
}

//Thanks, picklish!
boolean bcascMining() {
	if (checkStage("mining")) return true;

	string trapper = visit_url("trapper.php");
	if (my_level() >= 8 && !contains_text(trapper, "I reckon 3 chunks")) {
		print("Looks like we're done mining.", "purple");
		checkStage("mining", true);
		return true;
	}

	if (!have_outfit("mining gear"))
		return false;

	string goalString = get_property("trapperOre");
	item goal = to_item(goalString);

	if (goal != $item[asbestos ore] && goal != $item[chrome ore] && goal != $item[linoleum ore])
		abort("Can't figure out which ore to look for.");

	// Seed ore locations with what mafia knows about.
	int[int] oreLocations;
	string mineLayout = get_property("mineLayout1");
	int start = 0;
	while (true) {
		int num_start = index_of(mineLayout, '#', start);
		if (num_start == -1) break;
		int num_end = index_of(mineLayout, '<', num_start);
		if (num_end == -1) break;
		int end = index_of(mineLayout, '>', num_end);
		if (end == -1) break;

		if (contains_text(substring(mineLayout, num_end, end), goalString)) {
			int spot = to_int(substring(mineLayout, num_start + 1, num_end));
			oreLocations[count(oreLocations)] = spot;
		}
		start = end;
	}

	boolean rowContainsEmpty(string mine, int y) {
		for x from 1 to 6 {
			if (contains_text(mine, "Open Cavern (" + x + "," + y + ")"))
				return true;
		}

		return false;
	}

	boolean canMine(string mine, int x, int y, boolean onlySparkly) {
		if (x < 0 || x > 7 || y < 0 || y > 7) return false;
		int index = x + y * 8; 
		boolean clickable = (index_of(mine, "mining.php?mine=1&which=" + index + "&") != -1);

		if (!clickable || !onlySparkly) return clickable;

		return contains_text(mine, "Promising Chunk of Wall (" + x + "," + y + ")");
	}

	int adjacentSparkly(string mine, int index) {
		int x = index % 8;
		int y = index / 8;

		if (canMine(mine, x, y - 1, true)) return index - 8;
		if (canMine(mine, x - 1, y, true)) return index - 1;
		if (canMine(mine, x + 1, y, true)) return index + 1;
		if (canMine(mine, x, y + 1, true)) return index + 8;
		return - 1;
	}

	int findSpot(string mine, boolean[int] rows, boolean[int] cols) {
		foreach sparkly in $booleans[true, false] {
			foreach y in cols {
				foreach x in rows {
					if (canMine(mine, x, y, sparkly))
						return x + y * 8;
				}
			}
		}
		return -1;
	}

	cli_execute("outfit mining");

	while (item_amount(goal) < 3) {
		if (my_hp() == 0) cli_execute("restore hp");
		string mine = visit_url("mining.php?intro=1&mine=1");

		if (contains_text(mine, "You can't mine without the proper equipment.")) abort("Couldn't equip mining gear.");

		boolean willCostAdventure = contains_text(mine, "takes one Adventure.");
		if (have_skill($skill[Unaccompanied Miner]) && willCostAdventure && have_effect($effect[Teleportitis]) == 0 && my_level() < 12) {
			if (get_property("bcasc_MineUnaccOnly").to_boolean()) {
				print("BCC: No more mining today. I'll come back later.", "purple");
				return false;
			}
		}
		if (my_adventures() == 0 && willCostAdventure) abort("No Adventures");

		int choice = -1;
		string why = "Mining around found ore";
		// Ore is always coincident, so look nearby if we've aleady found some.
		if (count(oreLocations) > 0) {
			foreach key in oreLocations {
				choice = adjacentSparkly(mine, oreLocations[key]);
				if (choice != -1)
					break;
			}
		}

		// Prefer mining the middle first.  It leaves more options.
		boolean[int] rows = $ints[3, 4, 2, 5, 1, 6];

		// First, try to mine up to the top four rows if we haven't yet.
		if (choice == -1 && !rowContainsEmpty(mine, 6)) {
			choice = findSpot(mine, rows, $ints[6]);
			why = "Mining upwards";
		} 

		if (choice == -1 && !rowContainsEmpty(mine, 5)) {
			choice = findSpot(mine, rows, $ints[5]);
			why = "Mining upwards";
		}
				
		// Top three rows contain most ore.  Fourth row may contain ore.
		// Prefer second row and digging towards the middle because it
		// opens up the most potential options.  This could be more
		// optimal, but it's not a bad heuristic.
		if (choice == -1) {
			choice = findSpot(mine, rows, $ints[2, 3, 1, 4]);
			why = "Mining top four rows";
		}

		// There's only four pieces of the same ore in each mine.
		// Maybe you accidentally auto-sold them or something?
		if (choice == -1 || count(oreLocations) == 4) {
			print("BCC: Resetting mine!", "purple");
			visit_url("mining.php?mine=1&reset=1&pwd");
			oreLocations.clear();
			continue;
		}

		print(why + ": " + (choice % 8) + ", " + (choice / 8) + ".", "purple");
		string result = visit_url("mining.php?mine=1&which=" + choice + "&pwd");
		if (index_of(result, goalString) != -1) {
			oreLocations[count(oreLocations)] = choice;
		}
	}

	if (have_effect($effect[Beaten Up]) > 0) cli_execute("unaffect beaten up");
	visit_url("trapper.php");

	checkStage("mining", true);
	return true;
}

boolean bcascNaughtySorceress() {
	if (contains_text(visit_url("main.php"), "lair.php")) {
		//Get through the initial three doors. 
		while (!contains_text(visit_url("lair1.php"), "lair2.php")) {
			bcascLairFirstGate();
		}
		
		//Now try to get through the rest of the entryway.
		bcascLairMariachis();
		
		//Get through the hedge maze. Though we'll only ever spend one adventure at a time here, we use bumAdv for moxie maximiazation. 
		while (!contains_text(visit_url("lair3.php"), "lair4.php")) {
			bumAdv($location[Hedge Maze], "", "items", "1 hedge maze puzzle", "Getting another Hedge Maze");
			if (hedgemaze()) {}
		}
		
		while (!contains_text(visit_url("lair4.php"), "lair5.php")) {
			bcascLairTower();
		}
		
		while (!contains_text(visit_url("lair5.php"), "lair6.php")) {
			bcascLairTower();
		}
		
		while (!contains_text(visit_url("lair6.php"), "?place=5")) {
			bcascLairTower();
		}
		
		
		bcascLairFightNS();
	} else {
		abort("There is some error and you don't appear to be able to access the lair...");
	}
}

boolean bcascPantry() {
	if (checkStage("pantry")) return true;
	while (contains_text(visit_url("town_right.php"), "pantry.gif")) {
		bumAdv($location[Haunted Pantry], "", "", "", "Let's open the Pantry");
	}
	checkStage("pantry", true);
	return true;
}

boolean bcascPirateFledges() {
	boolean hitTheBarrr = false;
	if (checkStage("piratefledges")) return true;
	
	while (i_a("pirate fledges") == 0) {
		buMax("+outfit swash");
		
		//The Embarassed problem is only an issue if you're a moxie class. Otherwise, ignore it.
		if (my_primestat() == $stat[Moxie]) {
			cli_execute("speculate up Embarrassed; quiet");
			int safeBarrMoxie = 93;
			int specMoxie = 0;
			while (!hitTheBarrr) {
				specMoxie = numeric_modifier("_spec", "Buffed Moxie");
				if (specMoxie > safeBarrMoxie) { hitTheBarrr = true; }
				if (!hitTheBarrr) { levelMe(my_basestat($stat[Moxie])+3, true); }
			}
			
			setMCD(specMoxie, safeBarrMoxie);
		} else {
			cli_execute("mcd 0");
			levelMe(93, false);
		}
		
		buMax("+outfit swash");
		//Check if we've unlocked the f'c'le at all.
		if (index_of(visit_url("cove.php"), "cove3_3x1b.gif") == -1) {
			buMax("+outfit swash");
			setFamiliar("");
			setMood("i");
			
			if (i_a("the big book of pirate insults") == 0) {
				buy(1, $item[the big book of pirate insults]);
			}
			
			cli_execute("conditions clear");
			//Have we been given the quest at all?
			while (!contains_text(visit_url("questlog.php?which=1"), "I Rate, You Rate")) {
				if (my_adventures() == 0) { abort("You're out of adventures."); }
				print("BCC: Adventuring once at a time to meet the Cap'm for the first time.", "purple");
				bumMiniAdv(1, $location[Barrrney's Barrr], "consultBarrr");
			}
			
			//Check whether we've completed the beer pong quest.
			if (index_of(visit_url("questlog.php?which=1"), "Caronch has offered to let you join his crew") > 0) {
				print("BCC: Getting and dealing with the Cap'm's Map.", "purple");
				
				if (i_a("Cap'm Caronch's Map") == 0)
					bumAdv($location[Barrrney's Barrr], "+outfit swash", "", "1 Cap'm Caronch's Map", "", "Getting the Cap'm's Map", "consultBarrr");
				
				//Use the map and fight the giant crab.
				if (i_a("Cap'm Caronch's Map") > 0) {
					print("BCC: Using the Cap'm's Map and fighting the Giant Crab", "purple");
					use(1, $item[Cap'm Caronch's Map]);
					bumRunCombat();
					if (have_effect($effect[Beaten Up]) > 0) abort("Uhoh. Please use the map and fight the crab manually.");
				} else {
					abort("For some reason we don't have the map even though we should have.");
				}
			}
			
			//If we have the booty, we'll need to get the map.
			if (i_a("Cap'm Caronch's nasty booty") > 0)
				bumAdv($location[Barrrney's Barrr], "+outfit swash", "", "1 Orcish Frat House blueprints", "Getting the Blueprints", "", "consultBarrr");
			
			//Now, we'll have the blueprints, so we'll need to make sure we have 8 insults before using them. 
			while (numPirateInsults() < 7) {
				print("BCC: Adventuring one turn at a time to get 7 insults. Currently, we have "+numPirateInsults()+" insults.", "purple");
				if (my_adventures() == 0) { abort("You're out of adventures."); }
				bumMiniAdv(1, $location[Barrrney's Barrr], "consultBarrr");
			}
			
			print("BCC: Currently, we have "+numPirateInsults()+" insults. This is enough to continue with beer pong.", "purple");
			
			//Need to use the blueprints.
			if (index_of(visit_url("questlog.php?which=1"), "Caronch has given you a set of blueprints") > 0) {
				if ((in_muscle_sign() || i_a("frilly skirt") > 0)) {
					if (item_amount($item[hot wing]) < 3) {
						bumAdv($location[pandamonium slums], "", "items", "3 hot wing", "Getting 3 hot wings for the blueprints", "+i");
					}

					print("BCC: Using the skirt and hot wings to burgle the Frat House...", "purple");
					cli_execute("checkpoint");
					cli_execute("equip frilly skirt");
					visit_url("inv_use.php?which=3&whichitem=2951&pwd");
					visit_url("choice.php?whichchoice=188&option=3&choiceform3=Catburgle&pwd");
					cli_execute("outfit checkpoint");
				} else if(i_a("Orcish baseball cap") > 0 && i_a("homoerotic frat-paddle") > 0 && i_a("Orcish cargo shorts") > 0) {
					print("BCC: Using the Frat Outfit to burgle the Frat House...", "purple");
					cli_execute("checkpoint");
					cli_execute("outfit frat boy");
					visit_url("inv_use.php?which=3&whichitem=2951&pwd");
					visit_url("choice.php?whichchoice=188&option=1&choiceform1=Catburgle&pwd");
					cli_execute("outfit checkpoint");
				} else if(i_a("mullet wig") > 0 && i_a("briefcase") > 0) {
					print("BCC: Using the mullet wig and briefcase to burgle the Frat House...", "purple");
					cli_execute("checkpoint");
					cli_execute("equip mullet wig");
					visit_url("inv_use.php?which=3&whichitem=2951&pwd");
					visit_url("choice.php?whichchoice=188&option=2&choiceform2=Catburgle&pwd");
					cli_execute("outfit checkpoint");
				} else {
					abort("Please use the blueprints. I was not able to use them automatically, unfortunately :(");
				}
			}
			
			if (i_a("Cap'm Caronch's dentures") > 0) {
				cli_execute("outfit swash");
				print("BCC: Giving the dentures back to the Cap'm.", "purple");
				while (available_amount($item[Cap'm Caronch's dentures]) > 0) bumMiniAdv(1, $location[Barrrney's Barrr]);
			}
			
			print("BCC: Now going to do the beer pong adventure. This is HIGHLY experimental. Pausing to let you read this.", "purple");
			wait(5);
			
			while (my_adventures() > 0) {
				if (tryBeerPong().contains_text("victory laps")) {
					break;					
				}
			}
		}
		
		
		//When we get to here, we've unlocked the f'c'le. We must assume the user hasn't used the mop, polish or shampoo.
		bumAdv($location[F'c'le], "+outfit swash", "items", "1 pirate fledges", "Getting the Pirate Fledges, finally!", "+i");
	}
	checkStage("piratefledges", true);
	return true;
}

boolean bcascSpookyForest() {
	if (checkStage("spookyforest")) return true;
	while (contains_text(visit_url("questlog.php?which=1"), "bring them a mosquito larva")) {
		set_property("choiceAdventure502", "2");
		set_property("choiceAdventure505", "1");
		bumAdv($location[Spooky Forest], "", "", "1 choiceadv", "Let's get the mosquito");
		visit_url("council.php");
	}
	
	if (!contains_text(visit_url("woods.php"), "temple.gif")) {
		while (item_amount($item[spooky temple map]) + item_amount($item[tree-holed coin]) == 0) {
			set_property("choiceAdventure502", "2");
			set_property("choiceAdventure505", "2");
			bumAdv($location[Spooky Forest], "", "", "1 choiceadv", "Let's get a Tree-Holed Coin");
		}
		
		while (item_amount($item[spooky temple map]) == 0) {
			set_property("choiceAdventure502", "3");
			set_property("choiceAdventure506", "3");
			set_property("choiceAdventure507", "1");
			bumAdv($location[Spooky Forest], "", "", "1 choiceadv", "Let's get the map");
		}
		
		while (item_amount($item[spooky-gro fertilizer]) == 0) {
			set_property("choiceAdventure502", "3");
			set_property("choiceAdventure506", "2");
			bumAdv($location[Spooky Forest], "", "", "1 choiceadv", "Let's get the fertilizer");
		}
		
		while (item_amount($item[spooky sapling]) == 0) {
			cli_execute("mood execute");
			if (contains_text(visit_url("adventure.php?snarfblat=15"), "Combat")) {
				bumRunCombat();
			} else {
				visit_url("choice.php?whichchoice=502&option=1&pwd="+my_hash());
				visit_url("choice.php?whichchoice=503&option=3&pwd="+my_hash());
				if (item_amount($item[bar skin]) > 0) visit_url("choice.php?whichchoice=504&option=2&pwd="+my_hash());
				visit_url("choice.php?whichchoice=504&option=3&pwd="+my_hash());
				visit_url("choice.php?whichchoice=504&option=4&pwd="+my_hash());
			}
		}
		
		print("Using Spooky Temple Map", "blue");
		use(1, $item[spooky temple map]);
	}
	checkStage("spookyforest", true);
	return true;
}

//Thanks, picklish!
boolean bcascTavern() {
    if (checkStage("tavern")) return true;
	if (!checkStage("spookyforest")) return false;
	
	
	boolean checkComplete() {
		if (contains_text(visit_url("questlog.php?which=2"), "solved the rat problem")) {
			checkStage("tavern", true);
			return true;
		} else {
			return false;
		}
	}

	if (checkComplete()) return true;

	setFamiliar("");
	cli_execute("mood execute");
	levelMe(19, false);
	if (canMCD()) cli_execute("mcd 0");
	visit_url("tavern.php?place=barkeep");
	setMood("");
	buMax();
	
	//Re-get the current tavern layout.
	visit_url("cellar.php");

	
	while (!get_property("tavernLayout").contains_text("3")) {
		if (my_adventures() == 0) abort("No adventures.");
		tavern();
	}
	visit_url("rats.php?action=faucetoff");
	visit_url("tavern.php?place=barkeep");
	visit_url("tavern.php?place=barkeep");

	return checkComplete(); 
}

boolean bcascTeleportitisBurn() {
	if (have_effect($effect[Teleportitis]) == 0) return true;
	print("BCC: Burning off teleportitis", "purple");
	// Burn it off on shore adventures.
	if (get_property("telescopeUpgrades") >= 7) {
		if (cli_execute("telescope look low")) {}
		string shore = get_property("telescope7");
		location vacation;
		item goal;
		if (contains_text(shore, "horns")) {
			vacation = $location[moxie vacation];
			goal = $item[barbed-wire fence];
		} else if (contains_text(shore, "beam")) {
			vacation = $location[muscle vacation];
			goal = $item[stick of dynamite];
		} else if (contains_text(shore, "stinger")) {
			vacation = $location[mysticality vacation];
			goal = $item[tropical orchid];
		} else {
			abort("Internal error.  Couldn't sort out telescope text.");
		}
		if (item_amount(goal) == 0)
			bumMiniAdv(1, vacation);
	}
	if (have_effect($effect[Teleportitis]) == 0) return true;
	bcascMining();
	if (have_effect($effect[Teleportitis]) == 0) return true;
	bcascDailyDungeon();
	if (have_effect($effect[Teleportitis]) == 0) return true;
	bumMiniAdv(have_effect($effect[Teleportitis]), $location[Haunted Kitchen]);
	return true;
}

boolean bcascTelescope() {
	if (get_property("bcasc_telescope") != "true") return false;
	if (checkStage("lair2")) return false;

	record lair { 
		string loc;
		string a;
		string thing;
		string section;
	};
	
	lair [string] telescope;
	lair level;
	string telescopetext;
	telescope["catch a glimpse of a flaming katana"] 					= new lair("Ninja Snowmen", "a ", "frigid ninja stars", "trapper");
	telescope["catch a glimpse of a translucent wing"] 					= new lair("Sleazy Back Alley", "a ", "spider web", "");
	telescope["see a fancy-looking tophat"] 							= new lair("Guano Junction", "a ", "sonar-in-a-biscuit", "bats1");
	//telescope["see a flash of albumen"] 								= new lair("Black Forest", "", "black pepper", "macguffinprelim");
	telescope["see a giant white ear"] 									= new lair("Hidden City", "a ", "pygmy blowgun", "macguffinhiddencity");
	telescope["see a huge face made of Meat"] 							= new lair("Orc Chasm", "a ", "meat vortex", "chasm");
	telescope["see a large cowboy hat"] 								= new lair("Giant's Castle", "a ", "chaos butterfly", "castle");
	telescope["see a periscope"] 										= new lair("Fantasy Airship", "a ", "photoprotoneutron torpedo", "airship");
	telescope["see a slimy eyestalk"] 									= new lair("Haunted Bathroom", "", "fancy bath salts", "manorbedroom");
	telescope["see a strange shadow"] 									= new lair("Haunted Library", "an ", "inkwell", "manorbilliards");
	//telescope["see moonlight reflecting off of what appears to be ice"] = new lair("", "", "hair spray");
	telescope["see part of a tall wooden frame"] 						= new lair("Harem", "a ", "disease", "knobking");
	telescope["see some amber waves of grain"]							= new lair("Desert (Ultrahydrated)", "a ", "bronzed locus", "macguffinpyramid");
	telescope["see some long coattails"] 								= new lair("Outskirts of the Knob", "a ", "Knob Goblin firecracker", "");
	//telescope["see some pipes with steam shooting out of them"] 		= new lair("Middle Chamber", "", "powdered organs", "macguffinfinal");
	telescope["see some sort of bronze figure holding a spatula"]		= new lair("Haunted Kitchen", "", "leftovers of indeterminate origin", "pantry");
	telescope["see the neck of a huge bass guitar"] 					= new lair("South of the Border", "a ", "mariachi G-string", "dinghy");
	//telescope["see what appears to be the North Pole"] 					= new lair("", "an ", "NG", "chasm");
	telescope["see what looks like a writing desk"] 					= new lair("Giant's Castle", "a ", "plot hole", "castle");
	telescope["see the tip of a baseball bat"] 							= new lair("Guano Junction", "a ", "baseball", "bats1");
	telescope["see what seems to be a giant cuticle"] 					= new lair("Haunted Pantry", "a ", "razor-sharp can lid", "");
	//telescope["see a pair of horns"] 									= new lair("Moxie Vacation", "", "barbed-wire fence", "dinghy");
	//telescope["see a formidable stinger"] 								= new lair("Mysticality Vacation", "a ", "tropical orchid", "dinghy");
	//telescope["see a wooden beam"] 										= new lair("Muscle Vacation", "a ", "stick of dynamite", "dinghy");
	
	telescope["an armchair"] 											= new lair("Hidden City", "", "pygmy pygment", "macguffinhiddencity");
	//telescope["a cowardly-looking man"] 								= new lair("", "a ", "wussiness potion", "ZZZZZZZZZZZZZZZZZZZ");
	//telescope["a banana peel"] 											= new lair("Next to that Barrel with Something Burning in it", "", "gremlin juice", "|||||ZZZZZZZZZZZZZZ");
	telescope["a coiled viper"] 										= new lair("Black Forest", "an ", "adder bladder", "macguffinprelim");
	telescope["a rose"] 												= new lair("Giant's Castle", "", "Angry Farmer candy", "castle");
	telescope["a glum teenager"] 										= new lair("Giant's Castle", "a ", "thin black candle", "castle");
	telescope["a hedgehog"] 											= new lair("Fantasy Airship", "", "super-spiky hair gel", "airship");
	telescope["a raven"] 												= new lair("Black Forest", "", "Black No. 2", "macguffinprelim");
	telescope["a smiling man smoking a pipe"] 							= new lair("Giant's Castle", "", "Mick's IcyVapoHotness Rub", "castle");
	
	if (get_property("telescopeUpgrades") >= 1) {
		if(get_property("lastTelescopeReset") != get_property("knownAscensions")) cli_execute("telescope");
		
		for i from get_property("telescopeUpgrades").to_int() downto 1 {
			telescopetext = get_property("telescope"+i);
			
			level = telescope[telescopetext];
		
			if (level.thing == "") {
				print("BCC: Not sure what you need for telescope part "+i, "purple");
			} else if (i_a(level.thing) > 0) {
				print("BCC: You have at least one "+level.thing+" for telescope part "+i, "purple");
			} else if (level.loc == "") {
				print("BCC: Need "+level.thing+" for telescope part "+i, "purple");
			} else if (get_property("bcasc_stage_"+level.section) == my_ascensions() || level.section == "") {
				bumAdv(to_location(level.loc), "", "items", "1 "+level.thing, "Getting "+level.a+level.thing+" for the NS tower because we have finished the stage '"+level.section+" in this script.");
			} else {
				print("BCC: You haven't completed the stage '"+level.section+"' for the "+level.thing+" for telescope part "+i, "purple");
			}
		}
	}
}

boolean bcascTrapper() {
	if (checkStage("trapper")) return true;

	visit_url("trapper.php");
	
	while (index_of(visit_url("trapper.php"), "reckon 3 chunks of") > 0) {
		if (i_a("miner's helmet") == 0 || i_a("7-Foot Dwarven mattock") == 0 || i_a("miner's pants") == 0) {
			if (have_effect($effect[Everything Looks Yellow]) > 0)
				return false;
			bumAdv($location[Itznotyerzitz Mine], "", "hebo", "1 miner's helmet, 1 7-Foot Dwarven mattock, 1 miner's pants", "Getting the Mining Outfit", "", "consultHeBo");
			visit_url("trapper.php");
		}
		cli_execute("outfit mining");
		if (!bcascMining()) {
			print("BCC: The script has stopped mining for ore, probably because you ran out of unaccomapnied miner adventures. We'll try again tomorrow.", "purple");
			return false;
		}
	}
	while (contains_text(visit_url("trapper.php"), "6 chunks of goat cheese")) {
		cli_execute("friars food");
		bumAdv($location[Goatlet], "", "items", "6 goat cheese", "Getting Goat Cheese", "i");
		visit_url("trapper.php");
		visit_url("trapper.php");
	}
	if (index_of(visit_url("trapper.php"), "you'll need some kind of protection from the cold") > 0) {
		if (have_skill($skill[Northern Exposure])) {
			print("BCC: Visiting the trapper with your passive skill Northern Exposure to get the quest done.", "purple");
			visit_url("trapper.php");
		} else if (have_familiar($familiar[Exotic Parrot]) && have_skill($skill[Amphibian Sympathy])) {
			print("BCC: Visiting the trapper with a parrot to get the quest done.", "purple");
			cli_execute("familiar parrot");
			visit_url("trapper.php");
			//We do this just in case there's a 100% familiar here, so we set it back immediately. 
			setFamiliar("items");
		} else {
			//Try to use the maximizer on this. 
			cli_execute("maximize cold res -tie");
			if (contains_text(visit_url("trapper.php"), "you'll need some kind of protection from the cold")) {
				print("BCC: You need some cold resistance for the trapper but you don't have it yet.", "purple");
			}
		}
	}
	if (index_of(visit_url("questlog.php?which=2"), "learned how to hunt Yetis") > 0) {
		checkStage("trapper", true);
		return true;
	}
}

boolean bcascToot() {
    if (checkStage("toot")) return true;
    visit_url("tutorial.php?action=toot");
    if (item_amount($item["letter from King Ralph XI"]) > 0) use(1, $item[letter from King Ralph XI]);
	
	if (get_property("bcasc_sellgems") == "true") {
		if (item_amount($item["pork elf goodies sack"]) > 0) use(1, $item[pork elf goodies sack]);
		foreach stone in $items[hamethyst, baconstone, porquoise] autosell(item_amount(stone), stone);
	}
	if (i_a("stolen accordion") == 0 && i_a("Rock and Roll Legend") == 0 && i_a("Squeezebox of the Ages") == 0 && i_a("The Trickster's Trikitixa") == 0) {
		print("BCC: Getting an Accordion before we start.", "purple");
		while (i_a("stolen accordion") == 0) use(1, $item[chewing gum on a string]);
	}
	
	//KoLMafia doesn't clear these on ascension.
	set_property("mineLayout1", "");
	set_property("trapperOre", "");
	set_property("bcasc_lastHermitCloverGet", "");
	set_property("bcasc_lastShieldCheck", "");

	checkStage("toot", true);
    return true;
}

boolean bcascWand() {
	if (checkStage("wand")) return true;

	//Before we do the next thing, let's just check for and use the dead mimic.
	if (i_a("dead mimic") > 0) cli_execute("use dead mimic; use * small box; use * large box");
	
	//Check for a wand. Any wand will do. 
	if (i_a("aluminum wand") + i_a("ebony wand") + i_a("hexagonal wand") + i_a("marble wand") + i_a("pine wand") == 0) {
		//Use the plus sign if we have it. Just in case someone's found the oracle but forgotten to use the plus sign.
		if (i_a("plus sign") > 0) { if (cli_execute("use plus sign")) {} }

		//Need at least 1000 meat for the oracle adventure.  Let's be safe and say 2000.
		if (my_meat() < 2000) {
			print("BCC: Waiting on the oracle until you have more meat.", "purple");
			return false;
		}
		
		//Check for the DoD image. 
		while (index_of(visit_url("dungeons.php"), "greater.gif") > 0) {
			//Then we need to check for the plus sign. 
			if (i_a("plus sign") == 0) {
				cli_execute("set choiceAdventure451 = 3");
				bumAdv($location[Greater-Than Sign], "", "itemsnc", "1 plus sign", "Getting the Plus Sign", "-");
			}
			while (have_effect($effect[Teleportitis]) == 0) {
				cli_execute("set choiceAdventure451 = 5");
				bumAdv($location[Greater-Than Sign], "", "itemsnc", "1 choiceadv", "Getting Teleportitis", "-");
			}
			cli_execute("set choiceAdventure3 = 3");
			bumMiniAdv(1, $location[Greater-Than Sign]);
			if (i_a("plus sign") > 0) { if (cli_execute("use plus sign")) {} }
		}
		
		if (have_effect($effect[Teleportitis]) > 0) bcascTeleportitisBurn();

		//Then we have to get the wand itself. Must have at least 5000 meat for this, so use 6000 for safety. 
		if (my_meat() > 6000) {
			cli_execute("set choiceAdventure25 = 2");
			bumAdv($location[Dungeons of Doom], "", "itemsnc", "1 dead mimic", "Getting a Dead Mimic", "-");
		} else {
			return false;
		}
	}
	if (i_a("dead mimic") > 0) cli_execute("use dead mimic");
	if (numOfWand() > 0) {
		checkStage("wand", true);
		return true;
	}
}

/********************************************************
* START THE FUNCTIONS CALLING THE ADVENTURING FUNCTIONS *
********************************************************/

//This is all the stuff to do in level 1.
boolean bcs1() {	
    bcascToot();
	bcascKnob();
	bcascPantry();
	levelMe(5, true);
}

void bcs2() {
	bcCouncil();
	
	//First, we should unlock the first guild challenge. Do a mainstat check, and remember the 1K Meat. 
	bcascGuild1();
	bcascSpookyForest();
	levelMe(8, true);
}

void bcs3() {
	bcCouncil();
	
	//First, we should unlock the second guild challenge. Do a mainstat check, and remember the 1K Meat. 
	bcascGuild2();
	
	//If we're an AT, we should make our Epic Weapon now. It'll be the best weapon for a long time. 
	bcascEpicWeapons();
	bcascTavern();
	
	levelMe(13, true);
}

void bcs4() {
	bcCouncil();
	bcascBats1();
	bcascMeatcar();
	bcascBats2();
	if (my_buffedstat($stat[Moxie]) > 35) bcasc8Bit();
	levelMe(20, true);
}

void bcs5() {
	bcCouncil();
	
	bcascKnobKing();
	bcascDinghyHippy();
	bcascManorBilliards();
	
	levelMe(29, true);
}

void bcs6() {
	bcCouncil();
	
	bcascFriars();
	//Setting a second call to this as we want the equipment before the steel definitely. 
	bcascKnobKing();
	bcascFriarsSteel();
	
	//Get the Swashbuckling Kit. The extra moxie boost will be incredibly helpful for the Cyrpt
	while ((i_a("eyepatch") == 0 || i_a("swashbuckling pants") == 0 || i_a("stuffed shoulder parrot") == 0) && i_a("pirate fledges") == 0) {
		bumAdv($location[Pirate Cove], "", "equipmentnc", "1 eyepatch, 1 swashbuckling pants, 1 stuffed shoulder parrot", "Getting the Swashbuckling Kit", "-i");
	}
	
	bcascManorLibrary();
	levelMe(40, true);
}

void bcs7() {
	bcCouncil();
	
	bcascCyrpt();
	bcascInnaboxen();
	bcascManorBedroom();
	
	levelMe(53, true);
}

void bcs8() {
	bcCouncil();
	bcascTrapper();
	bcascWand();
	bcascTrapper();
	bcascPirateFledges();
	bcascTrapper();
	
	levelMe(68, true);
}

void bcs9() {
	bcCouncil();
	bcascDailyDungeon();
	
	//Unlock the guild store if you're AT or myst
	if (my_class() == $class[Accordion Thief] || my_primestat() == $stat[Mysticality]) {
		while (contains_text(visit_url("guild.php?place=challenge"), "<form")) {
			print("BCC: Doing the guild tests to open the store.", "purple");
			if (my_adventures() == 0) abort("You are out of adventures.");
			visit_url("guild.php?action=chal");
		}
	}
	
	if (!checkStage("leaflet")) {
		if (cli_execute("leaflet")) {}
		if (item_amount($item[instant house]) > 0)
			use(1, $item[instant house]);
		if (i_a("giant pinky ring") > 0)
			checkStage("leaflet", true);
	}
	
	bcascChasm();
	
	levelMe(85, true);
}

void bcs10() {
	bcCouncil();
	
	bcascAirship();
	bcascCastle();
	
	levelMe(104, true);
}

void bcs11() {
	bcCouncil();
	
	bcascMacguffinPrelim();
	bcascMacguffinPalindome();
	bcascHoleInTheSky();
	bcascMacguffinSpooky();
	bcascMacguffinPyramid();
	bcascMacguffinHiddenCity();
	bcascMacguffinFinal();
	
	levelMe(125, true);
}

void bcs12() {
	boolean doSideQuest(string name) {
		print("BCC: Starting SideQuest '"+name+"'", "purple");
		
		//We have to have these functions outside the switch. I think.
		int estimated_advs() { return ceil((100000 - to_float(get_property("currentNunneryMeat"))) / (1000 + (10*meat_drop_modifier()))); }
		int numMolyItems() { return item_amount($item[molybdenum hammer]) + item_amount($item[molybdenum crescent wrench]) + item_amount($item[molybdenum pliers]) + item_amount($item[molybdenum screwdriver]); }
		string visit_yossarian() {
			print("BCC: Visiting Yossarian...", "purple");
			if (cli_execute("outfit "+bcasc_warOutfit)) {}
			return visit_url("bigisland.php?action=junkman&pwd=");
		}
		
		switch (name) {
			case "arena" :
				if (get_property("sidequestArenaCompleted") != "none") return true;
				print("BCC: doSideQuest(Arena)", "purple");
				
				//First, either get the flyers or turn in the 10000ML if needed, then check if it's complete. 
				cli_execute("outfit "+bcasc_warOutfit);
				if (get_property("flyeredML").to_int() > 9999 || item_amount($item[jam band flyers]) + item_amount($item[rock band flyers]) == 0) visit_url("bigisland.php?place=concert&pwd=");
				cli_execute("outfit "+bcasc_warOutfit);
				if (get_property("sidequestArenaCompleted") != "none") return true;
				if (item_amount($item[jam band flyers]) + item_amount($item[rock band flyers]) == 0) abort("There was a problem acquiring the flyers for the Arena quest.");
				
				print("BCC: Finding the GMoB to flyer him...", "purple");
				set_property("choiceAdventure105","3");     // say "guy made of bees"
				while (to_int(get_property("guyMadeOfBeesCount")) < 5 && get_property("flyeredML").to_int() < 10000) {
					bumAdv($location[Haunted Bathroom], "", "", "1 choiceadv", "You need to say 'Guy made of bees' "+(5-to_int(get_property("guyMadeOfBeesCount")))+" more times.", "-", "consultGMOB");
				}
				
				cli_execute("outfit "+bcasc_warOutfit);
				visit_url("bigisland.php?place=concert&pwd=");
				visit_url("bigisland.php?place=concert&pwd=");
			break;
			
			case "beach" :
				if (get_property("sidequestLighthouseCompleted") != "none") return true;
				print("BCC: doSideQuest(Beach)", "purple");
				if (i_a("barrel of gunpowder") < 5) bumAdv($location[Wartime Sonofa Beach], "", "items", "5 barrel of gunpowder", "Getting the Barrels of Gunpowder", "+");
				cli_execute("outfit "+bcasc_warOutfit);
				visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");
				visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");
				return (get_property("sidequestLighthouseCompleted") != "none");
			break;
			
			case "dooks" :
				if (get_property("sidequestFarmCompleted") != "none") return true;
				print("BCC: doSideQuest(Dooks)", "purple");
				cli_execute("outfit "+bcasc_warOutfit);
				set_property("choiceAdventure147","3");
				set_property("choiceAdventure148","1");
				set_property("choiceAdventure149","2");
				
				visit_url("bigisland.php?place=farm&action=farmer&pwd=");
				
				//Use a chaos butterfly against a generic duck
				if (i_a("chaos butterfly") > 0) {
					string url;
					boolean altered = false;
					repeat {
						url = bumAdvUrl("adventure.php?snarfblat=137");
						if (contains_text(url, "Combat")) {
							throw_item($item[chaos butterfly]);
							altered = true;
							bumRunCombat();
						} else  {
							bumMiniAdv(1,$location[barn]);
						}
					} until (altered || contains_text(url,"no more ducks here."));
					
					if (altered) bumAdv($location[barn]);
				}
				bumAdv($location[pond]);
				bumAdv($location[back 40]);
				bumAdv($location[other back 40]);
				
				cli_execute("outfit "+bcasc_warOutfit);
				visit_url("bigisland.php?place=farm&action=farmer&pwd=");
				visit_url("bigisland.php?place=farm&action=farmer&pwd=");
				
				return (get_property("sidequestFarmCompleted") != "none");
			break;
			
			case "junkyard" :
				if (get_property("sidequestJunkyardCompleted") != "none") return true;
				print("BCC: doSideQuest(Junkyard)", "purple");
				
				visit_yossarian();
				visit_yossarian();
				while (get_property("currentJunkyardTool") != "") {
					bumAdv(to_location(get_property("currentJunkyardLocation")), "mox +DA +10DR -melee", "", "1 "+get_property("currentJunkyardTool"), "Getting "+get_property("currentJunkyardTool")+"...", "", "consultJunkyard");
					visit_yossarian();
				}
				return (get_property("sidequestJunkyardCompleted") != "none");
			break;
			
			case "nuns" :
				if (get_property("sidequestNunsCompleted") != "none") return true;
				print("BCC: doSideQuest(Nuns)", "purple");
				setFamiliar("meat");
				
				//Set up buffs and use items as necessary.
				if (have_effect($effect[sinuses for miles]) == 0) bumUse(1, $item[mick's icyvapohotness inhaler]);
				if (have_effect($effect[red tongue]) == 0) bumUse(1, $item[red snowcone]);
				if (get_property("sidequestArenaCompleted") == "fratboy" && cli_execute("concert 2")) {}
				if (get_property("demonName2") != "" && cli_execute("summon 2")) {}
				bumUse(ceil((estimated_advs()-have_effect($effect[wasabi sinuses]))/10), $item[Knob Goblin nasal spray]);
				bumUse(ceil((estimated_advs()-have_effect($effect[your cupcake senses are tingling]))/20), $item[pink-frosted astral cupcake]);
				bumUse(ceil((estimated_advs()-have_effect($effect[heart of pink]))/10), $item[pink candy heart]);
				cli_execute("trigger lose_effect, Polka of Plenty, cast 1 Polka of Plenty");
				
				//Put on the outfit and adventure, printing debug information each time. 
				buMax("+outfit "+bcasc_warOutfit);
				while (my_adventures() > 0 && bumMiniAdv(1, $location[themthar hills])) {
					print("BCC: Nunmeat retrieved: "+get_property("currentNunneryMeat")+" Estimated adventures remaining: "+estimated_advs(), "green");
				}
				
				visit_url("bigisland.php?place=nunnery");
			break;
			
			case "orchard" :
				if (get_property("sidequestOrchardCompleted") != "none") return true;
				print("BCC: doSideQuest(Orchard)", "purple");
				while (have_effect($effect[Filthworm Guard Stench]) == 0) {
					while (have_effect($effect[Filthworm Drone Stench]) == 0) {
							while (have_effect($effect[Filthworm Larva Stench]) == 0) {
								bumAdv($location[hatching chamber], "", "items", "1 filthworm hatchling scent gland", "Getting the Hatchling Gland (1/3)", "i");
								use(1, $item[filthworm hatchling scent gland]);
							}
							bumAdv($location[feeding chamber], "", "items", "1 filthworm drone scent gland", "Getting the Drone Gland (2/3)", "i");
							use(1, $item[filthworm drone scent gland]);
						}
					bumAdv($location[guards' chamber], "", "items", "1 filthworm royal guard scent gland", "Getting the Royal Guard Gland (3/3)", "i");
					use(1, $item[filthworm royal guard scent gland]);
				}
				bumAdv($location[Queen's Chamber], "", "", "1 heart of the filthworm queen", "Fighting the Queen");
				cli_execute("outfit "+bcasc_warOutfit);
				visit_url("bigisland.php?place=orchard&action=stand&pwd=");
				visit_url("bigisland.php?place=orchard&action=stand&pwd=");
			break;
		}
	}
	
	void item_turnin(item which) {
		if (item_amount(which) > 0) {
			print("Turning in "+item_amount(which)+" "+to_string(which)+"...");
			visit_url("bigisland.php?action=turnin&pwd=&whichcamp=1&whichitem="+to_int(which)+"&quantity="+item_amount(which));
			visit_url("bigisland.php?action=turnin&pwd=&whichcamp=2&whichitem="+to_int(which)+"&quantity="+item_amount(which));
		}
	}
	
	boolean killSide(int numDeadNeeded) {
		setFamiliar("");
		setMood("i");

		if (my_adventures() == 0) abort("You don't have any adventures :(");
		
		int numKilled;
		if (bcasc_doWarAs == "frat") {
			numKilled = to_int(get_property("hippiesDefeated"));
			buMax("+outfit frat war");
		} else if (bcasc_doWarAs == "hippy") {
			numKilled = to_int(get_property("fratboysDefeated"));
			buMax("+outfit war hippy");
		} else {
			abort("adskd");
		}
		
		while (numKilled < numDeadNeeded) {
			if (my_adventures() == 0) abort("No adventures in the Battlefield.");
			
			if (bcasc_doWarAs == "frat") {
				bumMiniAdv(1, $location[Battlefield (Frat Uniform)]);
				numKilled = to_int(get_property("hippiesDefeated"));
			} else if (bcasc_doWarAs == "hippy") {
				bumMiniAdv(1, $location[Battlefield (Hippy Uniform)]);
				numKilled = to_int(get_property("fratboysDefeated"));
			} else {
				abort("adskd");
			}
		}
		
		return (numKilled >= numDeadNeeded);
	}

	visit_url("council.php");
	if (index_of(visit_url("questlog.php?which=1"), "Make War, Not... Oh, Wait") > 0) {
		//First, get the outfit as necessary. 
		if (bcasc_doWarAs == "hippy") {
			if (i_a("reinforced beaded headband") == 0 || i_a("bullet-proof corduroys") == 0 || i_a("round purple sunglasses") == 0) {
				if (i_a("Orcish baseball cap") == 0 || i_a("homoerotic frat-paddle") == 0 || i_a("Orcish cargo shorts") == 0) {
					bumAdv($location[Frat House], "", "equipmentnc", "1 Orcish baseball cap, 1 homoerotic frat-paddle, 1 Orcish cargo shorts", "Getting the Frat Boy Outfit to then get the hippy one.", "-");
				}
				buMax("+outfit frat boy");
				if (my_primestat() == $stat[Moxie]) abort("Adventure in the Wartime Hippy Camp to get the Hippy Outfit. Why can't this script do this? Because you're wearing a melee weapon.");
				bumAdv($location[Wartime Hippy Camp], "+outfit frat boy", "hebo", "1 reinforced beaded headband, 1 bullet-proof corduroys, 1 round purple sunglasses", "Getting the War Hippy Outfit", "", "consultHeBo");
			}
		} else if (bcasc_doWarAs == "frat") {
			if (i_a("beer helmet") == 0 || i_a("distressed denim pants") == 0 || i_a("bejeweled pledge pin") == 0) 
				bumAdv($location[Wartime Frat House], "+outfit hippy", "hebo", "1 beer helmet, 1 distressed denim pants, 1 bejeweled pledge pin", "Getting the Frat Warrior Outfit", "", "consultHeBo");
		} else {
			abort("Please specify if you want the war done as a Hippy or a Fratboy.");
		}
		
		while (my_basestat($stat[mysticality]) < 70) {
			bumAdv($location[Haunted Bathroom], "", "", "70 mysticality", "Getting 70 myst to equip the " + bcasc_warOutfit + " outfit");
		} 
		
		//So now we have the outfit. Let's check if the war has kicked off yet. 
		if (!contains_text(visit_url("questlog.php?which=1"), "war between the hippies and frat boys started")) {
			if (bcasc_doWarAs == "hippy") {
				bumAdv($location[Wartime Frat House (Hippy Disguise)], "+outfit war hippy", "", "", "Starting the war by irritating the Frat Boys", "-");
			} else if (bcasc_doWarAs == "frat") {
				//I can't quite work out which choiceAdv number I need. Check it later. Plus, it should be "start the war" anyway. 
				//cli_execute("set choiceAdventure142");
				bumAdv($location[Wartime Hippy Camp (Frat Disguise)], "+outfit frat war", "", "", "Starting the war by irritating the Hippies", "-");
			}
		}
		
		//At this point the war should be started. 
		if (bcasc_doWarAs == "hippy") {
			if (i_a("reinforced beaded headband") == 0 || i_a("bullet-proof corduroys") == 0 || i_a("round purple sunglasses") == 0) {
				abort("What the heck did you do - where's your War Hippy outfit gone!?");
			}
			if (bcasc_doSideQuestDooks) doSideQuest("dooks");
			if (bcasc_doSideQuestOrchard) doSideQuest("orchard");
			if (bcasc_doSideQuestNuns) doSideQuest("nuns");
			killSide(64);
			if (bcasc_doSideQuestBeach) doSideQuest("beach");
			killSide(192);
			if (bcasc_doSideQuestJunkyard) doSideQuest("junkyard");
			killSide(458);
			if (bcasc_doSideQuestArena) doSideQuest("arena");
			killSide(1000);
		} else if (bcasc_doWarAs == "frat") {
			if (i_a("beer helmet") == 0 || i_a("distressed denim pants") == 0 || i_a("bejeweled pledge pin") == 0) {
				abort("What the heck did you do - where's your Frat Warrior outfit gone!?");
			}
			if (bcasc_doSideQuestArena) doSideQuest("arena");
			if (bcasc_doSideQuestJunkyard) doSideQuest("junkyard");
			if (bcasc_doSideQuestBeach) doSideQuest("beach");
			killSide(64);
			if (bcasc_doSideQuestOrchard) doSideQuest("orchard");
			killSide(192);
			if (bcasc_doSideQuestNuns) doSideQuest("nuns");
			killSide(458);
			if (bcasc_doSideQuestDooks) doSideQuest("dooks");
			killSide(1000);
		}
		
		//Sell all stuff.
		/*
		if (bcasc_doWarAs == "hippy") {
			item_turnin($item[red class ring]);
			item_turnin($item[blue class ring]);
			item_turnin($item[white class ring]);
			item_turnin($item[beer helmet]);
			item_turnin($item[distressed denim pants]);
			item_turnin($item[bejeweled pledge pin]);
			item_turnin($item[PADL Phone]);
			item_turnin($item[kick-ass kicks]);
			item_turnin($item[perforated battle paddle]);
			item_turnin($item[bottle opener belt buckle]);
			item_turnin($item[keg shield]);
			item_turnin($item[giant foam finger]);
			item_turnin($item[war tongs]);
			item_turnin($item[energy drink IV]);
			item_turnin($item[Elmley shades]);
			item_turnin($item[beer bong]);
		} else if (bcasc_doWarAs == "frat") {
			item_turnin($item[pink clay bead]);
			item_turnin($item[purple clay bead]);
			item_turnin($item[green clay bead]);
			item_turnin($item[bullet-proof corduroys]);
			item_turnin($item[round purple sunglasses]);
			item_turnin($item[reinforced beaded headband]);
			item_turnin($item[hippy protest button]);
			item_turnin(to_item("Lockenstock"));
			item_turnin($item[didgeridooka]);
			item_turnin($item[wicker shield]);
			item_turnin($item[lead pipe]);
			item_turnin($item[fire poi]);
			item_turnin($item[communications windchimes]);
			item_turnin($item[Gaia beads]);
			item_turnin($item[hippy medical kit]);
			item_turnin($item[flowing hippy skirt]);
			item_turnin($item[round green sunglasses]);
		}
		*/
			
		if (!checkStage("prewarboss")) {
			checkStage("prewarboss", true);
			abort("Stopping to let you sell war items.  Run script again to continue.");
		}
		
		// Kill the boss.
		int bossMoxie = 250;
		buMax("+outfit "+bcasc_warOutfit);
		setMood("");
		cli_execute("mood execute");
		
		//Now deal with getting the moxie we need.
		switch (my_primestat()) {
			case $stat[Moxie] :
				if (get_property("telescopeUpgrades") > 0 && !in_bad_moon()) cli_execute("telescope look high");
				if (my_buffedstat($stat[Moxie]) < bossMoxie && have_skill($skill[Advanced Saucecrafting])) cli_execute("cast * advanced saucecraft");
				if (my_buffedstat($stat[Moxie]) < bossMoxie && item_amount($item[scrumptious reagent]) > 0) cli_execute("use 1 serum of sarcasm");
				if (my_buffedstat($stat[Moxie]) < bossMoxie && item_amount($item[scrumptious reagent]) > 0) cli_execute("use 1 tomato juice of power");
				if (my_buffedstat($stat[Moxie]) < bossMoxie) abort("Can't get to " + bossMoxie + " moxie for the boss fight.  You're on your own.");
			break;
			
			default :
				abort("Not yet doing the boss as Muscle.");
			break;
		}
		
		cli_execute("restore hp;restore mp");
		visit_url("bigisland.php?place=camp&whichcamp=1");
		visit_url("bigisland.php?place=camp&whichcamp=2");
		visit_url("bigisland.php?action=bossfight&pwd");
		if (index_of(bumRunCombat(), "WINWINWIN") == -1) abort("Failed to kill the boss!\n");
		visit_url("council.php");
		checkStage("warboss", true);
	}
	
	levelMe(148, true);
}

void bcs13() {
	bcCouncil();
	
	bcascTelescope();
	load_current_map("bumrats_lairitems", lairitems);
	bcascNaughtySorceress();
}


void bumcheekcend() {
	print("Doing a check for Telescope Items", "green");
	if (get_property("bcasc_telescopeAsYouGo") == "true") bcascTelescope();
	print("Level 1 Starting", "green");
	bcs1();
	print("Level 2 Starting", "green");
	bcs2();
	print("Level 3 Starting", "green");
	bcs3();
	print("Level 4 Starting", "green");
	bcs4();
	print("Level 5 Starting", "green");
	bcs5();
	print("Level 6 Starting", "green");
	bcs6();
	print("Level 7 Starting", "green");
	bcs7();
	print("Level 8 Starting", "green");
	bcs8();
	print("Level 9 Starting", "green");
	bcs9();
	print("Level 10 Starting", "green");
	bcs10();
	print("Level 11 Starting", "green");
	bcs11();
	print("Level 12 Starting", "green");
	bcs12();
	print("Level 13 Starting", "green");
	bcs13();
}

void main() {
	if (index_of(visit_url("http://kolmafia.us/showthread.php?t=4963"), "0.23</b>") == -1) {
		print("There is a new version available - go download the next version of bumcheekascend.ash at the sourceforge page, linked from http://kolmafia.us/showthread.php?t=4963!", "red");
	}
	
	if (get_property("autoSatisfyWithNPCs") != "true") {
		set_property("autoSatisfyWithNPCs", "true");
	}

	if (have_effect($effect[Teleportitis]) > 0 && my_level() < 13) {
		if (!contains_text("dungeons.php", "greater.gif") && my_level() >= 8)
			bcascWand();
		else
			bcascTeleportitisBurn();
	}

	print("******************", "green");
	print("Ascending Starting", "green");
	print("******************", "green");
	
	//Before we start, we'll need an accordion. Let's get one. 
	if (i_a("stolen accordion") == 0 && i_a("Rock and Roll Legend") == 0 && i_a("Squeezebox of the Ages") == 0 && i_a("The Trickster's Trikitixa") == 0 && (checkStage("toot"))) {
		print("BCC: Getting an Accordion before we start.", "purple");
		while (i_a("stolen accordion") == 0) use(1, $item[chewing gum on a string]);
	}
	sellJunk();
	
	bumcheekcend();
	
	print("******************", "green");
	print("Ascending Finished", "green");
	print("******************", "green");
}
