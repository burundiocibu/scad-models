
translate([0,0,-5]) cylinder(h=4, d=198, $fn=200, center=true);
difference() {
   cylinder(h=14, d=191, $fn=200, center=true);
   translate([0, 0, 6]) cylinder(h=20, d=191-6, $fn=200, center=true);
}

