#!/usr/bin/env python
from flask import Flask, render_template
from termcolor import colored
import os
import requests
app = Flask(__name__)

app.config["DEBUG"] = False


def ledOn():
   os.system("echo 255 | sudo tee /sys/class/leds/ACT/brightness")
   os.system("echo 255 | sudo tee /sys/class/leds/PWR/brightness")
   print (colored("On", "green"))
def ledOff():
   os.system("echo 0 | sudo tee /sys/class/leds/ACT/brightness")
   os.system("echo 0 | sudo tee /sys/class/leds/PWR/brightness")
   print (colored("Off", "red"))


@app.route('/led/on')
def on():
    ledOn()
    return 'Led is on'
@app.route('/led/status')
def status():
    brightness = int(os.popen("cat /sys/class/leds/PWR/brightness").read())
    if brightness > 1:
        return "ON"
    elif brightness == 0:
        return "OFF"
@app.route('/led/off')
def off():
    ledOff()
    return 'Led is off'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
