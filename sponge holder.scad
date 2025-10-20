include <openscad-utilities/common.scad>
use <openscad-utilities/row layout.scad>

sponge_1_depth = 24;
sponge_2_depth = 20;
wall_thickness = 2.5;

depth = sponge_1_depth + sponge_2_depth + 3 * wall_thickness;
width = 94;
corner_radius = 10;
corner_r = 10;

dish_lip_height = wall_thickness + 10;
spong_holder_dish_h = dish_lip_height - 7;
sponge_lip_height = 70;

bottom_corner_r = 1.5;

adjusted_width = width - 2 * corner_radius;
adjusted_depth = depth - 2 * corner_radius;

divider_width = width - wall_thickness;

total_h = spong_holder_dish_h + sponge_lip_height + corner_r;

intersection() {
    union() {
        dish();
        difference() {
            holder();
            cuts();
            penn();
rotate(180) penn();
        }
    }
    //cube([100, 100, 30], center = true);
}

//cuts();

penny_stack_d = 19.4;
penny_stack_h = 9.4;



module penn() {
translate([5, -(adjusted_width - 20)/2 + penny_stack_d/2 + 8.5, 1])
rotate([0, 0, 90])
translate([0, 0, 0])
row_layout(total_width = adjusted_width - 20, part_width = penny_stack_d, part_count = 2, mode = 0) {
    cylinder(d = penny_stack_d, h = penny_stack_h);
}
}

// translate([-6, -(adjusted_width - 30)/2 + penny_stack_d/2, 1.5])
// rotate([0, 0, 90])
// translate([0, 0, 10])
// row_layout(total_width = adjusted_width - 30, part_width = penny_stack_d, part_count = 2, mode = 0) {
//     cylinder(d = penny_stack_d, h = 5);
// }

module cuts() {
    cut_count = 5;
    cut_width = 4;
    cut_distance = adjusted_width / cut_count;
    cut_vert_dist = 8;
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
                    l2 = total_h - 2 * cut_vert_dist - cut_len - wall_thickness - 2 * cut_width - penny_stack_h + 0.5;
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
    translate([0, 0, spong_holder_dish_h]) {
        reflect([1, 0, 0]) {
            translate([-corner_r + depth/2, adjusted_width/2]) {
                rotate([90, 0, 0]) {
                    linear_extrude(adjusted_width) {
                        part();
                    }
                }
            }
            reflect([0, 1, 0]) {
                translate([depth/2 - corner_radius, adjusted_width/2]) corner();
            }
        }
        reflect([0, 1, 0]) {
            translate([-adjusted_depth/2, -corner_r + width/2]) {
                rotate([90, 0, 90]) {
                    linear_extrude(adjusted_depth) {
                        part();
                    }
                }
            }
        }
        translate([sponge_1_depth - sponge_2_depth, divider_width/2, corner_r]) {
            rotate([90, 0, 0]) {
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
    }
    translate([-adjusted_depth/2, -adjusted_width/2]) {
        cube([adjusted_depth, adjusted_width, corner_r + 2 * bottom_corner_r + spong_holder_dish_h]);
    }
}

module corner() {
    rotate_extrude(angle = 90) part();
}

module part() {
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

module dish() {
    reflect([1, 0, 0]) {
        translate([0, adjusted_width/2]) {
            rotate([90, 0, 0]) {
                linear_extrude(adjusted_width) {
                    dish_part();
                }
            }
        }
        reflect([0, 1, 0]) {
            translate([depth/2 - corner_radius, adjusted_width/2]) dish_corner();
        }
    }
    reflect([0, 1, 0]) {
        translate([-adjusted_depth/2, -depth/2 + width/2]) {
            rotate([90, 0, 90]) {
                linear_extrude(adjusted_depth) {
                    dish_part();
                }
            }
        }
    }
}

module dish_corner() {
    rotate_extrude(angle = 90) {
        translate([-depth/2 + corner_radius, 0]) dish_part();
    }
}

module dish_part() {
    translate([depth/2 - corner_radius, 0]) {
        intersection() {
            translate([-depth/2 + corner_radius, 0]) {
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
            square([1000, 1000]);
        }
    }
}

