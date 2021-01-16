function scr_all_scores_callback_example(response, requestId) {

	// Be responsible. Handle errors.
	if (is_undefined(response)) {
		return;
	}
	
	if (! variable_struct_exists(response, "data")) {
		return;
	}
	
	if (! variable_struct_exists(response.data, "scores")) {
		return;
	}
	
	// What you do from now on is up to you. Save the scores to a global variable like below.
	global.scores = response.data.scores;
	
	// ...or send every score to the console output like this.
	for (var i = 0; i < array_length(response.data.scores); ++i) {
		var theScore = response.data.scores[i];
		
		show_debug_message("[" + string(theScore.player) + "] " + string(theScore.value));
	}
}
