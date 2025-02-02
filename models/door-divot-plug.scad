// The hole:
width = 16;
height = 4;
depth = 3;

// The base to cover the hole:
base_width = 42;
base_height = 20;
base_thickness = 1.6;

module plug() {
    color("lightgreen")
      cube([width, height, depth]);
}

module base() {
    intersection() {
        translate([base_width/2, base_height/2, -base_thickness])
          cylinder(h=3*base_thickness, r=base_height);
        cube([base_width, base_height, base_thickness]);
    }
}

$fn=100;

base();
translate([base_width/2 - width/2, base_height/2 - height/2, base_thickness])
  plug();
