include <../utils.scad>;

RailWidth = 23;
RailHeight = 22;

module Rail(length) {
	echo(str("Rail, L=", length));
	color("LightSteelBlue")
	linear_extrude(height = length)
	square([RailWidth, RailHeight], center = true);
}

RailRunnerHeight = 36;
RailRunnerWidth = 70;
RailRunnerLength = 104;

module RailRunner() {
	echo("Rail runner (flange type)");
	h1 = 5.5;
	t1 = 14;
	color("SpringGreen")
	translate(OZ * h1) {
		hull() {
			linear_extrude(height = RailRunnerHeight - h1)
				square([RailRunnerLength, 48], center = true);
			translate(OZ * (RailRunnerHeight - t1 - h1))
			linear_extrude(height = t1)
				square([RailRunnerLength, 57], center = true);
		};
		translate(OZ * (RailRunnerHeight - t1 - h1))
		linear_extrude(height = t1)
			square([RailRunnerLength, RailRunnerWidth], center = true);
		
	}
	
}