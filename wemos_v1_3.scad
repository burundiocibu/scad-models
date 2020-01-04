wemos_x=26;
wemos_y=35;
sense_y=20;

wt=2;
wt2=wt*2;

case_x = wemos_x;
case_y = wemos_y + sense_y;
case_z = 10;

usb_w=10;
usb_h=6;


module case() {
   difference() {
      // outside of case
      cube([case_x+wt2, case_y+wt2, case_z+wt]);
      // kill the inside of the enclosure
      translate([wt,wt,wt])
         cube([case_x, case_y, case_z+1]);
      // cut out the micro-usb opening
      translate([wt+case_x/2-1, wt+0.5, wt/2+usb_h/2])
         rotate([90,0,0]) oval(d=usb_h, w=usb_w, h=wt+2);
   };
   // Add a support under the antenna
   translate([wt, wt+wemos_y-4, wt])
      cube([wemos_x, 4, 2.3]);
   // wall between wemos and sensor cavity
   difference() {
      translate([wt, wemos_y+wt, wt])
         cube([case_x, wt, case_z-wt]);
      // Cut a wiring notch 'above' the device
      translate([wt+1, wemos_y+wt-1, wt+4])
         cube([3.5, 2*wt+2, 5]);
   }
   
   translate([case_x+wt2, 0, 0]) mounting_ear();
   translate([case_x+wt2, case_y-wt2-1.75, 0]) mounting_ear();
   translate([0,9.6,0]) rotate([0, 0, 180]) mounting_ear();
   translate([0, case_y-wt2+6+1.75, 0]) rotate([0, 0, 180]) mounting_ear();
}


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
   od = 6.6; // od of screw head
   shsf = 1.15; // small hole scale factor
   
   t = 3.5; // Thickness of ear
   w = od + 3;   // Width

   translate([w/2,w/2,1.5]) difference() {
      union() {
         cylinder(h=t,d=w,center=true,$fn=100);
         translate([-w/4,0,0])
            cube([w/2,w,t],center=true);
      };
      cylinder(h=t+2,d=id*shsf,center=true,$fn=100);
      translate([0,0,t-2.6]) cylinder(h=2.6, d1=id*shsf, d2=od*shsf, $fn=100, center=true);
   }
}

module lid() {
   cube([case_x+wt2, case_y+wt2, wt]);
   inset=0.1;
   translate([wt+inset, wt+inset, 0])
      cube([case_x-inset*2, case_y-inset*2, wt*2]);
}


case();
//translate([45,0,0]) lid();
