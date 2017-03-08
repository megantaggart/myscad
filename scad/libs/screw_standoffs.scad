module screw_standoff(outer_diameter,inner_diameter,height)
{
    difference()
    {
        cylinder(r=outer_diameter/2, h = height);
        cylinder(r=inner_diameter/2, h = height);
    }
}

module screw_push_fit(diameter,height)
{
    union()
    {
        trad = diameter/2;
        cylinder(r=trad, h = height-trad);
        translate([0,0,height-trad])
        {
            sphere(r = trad);
        }
    }
}

//m3 2.7


//screw_standoff(5,2.7,6);
//translate ([5,5,0]) screw_push_fit(3.1,5);
