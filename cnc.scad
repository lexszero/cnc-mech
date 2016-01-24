// set to true to use low detalisation parts
LowPoly = false;

include <frame.scad>;

Frame(1240, 770 - 1.25*BeamSize, 1000);

xPos = ($t*2000) % (1240 - 2*AngleJointSize - RailRunnerLength/2);
XAxis(240+BeamSize, 770, 1000, xPos);