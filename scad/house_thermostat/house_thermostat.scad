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
mid_ring_inner_r = inner_radius+wall+spin_gap;
out_ring_inner_r = mid_ring_inner_r+wall+fit_gap;
disp_radius = 35;

module spin_rings()
{
    union()
    {
        rotate_extrude(convexity = 10)
            translate([inner_radius+wall, spin_offset, 0])
                circle(r = spin_depth+spin_gap, $fn=20);
        rotate_extrude(convexity = 10)
            translate([inner_radius+wall, inner_height-spin_offset, 0])
                circle(r = spin_depth+spin_gap, $fn=20);
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
    spin_rings();
}

module mod_ring()
{
    difference()
    {
        union()
        {
            cylinder(r=mid_ring_inner_r+wall,h=inner_height);
        }
        union()
        {
            cylinder(r=mid_ring_inner_r,h=inner_height);
            spin_rings();
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
            cylinder(r=out_ring_inner_r+wall,h=inner_height);
        }
        union()
        {
            translate([0,0,-wall])
                cylinder(r=out_ring_inner_r,h=inner_height);
            cylinder(r=disp_radius,h=inner_height);
        }
    }
}



base();
//mod_ring();
//out_ring();
