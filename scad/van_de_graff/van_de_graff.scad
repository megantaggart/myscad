

module belt_pully(outer_radius,length,amount_of_ridge, shaft_radius, bering_radius, bering_depth)
{
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


belt_pully(10,50,0.04,3,6,4);