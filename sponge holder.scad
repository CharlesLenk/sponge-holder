include <openscad-utilities/common.scad>
use <openscad-utilities/row layout.scad>

// The interior depth of each sponge slot
sponge_slot_1_depth = 24;
sponge_slot_2_depth = sponge_slot_1_depth;
// The interior height of the sponge slots
sponge_slot_height = 80;

// The thickness of the walls
wall_thickness = 2.5;
// The radius of the corners
corner_r = 10;

// Height of the weight void
void_height = 8.5;
// The z dimension wall width of the bottom void
bottom_void_z_wall_width = 1.5;
// Sponge slot high offset from dish bottom
sponge_base_offset = void_height + 2 * bottom_void_z_wall_width + 7;
// The bottom of the drying cut
cut_bottom_h = void_height + 2 * bottom_void_z_wall_width;
// Drip dish wall heigh. Overlaps the cut so water drains into the dish
dish_lip_height = cut_bottom_h + 2;

// Width of the weight void. The width of the holder is based on this number
void_width = 72;
// The height, width, and depth of the holder itself
holder_height = sponge_base_offset + sponge_slot_height;
holder_width = void_width + 2 * wall_thickness + 2 * corner_r;
holder_depth = sponge_slot_1_depth + sponge_slot_2_depth + 3 * wall_thickness;

// Interior sizes for lining up parts
interior_width = holder_width - 2 * corner_r;
interior_depth = holder_depth - 2 * corner_r;

// Depth of the weight void
void_depth = interior_depth - 2 * wall_thickness;

sponge_holder();

echo_values([
    ["sponge_slot_height", sponge_slot_height],
    ["sponge_slot_width", holder_width - 2 * wall_thickness],
    ["sponge_slot_depth", sponge_slot_1_depth]
]);
echo_values([["holder_height", holder_height], ["holder_width", holder_width], ["holder_depth", holder_depth]]);
echo_values([["void_height", void_height], ["void_width", void_width], ["void_depth", void_depth]]);

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
    cut_len = (holder_height - dish_lip_height - 3 * cut_vert_dist)/2;

    translate([0, 0, holder_height - cut_vert_dist]) {
        rotate([270, 0, 90]) {
            translate([-interior_width/2 + cut_width/2, cut_width/2]) {
                row_layout(total_width = interior_width, part_width = cut_width, min_space_width = cut_vert_dist, mode = 2) {
                    hull() {
                        cylinder(holder_depth + 2, d = cut_width, center = true);
                        translate([0, cut_len]) {
                            cylinder(holder_depth + 2, d = cut_width, center = true);
                        }
                    }
                    l2 = holder_height - 2 * cut_vert_dist - cut_len - 2 * cut_width - cut_bottom_h;
                    translate([0, cut_len + cut_vert_dist + cut_width, 0]) {
                        hull() {
                            cylinder(holder_depth + 2, d = cut_width, center = true);
                            translate([0, l2]) {
                                cylinder(holder_depth + 2, d = cut_width, center = true);
                            }
                        }
                    }
                }
            }
        }
    }
}

module holder() {
    divider_width = holder_width - wall_thickness;
    translate([holder_depth/2 - wall_thickness - sponge_slot_1_depth, divider_width/2, sponge_base_offset])
        rotate([0, -90, 90])
            tombstone([sponge_slot_height, wall_thickness, divider_width]);
    translate([0, 0, -corner_r + sponge_base_offset]) {
        boxify()
            holder_2d();
    }
    difference() {
        translate([-interior_depth/2, -interior_width/2]) {
            cube([interior_depth, interior_width, sponge_base_offset]);
        }
        translate([-void_depth/2, -void_width/2, bottom_void_z_wall_width]) {
            cube([void_depth, void_width, void_height]);
        }
    }
}

module dish() {
    boxify()
        dish_2d();
}

module holder_2d() {
    translate([-wall_thickness + corner_r, corner_r]) {
        square([wall_thickness, sponge_slot_height - wall_thickness/2]);
    }
    translate([-wall_thickness/2 + corner_r, sponge_slot_height + corner_r - wall_thickness/2]) {
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
        translate([interior_depth/2, interior_width/2]) {
            rotate([90, 0, 0]) {
                linear_extrude(interior_width) {
                    children();
                }
            }
        }
        reflect([0, 1, 0]) {
            translate([holder_depth/2 - corner_r, interior_width/2])
                rotate_extrude(angle = 90)
                    children();
        }
    }
    reflect([0, 1, 0]) {
        translate([-interior_depth/2, holder_width/2 - corner_r]) {
            rotate([90, 0, 90]) {
                linear_extrude(interior_depth) {
                    children();
                }
            }
        }
    }
}
