$fn=360;

// IKEA glass cylinder vase
vase_inner_r = 147/2;
vase_wall_thickness = 5;

top_holder_thickness = 4; // thickness of toptm parts
top_holder_width = 40;    // width of top holder
top_holder_height = 60;   // height of top holder
top_holder_insert_y = 40;
top_holder_spacer_length = 6;
glass_hole_radius = 10/2;

top_comb_mnt_hole_dist = 25;
top_comb_mnt_hole_rad = 4/2;

pully_shaft_radius = 6/2;
pulley_width = 55;
pulley_spacer_radius = 6;

bot_pulley_spacer_radius = 10;
bot_holder_spacer_length = 10;

bering_radius = 12.6/2;
bering_width = 4;

module belt_pully(outer_radius,length,amount_of_ridge, shaft_radius, bering_radius, bering_depth)
{
    translate([-pulley_width/2,0,top_holder_insert_y])
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

module top_holder_basic()
{
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r=vase_inner_r,h=top_holder_height);
            }
            union()
            {
                translate([0,0,top_holder_thickness])
                    cylinder(r=vase_inner_r-top_holder_thickness,h=60);
            }
        }
        translate([0,-top_holder_width/2,0])
            cube([vase_inner_r,top_holder_width,top_holder_height]);
    }
    difference()
    {
        intersection()
        {
            translate([vase_inner_r-top_holder_spacer_length,0,top_holder_insert_y])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=pulley_spacer_radius,h=top_holder_spacer_length);
            cylinder(r=vase_inner_r,h=top_holder_height);
        }
        translate([vase_inner_r-top_holder_spacer_length-4,0,top_holder_insert_y])
            rotate(a=90,v=[0,1,0])
                cylinder(r=pully_shaft_radius,h=top_holder_spacer_length+10);
    }
    
}

module top_holder()
{
    difference()
    {
        union()
        {
            top_holder_basic();
            translate([vase_inner_r-top_holder_thickness,0,top_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=glass_hole_radius,h=vase_wall_thickness+top_holder_thickness);
            
        }
        union()
        {
            translate([vase_inner_r-top_holder_thickness-5,0,top_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=pully_shaft_radius,h=vase_wall_thickness+top_holder_thickness+10);
            translate([top_comb_mnt_hole_dist/2,0,-1])
                cylinder(r=top_comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(top_comb_mnt_hole_dist/2),0,-1])
                cylinder(r=top_comb_mnt_hole_rad,h=vase_inner_r);
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
                cylinder(r=vase_inner_r,h=top_holder_height);
            }
            union()
            {
                translate([0,0,top_holder_thickness])
                    cylinder(r=vase_inner_r-top_holder_thickness,h=60);
            }
        }
        translate([0,-top_holder_width/2,0])
            cube([vase_inner_r,top_holder_width,top_holder_height]);
    }
    difference()
    {
        intersection()
        {
            translate([vase_inner_r-bot_holder_spacer_length,0,top_holder_insert_y])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=bot_pulley_spacer_radius,h=bot_holder_spacer_length);
            cylinder(r=vase_inner_r,h=top_holder_height);
        }
        translate([vase_inner_r-bot_holder_spacer_length-5,0,top_holder_insert_y])
            rotate(a=90,v=[0,1,0])
                cylinder(r=pully_shaft_radius,h=bot_holder_spacer_length+10);
    }
    
}

module bottom_holder()
{
    difference()
    {
        union()
        {
            bottom_holder_basic();
            translate([vase_inner_r-top_holder_thickness,0,top_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=glass_hole_radius,h=vase_wall_thickness+top_holder_thickness);
            
        }
        union()
        {
            translate([vase_inner_r-top_holder_thickness-5,0,top_holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=pully_shaft_radius+1,h=vase_wall_thickness+top_holder_thickness+10);
            translate([top_comb_mnt_hole_dist/2,0,-1])
                cylinder(r=top_comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(top_comb_mnt_hole_dist/2),0,-1])
                cylinder(r=top_comb_mnt_hole_rad,h=vase_inner_r);
        }
    }
}

// top pulley
// belt_pully(10,pulley_width,0.05,pully_shaft_radius+1,bering_radius,bering_width);

// bottom pulley
belt_pully(10,pulley_width,0.05,pully_shaft_radius,pully_shaft_radius,0);

//bottom_holder();
bottom_holder_basic();
//top_holder();
