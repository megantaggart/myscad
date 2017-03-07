// 
// builds a solid rectangle with rounded corners (Z-only)
//

module screw_enc_block(width, height, depth, fillet_radius) {
    
    difference() {
        cube([width, height, depth], center = true);
        
        fudge = 0.1;
        fudge_depth = depth + 1.0;
        
        translate([-(width / 2), -(height / 2), -(fudge_depth / 2)])
        intersection () {
            cube([fillet_radius, fillet_radius, fudge_depth], center = false); 
            difference() {
                    cube([2 * fillet_radius, 2 * fillet_radius, fudge_depth], center = false); 
                    translate([fillet_radius, fillet_radius, 0.0])
                    cylinder(r = fillet_radius, h = fudge_depth);
            }
        }

        translate([-(width / 2 + fudge), (height / 2 + fudge), -(fudge_depth / 2)])
        rotate([0.0, 0.0, -90])
        intersection () {
            cube([fillet_radius, fillet_radius, fudge_depth], center = false); 
            difference() {
                    cube([2 * fillet_radius, 2 * fillet_radius, fudge_depth], center = false); 
                    translate([fillet_radius, fillet_radius, 0.0])
                    cylinder(r = fillet_radius, h = fudge_depth);
            }
        }

        translate([(width / 2 + fudge), (height / 2 + fudge), -(fudge_depth / 2)])
        rotate([0.0, 0.0, 180])
        intersection () {
            cube([fillet_radius, fillet_radius, fudge_depth], center = false); 
            difference() {
                    cube([2 * fillet_radius, 2 * fillet_radius, fudge_depth], center = false); 
                    translate([fillet_radius, fillet_radius, 0.0])
                    cylinder(r = fillet_radius, h = fudge_depth);
            }
        }

        translate([(width / 2 + fudge), -(height / 2 + fudge), -(fudge_depth / 2)])
        rotate([0.0, 0.0, 90])
        intersection () {
            cube([fillet_radius, fillet_radius, fudge_depth], center = false); 
            difference() {
                    cube([2 * fillet_radius, 2 * fillet_radius, fudge_depth], center = false); 
                    translate([fillet_radius, fillet_radius, 0.0])
                    cylinder(r = fillet_radius, h = fudge_depth);
            }
        }
    }
}

module screw_enc_enclosure(width, height, depth, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius) {
    union() {
    
        translate([0.0, 0.0, depth / 2.0])
        difference() {
            screw_enc_block(width, height, depth, fillet_radius);
            translate([0.0, 0.0, thickness]) 
                screw_enc_block(width - (2 * thickness), height - (2 * thickness), depth - thickness, fillet_radius);
        }
        
        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)), thickness ])
        difference() {
            cylinder(r = standoff_radius, h = (depth - (2 * thickness)), $fn=10);
            cylinder(r = standoff_hole_radius, h = (depth - (2 * thickness)), $fn=10);
        }
    
        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)), thickness ])
        difference() {
            cylinder(r = standoff_radius, h = (depth - (2 * thickness)), $fn=10);
            cylinder(r = standoff_hole_radius, h = (depth - (2 * thickness)), $fn=10);
        }

        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)), thickness ])
        difference() {
            cylinder(r = standoff_radius, h = (depth - (2 * thickness)), $fn=10);
            cylinder(r = standoff_hole_radius, h = (depth - (2 * thickness)), $fn=10);
        }

        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)), thickness ])
        difference() {
            cylinder(r = standoff_radius, h = (depth - (2 * thickness)), $fn=10);
            cylinder(r = standoff_hole_radius, h = (depth - (2 * thickness)), $fn=10);
        }
        
    }
}

module screw_enc_lid(width, height, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius) {
    difference() {
    
        lid_offset = 10.0;
        
        union() {
            translate([0.0, height + lid_offset, thickness / 2.0])
                screw_enc_block(width, height, thickness, fillet_radius);
            translate([0.0, height + lid_offset, thickness / 2.0 + thickness])
                screw_enc_block(width - (2 * thickness), height - (2 * thickness), thickness, fillet_radius);
        }
        
        hole_offset = height + lid_offset;
        
        // holes 
        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r = standoff_hole_radius, h = (2 * thickness), $fn=10);
        
        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r = standoff_hole_radius, h = (2 * thickness), $fn=10);

        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r = standoff_hole_radius, h = (2 * thickness), $fn=10);

        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r = standoff_hole_radius, h = (2 * thickness), $fn=10);
        
        // countersinks
        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r1 = standoff_hole_radius * 2, r2 = 0.0, h = thickness, $fn=10);
        
        translate([-((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r1 = standoff_hole_radius * 2, r2 = 0.0, h = thickness, $fn=10);

        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), -((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r1 = standoff_hole_radius * 2, r2 = 0.0, h = thickness, $fn=10);

        translate([((width / 2) - (thickness + standoff_radius + standoff_offset)), ((height / 2) - (thickness + standoff_radius + standoff_offset)) + hole_offset, 0.0])
        cylinder(r1 = standoff_hole_radius * 2, r2 = 0.0, h = thickness, $fn=10);
                
    }
}


// Customized Enclosure
width = 120.0;       // Width of the enclosure
height = 72.0;       // Height of the enclosure
depth = 20.0;        // Depth of the enclosure
thickness = 2;       // Thickness of the walls and lid
fillet_radius = 5.0; // Amount of corner rounding
// Hidden
standoff_offset = 0.5;      // Position offset from the corner for the stand-offs
standoff_radius = 3.5;      // Radius of the stand-offs
standoff_hole_radius = 1.5; // Radius of the hole in the stand-offs


screw_enc_enclosure(width, height, depth, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius);
screw_enc_lid(width, height, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius);

