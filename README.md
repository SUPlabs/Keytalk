# KeyTalk

# 1. Call login function
After the device ready we call the login procedure with the following piece of code 

```javascript
var certificate = KeyTalk.login(
    function(content){
        console.log(content);
    },
    function(error){
        console.log(error);
    },
    [
        <<username>>,
        <<password>>,
        <<pin> or null
    ]
);
```

# 2. Add the .rccd file to project
Add your kt_xxx.rccd file to the recources folder.

Make sure you add the file to your xCode project and activate the copy checkbox.

# 3. Add KeyTalk plugin to your project
Use the following command to add the KeyTalk plugin to your project.

```javascript
cordova plugin add https://github.com/SUPlabs/KeyTalk.git
```
