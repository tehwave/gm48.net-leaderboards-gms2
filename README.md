👷‍♂️👷‍♀️ The Leaderboards API is in Beta and may change at any time without prior warning and disclosure.

# gm48.net-leaderboards-gms2

Utilize gm48.net Leaderboards for your GameMaker Studio 2 game jam entry

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
gm48_leaderboards_init(gameId);
```

`gameId` must correspond to the value found in gm48.net Dashboard > Leaderboards.

You may optionally parse a 2nd argument, which contains the script that should be executed when the response from the gm48.net API has been received.

```gml
gm48_leaderboards_init(gameId, scr_example_callback);
```

**Async HTTP**

```gml
gm48_leaderboards_http();
```

3) Go to gm48.net Dashboard > (your game) > Leaderboards to create and edit your game's leaderboards.

Once you have created your first leaderboard, the credentials and information required to submit and retrieve scores is presented to you.

### Example project

Download the repository and open the project file in GameMaker Studio 2.

The project will not work out-of-the-box, as you must first install gm48.net OAuth2 for GameMaker Studio 2.

### gm48.net OAuth2 for GameMaker Studio 2

Please refer to the [gm48.net OAuth2 for GameMaker Studio 2 repository](https://github.com/tehwave/gm48.net-oauth2-gms2) for implementation.

## Usage

Before you can use the leaderboards, you must ask the player for authorization to use their gm48.net account.

This functionality is provided via the [gm48.net OAuth2 for GameMaker Studio 2](https://github.com/tehwave/gm48.net-oauth2-gms2) library. Please refer to the repository for instructions.

Once the player has been authorized, you may proceed to use the Leaderboards library.

### Submitting scores

All you need to submit a score is 1) the ID of the leaderboard, which corresponds to the value found in gm48.net Dashboard > Leaderboards, and 2) the score that you wish to submit.

```gml
gm48_leaderboards_add_score(leaderboardId, scoreToSubmit)
```

When you use the `gm48_leaderboards_add_score` function, the request ID is returned. Store this value if you want to recognize your request later.

Once the request to the gm48.net Leaderboards API has been processed, a response is sent back to GameMaker Studio 2 via the Async HTTP event, and if you have defined a callback script, the response and the request ID will be sent along as the the callback script is executed.

```
function scr_example_callback(response, requestId)
{
    show_message("Your score has been submitted to the official gm48.net Leaderboards!");
}
```

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
