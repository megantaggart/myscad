$fn=360;

// IKEA glass cylinder vase
vase_inner_r = 147/2;
vase_wall_thickness = 5;

bottom_holder_thickness = 4; // thickness of bottm parts
bottom_holder_width = 40;    // width of bottom holder
bottom_holder_height = 60;   // height of bottom holder
bottom_holder_insert_y = 40;
bottom_holder_spacer_length = 6;
glass_hole_radius = 10/2;
pully_shaft_radius = 6/2;

bot_comb_mnt_hole_dist = 25;
bot_comb_mnt_hole_rad = 4/2;

pulley_width = 80;
pulley_spacer_radius = 6;



module belt_pully(outer_radius,length,amount_of_ridge, shaft_radius, bering_radius, bering_depth)
{
    translate([-pulley_width/2,0,bottom_holder_insert_y])
    rotate(a=90, v=[0,1,0])
    difference ()
    {
        union()
        {
            // basic shape
            rotate_extrude(convexity = 10, $fn = 100)
            union() 
            {
                square([outer_radius,length]);
                translate([outer_radius,length/2,0]) scale([amount_of_ridge,1,1]) circle(r=length/2);
            }
        }
        union()
        {
            //center shaft hole
            translate(0,0,-1);
            cylinder(r=shaft_radius, h=length*2);
            cylinder(r=bering_radius, h = bering_depth);
            translate([0,0,length-bering_depth]) cylinder(r=bering_radius, h = bering_depth);
        }
    }
    
}

module bottom_holder_basic()
{
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r=vase_inner_r,h=bottom_holder_height);
            }
            union()
            {
                translate([0,0,bottom_holder_thickness])
                    cylinder(r=vase_inner_r-bottom_holder_thickness,h=60);
            }
        }
        translate([0,-bottom_holder_width/2,0])
            cube([vase_inner_r,bottom_holder_width,bottom_holder_height]);
    }
    difference()
    {
        intersection()
        {
            translate([vase_inner_r-bottom_holder_spacer_length,0,bottom_holder_insert_y])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=pulley_spacer_radius,h=bottom_holder_spacer_length);
            cylinder(r=vase_inner_r,h=bottom_holder_height);
        }
        translate([vase_inner_r-bottom_holder_spacer_length-4,0,bottom_holder_insert_y])
            rotate(a=90,v=[0,1,0])
                cylinder(r=pully_shaft_radius,h=bottom_holder_spacer_length+10);
    }
    
}

module bottom_holder()
{
    difference()
    {
        union()
        {
            bottom_holder_basic();
            translate([vase_inner_r-bottom_holder_thickness,0,bottom_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=glass_hole_radius,h=vase_wall_thickness+bottom_holder_thickness);
            
        }
        union()
        {
            translate([vase_inner_r-bottom_holder_thickness-5,0,bottom_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=pully_shaft_radius,h=vase_wall_thickness+bottom_holder_thickness+10);
//bot_comb_mnt_hole_dist = 40;
//bot_comb_mnt_hole_rad = 4/2;
            translate([bot_comb_mnt_hole_dist/2,0,-1])
                cylinder(r=bot_comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(bot_comb_mnt_hole_dist/2),0,-1])
                cylinder(r=bot_comb_mnt_hole_rad,h=vase_inner_r);
        }
    }
}

belt_pully(10,pulley_width,0.05,pully_shaft_radius+1,6,4);
bottom_holder();
//holder_glass_insert();