function scr_my_scores_callback_example(response, requestId) {
	/*
		Take a look at the other scores callback example
		for a more in-depth look at how you can process the response
		by doing 1) error-handling and 2) output or save the scores.
	*/
	gm48_debug("My Scores", response.data.scores);
}