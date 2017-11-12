// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";

AWS.config.update({region: "us-west-2"});
let dynamo = new AWS.DynamoDB();

console.log("Loading function");

exports.handler = (event, context, callback) => {
    console.log("Received event:", JSON.stringify(event, null, 2));
    /*event.Records.forEach((record) => {
        console.log(record.eventID);
        console.log(record.eventName);
        console.log('DynamoDB Record: %j', record.dynamodb);
    });*/

    let scanArgs: AWS.DynamoDB.ScanInput = {
        TableName: "scenarioMaster",
        ReturnConsumedCapacity: "TOTAL",
        ConsistentRead: false
    }

    dynamo.scan(scanArgs).promise()
    .then((result: AWS.DynamoDB.ScanOutput) => {
        console.log(result);
        console.log("done");


        callback(null, "Success");
    })


};
