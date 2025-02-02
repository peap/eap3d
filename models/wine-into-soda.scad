// Soda can adapter for wine fridge.

num_cans = 6;
num_rows = 3;
can_length = 123;
can_diam = 66;
can_radius = can_diam / 2;
can_buffer = 10;

num_rails = 9;
rail_diam = 7.75;
rail_radius = rail_diam/2;
rail_height = 16 - rail_radius;
rail_gaps = [46.55, 47.75, 48.07, 48.07, 48.00, 47.78, 48.27, 45.68];

drawer_width = 25.4 * (18 + 3.5/16); // outer width
drawer_depth = 25.4 * (16 + 2.5/16); // outer depth
drawer_height = 31.4;
drawer_thickness = 1.70;

function rail_offset(i, sum=9.9) = 
  i == 0 ? sum : rail_offset(i-1, sum + rail_diam + rail_gaps[i-1]);

screw_x = 5;
screw_y = 7;
screw_ys = [46, 79];

module screw() { color("blue") cube([screw_x, screw_y, drawer_height]); }
module notch() { color("blue") cube([notch_x, notch_y, drawer_height]); }

notch_x = 40;
notch_y = 5;

module drawer() {
    // Drawer frame
    t = drawer_thickness;
    outer_x = drawer_width;
    outer_y = drawer_depth;
    z = drawer_height;
    difference() {
        cube([outer_x, outer_y, z]);
        translate([t, t, -1])
          cube([outer_x - 2*t, outer_y - 2*t, z+2]);
    }
    // Drawer frame notches / folds
    translate([t, t, 0]) notch();
    translate([outer_x-t-notch_x, t, 0]) notch();
    translate([t, outer_y-t-notch_y, 0]) notch();
    translate([outer_x-t-notch_x, outer_y-t-notch_y, 0]) notch();
    // Screws
    for (i = [0:1:1]) {
        y = screw_ys[i];
        translate([0, y, 0]) screw();
        translate([0, outer_y-y, 0]) screw();
        translate([outer_x-screw_x, y, 0]) screw();
        translate([outer_x-screw_x, outer_y-y, 0]) screw();
    }
    // Rails
    for (i = [0:1:num_rails-1]) {
        translate([rail_offset(i), 0, rail_height])
          rotate([-90, 0, 0]) 
          cylinder(h=outer_y, r=rail_radius);
    }
}

module soda_can(h=can_length) {
    cylinder(h=h, r=can_diam/2);
}

module soda_can_row(can_length=can_length) {
    free_space =
        drawer_width - 2*drawer_thickness -
        num_cans * can_diam -
        (num_cans - 1) * can_buffer;
    for (i = [0:1:num_cans-1]) {
        x = free_space/2 + can_radius + i*(can_diam + can_buffer);
        t = drawer_thickness;
        translate([x + t, 10, rail_height + can_radius+5])
          rotate([-90, 0, 0])
          soda_can(h=can_length);
    }
}

module soda_cans(nr=num_rows, cl=can_length) {
    for (i = [0:1:nr-1]) {
        translate([0, i * (can_length + can_buffer), 0])
          color("green")
          soda_can_row(can_length=cl);
    }
}

module simple_holder() {
    thickness = 12;
    dt = drawer_thickness;
    difference() {
        translate([dt, dt, rail_height]) 
          cube([drawer_width - 2*dt, drawer_depth - 2*dt, thickness]);
        drawer();
        translate([0, -20, 2])
            soda_cans(nr=1, cl=2*drawer_depth);
    }
}

module diamond_grid() {
    t = 20;
    steps = 7;
    x_max = drawer_width;
    y_max = drawer_depth;
    x_step = x_max / steps;
    y_step = y_max / steps;
    difference() {
        square([x_max, y_max]);
        translate([t, t]) square([x_max-2*t, y_max-2*t]);
    }
    intersection() {
        square([drawer_width, drawer_depth]);
        for (i = [0:1:2*steps]) {
            x = i * x_step;
            y = i * y_step;
            polygon([[x, 0], [x+t, 0], [0, y+t], [0, y]]);
            translate([-x_max, 0])
              polygon([[x, 0], [x+t, 0], [2*x_max, 2*y_max-y-t], [2*x_max, 2*y_max-y]]);
        }
    }
}

// drawer();
// soda_cans();
// diamond_grid();

slice_xs = [155, 310];
slice_ys = [140, 270];

module slice_preview() {
    for (i = [0:1:1]) {
        x = slice_xs[i];
        y = slice_ys[i];
        translate([x, 0, 0]) cube([1, drawer_depth, 50]);
        translate([0, y, 0]) cube([drawer_width, 1, 50]);
    }
}
// color("red") slice_preview();

module segment(i=0, j=0) {
    x1 = i == 0 ? 0 : slice_xs[i-1];
    x2 = i == 2 ? drawer_width : slice_xs[i];
    y1 = j == 0 ? 0 : slice_ys[j-1];
    y2 = j == 2 ? drawer_depth : slice_ys[j];
    translate([x1, y1, 0]) cube([x2-x1, y2-y1, 150]);
}

// intersection() {
//     translate([350, 0, 0])
//       cube([150, 90, 150]); // for slicing demos
    intersection() {
        $fn = 100;
        segment(2, 2);
        simple_holder();
        linear_extrude(50) diamond_grid();
    }
// }
