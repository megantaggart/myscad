

module house_name()
{
    translate([-8,-8,0])
    cube([170,40,1.2]);

    translate([0,5,0])
    linear_extrude(height = 2.4)
    {
        union()
        {
            text("Van de Graaff", font = "England Hand DB",size = 20);
        }
    }
}



difference()
{
    house_name();
}
