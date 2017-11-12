var lambda = require("./built/index")
lambda.handler({}, {}, (error, result) => 
{
    if(!error) {
        console.log(result)
    }

});