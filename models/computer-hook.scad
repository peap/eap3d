// My measurements:
tolerance = 0.05;
back_h = 11.0 + tolerance;
top_w = 20.2 + tolerance;

// My preferences:
width = 8.0;
thickness = 4.0;
clamp_w = 4.0;
front_h = 150.0;
hook_radius = 15; // interior radius

module hook() {
    union() {
        polygon([
            // inside edges
            [clamp_w, 0 - back_h],
            [0, 0 - back_h],
            [0, 0],
            [top_w, 0],
            [top_w, 0 - front_h],
            // back along the outside
            [top_w + thickness, 0 - front_h],
            [top_w + thickness, 0 + thickness],
            [0 - thickness, 0 + thickness],
            [0 - thickness, 0 - back_h - thickness],
            [clamp_w, 0 - back_h - thickness],
        ]);
        // hook loop
        difference() {
            translate([top_w + hook_radius + thickness, 0 - front_h]) {
                difference() {
                    $fn = 100;
                    circle(hook_radius + thickness);
                    circle(hook_radius);
                }
            }
            translate([top_w, 0 - front_h]) {
                square(2 * (hook_radius + thickness) + tolerance);
            }
        }
    }
};

translate([-1 * top_w / 2, front_h / 2]) {
    union() {
        linear_extrude(width) {
            hook();
        }
    }
}
