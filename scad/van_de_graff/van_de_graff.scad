$fn=360;

// IKEA glass cylinder vase
vase_inner_r = 147/2;
vase_outer_r = 158/2;
vase_wall_thickness = 5;

holder_thickness = 4; // thickness of toptm parts
holder_width = 30;    // width of top holder
holder_height = 50;   // height of top holder
holder_insert_y = 40;
top_holder_spacer_length = 6;
glass_hole_radius = 10/2;

comb_mnt_hole_dist = 25;
comb_mnt_hole_rad = 4/2;

pully_shaft_radius = 6/2;
pulley_width = 55;
pulley_spacer_radius = 6;

bot_pulley_spacer_radius = 10;
bot_holder_spacer_length = 10;

bering_radius = 12.6/2;
bering_width = 4;
pulley_radius = (holder_width/2)+5;

comb_holder_length = 90;
comb_holder_height = 9;
comb_holder_slot_min_y = 12;
comb_holder_slot_max_y = 22;

sphere_radius = 280;
sphere_clip_drop = 30;
sphere_clip_thickness = 2;
sphere_clip_lip_height = 5;
sphere_thickness = 1;
sphere_clip_width = 60;
sphere_clip_protrude_dist =20;

module belt_pully(outer_radius,length,amount_of_ridge, shaft_radius, bering_radius, bering_depth)
{
    translate([-pulley_width/2,0,holder_insert_y])
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
                cylinder(r=vase_inner_r,h=holder_height);
            }
            union()
            {
                translate([0,0,holder_thickness])
                    cylinder(r=vase_inner_r-holder_thickness,h=60);
            }
        }
        translate([0,-holder_width/2,0])
            cube([vase_inner_r,holder_width,holder_height]);
    }
    difference()
    {
        intersection()
        {
            translate([vase_inner_r-top_holder_spacer_length,0,holder_insert_y])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=pulley_spacer_radius,h=top_holder_spacer_length);
            cylinder(r=vase_inner_r,h=holder_height);
        }
        translate([vase_inner_r-top_holder_spacer_length-4,0,holder_insert_y])
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
            translate([vase_inner_r-holder_thickness,0,holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=glass_hole_radius,h=vase_wall_thickness+holder_thickness);
            
        }
        union()
        {
            translate([vase_inner_r-holder_thickness-5,0,holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=pully_shaft_radius,h=vase_wall_thickness+holder_thickness+10);
            translate([comb_mnt_hole_dist/2,0,-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(comb_mnt_hole_dist/2),0,-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
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
                cylinder(r=vase_inner_r,h=holder_height);
            }
            union()
            {
                translate([0,0,holder_thickness])
                    cylinder(r=vase_inner_r-holder_thickness,h=60);
            }
        }
        translate([0,-holder_width/2,0])
            cube([vase_inner_r,holder_width,holder_height]);
    }
    difference()
    {
        intersection()
        {
            translate([vase_inner_r-bot_holder_spacer_length,0,holder_insert_y])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=bot_pulley_spacer_radius,h=bot_holder_spacer_length);
            cylinder(r=vase_inner_r,h=holder_height);
        }
        translate([vase_inner_r-bot_holder_spacer_length-5,0,holder_insert_y])
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
            translate([vase_inner_r-holder_thickness,0,holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=glass_hole_radius,h=vase_wall_thickness+holder_thickness);
            
        }
        union()
        {
            translate([vase_inner_r-holder_thickness-5,0,holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=pully_shaft_radius+1,h=vase_wall_thickness+holder_thickness+10);
            translate([comb_mnt_hole_dist/2,0,-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(comb_mnt_hole_dist/2),0,-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([vase_inner_r-bot_holder_spacer_length,0,holder_insert_y])
                rotate(a=90, v=[0,1,0])
                    cylinder(r=bering_radius, h = bering_width);
        }
    }
}

module comb_holder()
{
    difference()
    {
        union()
        {
            translate([-comb_holder_length/2,-holder_width/2,holder_thickness])
            cube([comb_holder_length,holder_width,holder_thickness]);
            translate([-pulley_width/2,holder_width/2,holder_thickness*2])
            rotate(a=90,v=[1,0,0])
            cube([pulley_width,comb_holder_height,holder_thickness]);
        }
        union()
        {
            translate([comb_mnt_hole_dist/2,0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(comb_mnt_hole_dist/2),0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-comb_mnt_hole_dist/2,0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-3*(comb_mnt_hole_dist/2),0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);

            translate([comb_mnt_hole_dist-5,30,comb_holder_slot_min_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);

            translate([-(comb_mnt_hole_dist-5),30,comb_holder_slot_min_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
        }
    }
    
}

module comb_holder_part_2()
{
    translate([0,30,0])
    
    difference()
    {
        union()
        {
            translate([-pulley_width/2,holder_width/2,holder_thickness*2])
            rotate(a=90,v=[1,0,0])
            cube([pulley_width,comb_holder_height*2,holder_thickness]);
        }
        union()
        {
            translate([comb_mnt_hole_dist/2,0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([3*(comb_mnt_hole_dist/2),0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-comb_mnt_hole_dist/2,0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-3*(comb_mnt_hole_dist/2),0,holder_thickness-1])
                cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);

            translate([comb_mnt_hole_dist-5,30,comb_holder_slot_min_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([comb_mnt_hole_dist-5,30,comb_holder_slot_max_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([comb_mnt_hole_rad+comb_mnt_hole_dist-5,holder_thickness,comb_holder_slot_min_y])
                rotate(a=90,v=[0,0,1])
                    cube([vase_inner_r,comb_mnt_hole_rad*2,comb_holder_slot_max_y-comb_holder_slot_min_y]);

            translate([-(comb_mnt_hole_dist-5),30,comb_holder_slot_min_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-(comb_mnt_hole_dist-5),30,comb_holder_slot_max_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            translate([-(comb_mnt_hole_dist-5-comb_mnt_hole_rad),holder_thickness,comb_holder_slot_min_y])
                rotate(a=90,v=[0,0,1])
                    cube([vase_inner_r,comb_mnt_hole_rad*2,comb_holder_slot_max_y-comb_holder_slot_min_y]);


            translate([10,30,comb_holder_slot_max_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
            
            translate([-10,30,comb_holder_slot_max_y])
                rotate(a=90,v=[1,0,0])
                    cylinder(r=comb_mnt_hole_rad,h=vase_inner_r);
        }
    }
}

module sphere_clip()
{
    difference()
    {
        intersection()
        {
            union()
            {
                difference()
                {
                    union()
                    {
                        cylinder(r=vase_outer_r+sphere_clip_thickness, h= sphere_clip_drop);
                    }
                    union()
                    {
                        cylinder(r=vase_outer_r, h= sphere_clip_drop);
                    }
                }
                difference()
                {
                    // find height of sphere for vase radius
                    ang_of_sph_intersect = asin((vase_outer_r+sphere_clip_thickness*2)/sphere_radius);
                    dist_y = sphere_radius *cos(ang_of_sph_intersect);
                    echo("vertical distamnceof sphere intersect = ", dist_y);

                    union()
                    {
                        translate([0,0,dist_y+sphere_clip_thickness])
                            sphere(r=sphere_radius+sphere_clip_thickness, h= sphere_clip_lip_height);
                    }
                    union()
                    {
                        translate([0,0,dist_y+sphere_clip_thickness])
                            sphere(r=sphere_radius, h= sphere_clip_lip_height);
                    }
                }
                difference()
                {
                    union()
                    {
                        cylinder(r=vase_outer_r+sphere_clip_thickness*2+sphere_thickness, h= sphere_clip_thickness);
                    }
                    union()
                    {
                        cylinder(r=vase_outer_r, h= sphere_clip_thickness);
                    }
                }
            }
            intersection()
            {
                translate([0,-sphere_clip_width/2,0])
                    cube([vase_outer_r+sphere_clip_protrude_dist,sphere_clip_width,sphere_clip_drop]);
                cylinder(r=vase_outer_r+sphere_clip_protrude_dist,h=sphere_clip_drop);
            }
        }
        union()
        {
            translate([vase_outer_r-top_holder_spacer_length-4,0,sphere_clip_drop-10])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=pully_shaft_radius,h=top_holder_spacer_length+10);
            translate([0,0,-5])
                cylinder(r=vase_outer_r, h= sphere_clip_drop);
        }
    }
}

module sphere_clip_part_2()
{
    difference()
    {
        intersection()
        {
            union()
            {
                difference()
                {
                    union()
                    {
                        cylinder(r=vase_outer_r+sphere_clip_thickness, h= sphere_clip_drop);
                    }
                    union()
                    {
                        cylinder(r=vase_outer_r, h= sphere_clip_drop);
                    }
                }
            }
            translate([0,-sphere_clip_vertical_width/2,0])
                cube([vase_outer_r+sphere_clip_protrude_dist,sphere_clip_vertical_width,sphere_clip_drop]);
        }
        union()
        {
            translate([vase_outer_r-top_holder_spacer_length-4,0,sphere_clip_drop-10])
                rotate(a=90,v=[0,1,0])
                    cylinder(r=pully_shaft_radius,h=top_holder_spacer_length+10);
        }
    }
}

motor_outer_radius = 36/2;
motor_length = 40;
motor_full_outer_radius = 38/2;
motor_shaft_radius = 3/2;
motor_inner_radius = 13/2;
motor_screw_hole_radius = 25/2;
motor_screw_hole_r1 = 3/2;
motor_screw_hole_r2 = 6/2;
motor_screw_length_r1 = 1.5;
motor_mount_wall = 3;
motor_mount_hole = 4;


module motor_mount_basic()
{
    difference()
    {
        union()
        {
            cylinder(r=motor_full_outer_radius+motor_mount_wall,h=motor_mount_wall*2);
            translate([-(motor_full_outer_radius+motor_mount_wall),0,0])
                cube([2*(motor_full_outer_radius+motor_mount_wall),motor_full_outer_radius+motor_mount_wall,motor_mount_wall*2]);
            translate([-(motor_full_outer_radius+motor_mount_wall),(motor_full_outer_radius+motor_mount_wall),0])
                rotate(a=90,v=[1,0,0])
                    cube([2*(motor_full_outer_radius+motor_mount_wall),motor_length,motor_mount_wall]);
    
        }
        union()
        {
            translate([0,0,motor_mount_wall])
                cylinder(r=motor_outer_radius,h=motor_mount_wall);
            cylinder(r=motor_inner_radius,h=motor_mount_wall);
            translate([motor_screw_hole_radius,0,0])
                cylinder(r=motor_screw_hole_r1,h=motor_mount_wall);
            translate([motor_screw_hole_radius,0,0])
                cylinder(r=motor_screw_hole_r2,h=motor_mount_wall-motor_screw_length_r1);
            translate([-motor_screw_hole_radius,0,0])
                cylinder(r=motor_screw_hole_r1,h=motor_mount_wall);
            translate([-motor_screw_hole_radius,0,0])
                cylinder(r=motor_screw_hole_r2,h=motor_mount_wall-motor_screw_length_r1);
        }
    }
}

module motor_mount_support()
{
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r=motor_full_outer_radius+motor_mount_wall,h=motor_mount_wall*2);
                translate([-(motor_full_outer_radius+motor_mount_wall),0,0])
                    cube([2*(motor_full_outer_radius+motor_mount_wall),motor_full_outer_radius+motor_mount_wall,motor_mount_wall]);
            }
            union()
            {
                cylinder(r=motor_outer_radius,h=motor_mount_wall*2);
            }
        }
        translate([-(motor_full_outer_radius+motor_mount_wall),0,0])
            cube([2*(motor_full_outer_radius+motor_mount_wall),motor_full_outer_radius+motor_mount_wall,motor_mount_wall]);
    }
    
}
module motor_mount_tab()
{
    rotate(a=90,v=[0,1,0])
    rotate(a=90,v=[1,0,0])
        difference()
        {
            union()
            {
                cylinder(r=motor_mount_hole+motor_mount_wall,h=motor_mount_wall);
                translate([-(motor_mount_hole+motor_mount_wall),0,0])
                    cube([2*(motor_mount_hole+motor_mount_wall),motor_full_outer_radius+motor_mount_wall,motor_mount_wall]);
            }
            union()
            {
                cylinder(r=motor_mount_hole,h=motor_mount_wall);
            }
        }
}

module motor_mount()
{
    motor_mount_basic();
    translate([0,0,motor_length/2])
    {
        motor_mount_support();
        translate([-(motor_mount_hole+motor_mount_wall*2+motor_full_outer_radius),motor_full_outer_radius+motor_mount_wall,-(motor_mount_hole)])
            motor_mount_tab();
        translate([(motor_mount_hole+motor_mount_wall*2+motor_full_outer_radius),motor_full_outer_radius+motor_mount_wall,-(motor_mount_hole)])
           rotate(a=180,v=[0,1,0])
            motor_mount_tab();
    }
    translate([0,0,motor_length])
    {        
        motor_mount_support();
        translate([-(motor_mount_hole+motor_mount_wall*2+motor_full_outer_radius),motor_full_outer_radius+motor_mount_wall,-(motor_mount_hole)])
            motor_mount_tab();
        translate([(motor_mount_hole+motor_mount_wall*2+motor_full_outer_radius),motor_full_outer_radius+motor_mount_wall,-(motor_mount_hole)])
           rotate(a=180,v=[0,1,0])
            motor_mount_tab();
    }
}


// top pulley
//belt_pully(pulley_radius,pulley_width,0.05,pully_shaft_radius+1,bering_radius,bering_width);

// bottom pulley
//belt_pully(pulley_radius,pulley_width,0.05,pully_shaft_radius,pully_shaft_radius,0);

//bottom_holder();
//rotate(a=180,v=[0,0,1])
//    bottom_holder();

// comb_holder
//comb_holder();
//comb_holder_part_2();

//bottom_holder_basic();
//top_holder();

//sphere_clip();
//sphere_clip_part_2();

motor_mount();