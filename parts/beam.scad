BeamSize = 90;

module Beam(length) {
	echo(str("Beam ", BeamSize, "x", BeamSize, ", L=", length));
	color("LightGrey")
	if (LowPoly) {
		translate(length/2 * OZ)
		cube([BeamSize, BeamSize, length], center = true);
	} else {
		scale([1, 1, length/1000])
		import("parts/beam.stl");
	}
}
