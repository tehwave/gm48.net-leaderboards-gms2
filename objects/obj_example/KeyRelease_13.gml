// Choose a random score to send.
var randomScore = choose(69, 420, 1337);

// You may send meta information along with the score.
// This can come in the form of either a ds_map or struct. 
var meta = ds_map_create();
ds_map_add(meta, "foo", "bar");

/*
var meta = {
    game_version : GM_version,
};
*/

// Send the score.
gm48_leaderboards_add_score(leaderboardId, randomScore, meta);

// Log it.
gm48_debug("Sent score to online leaderboard", randomScore);
