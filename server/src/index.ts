// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";

let dynamo = new AWS.DynamoDB();

console.log("Loading function");

exports.handler = (event, context, callback) => {
    console.log("Received event:", JSON.stringify(event, null, 2));
    /*event.Records.forEach((record) => {
        console.log(record.eventID);
        console.log(record.eventName);
        console.log('DynamoDB Record: %j', record.dynamodb);
    });*/
    callback(null, "Success");
};
