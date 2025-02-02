use <wall cap.scad>;

// Measurements:
wall = 30.3;

drop = 10;
thickness = 8.0;

wheel_width = 12.5;
wheel_radius = 8.0; // not really circular tho
wheel_base = 59.0;
wheel_depth = 6;

bus_width = 41;
bus_length = 105;

$fn = 100;

difference() {
    rotate([90, 0, 0]) cap(length=2*wheel_radius + 2, drop=drop, t=thickness);
    translate([((2*thickness+wall)-bus_width)/2, 0, 0]) {
        wheel_well("left");
        wheel_well("right");
    }
}

module wheel() {
    translate([-wheel_width/2, 0, 0])
      rotate([90, 0, 90])
      cylinder(h=wheel_width, r=wheel_radius);
}

module wheel_well(which = "left") {
    if (which == "left") {
        x = wheel_width / 2;
        translate([x, -wheel_radius - 1, drop + thickness + (wheel_radius - wheel_depth)])
          color("green") wheel();
    } else {
        x = bus_width - wheel_width / 2;
        translate([x, -wheel_radius - 1, drop + thickness + (wheel_radius - wheel_depth)])
        color("red") wheel();
    }
}
