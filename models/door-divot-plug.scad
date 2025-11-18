// The hole:
width = 16;
height = 4;
depth = 3;

// The base to cover the hole:
base_width = 42;
base_height = 20;
base_thickness = 2;

module plug() {
    cube([width, height, depth]);
    translate([width/3, -1, 0]) cube([1, height + 2, depth]);
    translate([2*width/3, -1, 0]) cube([1, height + 2, depth]);
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
  color("lightgreen") plug();
