#!/usr/bin/env python
from flask import Flask, render_template
from termcolor import colored
import os
from flask import Flask, request, jsonify
import credentials
app = Flask(__name__)


app.config["DEBUG"] = False

API_KEY = credentials.API_KEY


def authenticate():
    api_key = request.headers.get('x-api-key')
    if api_key != API_KEY:
        return False
    return True

@app.route('/led/on', methods=['POST'])
def ledOn():
   if authenticate() == False:
       return jsonify({'error': 'Unauthorized'}), 401
   if authenticate() == True:
        os.system("echo 255 | sudo tee /sys/class/leds/ACT/brightness")
        os.system("echo 255 | sudo tee /sys/class/leds/PWR/brightness")
        print (colored("On", "green"))
        return jsonify({'status': 'Power and Activity LED turned ON'})

@app.route('/led/off', methods=['POST'])
def ledOff():
      if authenticate() == False:
        return jsonify({'error': 'Unauthorized'}), 401
      if authenticate() == True:
        os.system("echo 0 | sudo tee /sys/class/leds/ACT/brightness")
        os.system("echo 0 | sudo tee /sys/class/leds/PWR/brightness")
        print (colored("Off", "red"))
        return jsonify({'status': 'Power and Activity LED turned OFF'})


@app.route('/led/status', methods=['GET'])
def status():
    brightness = int(os.popen("cat /sys/class/leds/PWR/brightness").read())
    if brightness > 1:
        return "ON"
    elif brightness == 0:
        return "OFF"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=credentials.PORT)
