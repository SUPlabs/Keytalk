# Keytalk

# 1. Call login function
After the device ready we call the login procedure with the following piece of code 

```javascript
var certificate = keytalk.login(
    function(content){
        console.log(content);
    },
    function(error){
        console.log(error);
    },
    [
        <<username>>,
        <<password>>,
        <<pin>< or null
    ]
);
```

# 2. Add the .rccd file to project
Add your kt_xxx.rccd file to the recources folder.

Make sure you add the file to your xCode project and activate the copy checkbox.

# 3. Plugin to yout project
cordova plugin add https://github.com/SUPlabs/Keytalk.git

