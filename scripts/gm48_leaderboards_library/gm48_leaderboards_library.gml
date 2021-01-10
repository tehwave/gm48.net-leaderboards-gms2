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
    #macro GM48_LEADERBOARDS_API_URL "https://gm48.test/api/v4/"
}

function gm48_leaderboards_globals()
{
	global.gm48_leaderboards_callback = -1;
	global.gm48_leaderboards_requests = ds_map_create();
}

/* --------------------------------

API

-------------------------------- */

function gm48_leaderboards_add_score(leaderboardId, scoreToSubmit)
{
	if (! is_string(global.gm48_oauth2_access_token)) {
		show_error("gm48.net-leaderboards-gms2: OAuth2 Access token is required.", true);	
	}
	
	// Put together request.
	var _url = GM48_LEADERBOARDS_API_URL + "leaderboards/" + string(leaderboardId) + "/scores"; 
	
    var _header_map = ds_map_create();
	    _header_map[? "User-Agent"] = GM48_LEADERBOARDS_USERAGENT;
		_header_map[? "Authorization"] = "Bearer " + string(global.gm48_oauth2_access_token);
		_header_map[? "Content-Type"] = "application/x-www-form-urlencoded";
		_header_map[? "Accept"] = "application/json";

    var _body  = "value=" + string(scoreToSubmit);
	
	// Third argument is "meta" which allows you to send additional data along with the score. 
	// This includes support for both ds_map and structs.
	if (argument_count == 3 && is_struct(argument[2])) {
		_body += "&meta=" + json_stringify(argument[2]);
	} else if (argument_count == 3 && is_real(argument[2]) && ds_exists(argument[2], ds_type_map)) {
		_body += "&meta=" + string(json_encode(argument[2]));
		
		// Free memory.
		ds_map_destroy(argument[2]);
	} else if (argument_count == 3) {
		show_error("gm48.net-leaderboards-gms2: Unable to prepare meta data for request.", false);	
	}

	// Send request.
    var _result = http_request(_url, "POST", _header_map, _body);
	
	// Save request.
	var _request = ds_map_create();
		_request[? "url"] = _url;
		_request[? "headers"] = _header_map;
		_request[? "body"] = _body;
		_request[? "method"] = "POST";

	ds_map_add(global.gm48_leaderboards_requests, _result, _request);
	
	// Log it.
	gm48_debug("Request sent to Leaderboards API", _url, _body);

	// Free memory.
    ds_map_destroy(_header_map);
	
	return _result;
}

function gm48_leaderboards_get_my_scores(leaderboardId)
{
	// TODO	
}

function gm48_leaderboards_get_all_scores(leaderboardId)
{
	// TODO
}

/* --------------------------------

Async

-------------------------------- */

function gm48_leaderboards_http()
{
	// Validate that the request is one of ours.
	var _id = async_load[? "id"];

	if (! ds_exists(global.gm48_leaderboards_requests, ds_type_map)) {
		show_error("gm48.net-leaderboards-gms2: Requests ds_map doesn't exist.", true);	
	}

	if (ds_map_size(global.gm48_leaderboards_requests) == 0) {
		gm48_debug("HTTP request is not of Leaderboards variant.", _id);	

		return;
	}
	
	var _request = ds_map_find_value(global.gm48_leaderboards_requests, _id);
	
	if (is_undefined(_request)) {
		gm48_debug("HTTP request is not of Leaderboards variant.", _id);	

		return;
	}
	
	// Retrieve our remaining data.
	var _http_status = async_load[? "http_status"];
    var _status = async_load[? "status"];
    var _result = async_load[? "result"];
	
	// Validate response.
	if (_status < 0) {
		gm48_debug("Something went wrong with request.", _http_status, _status, _result);	
		
		return;
	}
	
	if (_status = 1) {
		gm48_debug("Content is being downloaded.", _http_status, _status, _result);
		
		return;
	}		

	if (_http_status < 200 || _http_status >= 300) {
		gm48_debug("Non-successful response.", _http_status, _status, _result);
		
		return;
	}

	// Process result.
    var _decoded_result = json_parse(_result);

	gm48_debug("Successful response received.", _http_status, _result, _decoded_result);
	
	// Execute callbacks.
	if (! is_undefined(_request[? "callback"]) && script_exists(_request[? "callback"])) {
		script_execute(_request[? "callback"], _decoded_result, _id);	
	}
	
	if (script_exists(global.gm48_leaderboards_callback)) {
		script_execute(global.gm48_leaderboards_callback, _decoded_result, _id);	
	}
}

/* --------------------------------

Helpers

-------------------------------- */

if (! asset_get_index("gm48_debug")) {
	function gm48_debug()
	{
	    if (! debug_mode) {
	        return -1
	    }

		if (argument_count == 1) {
			return show_debug_message("gm48: " + string(argument0));
		}

	    var _string = "",
			_i = 0;
		
	    repeat(argument_count) {
	        _string += "(" + string(_i) + ") " + string(argument[_i]) + "\n";
			
	        ++_i;
	    }

	    return show_debug_message("gm48:\n" + _string);
	}	
}
