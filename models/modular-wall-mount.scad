// Modular wall hook

screw_diam        =  4.25;
screw_head_diam   =  6.25;
screw_head_recess =  4.0;
screw_length      = 27.5;

mount_width  = 1.00 * 25.4;
mount_height = 2.50 * 25.4;
mount_depth  = 0.50 * 25.4;

adapter_edge = 5;

module screw() {
  h = screw_length;
  translate([0, 0, 0 - screw_head_recess - h])
    cylinder(h=h, d=screw_diam);
  translate([0, 0, 0 - screw_head_recess])
    cylinder(h=screw_head_recess, d=screw_head_diam);
}

module notch() {
  x = mount_depth;
  y = 1.25*mount_depth;
  rotate([0, -90, 180])
    linear_extrude(mount_width)
    polygon([[0, 0], [x, 0], [0, y]]);
}

module mount_base() {
  r = 5;
  x = mount_width;
  y = mount_height;
  module corner() { cylinder(h=mount_depth, r=5); }
  difference() {
    hull() {
      translate([r,   r,   0]) corner();
      translate([x-r, r,   0]) corner();
      translate([r,   y-r, 0]) corner();
      translate([x-r, y-r, 0]) corner();
    }
    translate([0, y, 0]) notch();
  }
}

module mount() {
  x = mount_width;
  y = mount_height;
  difference() {;
    mount_base();
    translate([x*1/2, y*2/7, mount_depth]) screw();
    translate([x*1/2, y*5/7, mount_depth]) screw();
  }
}

module adapter_base() {
  x = mount_width  + 2*adapter_edge;
  y = mount_height + adapter_edge - 5;
  z = mount_depth  + adapter_edge;
  difference() {
    translate([-adapter_edge, 5, 0]) cube([x, y, z]);
    mount_base();
  }
}

purse_diam  = 3.5 * 25.4;
strap_width = 1.5 * 25.4;
rim_height = 2*adapter_edge;

module strap_arc() {
  d = purse_diam;
  h = strap_width;
  t = adapter_edge;
  l = rim_height;
  difference() {
    union() {
      difference() {
        union() {
          // main arch
          cylinder(h=h, d=d);
          // wall-side rim
          cylinder(h=t, d=d+l);
          // front-side rim
          translate([0, 0, h]) cylinder(h=t, d=d+l);
        }
        // inner hollow
        cylinder(h=2*h, d=d-t);
      }
      // tapered support spokes
      difference() {
        linear_extrude(h + t) {
          for (za = [0:30:180]) {
            rotate([0, 0, za])
              translate([0, -t/2, 0])
              square([d/2-1, t]);
          }
        }
        translate([0, 0, mount_depth+t])
          cylinder(h=h+t-mount_depth, r1=mount_width/2, r2=d/2);
      }
    }
    // trim bottom
    translate([-d/2-t, -d, 0]) cube([2*d, d, 2*h]);
  }
}

module adapter_for_purse() {
  x = mount_width / 2;
  y = mount_height + 2*adapter_edge - purse_diam / 2;
  difference() {
    union() {
      translate([x, y, 0]) strap_arc();
      adapter_base();
    }
    mount_base();
  }
}

$fn = 200;
// color("red") mount();
adapter_for_purse();
