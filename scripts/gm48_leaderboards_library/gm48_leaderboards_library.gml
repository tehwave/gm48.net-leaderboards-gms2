/* --------------------------------

Library of scripts to utilize gm48.net Leaderboards in GameMaker Studio 2 v2.3.0 or newer

@see https://github.com/tehwave/gm48.net-leaderboards-gms2

This library requires the gm48.net OAuth2 for GameMaker Studio 2 library to function.

@see https://github.com/tehwave/gm48.net-oauth2-gms2

-------------------------------- */

function gm48_leaderboards_init(callback)
{
	// Verify that OAuth2 library exists.
	if (! asset_get_index("gm48_oauth2_init") && ! debug_mode) {
		show_error("gm48.net-leaderboards-gms2: OAuth2 Library is required.", true);
	}

	// Prepare global variables.
	gm48_leaderboards_globals();

	if (! is_undefined(callback)) {
		global.gm48_leaderboards_callback = argument0;
	}

	// Prepare macros.
	gm48_leaderboards_macros();

	// All ready.
	gm48_debug("Leaderboards functionality initialized.");
}

function gm48_leaderboards_macros()
{
	#macro GM48_LEADERBOARDS_USERAGENT "gamemaker:" + game_display_name + ":" + GM_version
    #macro GM48_LEADERBOARDS_API_URL "https://gm48.net/api/v4/"
}

function gm48_leaderboards_globals()
{
	global.gm48_leaderboards_callback = -1;
	global.gm48_leaderboards_requests = ds_map_create();

	if (! variable_global_exists("gm48_game_api_token")) {
		global.gm48_game_api_token = -1;
	}
}

/* --------------------------------

API

-------------------------------- */

function gm48_leaderboards_add_score(leaderboardId, scoreToSubmit, meta, callback)
{
	if (! gm48_isset_oauth2_access_token()) {
		show_error("gm48.net-leaderboards-gms2: OAuth2 Access token is required.", true);
	}

	if (! gm48_isset_game_api_token()) {
		show_error("gm48.net-leaderboards-gms2: Game API Token is required.", true);
	}

	// Put together request.
	var url = GM48_LEADERBOARDS_API_URL + "leaderboards/" + string(leaderboardId) + "/scores";

    var headers = ds_map_create();
	    headers[? "User-Agent"] = GM48_LEADERBOARDS_USERAGENT;
		headers[? "Authorization"] = "Bearer " + gm48_get_oauth2_access_token();
		headers[? "Content-Type"] = "application/x-www-form-urlencoded";
		headers[? "Accept"] = "application/json";
		headers[? "Game-Token"] = gm48_get_game_api_token();

	// Set the score as the value. When it's a double, we use json_stringify to preserve
	// data precision and allow better comparison between scores.
	var body = "value=" + string(scoreToSubmit);
		
	if (is_real(scoreToSubmit) && (floor(scoreToSubmit) != scoreToSubmit)) {
		body = "value=" + json_stringify(scoreToSubmit);
	}

	// Third argument is "meta" which allows you to send additional data along with the score.
	// This includes support for both ds_map and structs.
	if (! is_undefined(meta)) {
		if (is_struct(meta)) {
			body += "&meta=" + json_stringify(meta);
		} else if (is_real(meta) && ds_exists(meta, ds_type_map)) {
			body += "&meta=" + string(json_encode(meta));

			// Free memory.
			ds_map_destroy(meta);
		} else {
			show_error("gm48.net-leaderboards-gms2: Meta data is wrong data type. It must be a struct or ds_map.", false);
		}
	}

	// Send request.
    var requestId = http_request(url, "POST", headers, body);

	// Save request.
	var request = ds_map_create();
		request[? "url"] = url;
		request[? "headers"] = headers;
		request[? "body"] = body;
		request[? "method"] = "POST";

	if (! is_undefined(callback)) {
		request[? "callback"] = callback;
	}

	gm48_add_leaderboards_request(requestId, request);

	// Log it.
	gm48_debug("Request sent to Leaderboards API", url, body);

	// Free memory.
    ds_map_destroy(headers);

	return requestId;
}

