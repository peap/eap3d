// Measured:
wall_width = 30.3;
// tolerance = 0.05;
$fn = 100;

// Desired:
thickness = 4.0;
drop = wall_width;
hook_radius = 12.0;
length = 8.0;

module cap(length, drop = drop, t = thickness) {
    w = wall_width;
    linear_extrude(length) {
        square([t, drop]);
        translate([0, drop]) square([t + w + t, t]);
        translate([t + w, 0]) square([t, drop]);
    }
}

module hook(length, radius) {
    linear_extrude(length) {
        difference() {
            circle(radius);
            circle(radius-thickness);
            translate([-radius, 0]) square(2*radius);
        }
    }
}

cap(length=length);
translate([-hook_radius + thickness, 0, 0]) color("green")
  hook(length=length, radius=hook_radius);
translate([wall_width + hook_radius + thickness, 0, 0]) color("green")
  hook(length=length, radius=hook_radius);
