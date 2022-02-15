//////////////////////////////////////////////////////////////////////
//  SpringFactory: SpringFactory.scad
/*
        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/SpringFactory
      
        Parametric OpenSCAD file in support of the "Spring Factory 1.2"
        https://www.thingiverse.com/thing:5171637
        Vincent Baillet
        https://www.thingiverse.com/vbaillet/designs
*/
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//  GNU GPLv3
/*
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
*/
//////////////////////////////////////////////////////////////////////


// BOSL Library -- https://github.com/revarbat/BOSL
use <BOSL/threading.scad>;
use <BOSL/shapes.scad>;


//////////////////////////////////////////////////////////////////////
//  Customizer
/*
    Define Menu(s) and Default Values
*/
//////////////////////////////////////////////////////////////////////
/* [General OpenSCAD Parameters] */
// Display Verbose Output?
VERBOSE=1; // [1:Yes,0:No]
SHOW_CUTOUTS=0; // [1:Yes,0:No]
SHOW_REFERENCE=0; // [1:Yes,0:No]

/* ["The Bolt" Parameters] */
// Display Bolt
SHOW_BOLT=1; // [1:Yes,0:No]
// Length (X) of the Bolt grip
custom_bolt_grip_length=60; // [0:.1:100]
// Width (Y) of the Bolt grip
custom_bolt_grip_width=6; // [0:1:10]
// Height (Z) of the Bolt grip
custom_bolt_grip_height=6; // [0:1:10]
// Length (Z) of the Bolt
custom_bolt_length=47.5; // [10:.1:250]
// Diameter of the Bolt.
custom_bolt_diameter=8; // [.01:.01:210]
// Pitch of the Bolt
custom_bolt_pitch=2.4; // [0.2:0.01:6]
// Diameter of Bolt Base
custom_bolt_base_diameter=31.8; // [20:.1:80]

/* ["The Screw" Parameters] */
// Display Screw
SHOW_SCREW=1; // [1:Yes,0:No]
// Length (X) of the Screw grip
custom_screw_grip_length=47; // [0:.1:100]
// Width (Y) of the Screw grip
custom_screw_grip_width=6.27; // [1:1:210]
// Height (Z) of the Screw grip
custom_screw_grip_height=6.27; // [1:1:250]
// Diameter of Screw/Nut
custom_screw_diameter=8; // [.2:0.01:54]
// Pitch of the Screw
custom_screw_pitch=2.4; // [0.2:0.01:6]
// Diameter of Screw Base
custom_screw_base_diameter=14.9836; // [1:1:210]

/* ["The Cap" Parameters] */
// Display Cap
SHOW_CAP=1; // [1:Yes,0:No]
// Diameter of Screw/Nut
custom_cap_diameter=8; // [0.1:0.01:54]
// Pitch of the Screw
custom_cap_pitch=2.4; // [0.2:0.01:6]

/* [Hidden] */
//$fa = 0.1;
//$fs = 0.1;

//////////////////////////////////////////////////////////////////////
//  Define default values if Customizer is not used
/*
    If the corresponding input variable is not the default value, define sample working values
*/
//////////////////////////////////////////////////////////////////////
// The Bolt
bolt_grip_length=(custom_bolt_grip_length==0) ? 60 : custom_bolt_grip_length;
bolt_grip_width=(custom_bolt_grip_width==0) ? bolt_grip_length/10 : custom_bolt_grip_width;
bolt_grip_height=(custom_bolt_grip_height==0) ? bolt_grip_width : custom_bolt_grip_height;
bolt_length=(custom_bolt_length==0) ? 47.5 : custom_bolt_length;
bolt_diameter=(custom_bolt_diameter==0) ? 8 : custom_bolt_diameter;
bolt_pitch=(custom_bolt_pitch==0) ? 2.4 : custom_bolt_pitch;
bolt_base_diameter=(custom_bolt_base_diameter==0) ? bolt_grip_length*0.53 : custom_bolt_base_diameter;

// The Screw
screw_grip_length=(custom_screw_grip_length==0) ? 47 : custom_screw_grip_length;
screw_grip_width=(custom_screw_grip_width==0) ? screw_grip_length/7.5 : custom_screw_grip_width;
screw_grip_height=(custom_screw_grip_height==0) ? screw_grip_width : custom_screw_grip_height;
screw_diameter=(custom_screw_diameter==0) ? bolt_diameter: custom_screw_diameter;
screw_pitch=(custom_screw_pitch==0) ? bolt_pitch : custom_screw_pitch;
screw_base_diameter=(custom_screw_base_diameter==0) ? screw_grip_length*0.3188 : custom_screw_base_diameter;

