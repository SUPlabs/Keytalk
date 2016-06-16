# Keytalk

# 1. Call login function

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

