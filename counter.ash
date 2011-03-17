import <betweenbattle.ash>

boolean main(string counter, int turns) {
	if (counter == danceCardCounter) {
		if (turns == 0) {
			if (my_location() != $location[haunted ballroom]) {
				debug("Detouring to the Ballroom for the dance card counter");
				preppedAdventure(1, $location[haunted ballroom]);
			}
		} else {
			debug("Sadly, skipping the dance card counter.  (Turns=" + turns +")");
		}
		return true;
	}

	if (counter == fortuneCounter) {
		if (turns == 0) {
			getFortune();
		} else {
			// FIXME: Surely we can do something useful here?
			abort("Need to burn turns before fortune cookie is used up");
		}
		return true;
	}

	return false;
}
