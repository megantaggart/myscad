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

extra=100;
button_hole_rad = 6;
pot_hole_rad = 3.5;
dist_but_but=28;
dist_but_pot=58;
plate_width=(lamp_radius*2)+wall*2;
plate_height=30;
plate_angle=30;
base_height = sin(plate_angle)*plate_height;
plate_x_len=cos(plate_angle)*plate_height-wall;

stand_off_height=8.5;
stand_off_xlen=6;
stand_off_ylen=8;
stand_off_x1=-15;
stand_off_x2=41;
stand_hole_rad=2.9/2;
stand_hole_depth=stand_off_height-1;
sy=plate_height/2;
sx=(plate_width-dist_but_pot)/2;

extra_base_height=10;

module stand_off()
{
    difference()
    {
        cube([stand_off_xlen,stand_off_ylen,stand_off_height]);
        translate([stand_off_xlen/2,stand_off_ylen/2,0])
            cylinder(r=stand_hole_rad,h=stand_hole_depth);
    }
}

module control_button_plate()
{
    rotate(a=plate_angle,v=[1,0,0])
    difference()
    {
        union()
        {
            cube([plate_width,plate_height,wall]);
            // stands
            translate([sx+stand_off_x1,(plate_height-stand_off_ylen)/2,-stand_off_height])
                stand_off();
            translate([sx+stand_off_x2,(plate_height-stand_off_ylen)/2,-stand_off_height])
                stand_off();
        }
        union()
        {
            translate([sx,sy,0])
                cylinder(r=button_hole_rad,h=wall);
            translate([sx+dist_but_but,sy,0])
                cylinder(r=button_hole_rad,h=wall);
            translate([sx+dist_but_pot,sy,0])
                cylinder(r=pot_hole_rad,h=wall);
        }
    }
}


module lamp_base_cap()
{
//    rotate(a=180,v=[1,0,0])
    lrw=lamp_radius+wall;
    difference()
    {        
        union()
        {
            translate([lrw,lrw,-extra_base_height])
                cylinder(r=lrw,h=base_height+wall+extra_base_height);
            translate([0,-plate_x_len,-extra_base_height])
                cube([lrw*2,lrw+plate_x_len,base_height+wall+extra_base_height]);

        }
        union()
        {
            translate([lamp_radius+wall,lamp_radius,wall-extra_base_height])
                cylinder(r=lamp_radius,h=cap_height+wall+extra++extra_base_height);
            translate([0,-plate_x_len,wall])
                rotate(a=plate_angle,v=[1,0,0])
                    cube([plate_width,plate_height,extra]);
            translate([wall,wall-plate_x_len,-wall-extra_base_height])
                cube([lamp_radius*2,lamp_radius+plate_x_len,base_height+wall+extra_base_height]);
        }
    }
}

module lamp_base()
{
    lamp_base_cap();
    translate([0,-plate_x_len,0])
        control_button_plate();
}

//lamp_cap();
lamp_base();