// This is a dummy main file for local debugging, lambda will never see this file.

var lambda = require("./built/index")
lambda.handler({}, {}, (error, result) => 
{
    if(!error) {
        console.log(result)
    }

});