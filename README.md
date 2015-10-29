Awesomation is a web server that interacts with [Belkin WeMo switches](http://www.amazon.com/WeMo-Electronics-Anywhere-Automation-Smartphones/dp/B00BB2MMNE).

# Getting started

Install mplayer:

    brew install youtube-dl
    brew install mpg123
    brew install ffmpeg
    brew install wget

Run a rails console via `rails c` and run:

    WemoSwitch.create_devices!

This will create database entries for all devices on your local network.

You may want to configure static IPs on your local network so that these don't change!

That's it! You can now control your devices a la:

    switch = WemoSwitch.first
    switch.turn_on!
    switch.turn_off!

Once your devices are configured, you can control them by running a server:

    rails s -b 0.0.0.0

and making POST requests to turn them on and off:

    curl -X POST http://localhost:3000/devices/1/on -d ''
    curl -X POST http://localhost:3000/devices/1/off -d ''

You can announce things via the Announce API:

    curl --data "statement='Hilarious'&voice=hysterical&words_per_minute=300" http://localhost:3000/say

Or play youtube audio!

    curl --data "url=https://www.youtube.com/watch?v=B-UMKxUR2tU&volume=0.5" http://localhost:3000/play_youtube_audio