function gm48_leaderboards_get_my_scores(leaderboardId, callback)
{
	if (! gm48_isset_oauth2_access_token()) {
		show_error("gm48.net-leaderboards-gms2: OAuth2 Access token is required.", true);
	}

	if (! gm48_isset_game_api_token()) {
		show_error("gm48.net-leaderboards-gms2: Game API Token is required.", true);
	}

	// Put together request.
	var url = GM48_LEADERBOARDS_API_URL + "leaderboards/" + string(leaderboardId) + "/me";

    var headers = ds_map_create();
	    headers[? "User-Agent"] = GM48_LEADERBOARDS_USERAGENT;
		headers[? "Authorization"] = "Bearer " + gm48_get_oauth2_access_token();
		headers[? "Accept"] = "application/json";
		headers[? "Game-Token"] = gm48_get_game_api_token();

	// Send request.
    var requestId = http_request(url, "GET", headers, "");

	// Save request.
	var request = ds_map_create();
		request[? "url"] = url;
		request[? "headers"] = headers;
		request[? "body"] = undefined;
		request[? "method"] = "GET";

	if (! is_undefined(callback)) {
		request[? "callback"] = argument[1];
	}

	gm48_add_leaderboards_request(requestId, request);

	// Log it.
	gm48_debug("Request sent to Leaderboards API", url);

	// Free memory.
    ds_map_destroy(headers);

	return requestId;
}

function gm48_leaderboards_get_all_scores(leaderboardId, callback)
{
	if (! gm48_isset_oauth2_access_token()) {
		show_error("gm48.net-leaderboards-gms2: OAuth2 Access token is required.", true);
	}

	if (! gm48_isset_game_api_token()) {
		show_error("gm48.net-leaderboards-gms2: Game API Token is required.", true);
	}

	// Put together request.
	var url = GM48_LEADERBOARDS_API_URL + "leaderboards/" + string(leaderboardId);

    var headers = ds_map_create();
	    headers[? "User-Agent"] = GM48_LEADERBOARDS_USERAGENT;
		headers[? "Authorization"] = "Bearer " + gm48_get_oauth2_access_token();
		headers[? "Accept"] = "application/json";
		headers[? "Game-Token"] = gm48_get_game_api_token();

	// Send request.
    var requestId = http_request(url, "GET", headers, "");

	// Save request.
	var request = ds_map_create();
		request[? "url"] = url;
		request[? "headers"] = headers;
		request[? "body"] = undefined;
		request[? "method"] = "GET";

	if (! is_undefined(callback)) {
		request[? "callback"] = argument[1];
	}

	gm48_add_leaderboards_request(requestId, request);

	// Log it.
	gm48_debug("Request sent to Leaderboards API", url);

	// Free memory.
    ds_map_destroy(headers);

	return requestId;
}

/* --------------------------------

Async

-------------------------------- */

function gm48_leaderboards_http()
{
	// Validate that the request is one of ours.
	var requestId = async_load[? "id"];

	if (! ds_exists(global.gm48_leaderboards_requests, ds_type_map)) {
		show_error("gm48.net-leaderboards-gms2: Requests ds_map doesn't exist.", true);
	}

	if (ds_map_size(global.gm48_leaderboards_requests) == 0) {
		gm48_debug("HTTP request is not of Leaderboards variant.", requestId);

		return;
	}

	var request = gm48_get_leaderboards_request(requestId);

	if (is_undefined(request)) {
		gm48_debug("HTTP request is not of Leaderboards variant.", requestId);

		return;
	}

	// Retrieve our remaining data.
	var httpStatusCode = async_load[? "http_status"];
    var status = async_load[? "status"];
    var result = async_load[? "result"];

	// Validate response.
	if (status < 0) {
		gm48_debug("Something went wrong with request.", httpStatusCode, status, result);

		return;
	}

	if (status = 1) {
		gm48_debug("Content is being downloaded.", httpStatusCode, status, result);

		return;
	}

	if (httpStatusCode < 200 || httpStatusCode >= 300) {
		gm48_debug("Non-successful response.", httpStatusCode, status, result);

		return;
	}

	// Process result.
    var decodedResult = json_parse(result);

	gm48_debug("Successful response received.", httpStatusCode, result, decodedResult);

	// Execute callbacks.
	if (! is_undefined(request[? "callback"]) && script_exists(request[? "callback"])) {
		script_execute(request[? "callback"], decodedResult, requestId);
	}

	if (script_exists(global.gm48_leaderboards_callback)) {
		script_execute(global.gm48_leaderboards_callback, decodedResult, requestId);
	}
}

/* --------------------------------

Local helper scripts.

-------------------------------- */

function gm48_add_leaderboards_request(requestId, request)
{
	return ds_map_add(global.gm48_leaderboards_requests, requestId, request);
}

function gm48_get_leaderboards_request(requestId)
{
	return ds_map_find_value(global.gm48_leaderboards_requests, requestId);
}
