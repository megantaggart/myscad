use <screw_standoffs.scad>
use <shapes.scad>

module part_dht11_pcb_unions()
{
    % cube([16,15,7]);
    translate([0,0,7]) % cube([40,15,2]);
    translate([24,7.5,0]) screw_standoff(6,2.7,7);
}

module part_dht11_pcb_diffs()
{
    translate([-5,7,5])
    rotate(a=90,v=[1,0,0])
    rotate(a=90,v=[0,1,0])
    roundedBox([9,4,20],1);
}

module part_3231_rtc_pcb_unions()
{
    translate([0,0,5])
    {
        % cube([50,22,2]);
        translate([18,11,0]) % cylinder(r=10, h= 8);
    }
    translate([4 ,20,0]) screw_standoff(6,2.7,5);
    translate([30,3,0]) screw_standoff(6,2.7,5);
    translate([30,20,0]) screw_standoff(6,2.7,5);
}

part_dht11_pcb_unions();
//part_dht11_pcb_diffs();
//part_3231_rtc_pcb_unions();
