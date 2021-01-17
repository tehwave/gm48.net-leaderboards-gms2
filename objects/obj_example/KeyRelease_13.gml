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

// You can also specify a specific script to execute 
// when the response back from gm48.net API has been received.
var callback = scr_add_score_callback_example;

// Send the score.
gm48_leaderboards_add_score(leaderboardId, randomScore, meta, callback);

// Log it.
gm48_debug("Sent score to online leaderboard", randomScore);
