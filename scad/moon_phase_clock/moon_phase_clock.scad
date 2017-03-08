$fn=60;

module backbox()
{
    difference()
    {
        union()
        {
            translate([60,110,0]) 
            {
                cylinder(r=60,h=1.2);
                translate([0,0,1]) difference()
                {
                    cylinder(r=98/2,h=3);
                    cylinder(r=(98-2)/2,h=4);
                }
                translate([0,0,1]) difference()
                {
                    cylinder(r=50/2,h=3);
                    cylinder(r=(50-2)/2,h=4);
                }
            }
            cube([120,110,1.2]);
            translate([(120-73)/2,17,0]) cube([73,27,4]);
            
        }
        union()
        {
            translate([60,100,-1]) cylinder(r=3,h=3);
            translate([(120-71)/2,18,-1]) cube([71,25,6]);
        }
    }
}


backbox();