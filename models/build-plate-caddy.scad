// Print bed sheet holder - Prusa Mini

slots = 4;
slot_w = 10;
wall_h = 100;
wall_w = 4;
depth = 150;
base = 5;

total_w = slots * (slot_w + wall_w) + wall_w;

module base() {
    union() {
        cube([total_w, depth, base]);
        intersection() {
            translate([0, depth, 0])
              cube([total_w, base, wall_h]);
            translate([0, depth/1.75, base])
              rotate([90, 0, 90])
              cylinder(h=total_w, r=depth/1.75);
        }
    }
}

module slots() {
    for(x = [0:slots]) {
        translate([x*(slot_w+wall_w), 0, 0]) {
            intersection() {
                cube([wall_w, depth, wall_h]);
                translate([0, depth/1.75, 0]) sphere(depth/1.75);
            }
        }
    }
}

module label() {
    translate([2, depth/1.75, 2*base])
      rotate([90, 0, -90]) 
      linear_extrude(3) 
      text("build plates");
}

translate([-total_w/2, -depth/2, 0]) {
    union() {
        $fn = 300;
        base();
        translate([0, 0, base]) slots();
        label();
    }
}
