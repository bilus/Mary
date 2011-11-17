Feature: Wind farm project estimation
	In order to see if a project is a profitable one
	As an investor
	I want to generate a profitability report.
	
	@story1
	Scenario: Story #1 - HTML report contains the submitted project name.
		When the investor creates a new project "Wilamowa"
		And the investor generates a profitability report
		Then the report should include "Wilamowa"