# Web Starter Template

Base template for small projects using HTML, SASS, and CoffeeScript.

## Install
* `npm install -g coffee-script`
* `gem install sass`

## Dev
Run `bin/dev`

## Sass Breakdown

This is a simple copy of instagram's feed. Card elements are broken down into `image`, `likes` and `comment` components. All cards are overlaid on the cardbar.

Zaarlbox and zaarlogo are not essential, just a cute attempt to ape the original logo.

## Using the Instagram API for ajax calls:

This part is a little tricky. First, set yourself up a developer account on [their site](http://instagram.com/developer/).

After creating the account, you'll recieve a CLIENT-ID and CLIENT-SECRET. Make a an api request in the following format to recieve a temporary code for a token: `https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code`

You will be redirected to your custom redirect url. The tail end of this url will contain your temp code, IE:  https://zaarly.com/`1adsf234sfasfasa`

Paste this temp code into the following curl command. (Preferably in terminal.)

`curl \-F 'client_id=CLIENT-ID' \
    -F 'client_secret=CLIENT-SECRET' \
    -F 'grant_type=authorization_code' \
    -F 'redirect_uri=YOUR-REDIRECT-URI' \
    -F 'code=CODE' \https://api.instagram.com/oauth/access_token`

Your response will contain the access-token for this particular user. If your app is only going to look up users and return images (IE, no user-specific actions) this should be the only access token you ever need.