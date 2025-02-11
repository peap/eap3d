// Contacts dispenser

// An individual contact package
pkg_width  = 30;
pkg_depth  = 47;
pkg_height = 7.6;

// Interior volume
n_per_row  = 5;
n_rows     = 90 / 5;
x = pkg_width * n_per_row;
y = pkg_depth;
z = pkg_height * n_rows;

// Preferences
wall_thickness = 3;

module contacts() {
  color("blue") cube([x, y, z], center=true);
}

module tray() {
  t = wall_thickness;
  // base
  difference() {
    translate([0, -y/2, -z/2])
      color("red")
      cube([x + 2*t, 2*y + 2*t, pkg_height + t], center=true);
    translate([0, -y/2, -z/2 + t])
      color("pink")
      cube([x, 2*y, pkg_height], center=true);
  }
  // ramp
  translate([-x/2, y/2, -z/2])
    rotate([-90, -90, -90])
    color("green")
    linear_extrude(x)
    polygon([[0, 0], [y/2, 0], [0, y]]);
}

module chamber() {
  t = wall_thickness;
  difference() {
    cube([x + 2*t, y + 2*t, z], center=true);
    contacts();
    // exit door
    dt = 1.75 * pkg_height;
    translate([0, -y/2, -z/2+dt/2])
      color("green")
      cube([x, y, dt], center=true);
  }
}

module dispenser() {
  chamber();
  tray();
}

dispenser();