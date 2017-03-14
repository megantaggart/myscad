$fn=180;

inner_radius=40;
inner_height=25;
wall=1.2;
spin_gap=0.5;
spin_depth=0.3;
spin_offset=5;
gaps_ang=15;
gaps_ang_off=3;
gaps_size_x = 4;
gaps_size_y = 4;

gaps_y1= (inner_height-(gaps_size_y*2+wall))/2;
gaps_y2= gaps_y1+gaps_size_y+wall;
fit_gap = 0.25;
mid_ring_inner_r = inner_radius+wall+spin_gap*1.5;
out_ring_inner_r = mid_ring_inner_r+wall+fit_gap;
disp_radius = 35;

module spin_rings(rd)
{
    union()
    {
        rotate_extrude(convexity = 10)
            translate([rd+wall, spin_offset, 0])
                circle(r = spin_depth+spin_gap, $fn=20);
        //rotate_extrude(convexity = 10)
        //    translate([rd+wall, inner_height-spin_offset, 0])
        //        circle(r = spin_depth+spin_gap, $fn=20);
    }
}


module spin_rings1(rd)
{
    union()
    {
        rotate_extrude(convexity = 10)
            translate([rd+wall, spin_offset, 0])
                circle(r = spin_depth+spin_gap, $fn=20);
        //rotate_extrude(convexity = 10)
        //    translate([rd+wall, inner_height-spin_offset, 0])
        //        circle(r = spin_depth+spin_gap, $fn=20);
    }
}

module base()
{
    difference()
    {
        union()
        {
            cylinder(r=inner_radius+wall,h=inner_height-fit_gap);
        }
        union()
        {
            translate([0,0,wall])
            cylinder(r=inner_radius,h=inner_height-fit_gap);
            translate([inner_radius-wall,0,gaps_y1])
                cube([wall*3,gaps_size_x,gaps_size_y]);
            translate([inner_radius-wall,0,gaps_y2])
                cube([wall*3,gaps_size_x,gaps_size_y]);
        }
    }
    spin_rings1(inner_radius);
    rotate(a=3,v=[0,0,1])
    led_holder();
}

module mod_ring()
{
    difference()
    {
        union()
        {
            translate([0,0,wall])
            cylinder(r=mid_ring_inner_r+wall,h=inner_height);
        }
        union()
        {
            translate([0,0,wall])
            cylinder(r=mid_ring_inner_r,h=inner_height);
            
            spin_rings(inner_radius+fit_gap*1.6);
            for (ag =[0:gaps_ang:360-gaps_ang])
            {
                rotate(a=ag,v=[0,0,1])
                translate([mid_ring_inner_r-wall,0,gaps_y1])
                    cube([wall*3,gaps_size_x,gaps_size_y]);
            }
            for (ag =[0:gaps_ang:360-gaps_ang])
            {
                rotate(a=ag+gaps_ang_off,v=[0,0,1])
                translate([mid_ring_inner_r-wall,0,gaps_y2])
                    cube([wall*3,gaps_size_x,gaps_size_y]);
            }
        }
    }
}

module out_ring()
{
    translate([0,0,wall+fit_gap])
    difference()
    {
        union()
        {
            cylinder(r=out_ring_inner_r+wall,h=inner_height+wall);
        }
        union()
        {
            translate([0,0,-wall])
                cylinder(r=out_ring_inner_r,h=inner_height+wall);
            cylinder(r=disp_radius,h=inner_height);
        }
    }
}

led_depth=10;
led_rad=5/2;
led_ang=26;
led_sep=6.5;
holder_width = 14;
holder_length = 6;
holder_height=20;

module led_holes()
{
    translate([-1,led_sep/2,0])
    rotate(a=90,v=[1,0,0])
    rotate(a=90-led_ang,v=[0,1,0])
    {
        cylinder(r1=led_rad+.2,r2=gaps_size_x/2,h=holder_length+2);
    }
    translate([-1,-led_sep/2,0])
    rotate(a=90,v=[1,0,0])
    rotate(a=90+led_ang,v=[0,1,0])
    {
        cylinder(r1=led_rad+.2,r2=gaps_size_x/2,h=holder_length+2);
    }
    translate([1,led_sep/2,0])
    rotate(a=90,v=[1,0,0])
    rotate(a=-90,v=[0,1,0])
    {
        cylinder(r=led_rad,h=led_depth*2);
    }
    translate([1,-led_sep/2,0])
    rotate(a=90,v=[1,0,0])
    rotate(a=-90,v=[0,1,0])
    {
        cylinder(r=led_rad,h=led_depth*2);
    }
}

module led_holder()
{
    max_l=led_depth+holder_length;
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r=inner_radius,h=inner_height-fit_gap);
            }
            union()
            {
                cylinder(r=inner_radius-max_l,h=inner_height-fit_gap);
                translate([inner_radius-holder_length,0,gaps_y1+led_rad-0.5])
                led_holes();
                translate([inner_radius-holder_length,0,gaps_y2+led_rad-0.5])
                led_holes();
            }
        }
        translate([inner_radius-max_l,-holder_width/2,0])
            cube([max_l,holder_width,holder_height]);
    }
}

module test_section()
{
    intersection()
    {
        union()
        {
            base();
            mod_ring();
            out_ring();
        }
        cube([200,200,200]);
    }
}


//test_section();
base();
//rotate(a=3,v=[0,0,1])
//mod_ring();
//out_ring();

