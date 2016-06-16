var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

channel.createSticky('onCordovaInfoReady');

// Tell cordova channel to wait on the CordovaInfoReady event
channel.waitForInitialization('onCordovaInfoReady');

/**
 * This represents the mobile device, and provides properties for inspecting the model, version, UUID of the
 * phone, etc.
 * @constructor
 */

var Keytalk = {

	alert = function(successCallback, errorCallback) {
    	argscheck.checkArgs('fF', 'Keytalk.alert', arguments);
    	exec(successCallback, errorCallback, "Keytalk", "alert", [title, message, buttonLabel]);
	};

}

module.exports = Keytalk;