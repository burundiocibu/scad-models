
wall_thickness=2;
wemos_x=26;
wemos_y=35;
wemos_z=10;

module wemos_case()
{
   usb_y=9;
   usb_z=4;
   difference(){
      wt2=wall_thickness*2;
      cube([wemos_x+wt2,wemos_y+wt2,wemos_z+wall_thickness]);
      // kill the inside of the enclosure
      translate([wall_thickness,wall_thickness,wall_thickness])
         cube([wemos_x,wemos_y,wemos_z+1]);
      // cut out the micro-usb opening
      translate([wall_thickness+wemos_x/2-usb_y/2,-1,wall_thickness])
         cube([usb_y,wall_thickness+2,usb_z]);
   }
   // Add a support under the antenna
   translate([wall_thickness,wall_thickness+wemos_y-4,wall_thickness])
      cube([wemos_x,4,2.3]);
}

wemos_case();
