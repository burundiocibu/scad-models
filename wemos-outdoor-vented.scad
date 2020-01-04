// A small case for a wemos mini and a temp sensor appropriate for outside use not in
// direct rain. The case is intended to be mounted in with the positive y up to
// keep rain from entering the cavities.

// Size of a wemos d1 mini and sensor
wemos_x=26;
wemos_y=35;
wemos_z=12;
sense_y=30;

// opening for a usb plug
usb_w=14;
usb_h=8;

// louvered (y) wall thickness; needs to be thick enough to allow for holes
// that can keep mist/rain out
yt=3;

// non-louvered wall thickness (horizontal and back surfaces)
xt=2;

// Overall dimenstions of the outside of the case
case_x = wemos_x + 5 + 2*yt;
case_y = wemos_y + sense_y + 3 * xt;
case_z = wemos_z + xt + yt;
echo("case:", case_x, case_y, case_z);

$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

module case() {
   module side_vent(d) {
      rotate([0, 0, 50]) cube([yt*2.3, 1.5, case_z-xt-yt]);
   }
   
   // These are for a #6 wood screw
   id = 3.75; // id of hole
   od = 7; // od of screw head
   shsf = 1.10; // small hole scale factor   
   bt = 4; // Thickness of boss

   difference() {
      union() {
         cube([case_x, case_y, xt]); // Back of case
         cube([yt, case_y, case_z]); //left side
         translate([case_x - yt, 0, 0]) cube([yt, case_y, case_z]); // right side
         cube([case_x, xt, case_z]); // bottom
         translate([0, case_y - xt, 0]) cube([case_x, xt, case_z]); // top
         
         // Support under the antenna
         translate([yt + 4, xt+wemos_y-4, xt])
            cube([wemos_x-3, 4, 2.3]);
         
         // wall between wemos and sensor cavity
         translate([0, wemos_y+xt, 0])
            cube([case_x, xt, case_z-yt]);

         // The mouting boss
         translate([case_x/2, wemos_y+xt+(od+2)/2+4, 0])
            cylinder(h=bt, d=od+2, $fn=100);
      }
      union() {
         // opening into sensor cavity
         translate([4, wemos_y-1+xt, 6])
            cube([4, 4, 20]);
         // And the usb port
         translate([case_x/2 - usb_w/2, -1, xt+0.01])
            cube([usb_w, xt*2, usb_h]);
         // The slot for the lid to go into
         translate([yt-1.5-0.125, xt-0.5, case_z-yt])
            lid(case_x-3+0.25, case_y-xt+2, yt+0.1, v=0);
         // The screwhole in the mounting boss
         translate([case_x/2, wemos_y+xt+(od+2)/2+4, -0.1])
            cylinder(h=bt+1, d=id*shsf, $fn=100);
         // and the countersink
         translate([case_x/2, wemos_y+xt+(od+2)/2+4, bt-3+0.1])
            cylinder(h=3, d1=id*shsf, d2=od*shsf, $fn=100);
        // side vent slots for the sensor section
        for(y=[wemos_y+xt+1:5:case_y-8])
         union() {
            translate([-0.1, y, yt+1])
               rotate([0,0,40]) cube([2*yt, 2, case_z-2*yt-2]) ;
            translate([case_x-4.5, y+4, yt+1])
               rotate([0,0,-40]) cube([2*yt, 2, case_z-2*yt-2]) ;
         }
      }
   }
   
}


module lid(w, h, t, v) {
   ww=1.5;
   echo("Lid:", w, h, t, ww);
   module top_vent() {
      translate([3, 0, 5])
         rotate([-50, 0, 0])
         cube([w - 2*ww - 8, t*3, 1.5]);
   }
   difference() {
      union() {
         translate([ww,0,0])
            cube([w-2*ww, h, t]); // center part of lid
         polyhedron(points=[[0,0,0], [ww,0,0], [ww,0,t],
                           [0,h,0], [ww,h,0], [ww,h,t]],
                    faces=[[0,1,2], [3,5,4],
                           [0,3,4,1], [0,2,5,3], [1,4,5,2]],
                    convexity=10);
         translate([w,0,0])
            mirror([1,0,0])
            polyhedron(points=[[0,0,0], [ww,0,0], [ww,0,t],
                               [0,h,0], [ww,h,0], [ww,h,t]],
                       faces=[[0,1,2], [3,5,4],
                              [0,3,4,1], [0,2,5,3], [1,4,5,2]],
                       convexity=10);
         
      }
      union() {
         // Some vent slots
         if (v>0)
            for(y=[8:5:h-8])
               translate([1+ww, y, 0])
                  top_vent();
      }
      
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


case();
translate([50,0,0]) lid(case_x-3, case_y-xt, yt, v=1);
