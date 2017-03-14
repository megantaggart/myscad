$fn=60;
wall = 2;
pole_rad=43/2;
arm_rad=53/2;

conn_length=30;
conn_angle=45;
conn_extra=15;

module pole_slieve()
{
    difference()
    {
        union()
        {
            cylinder(r=pole_rad+wall,h=conn_length+conn_extra);
        }
        cylinder(r=pole_rad,h=conn_length);
    }
}

module arm_slieve(ty)
{
    difference()
    {
        cylinder(r=arm_rad+wall,h=conn_length+conn_extra);
        if (ty>0)
        {
            translate([0,0,conn_extra])
            cylinder(r=arm_rad,h=conn_length);
        }
        else
        {
            cylinder(r=arm_rad,h=conn_length);
        }
    }
}

module gate_connector()
{
    difference()
    {
        union()
        {
            pole_slieve();
            translate([0,3,conn_length*1])
            rotate(a=conn_angle,v=[1,0,0])
                arm_slieve(1);
        }
        cylinder(r=pole_rad,h=conn_length);

    }
}

module switch_connector()
{
    difference()
    {
        union()
        {
            rotate(a=conn_angle,v=[1,0,0])
                arm_slieve(0);
        }
    }
}

gate_connector();
//switch_connector();
