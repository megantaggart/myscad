$fn=360;

wall=1;
lamp_radius = 101/2;
cap_height=10;

module lamp_cap()
{
    difference()
    {
        cylinder(r=lamp_radius+wall,h=cap_height+wall);
        cylinder(r=lamp_radius,h=cap_height);
    }
}

lamp_cap();