/* [Global] */

use <Write.scad>

dia = 25;
holeDia = 3;
coneDia = 20;
coneHeight = 27;


//sphere(10);
//color([0,1,1]) 
//writesphere(text="OpenSCAD", where=[0,0,0], radius=10, font = "orbitron.dxf");

translate([0,0,dia/4])
	difference(){
		sphere(dia/2,$fn=72);
		holes();
	}



module holes () {
	union(){
		translate([0,0,-dia/2])
			cylinder(h=coneHeight,r1=coneDia/2,r2=0,$fn=72);
		translate([-dia/2,-dia/2,-dia*5/4])
			cube(dia);
		translate([0,0,-dia])
			cylinder(r=holeDia/2,h=dia*2,$fn=36);
        writesphere("Lights", [0,0,0], dia/2, font = "orbitron.dxf");
        writesphere("Lights", [0,0,0], dia/2, font = "orbitron.dxf", east=120);
        writesphere("Lights", [0,0,0], dia/2, font = "orbitron.dxf", east=240);
	}
}