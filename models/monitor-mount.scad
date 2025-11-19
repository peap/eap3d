// Thin sign mount for the top of my Dell monitor.

monitor_depth = 25.0; // mm
sign_depth    =  5.1;
front_drop    =  8.0;
back_drop     = 12.0;

width = monitor_depth;

front_height = front_drop;
back_height  = 2 * front_height;
thickness    = 4.0;

module monitor_clip() {
  linear_extrude(thickness)
    square([width, monitor_depth + 2*thickness]);
  translate([0, 0, -front_drop])
    linear_extrude(front_drop)
    square([width, thickness]);
  translate([0, monitor_depth + thickness, -back_drop])
    linear_extrude(back_drop)
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
translate([0, monitor_depth/2 - sign_depth/2, thickness]) sign_holder();