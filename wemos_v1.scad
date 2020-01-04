
wall_thickness=2;
wemos_x=26.2;
wemos_y=35;
wemos_z=10;


difference(){
   wt2=wall_thickness*2;
   cube([wemos_x+wt2,wemos_y+wt2,wemos_z+wall_thickness], center=true);
   translate([0,0,wall_thickness]) cube([wemos_x,wemos_y,wemos_z+1], center=true);
}
