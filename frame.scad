//LowPoly = true;
include <utils.scad>;
include <parts/beam.scad>;
include <parts/angle_joint.scad>;
include <parts/rail.scad>;

module BeamWithJoints(length, j1 = true, j2 = true) {
	module joints() {
		rotZ(-90) {
			if (j1)
				translate(BeamSize/2 * OY)
					AngleJoint();
			if (j2)
				translate(-BeamSize/2 * OY)
					rotZ(180) AngleJoint();
		};
	};
	
	Beam(length);
		
	joints();
	translate(length * OZ) mirror(OZ) joints();
};

// Builds a simple frame using beams of given lengths
module Frame(szX, szY, szZ) {
	module HorizontalBeams(length, rail = false) {
		translate(BeamSize/2 * (OX + OZ))
		rotate(90 * [-1, -1, -1]) {
			BeamWithJoints(length, j2 = false);
			translate(OX * (szZ - BeamSize - AngleJointSize)) {
				BeamWithJoints(length);
				if (rail) {
					translate([(BeamSize + RailHeight)/2, -BeamSize/4, AngleJointSize]) rotZ(90)
						Rail(length - 2*AngleJointSize);
					translate([BeamSize/4, -BeamSize/2 - RailHeight/2, AngleJointSize])
						Rail(length - 2*AngleJointSize);
					translate([-(BeamSize + RailHeight)/2, -BeamSize/4, AngleJointSize]) rotZ(90)
						Rail(length - 2*AngleJointSize);
				}
			}
		}
	}
	// Z axis (vertical)
	array(OX * (szX + BeamSize), 2)
		array(OY * (szY + BeamSize), 2)
			Beam(szZ);
	
	// X axis
	HorizontalBeams(szX, rail = true);
	mirror(OY) translate(OY * -(szY + BeamSize))
		HorizontalBeams(szX, rail = true);
		
	// Y axis
	array(OX * (szX + BeamSize), 2)
		rotZ(90) HorizontalBeams(szY);
}

module XAxis(szZ, szY, Z, pos) {
	endingSize = BeamSize + 2*AngleJointSize;
	
	module RunnerWithAdapter() {
		RailRunner();
		color("YellowGreen")
		translate(OZ * RailRunnerHeight)
		linear_extrude(height = szZ/2 - BeamSize - RailRunnerHeight)
			square([BeamSize, RailRunnerWidth], center = true);
	}
	
	module BeamWithRunners() {
		color("LightSeaGreen")
		translate(OY * (-RailRunnerWidth/2 + BeamSize/4) +
			OZ * -szZ/2) rotX(-90)
			Beam(szY);
		
		// runners
		array(OY * (szY - RailRunnerWidth), 2)
		translate(OY * (BeamSize/4) + OZ * BeamSize/2)
			RunnerWithAdapter();
	}
		
	module Bridge() {
		translate(OY * (BeamSize + RailRunnerHeight) +
			OZ * (-szZ + BeamSize)/2) {
			color("LightSeaGreen")
			rotZ(90)
				BeamWithJoints(szZ - BeamSize, j2 = false);
		}
		translate(OY * (BeamSize/2) + OZ * (BeamSize/4)) rotX(-90) RailRunner();
	}
	
	translate(OX * (AngleJointSize + (BeamSize + RailRunnerLength)/2 + pos) +
		OZ * (Z - AngleJointSize - BeamSize/2)) {

		BeamWithRunners();
		mirror(OZ) BeamWithRunners();
		
		Bridge();
		mirror(OY) translate(OY * (-szY + BeamSize/4)) Bridge();
	}
}

