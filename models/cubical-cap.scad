// Like wall-cap.scad, but for my new cubicle wall.
//
// Shape:
//   ----------
//   |        |  topper_width
//   ---    ---
//      |  |     indent_width
//   ---    ---
//   |        |  overhang_width
//   --      --
//    |      |   wall_width
//    |      |

// Measured:
topper_width    = 78.70; // mm
topper_height   =  9.70;
indent_width    = 11.50 - 8; // for easier installation
indent_height   =  8.05;
overhang_width  =  3.00;
overhang_height =  4.40;

// tolerance = 0.05;
$fn = 100;

// Desired:
thickness = 5.0;
drop = topper_width;
hook_radius = 20.0;
length = 8.0;

module wall(drop=drop) {
  linear_extrude(length) {
    w1 = topper_width;
    w2 = topper_width - 2 * indent_width;
    w3 = topper_width;
    w4 = topper_width - 2 * overhang_width;
    y1 = 0 - topper_height;
    y2 = y1 - indent_height;
    y3 = y2 - overhang_height;
    y4 = y3 - drop;
    translate([             0, y1, 0]) square([w1, topper_height]);
    translate([  indent_width, y2, 0]) square([w2, indent_height]);
    translate([             0, y3, 0]) square([w3, overhang_height]);
    translate([overhang_width, y4, 0]) square([w4, drop]);
  }
}

module cap(length, drop = drop, t = thickness) {
    w = topper_width + 2*t;
    difference() {
      linear_extrude(length) {
        translate([-t, -drop, 0]) square([w, drop+t]);
      }
      wall();
    }
}

module hook(length, radius) {
    t = thickness + overhang_width;
    linear_extrude(length) {
        difference() {
            circle(radius);
            circle(radius-t);
            translate([-radius, 0]) square(2*radius);
        }
    }
}

translate([thickness, 0, 0]) cap(length=length);
translate([-hook_radius + thickness + overhang_width, -drop, 0]) color("green")
  hook(length=length, radius=hook_radius);
translate([topper_width + hook_radius + thickness - overhang_width, -drop, 0]) color("green")
  hook(length=length, radius=hook_radius);
