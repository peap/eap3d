diameter = 69;
min_base_thickness = 3;

radius = diameter / 2;
base_peak = radius;

difference() {
    $fn = 100;
    rotate_extrude(angle=360)
        polygon([[0, 0], [radius, 0], [0, base_peak]]);
    translate([0, 0, radius + min_base_thickness])
        sphere(radius);
}