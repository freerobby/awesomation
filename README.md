Awesomation is a web server that interacts with [Belkin WeMo switches](http://www.amazon.com/WeMo-Electronics-Anywhere-Automation-Smartphones/dp/B00BB2MMNE).

# Getting started

Run a rails console via `rails c` and run:

    WemoSwitch.create_devices!

This will create database entries for all devices on your local network.

That's it! You can now control your devices a la:

    switch = WemoSwitch.first
    switch.turn_on!
    switch.turn_off!
