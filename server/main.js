// This is a dummy main file for local debugging, lambda will never see this file.

var lambda = require("./built/src/index")
// simply call the handler function with some default parameters
// This is only for local debugging, testing, and TA testing.
lambda.handler({}, {}, (error, result) => 
{
    if(!error) {
        console.log(result)
    }

});