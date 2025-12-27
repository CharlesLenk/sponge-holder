include <openscad-utilities/common.scad>
use <openscad-utilities/row layout.scad>

sponge_1_depth = 25;
sponge_2_depth = 18;
sponge_width = 88;
sponge_length = 137;

wall_thickness = 2.5;
depth = sponge_1_depth + sponge_2_depth + 3 * wall_thickness;
width = sponge_width + 2 * wall_thickness;
sponge_lip_height = 0.6 * sponge_length;

corner_r = 10;
adjusted_width = width - 2 * corner_r;
adjusted_depth = depth - 2 * corner_r;

sponge_base_offset = wall_thickness + 5;
total_h = sponge_base_offset + corner_r + sponge_lip_height;

dish_lip_height = wall_thickness + 10;
cut_bottom_h = dish_lip_height - 1.5;

sponge_holder();

module sponge_holder() {
    dish();
    difference() {
        holder();
        cuts();
    }
}

module cuts() {
    cut_width = 5;
    cut_vert_dist = 7;
    cut_len = (total_h - dish_lip_height - 3 * cut_vert_dist)/2;

    translate([0, 0, total_h - cut_vert_dist]) {
        rotate([270, 0, 90]) {
            translate([-adjusted_width/2 + cut_width/2, cut_width/2]) {
                row_layout(total_width = adjusted_width, part_width = cut_width, min_space_width = cut_vert_dist, mode = 2) {
                    hull() {
                        cylinder(depth + 2, d = cut_width, center = true);
                        translate([0, cut_len]) {
                            cylinder(depth + 2, d = cut_width, center = true);
                        }
                    }
                    l2 = total_h - 2 * cut_vert_dist - cut_len - 2 * cut_width - cut_bottom_h;
                    translate([0, cut_len + cut_vert_dist + cut_width, 0]) {
                        hull() {
                            cylinder(depth + 2, d = cut_width, center = true);
                            translate([0, l2]) {
                                cylinder(depth + 2, d = cut_width, center = true);
                            }
                        }
                    }
                }
            }
        }
    }
}

module holder() {
    divider_width = width - wall_thickness;
    translate([depth/2 - wall_thickness - sponge_1_depth, divider_width/2, sponge_base_offset + corner_r])
        rotate([0, -90, 90])
            tombstone([sponge_lip_height, wall_thickness, divider_width]);
    translate([0, 0, sponge_base_offset]) {
        boxify()
            holder_2d();
    }
    difference() {
        translate([-adjusted_depth/2, -adjusted_width/2]) {
            cube([adjusted_depth, adjusted_width, sponge_base_offset + corner_r]);
        }
        void_depth = adjusted_depth - 2 * wall_thickness;
        void_width = adjusted_width - 2 * wall_thickness;
        bottom_void_height_offset = 1.5;
        translate([-void_depth/2, -void_width/2, bottom_void_height_offset]) {
            cube([void_depth, void_width, cut_bottom_h - 2 * bottom_void_height_offset]);
        }
    }
}

module dish() {
    boxify()
        dish_2d();
}

module holder_2d() {
    translate([-wall_thickness + corner_r, corner_r]) {
        square([wall_thickness, sponge_lip_height - wall_thickness/2]);
    }
    translate([-wall_thickness/2 + corner_r, sponge_lip_height + corner_r - wall_thickness/2]) {
        circle(wall_thickness/2);
    }
    hull() {
        translate([-wall_thickness/2 + corner_r, corner_r])
            rotate(180)
                pie_wedge_2d(wall_thickness/2, 180);
        square([0.001, corner_r]);
    }
}

module dish_2d() {
    square([corner_r - wall_thickness/2, wall_thickness]);
    translate([corner_r - wall_thickness/2, wall_thickness/2]) {
        circle(wall_thickness/2);
    }
    translate([corner_r - wall_thickness, wall_thickness/2]) {
        square([wall_thickness, dish_lip_height - wall_thickness/2 - wall_thickness/2]);
    }
    translate([corner_r - wall_thickness/2, dish_lip_height - wall_thickness/2]) {
        circle(wall_thickness/2);
    }
}

module boxify() {
    reflect([1, 0, 0]) {
        translate([adjusted_depth/2, adjusted_width/2]) {
            rotate([90, 0, 0]) {
                linear_extrude(adjusted_width) {
                    children();
                }
            }
        }
        reflect([0, 1, 0]) {
            translate([depth/2 - corner_r, adjusted_width/2])
                rotate_extrude(angle = 90)
                    children();
        }
    }
    reflect([0, 1, 0]) {
        translate([-adjusted_depth/2, width/2 - corner_r]) {
            rotate([90, 0, 90]) {
                linear_extrude(adjusted_depth) {
                    children();
                }
            }
        }
    }
}
