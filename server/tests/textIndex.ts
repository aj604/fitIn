import { expect } from "chai";
import * as Index from "../src/index";
import * as Scenario from "../src/scenario";
import * as AWS from "aws-sdk";

describe("Index", () => {
    it("noNan should convert a null to zero", () => {
        expect(Index.noNan(null)).to.equal(0);
    });

    it("noNan should convert a undefined to zero", () => {
        expect(Index.noNan(undefined)).to.equal(0);
    });

    it("noNan should convert a Nan to zero", () => {
        expect(Index.noNan(Infinity)).to.equal(0);
    });

    it("merge should increment numberOfAnswers in Scenario", () => {
        let scenario: Scenario.Scenario = new Scenario.Scenario();
        let update: Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate();

        Index.merge(scenario, update);

        expect(scenario.numberOfAnswers).to.equal(1);
    });

    it("merge should perform an average calculation on averageTimeToAnswer", () => {
        let scenario: Scenario.Scenario = new Scenario.Scenario();
        let update: Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate();
        update.timeToAnswer = 1000;

        Index.merge(scenario, update);

        expect(scenario.averageTimeToAnswer).to.greaterThan(0);
    });

    it("merge should perform an average calculation on averageAnswer", () => {
        let scenario: Scenario.Scenario = new Scenario.Scenario();
        let update: Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate();
        update.userAnswer = 1000;

        Index.merge(scenario, update);

        expect(scenario.averageAnswer).to.greaterThan(0);
    });

    it("merge should calculate standard deviation", () => {
        let scenario: Scenario.Scenario = new Scenario.Scenario();
        let update: Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate();
        update.userAnswer = 1000;
        scenario.mean = 10;
        scenario.currentMean = 100;

        Index.merge(scenario, update);

        expect(scenario.standardDeviation).to.greaterThan(0);
    });
});
