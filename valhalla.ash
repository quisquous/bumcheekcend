void ascend(int type, int cls, int gender, int path, int sign) {
    string options = "&asctype=" + type + "&whichclass=" + cls + "&gender=" + gender + "&whichpath=" + path + "&whichsign=" + sign;
    string confirm = "&lamepathok=1&nopetok=1&noskillsok=1&confirmascend=1";
    visit_url("afterlife.php?action=ascend" + options + confirm, true);

    // FIXME: Verify options.

	cli_execute("refresh all");
}

void defaultAscend() {
    // hardcore
    int type = 3;
    // accordion
    int cls = 6;
    // gender
    int gender = 2;
    // path
    int path = 0;
    // sign (3, 6, 9)
    int sign = 3;

    ascend(type, cls, gender, path, sign);
}

void main() {
    if (my_adventures() > 0)
        abort("Spend adventures first");

    // FIXME: Look for "Pearly Gates" string.
    visit_url("ascend.php?action=ascend&pwd=&confirm=on&confirm2=on", true);

    // FIXME: Check banked karma string
    visit_url("afterlife.php?action=pearlygates");

    defaultAscend();
}
