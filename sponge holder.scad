include <openscad-utilities/common.scad>
use <openscad-utilities/row layout.scad>

sponge_1_depth = 24;
sponge_2_depth = 20;
sponge_width = 0;
sponge_length = 0;

wall_thickness = 2.5;

depth = sponge_1_depth + sponge_2_depth + 3 * wall_thickness;
width = 94;
sponge_lip_height = 70;

corner_r = 10;
adjusted_width = width - 2 * corner_r;
adjusted_depth = depth - 2 * corner_r;

dish_lip_height = wall_thickness + 10;
sponge_holder_dish_h = dish_lip_height - 7;
cut_bottom_h = dish_lip_height - 1;

bottom_corner_r = 1.5;

total_h = sponge_holder_dish_h + sponge_lip_height + corner_r;

bottom_void_height_offset = 1.5;

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
    cut_len = 23;

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


divider_width = width - wall_thickness;



                // linear_extrude(divider_width){
                //     translate([-wall_thickness/2, 0]) {
                //         square([wall_thickness, sponge_lip_height - wall_thickness/2]);
                //     }
                //     translate([0, sponge_lip_height - wall_thickness/2]) {
                //         circle(wall_thickness/2);
                //     }
                // }

module holder() {
    divider_width = width - wall_thickness;
    translate([0, 0, sponge_holder_dish_h]) {
        boxify()
            holder_2d();
        translate([sponge_1_depth - sponge_2_depth, divider_width/2, corner_r]) {
            rotate([90, 0, 0]) {
                // Use tombstone
                linear_extrude(divider_width){
                    translate([-wall_thickness/2, 0]) {
                        square([wall_thickness, sponge_lip_height - wall_thickness/2]);
                    }
                    translate([0, sponge_lip_height - wall_thickness/2]) {
                        circle(wall_thickness/2);
                    }
                }
            }
        }
        translate([wall_thickness/2, divider_width/2, corner_r])
            rotate([0, -90, 90])
                tombstone([sponge_lip_height - wall_thickness/2, wall_thickness, divider_width]);
    }
    difference() {
        translate([-adjusted_depth/2, -adjusted_width/2]) {
            cube([adjusted_depth, adjusted_width, corner_r + 2 * bottom_corner_r + sponge_holder_dish_h]);
        }
        void_depth = adjusted_depth - 2 * wall_thickness;
        void_width = adjusted_width - 2 * wall_thickness;
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
    translate([-wall_thickness + corner_r, bottom_corner_r + corner_r]) {
        square([wall_thickness, sponge_lip_height - bottom_corner_r - wall_thickness/2]);
    }
    translate([-wall_thickness/2 + corner_r, sponge_lip_height + corner_r - wall_thickness/2]) {
        circle(wall_thickness/2);
    }
    hull() {
        translate([-bottom_corner_r + corner_r, bottom_corner_r + corner_r]) {
            circle(bottom_corner_r);
        }
        square([0.001, corner_r + 2 * bottom_corner_r]);
    }
}

module dish_2d() {
    translate([0, 0]) {
        intersection() {
            translate([-depth/2 + corner_r, 0]) {
                union() {
                    square([depth/2 - bottom_corner_r, wall_thickness]);
                    translate([depth/2 - bottom_corner_r, bottom_corner_r]) {
                        circle(bottom_corner_r);
                    }
                    translate([depth/2 - wall_thickness, bottom_corner_r]) {
                        square([wall_thickness, dish_lip_height - bottom_corner_r - wall_thickness/2]);
                    }
                    translate([depth/2 - wall_thickness/2, dish_lip_height - wall_thickness/2]) {
                        circle(wall_thickness/2);
                    }
                }
            }
            // Remove need for this intersect
            square([1000, 1000]);
        }
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
