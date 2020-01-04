// d: diameter of ends
// w: width of entire oval
// h: height of oval
module oval(d, w, h) {
   union() {
      translate([0, 0, h/2])
         cube([w-d, d, h], center=true);         
      translate([-(w-d)/2, 0, 0])
         cylinder(h=h, d=d, $fn=100);
      translate([(w-d)/2, 0, 0])
         cylinder(h=h, d=d, $fn=100);
   }
}

module mounting_ear() {
   // These are for a #6 wood screw
   id = 3.75; // id of hole
   od = 7; // od of screw head
   shsf = 1.10; // small hole scale factor
   
   t = 4; // Thickness of ear
   w = od + 3;   // Width

   translate([w/2,w/2,2]) difference() {
      union() {
         cylinder(h=t,d=w,center=true,$fn=100);
         translate([-w/4,0,0])
            cube([w/2,w,t],center=true);
      };
      cylinder(h=t+2,d=id*shsf,center=true,$fn=100);
      translate([0,0,t-3]) cylinder(h=3, d1=id*shsf, d2=od*shsf, $fn=100, center=true);
   }
}
