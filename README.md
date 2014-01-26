To get started, something like this should probably be enough:

    pod install

And assuming your App.net username, the channel you're interested in, and your App.net token are in the `ADN_USERNAME`, `ADN_CHANNEL_ID`, and `ADN_TOKEN` environment variables:

    defaults write com.mthurman.ADNNotifier username $ADN_USERNAME
    security add-generic-password -s ADNNotifier -a $ADN_USERNAME -w $ADN_TOKEN
