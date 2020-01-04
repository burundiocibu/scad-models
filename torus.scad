d=100; // diameter of ring center
t=8;  // thickness of ring
res=100; // resolution

rotate_extrude($fn=res, convexity = 10)
translate([d/2, 0, 0])
circle(r = t/2, $fn = res);
