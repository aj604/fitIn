import { expect } from "chai";
import * as Scenario from "../src/scenario";
import * as AWS from "aws-sdk";

describe("Scenario", () => {
    it("Should convert from a Scenario to a DBDictionary and back again, without change", () =>{
        let scenario: Scenario.Scenario = new Scenario.Scenario();
        let scenario2: Scenario.Scenario = scenario;

        let dict = scenario.toDB();
        scenario.fromDB(dict);

        expect(scenario).to.deep.equal(scenario2, "forward direction failed");

    });

    it("Should convert from a DBDictionary to a Scenario and back again, without change", () =>{
        let scenario: Scenario.Scenario = new Scenario.Scenario();

        let dict = {
            "scenarioID": { S: "a" },
            "createdBy": { S: "a" },
            // item["tags"] = { SS: this.tags };

            "questionText": { S: "a" },
            "answerReasoning": { S: "a" },
            "imageLoc": { S: "a" },

            "type": { N: "0" },
            "initialAnswer": { N: "0" },
            "averageAnswer": { N: "0" },
            "averageTimeToAnswer": { N: "0" },
            "numberOfAnswers": { N: "0" },

            "standardDeviation": { N: "0" },
            "mean": { N: "0" },
            "currentMean": { N: "0" }
        };

        scenario.fromDB(dict);

        expect(scenario.toDB()).to.deep.equal(dict, "backward direction failed");
    });
});
