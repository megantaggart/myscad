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


bk_height=30;
wall=1.2;

module back_cover()
{
    translate([10,0,-bk_height])
        cube([100,110,1.2]);
    
    translate([10,wall,-bk_height])
        rotate(a=90,v=[1,0,0])
            cube([100,bk_height,1.2]);

    translate([10,110,-bk_height])
        rotate(a=90,v=[1,0,0])
            cube([100,bk_height,1.2]);

    translate([10+wall,0,0])
        rotate(a=-90,v=[0,1,0])
            rotate(a=90,v=[0,0,1])
                cube([110,bk_height,1.2]);

    translate([110,0,0])
        rotate(a=-90,v=[0,1,0])
            rotate(a=90,v=[0,0,1])
                cube([110,bk_height,1.2]);
}

//backbox();
back_cover();