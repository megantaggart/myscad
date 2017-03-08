$fn=30;

use <../libs/screw_enclosure.scad>
use <../libs/arduino.scad>
use <../libs/parts_ard_modules.scad>

// Customized Enclosure
width = 100.0;       // Width of the enclosure
height = 75.0;       // Height of the enclosure
depth = 20.0;        // Depth of the enclosure
thickness = 2;       // Thickness of the walls and lid
fillet_radius = 5.0; // Amount of corner rounding
// Hidden
standoff_offset = 0.5;      // Position offset from the corner for the stand-offs
standoff_radius = 3.5;      // Radius of the stand-offs
standoff_hole_radius = 1.5; // Radius of the hole in the stand-offs

ard_pos_x = 1+thickness;
ard_pos_y = 30;
dht11_x = width-thickness-1;
dht11_y = 30;
rtc_x=width-thickness-1;
rtc_y=60;

module body()
{
difference()
{
    union()
    {
        translate([(width/2),(height/2),-thickness])
        {
            screw_enc_enclosure(width, height, depth, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius);
        }
        translate([ard_pos_x,ard_pos_y,thickness])
        {
            rotate(a=-90, v=[0,0,1]) arduino_nano_unions();
        }
        translate([dht11_x,dht11_y,0])
        {
            rotate(a=180, v=[0,0,1]) part_dht11_pcb_unions();
        }
        translate([rtc_x,rtc_y,0])
        {
            rotate(a=180, v=[0,0,1]) part_3231_rtc_pcb_unions();
        }
    }
    union()
    {
        translate([ard_pos_x,ard_pos_y,thickness])
        {
            rotate(a=-90, v=[0,0,1]) arduino_nano_diffs();
        }   
        translate([width,height-15,depth/2]) rotate(a=-90, v=[0,1,0]) cylinder(r=5/2,h=1);

        translate([3,50,(depth/2)-2.5]) rotate(a=-90, v=[0,1,0]) cylinder(r=5/2,h=thickness+2);

        translate([dht11_x,dht11_y,0])
        {
            rotate(a=180, v=[0,0,1]) part_dht11_pcb_diffs();
        }
    }
}
}
//body();
union()
{
//    translate([width/2,height/2,-thickness])
//    {
        screw_enc_lid(width, height, fillet_radius, thickness, standoff_offset, standoff_radius, standoff_hole_radius);
//    }
}

