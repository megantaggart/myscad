use <screw_standoffs.scad>

ard_nano_under_clearance = 3;
ard_nano_ease = 2-1.27; // additional space
ard_nano_width  = 17.78;
ard_nano_length = 43.18;
ard_nano_pin_width  = 15.24;
ard_nano_pin_length = 40.64;
ard_nano_usb_width  = 9;
ard_nano_usb_length = 20;
ard_nano_usb_height = 6;
ard_nano_pcb_thichness = 1;

module arduino_nano_sub_holder_pin()
{
    union()
    {
        screw_standoff(5,1.7,ard_nano_under_clearance);
    }
}

module arduino_nano_unions()
{
    translate([0,0,ard_nano_under_clearance]) % cube([ard_nano_width+(ard_nano_ease*2),ard_nano_length+(ard_nano_ease*2),ard_nano_pcb_thichness]);
    translate([ard_nano_ease + 1.27, ard_nano_ease + 1.27 ,0 ]) arduino_nano_sub_holder_pin();
    translate([ard_nano_ease + 1.27+ard_nano_pin_width , ard_nano_ease + 1.27 ,0 ]) arduino_nano_sub_holder_pin();
    translate([ard_nano_ease + 1.27, ard_nano_ease + 1.27+ard_nano_pin_length ,0 ]) arduino_nano_sub_holder_pin();
    translate([ard_nano_ease + 1.27+ard_nano_pin_width , ard_nano_ease + 1.27+ard_nano_pin_length ,0 ]) arduino_nano_sub_holder_pin();
}


module arduino_nano_diffs()
{
    cxp = ((ard_nano_width/2) - (ard_nano_usb_width/2))+ard_nano_ease;
    translate([cxp,-ard_nano_usb_length/2,ard_nano_under_clearance+ard_nano_pcb_thichness])
    {
       cube([ard_nano_usb_width,ard_nano_usb_length,ard_nano_usb_height-ard_nano_pcb_thichness]);
    }
}

arduino_nano_unions();
arduino_nano_diffs();

//m3 2.7
//screw_standoff(5,2.7,6);
//screw_push_fit(3.1,5);