//The Cap
cap_diameter=(custom_cap_diameter==0) ? bolt_diameter: custom_cap_diameter;
cap_pitch=(custom_cap_pitch==0) ? bolt_pitch : custom_cap_pitch;

//////////////////////////////////////////////////////////////////////
// Module: show_reference_objects()
/*
    Description:
        Wrapper module to display original STL files for comparison

    Arguments:
        N/A
*/
// Example: Make sample objects
if(SHOW_REFERENCE){
    show_reference_objects();
}
//////////////////////////////////////////////////////////////////////
module show_reference_objects(){
    // The Bolt
    color(c=[106,90,205]/255) {
        translate([-33.5,-3,2]) 
            import("./reference/SpringFactory1.2_TheBolt.stl");
    }
    // The Screw
    color(c=[186,85,211]/255,alpha=0.75) {
        translate([2.2,34.422,31])
            import("./reference/SpringFactory1.2_TheScrew.stl");
    }
    // The Cap
    color(c=[138,43,226]/255,alpha=0.75) {
        translate([-40.15,-3.918,0])
            import("./reference/SpringFactory1.2_TheCap.stl");
    }
}


//////////////////////////////////////////////////////////////////////
// Module: make_SpringFactory()
/*
    Description:
        Wrapper module to create all Spring Factory objects

    Arguments:
        N/A
*/
// Example: Make sample objects
   make_SpringFactory();
//////////////////////////////////////////////////////////////////////
module make_SpringFactory(){
    if(SHOW_BOLT){
        make_bolt(bolt_base_diameter,
                  bolt_grip_width, bolt_grip_length, bolt_grip_height,
                  bolt_diameter, bolt_length, bolt_pitch);
    }
    if(SHOW_SCREW){
        rotate([0,0,90]) translate([0,0,35.1])
            make_screw(screw_base_diameter,
                       screw_grip_width, screw_grip_length, screw_grip_height,
                       screw_diameter, screw_grip_height*1.5, screw_pitch);
    }
    if(SHOW_CAP){
        translate([33,0,0])
            make_cap(cap_diameter, cap_pitch*1.5, cap_pitch);
    }
}



