$fn=90;

cap_length = 35;
cap_width = 8;
cap_heigth = 12;
cap_round_radius = 6;
cap_wall = 1.5;

module basic_block()
{
    intersection()
    {
        difference()
        {
            minkowski()
            {
                translate([cap_round_radius,cap_round_radius,cap_round_radius])
                cube([cap_length-(cap_round_radius*2),cap_width*2-cap_round_radius,cap_heigth*2-cap_round_radius]);
                //cylinder(r=radius);
                sphere(r=cap_round_radius);
            }
            

            minkowski()
            {
                cap_length2=cap_length-cap_wall;
                cap_width2=cap_width-cap_wall;
                cap_heigth2=cap_heigth-cap_wall;
                cap_round_radius2= cap_round_radius- cap_wall;
                translate([cap_wall,cap_wall,cap_wall])
                translate([cap_round_radius2,cap_round_radius2,cap_round_radius2])
                cube([cap_length2-(cap_round_radius2*2)-cap_wall,cap_width2*2-cap_round_radius2,cap_heigth2*2-cap_round_radius2]);
                //cylinder(r=radius);
                sphere(r=cap_round_radius2);
            }
            
        }
        cube([cap_length,cap_width,cap_heigth]);
    }
}

clip_width=4;
clip_length=4;
clip_depth=12;
clip_clipper=0.20;
clip_clipper_depth=2.5;
slot_depth=5;
slot_width=0.85;

module clip_snap()
{
    rotate(a=90,v=[1,0,0])
        rotate(a=90,v=[0,1,0])
            linear_extrude(height=clip_width)
                polygon(points=[[0,0],[clip_clipper,0],[0,clip_clipper_depth]]);
}

module clip()
{
    translate([0,0,clip_length])
    rotate(a=-90,v=[1,0,0])
    difference()
    {
        union()
        {
            cube([clip_width,clip_length,clip_depth]);
            translate([0,0,clip_depth-clip_clipper_depth])
            {
                translate([0,clip_length,0])
                    clip_snap();
                translate([clip_width,0,0])
                    rotate(a=180,v=[0,0,1])
                        clip_snap();
            }
        }
        translate([0,(clip_length-slot_width)/2,(clip_depth-slot_depth)])
            cube([clip_width,slot_width,slot_depth]);
    }
}

cap_offset = 8.5;


cyl_od=10/2;
cyl_od2=12/2;
cyl_depth=6;
cyl_clip_rad=.2;
cyl_clip_rad2=2;
module circ_clip()
{
    rotate(a=-90,v=[1,0,0])
    {
        difference()
        {
            union()
            {
                cylinder(r=cyl_od,h=cyl_depth);
                translate([0,0,cyl_depth-cyl_clip_rad2])
                {
                    intersection()
                    {
                        scale([1,1,cyl_clip_rad2/cyl_clip_rad])
                        rotate_extrude(convexity = 10)
                            translate([cyl_od, 0, 0])
                                circle(r = cyl_clip_rad, $fn = 100);
                        cylinder(r=cyl_od+cyl_clip_rad,h=cyl_clip_rad2);
                    }
                }
            }
            union()
            {
                cylinder(r=cyl_od-cap_wall,h=cyl_depth);
                translate([-cap_wall/2,-cyl_depth,0])
                    cube([cap_wall,cyl_depth*2.1,cyl_depth]);
            }
        }
    }
}

module window_clip()
{
    intersection()
    {
        union()
        {
            basic_block();
            translate([cap_length/2,cap_width,cap_wall+cyl_od])
                circ_clip();
            translate([cap_length/2-cyl_od,0,cap_wall])
                cube([cyl_od*2,cap_width,cyl_od]);
            translate([cap_length/2,cap_width,cap_wall+cyl_od])
                rotate(a=90,v=[1,0,0])
                    difference()
                    {
                        cylinder(r=cyl_od2,h=cap_wall);
                        cylinder(r=cyl_od,h=cap_wall);
                    }
        }
        minkowski()
        {
            translate([cap_round_radius,cap_round_radius,cap_round_radius])
            cube([cap_length-(cap_round_radius*2),cap_width*2-cap_round_radius,cap_heigth*2-cap_round_radius]);
            //cylinder(r=radius);
            sphere(r=cap_round_radius);
        }        
    }
}

window_clip();
