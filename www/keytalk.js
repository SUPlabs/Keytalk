// (C) SUPERP

    var argscheck = require('cordova/argscheck'),
        channel = require('cordova/channel'),
        utils = require('cordova/utils'),
        exec = require('cordova/exec'),
        cordova = require('cordova');

    var keytalk = {

               login: function(success, error, args) {
               
               if (args.length == 0 || args[0] < 0) {
                    // Invalid call to the plugin, so return an error condition
                    error('Parameters are missing');
                    return;
               }
               
               /**
                Code to retrieve username, password and pincode needed to proceed
                **/
               
               exec(
                success, 
                error, 
                "keytalk", 
                "login", 
                args
                );
               

               }
    }

    module.exports = keytalk;