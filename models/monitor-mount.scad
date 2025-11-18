// Thin sign mount for the top of my Dell monitor.

monitor_depth = 25.0; // mm
sign_depth    =  5.1 + 0.1;
drop          =  8.0;

width = 1.618 * monitor_depth; // golden ratio, why not?

front_height = drop;
back_height  = 2 * front_height;
thickness    = 4.0;

module monitor_clip() {
  linear_extrude(thickness)
    square([width, monitor_depth + 2*thickness]);
  translate([0, 0, -drop])
    linear_extrude(drop)
    square([width, thickness]);
  translate([0, monitor_depth + thickness, -drop])
    linear_extrude(drop)
    square([width, thickness]);
}

module sign_holder() {
  linear_extrude(front_height)
    square([width, thickness]);
  translate([0, sign_depth+thickness, 0])
    linear_extrude(back_height)
    square([width, thickness]);
}
monitor_clip();
translate([0, 0, thickness]) sign_holder();