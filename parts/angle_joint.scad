include <../utils.scad>;

AngleJointWidth = 85;
AngleJointSize = 86;

module AngleJoint() {
echo("Angle joint");
W = AngleJointWidth;
L = AngleJointSize;

baseThickness = 9;
sideThickness = 8;

module groove(w, h, h1, hd, depth = 2.6, center = true, r = 2) {
	module base()
		translate(OY * (center ? 0 : h/2))
		roundedSquare(pos = [w, h]);
	
	translate(OY * (center ? h/2 : 0))
	hull() {
		linear_extrude(height = depth, scale = [1, h1/h])
			base();
				
		// kludge to avoid z-fighting
		mirror(OZ) linear_extrude(height = 10)
			base();
	}
}

module hole() {
	w = 8.5;
	h1 = 23.5;
	h = 32;
	translate([18 + w/2, h1, 0])
	mirror(OY) union() {
		groove(w, h, h1, depth = baseThickness, center = false);
		
		// kludge to avoid z-fighting
		translate(h1/2 * OY)
		linear_extrude(height = baseThickness + 10)
		roundedSquare(pos = [w, h1]);
	}
}

module holes() union() {
	margin = 7.5;
	translate(15.5 * OY) hole();
	translate(55.5 * OY) hole();
	
	translate([31.7+3, L, 0]) mirror(OY) union() {
		translate([0, margin, 0])
			groove(6, 32.5, 26);
		translate([0, 43, 0])
			groove(6, 37, 30.6);
	}
	
	w = 26;
	h = 72.5;
	translate((L-margin-h) * OY)
		groove(w, 72.5, 66);
}

module half() difference() {
	union() {
		cube([W/2, L, baseThickness]);
		mirror(OY) rotX(90)
			cube([W/2, L, baseThickness]);
		translate((W/2-sideThickness) * OX)
			cube([sideThickness, L, L]);
	};

	if (!LowPoly) {
		// make holes and pockets, which are symmetric
		holes();
		mirror(OY) rotX(90) holes();
	}

	// cut at 45°, leaving small facets on both bases
	ll = L + 1;
	mirror(OX)
	rotY(-90)
	linear_extrude(height = W/2+1)
	polygon([
		[ll, ll],
		[ll, baseThickness-2],
		[baseThickness-2, ll],
	]);
}

color("LightGrey") union() {
	half();
	mirror() half();
}

}
