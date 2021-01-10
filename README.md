👷‍♂️👷‍♀️ The Leaderboards API is in Beta and may change at any time without prior warning and disclosure.

# gm48.net-leaderboards-gms2

Utilize official gm48.net Leaderboards for your GameMaker Studio 2 game jam entry

## Requirements

* YYC (YoYo Compiler)
* GameMaker Studio 2 v2.3.0 or newer
* Windows (other platforms not supported, but may work)
* Leaderboards enabled for your game on gm48.net
* [gm48.net OAuth2 for GameMaker Studio 2](https://github.com/tehwave/gm48.net-oauth2-gms2)

## Installation

> 🚨 This library requires that [gm48.net OAuth2 for GameMaker Studio 2](https://github.com/tehwave/gm48.net-oauth2-gms2) is installed in your GameMaker Studio 2 project.

1) Copy and paste the contents of the [gm48_leaderboards_library.gml](scripts/gm48_leaderboards_library/gm48_leaderboards_library.gml) file into a new script resource.

2) Create a new persistent object resource and set up the following events:

**Create**

```gml
gm48_leaderboards_init();
```

You may optionally send an argument, which contains the script that should be executed when the response from the gm48.net API has been received.

```gml
gm48_leaderboards_init(scr_example_callback);
```

**Async HTTP**

```gml
gm48_leaderboards_http();
```

3) Go to gm48.net Dashboard > (your game) > Leaderboards to create and edit your game's leaderboards.

Once you have created your first leaderboard, the credentials and information required to submit and retrieve scores is presented to you.

### Example project

1) Download the repository and open the project file in GameMaker Studio 2.

The project will not work out-of-the-box, as you must first retrieve an access token via [gm48.net OAuth2 for GameMaker Studio 2](https://github.com/tehwave/gm48.net-oauth2-gms2).

You must also change the `leaderboardId` variable's value in the `obj_example` object resource to a corresponding leaderboard ID in gm48.net Dashboard > (your game) > Leaderboards.

2) Launch the game in debug mode (F6). Watch the console output for debugging information.

3) Press `Enter` to submit a score.

### gm48.net OAuth2 for GameMaker Studio 2

Please refer to the [gm48.net OAuth2 for GameMaker Studio 2 repository](https://github.com/tehwave/gm48.net-oauth2-gms2) for implementation.

## Usage

Before you can use the leaderboards, you must ask the player for authorization to use their gm48.net account.

This functionality is provided via the [gm48.net OAuth2 for GameMaker Studio 2](https://github.com/tehwave/gm48.net-oauth2-gms2) library. Please refer to the repository for instructions.

Once the player has been authorized, you may proceed to use the Leaderboards library.

### Submitting scores

> 🚨 Submitting scores is always done on the behalf of an gm48.net account. You should not use your own or the same account for every score submitted.

All you need to submit a score is 1) the ID of the leaderboard, which corresponds to the value found in gm48.net Dashboard > Leaderboards, and 2) the score that you wish to submit.

```gml
gm48_leaderboards_add_score(leaderboardId, scoreToSubmit)
```

When you use the `gm48_leaderboards_add_score` function, the request ID is returned. Store this value if you want to recognize your request later. All requests are stored in the global `gm48_leaderboards_request` variable ds_map.

You may send meta information along with the score. Please see the `obj_example` object resource's [`Key Up: Enter`](objects/obj_example/KeyRelease_13.gml) event for details on how to implement this functionality.

Once the request to the gm48.net Leaderboards API has been processed, a response is sent back to GameMaker Studio 2 via the Async HTTP event, and if you have defined a callback script, the response and the request ID will be sent along as the the callback script is executed.

```gml
function scr_example_callback(response, requestId)
{
    show_message("Your score has been submitted to the official gm48.net Leaderboards!");
}
```

The `response` value is a struct, as the raw response is run through `json_parse`. Please see GameMaker Studio 2 documentation for more information on how to deal with structs.

### Retrieving leaderboard scores

📝 TODO

## Security

For any security related issues, please use the form located here: https://gm48.net/contact-us instead of using the issue tracker.

## Changelog

See [CHANGELOG](CHANGELOG.md) for details on what has changed.

## Contributions

See [CONTRIBUTING](CONTRIBUTING.md) for details on how to contribute.

## Credits

- [Peter Jørgensen](https://github.com/tehwave)
- [All Contributors](../../contributors)

## License

[MIT License](LICENSE)
