use <MCAD/2Dshapes.scad>;

OX = [1, 0, 0];
OY = [0, 1, 0];
OZ = [0, 0, 1];

module array(v, count = 1) {
	for (i = [0:count-1]) {
		translate(i * v) children();
	}
}

include <MCAD/2Dshapes.scad>

module rotX(a) rotate(a * OX) children();
module rotY(a) rotate(a * OY) children();
module rotZ(a) rotate(a * OZ) children();