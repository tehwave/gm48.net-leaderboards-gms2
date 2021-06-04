/* 

The following variables is required for the example to work.

`global.gm48_oauth2_access_token` value is set via the gm48.net OAuth2 for GameMaker Studio 2 library. 

`leaderboardId` value is retrieved from the gm48.net Dashboard > (your game) > Leaderboards.

`gameApiToken` value is retrieved from the gm48.net Dashboard > (your game) > Leaderboards.

*/

// This value must be set for the example to work.
// You can retrieve it via the gm48.net OAuth2 for GameMaker Studio 2 example.
global.gm48_oauth2_access_token =  "";

// The example real used here is valid for testing against the API.
leaderboardId = 0;

// The example string used here is valid for testing against the API.
gameApiToken = "this-api-token-is-used-for-testing";

// Set the Game API Token.
gm48_set_game_api_token(gameApiToken);

// Start the leaderboard.
gm48_leaderboards_init(scr_callback_example);