//////////////////////////////////////////////////////////////////////
// Module: make_bolt()
/*
    Description:
        Creates Bolt object to act as a mold for the spring shape

    Arguments:
        base_diameter = The diameter of the circular base of the mold

        grip_width = The width of the grip structure protruding from each side of the base
        grip_length = The cumulative length of of the grip structure protruding from each side of the base
        grip_height = The height of of the grip structure protruding from each side of the base

        diameter = The outside diameter of the threaded rod (inner diameter + pitch/2)
        length = The length of the thraded rod base to end
        pitch = The length between threads
*/
// Example: Make sample object
//   make_bolt(bolt_base_diameter, bolt_grip_width, bolt_grip_length, bolt_grip_height, bolt_diameter, bolt_length, bolt_pitch);
//////////////////////////////////////////////////////////////////////
module make_bolt(base_diameter,
                 grip_width, grip_length, grip_height,
                 diameter, length, pitch){
    union(){
        // Base
        if(VERBOSE) echo("--> Make \"Bolt\" Base");
        make_bolt_base(base_diameter,grip_height);
        // Grip
        if(VERBOSE) echo("--> Make \"Bolt\" Grip");
        make_bolt_grip(grip_width,grip_length,grip_height);
        // Threads
        if(VERBOSE) echo("--> Make \"Bolt\" Threads");
        translate([0,0,grip_height])
            make_bolt_thread(diameter, length, pitch);
        // Wire Eyelet
        if(VERBOSE) echo("--> Make \"Bolt\" Wire Eyelet");
        make_bolt_wire_eyelet(grip_width, grip_height, base_diameter/2, angle=27, z_rotation=3);
        // Wire Catch
        if(VERBOSE) echo("--> Make \"Bolt\" Wire Catch");
        make_bolt_wire_catch(grip_width, grip_height, base_diameter/2, angle=27, z_rotation=-21);
    }
}
//////////////////////////////////////////////////////////////////////
// Module: make_bolt_base()
/*
    Description:
        Creates "base" part for inclusion in the larger Bolt object

    Arguments:
        d = The diameter of the circular base of the mold
        h = The height of base of the mold
        cutout_angle = The off-set angle (from zero-degrees) for the wire catch relief
*/
// Example: Make sample object
//   make_bolt_base(bolt_base_diameter, bolt_grip_height);
//////////////////////////////////////////////////////////////////////
module make_bolt_base(d, h, cutout_angle=13){
    if(VERBOSE) echo("----> Begin \"Bolt\" Base Creation");
    if(VERBOSE) echo(str("**======> Base Diameter (D=X/Y): ",d,"**"));
    if(VERBOSE) echo(str("**======> Base Height (Z): ",h,"**"));
    if(VERBOSE) echo(str("**======> Base Cutout Rotation Angle: ",cutout_angle,"**"));
    difference(){
        // Base
        cylinder(h=h,d=d,$fn=360);
        // Cutout
        rotate([0,0,cutout_angle]) translate([d*.155,-d/2,h*.89]) {
            if(SHOW_CUTOUTS){
                #cube([d*.23,d,h*.13]);
            } else {
                cube([d*.23,d,h*.13]);
            }
        }
    }
}
//////////////////////////////////////////////////////////////////////
// Module: make_bolt_grip()
/*
    Description:
        Creates "grip" part for inclusion in the larger Bolt object

    Arguments:
        x = The "width" distance on the X-axis
        y = The "length" distance on the Y-axis
        z = The "height" distance on the Z-axis
*/
// Example: Make sample object
//   make_bolt_base(bolt_grip_width, bolt_grip_length, bolt_grip_height);
//////////////////////////////////////////////////////////////////////
module make_bolt_grip(x,y,z){
    if(VERBOSE) echo("----> Begin \"Bolt\" Grip Creation");
    if(VERBOSE) echo(str("**======> Grip Width (X): ",x,"**"));
    if(VERBOSE) echo(str("**======> Grip Length (Y): ",y,"**"));
    if(VERBOSE) echo(str("**======> Grip Height (Z): ",z,"**"));
    translate([0,0,(z*.97)/2+0.1])
        cuboid([x,y,z*.97], fillet=1);
}
//////////////////////////////////////////////////////////////////////
// Module: make_bolt_thread()
/*
    Description:
        Creates "thread" part for inclusion in the larger Bolt object

    Arguments:
        d = The outside diameter of the threaded rod (inner diameter + pitch/2)
        l = The length of the thraded rod base to end
        pitch = The lenght between threads
*/
// Example: Make sample object
//   make_bolt_thread(bolt_diameter, bolt_length, bolt_pitch);
//////////////////////////////////////////////////////////////////////
module make_bolt_thread(d,l,pitch){
    if(VERBOSE) echo("----> Begin \"Bolt\" Thread Creation");
    if(VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
    if(VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
    if(VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
    translate([0,0,l/2])
        threaded_rod(d=d, l=l, pitch=pitch, $fa=1, $fs=1);
}
//////////////////////////////////////////////////////////////////////
// Module: make_bolt_wire_eyelet()
/*
    Description:
        Creates "wire eyelet" part for inclusion in the larger Bolt object

    Arguments:
        width = The "width" distance on the X-axis
        height = The "height" distance on the Z-axis
        radius = The radius to extrude the part around
        angle = The "length" of the part in degrees  Default: `0`
        z_rotation = The Z-axis rotation offset angle in degrees  Default: `0`
*/
// Example: Make sample object
//   make_bolt_wire_eyelet(bolt_grip_width, bolt_grip_height, bolt_base_diameter/2);
//////////////////////////////////////////////////////////////////////
module make_bolt_wire_eyelet(width,height,radius, angle=0, z_rotation=0){
    if(VERBOSE) echo("----> Begin \"Bolt\" Eyelet Creation");
    if(VERBOSE) echo(str("**======> Eyelet Width (X): ",width,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Height (Z): ",height,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Radius (r): ",radius,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Extrusion Length: ",angle,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Eyelet
    rotate([0,0,z_rotation+angle/2]) {       // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                rotate_extrude(angle=angle, $fn=360) translate([radius-(width/2),0,0])
                    square([width/2,height*1.67]);
            // Construct Eyelet
            translate([radius-width/4,0,height*1.3]) rotate([45,0,0]){
                if(SHOW_CUTOUTS){
                    #cube([width,width/3,width/3],center=true);
                } else {
                    cube([width,width/3,width/3],center=true);
                }
            }
        }
    }
}
//////////////////////////////////////////////////////////////////////
// Module: make_bolt_wire_catch()
/*
    Description:
        Creates "wire catch" part for inclusion in the larger Bolt object

    Arguments:
        width = The "width" distance on the X-axis
        height = The "height" distance on the Z-axis
        radius = The radius to extrude the part around
        angle = The "length" of the part in degrees  Default: `0`
        z_rotation = The Z-axis rotation offset angle in degrees  Default: `0`
*/
// Example: Make sample object
//   make_bolt_wire_catch(bolt_grip_width, bolt_grip_height, bolt_base_diameter/2);
//////////////////////////////////////////////////////////////////////
module make_bolt_wire_catch(width,height,radius, angle=0, z_rotation=0){
    if(VERBOSE) echo("----> Begin \"Bolt\" Catch Creation");
    if(VERBOSE) echo(str("**======> Catch Width (X): ",width,"**"));
    if(VERBOSE) echo(str("**======> Catch Height (Z): ",height,"**"));
    if(VERBOSE) echo(str("**======> Catch Radius (r): ",radius,"**"));
    if(VERBOSE) echo(str("**======> Catch Extrusion Length: ",angle,"**"));
    if(VERBOSE) echo(str("**======> Catch Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Catch
    rotate([0,0,z_rotation]) {     // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                rotate_extrude(angle=angle, $fn=360) translate([radius,0,0])
                    square([width/2,height*1.67]);
            // Construct Slot for Wire in Wire Catch
            translate([radius-width/4,0,height]){
                difference(){    
                    translate([height/4,0,0]) {
                        union() {
                            a=[height/2,width*angle/18];
                            b=[0,width*angle/18];
                            if(SHOW_CUTOUTS){
                                #prismoid(size1=a,size2=b,shift=[-height/4,0],h=height*.84);
                                #translate([-height*0.18,0,0])
                                    prismoid(size1=b,size2=a,shift=[height/4,0],h=height*.84);
                            } else {
                                prismoid(size1=a,size2=b,shift=[-height/4,0],h=height*.84);
                                translate([-height*0.18,0,0])
                                    prismoid(size1=b,size2=a,shift=[height/4,0],h=height*.84);
                            }
                        }
                    }
                    // Introduce Filet Relief at 30%
                    translate([width/2,0,0]) rotate([0,30,0])
                        cube([1,width*2.1,1],center=true);
                }
            }
        }
    } 
}



//////////////////////////////////////////////////////////////////////
// Module: make_screw()
/*
    Description:
        Creates Screw object to manipulate wire around mold for the spring shape

    Arguments:
        base_diameter = The diameter of the circular base of the mold

        grip_width = The width of the grip structure protruding from each side of the base
        grip_length = The cumulative length of of the grip structure protruding from each side of the base
        grip_height = The height of of the grip structure protruding from each side of the base

        diameter = The outside diameter of the threaded rod (inner diameter + pitch/2)
        length = The length of the thraded rod base to end
        pitch = The length between threads
*/
// Example: Make sample object
//   make_screw(screw_base_diameter, screw_grip_width, screw_grip_length, screw_grip_height, screw_diameter, screw_grip_height*1.5, screw_pitch);
//////////////////////////////////////////////////////////////////////
module make_screw(base_diameter,grip_width,grip_length,grip_height, d,l,pitch){
    union(){
        translate([0,0,grip_height/2]) {
            difference(){
                union(){
                    // Base
                    h=grip_height*1.24;
                    if(VERBOSE) echo("--> Make \"Screw\" Base");
                    if(VERBOSE) echo("----> Begin \"Screw\" Base Creation");
                    if(VERBOSE) echo(str("**======> Base Diameter (D=X/Y): ",base_diameter,"**"));
                    if(VERBOSE) echo(str("**======> Base Height (Z): ",h,"**"));
                    translate([0,0,(h-grip_height)/2]) cylinder(h=h*1.,d=base_diameter,center=true,$fn=360);
                    // Grip
                    if(VERBOSE) echo("--> Make \"Screw\" Grip");
                    if(VERBOSE) echo("----> Begin \"Screw\" Grip Creation");
                    if(VERBOSE) echo(str("**======> Grip Width (X): ",grip_width,"**"));
                    if(VERBOSE) echo(str("**======> Grip Length (Y): ",grip_length,"**"));
                    if(VERBOSE) echo(str("**======> Grip Height (Z): ",grip_height,"**"));
                    cuboid([grip_width,grip_length,grip_height], fillet=1);
                }
                // Threads
                if(VERBOSE) echo("--> Make \"Screw\" Threads");
                if(VERBOSE) echo("----> Begin \"Screw\" Thread Creation");
                if(VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
                if(VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
                if(VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
                if(SHOW_CUTOUTS){
                    #threaded_rod(d=d, l=l, pitch=pitch, $fa=1, $fs=1);
                } else {
                    threaded_rod(d=d, l=l, pitch=pitch, $fa=1, $fs=1);
                }
            }
        }
        // Wire Eyelet
        if(VERBOSE) echo("--> Make \"Screw\" Wire Eyelet");
        make_screw_wire_eyelet(grip_width*1.275, grip_height*1.899, base_diameter/2, angle=100, z_rotation=-98);
    }
}
//////////////////////////////////////////////////////////////////////
// Module: make_screw_wire_eyelet()
/*
    Description:
        Creates "wire eyelet" part for inclusion in the larger Screw object

    Arguments:
        width = The "width" distance on the X-axis
        height = The "height" distance on the Z-axis
        radius = The radius to extrude the part around
        angle = The "length" of the part in degrees  Default: `0`
        z_rotation = The Z-axis rotation offset angle in degrees  Default: `0`
*/
// Example: Make sample object
//   make_screw_wire_eyelet(screw_grip_width, screw_grip_height, screw_base_diameter/2);
//////////////////////////////////////////////////////////////////////
module make_screw_wire_eyelet(width,height,radius, angle=0, z_rotation=0){
    if(VERBOSE) echo("----> Begin \"Screw\" Eyelet Creation");
    if(VERBOSE) echo(str("**======> Eyelet Width (X): ",width,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Height (Z): ",height,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Radius (r): ",radius,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Extrusion Length: ",angle,"**"));
    if(VERBOSE) echo(str("**======> Eyelet Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Eyelet
    rotate([0,0,z_rotation+angle/2]) {       // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                difference(){
                    rotate_extrude(angle=angle, $fn=360) translate([radius-(width/4),0,0])
                        square([width/2,height]);
                    translate([radius*.5,-radius*.174,height]) mirror([0,0,1]){
                        if(SHOW_CUTOUTS){
                            #interior_fillet(width*1.5,height,ang=100, $fn=100);
                        } else {
                            interior_fillet(width*1.5,height,ang=100, $fn=96);
                        }
                    }
                }
            // Construct Eyelet
            translate([radius-width*.15,width*.03,height*.77]) rotate([45,0,-45]){
                if(SHOW_CUTOUTS){
                    #cube([width,width/4,width/4],center=true);
                } else {
                    cube([width*1.3,width*.25,width*.25],center=true);
                }
            }
        }
    }
}



//////////////////////////////////////////////////////////////////////
// Module: make_cap()
/*
    Description:
        Creates Cap object to create a flat surface on the end of the spring

    Arguments:
        base_diameter = The diameter of the circular base of the mold

        diameter = The outside diameter of the threaded rod (inner diameter + pitch/2)
        length = The length of the thraded rod base to end
        pitch = The length between threads
*/
// Example: Make sample object
//   make_cap(cap_diameter, screw_grip_height*1.5, screw_pitch);
//////////////////////////////////////////////////////////////////////
module make_cap(d,l,pitch){
    // Threads
    if(VERBOSE) echo("--> Make \"Cap\" Threads");
    if(VERBOSE) echo("----> Begin \"Cap\" Thread Creation");
    if(VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
    if(VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
    if(VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
    translate([0,0,l/2]) {
        difference(){
            union(){
                threaded_rod(d=d, l=l, pitch=pitch, $fa=1, $fs=1);
                //cylinder(h=l,d=d*1.124,center=true, $fn=360);
                translate([0,0,-l/2]) linear_extrude(pitch*.24)
                    circle(d=d*1.124, $fn=360);
            }
            if(SHOW_CUTOUTS){
                #cylinder(h=l*1.5,d=d-pitch*1.81, center=true, $fn=360);
            } else {
                cylinder(h=l*1.5,d=d-pitch*1.81, center=true, $fn=360);
            }
        }
    }
}