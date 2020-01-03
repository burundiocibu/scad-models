/*                                                 -*- c++ -*-
 * A Bahtinov mask generator.
 * Units in mm, default values are for
 * a Celestron NexStar GPS 8.
 *
 * Copyright 2013-2014, Brent Burton
 * License: CC-BY-SA
 *
 * Updated: 2014-06-23
 * Updated: 2019-11-09 - increased center diameter limit to 120.
 */

tubeOuterDiameter = 117; // [80:400]

sideThickness = 2;

// This is the diameter of the mask.
outerDiameter = tubeOuterDiameter + 2*sideThickness;

// The telescope light's path diameter.
aperture = 102; // [80:400]

// Diameter of secondary mirror holder. If no secondary, set to 0.
centerHoleDiameter = 0; // [0:120]

// Width of the gaps and the bars.
gap = 4; // [4:10]

/* create a series of bars covering roughly one half of the
 * scope aperture. Located in the +X side.
 */
module bars(gap, width, num=5) {
    num = round(num);
    for (i=[-num:num]) {
        translate([width/2,i*2*gap]) square([width,gap], center=true);
    }
}

module bahtinovBars(gap,width) {
    numBars = aperture/2 / gap / 2 -1;
    // +X +Y bars
    intersection() {
        rotate([0,0,30])
            bars(gap, width, numBars);
        square([outerDiameter, outerDiameter], center=false);
    }
    // +X -Y bars
    intersection() {
        rotate([0,0,-30])
            bars(gap, width, numBars);
        translate([0,-outerDiameter])
        square([outerDiameter, outerDiameter], center=false);
    }
    // -X bars
    rotate([0,0,180])
        bars(gap, width, numBars);
}

$fn=180;
module bahtinov2D() {
    R = aperture/2;
    difference() {
        union() {
            difference() {            // makes circular mask bars
                circle(r=R);
                bahtinovBars(gap,R);
            }

            difference() {                  // makes the outer margin
                circle(r=outerDiameter/2);
                circle(r=R);
            }

            if (centerHoleDiameter > 0 && centerHoleDiameter < outerDiameter) {
                circle(r=centerHoleDiameter/2+3);
            }

            // Add horizontal and vertical structural bars:
            square([gap, 2*(R-1)], center=true);
            translate([R/2, 0])
                square([R-1, gap], center=true);
        }

        // subtract center hole if needed:
        if (centerHoleDiameter > 0 && centerHoleDiameter < outerDiameter) {
            circle(r=centerHoleDiameter/2);
        }
    }
}

module sleeve() {
   difference(){
      cylinder(r=outerDiameter/2, h=12);
      translate([0,0,-1]) cylinder(r=tubeOuterDiameter/2, h=14);
   }
}

linear_extrude(height=2) bahtinov2D();
translate([0,0,0])
   sleeve();
