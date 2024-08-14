/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  SpringFactory: SpringDesigner.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/SpringFactory
        
        Parametric OpenSCAD file in support of the "Spring Factory 1.2"
        https://www.thingiverse.com/thing:5171637
        Vincent Baillet
        https://www.thingiverse.com/vbaillet/designs
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  GNU GPLv3
&&
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/


// BOSL Library -- https://github.com/revarbat/BOSL
use <external/BOSL/threading.scad>;
use <external/BOSL/shapes.scad>;


/*?????????????????????????????????????????????????????????????????
/*???????????????????????????????????????????????????????
?? Section: Customizer
??
    Description:
        The Customizer feature provides a graphic user interface for editing model parameters.
??
???????????????????????????????????????????????????????*/
/* [Global] */
// Display Verbose Output?
$VERBOSE=1; // [0:No,1:Level=1,2:Level=2,3:Developer]

/* [Spring Factory Parameters] */
// Show Reference Model
show_reference_model=1; // [1:Yes,0:No]
// Overlap or Offset Reference Model
offset_reference_model=1; // [0:Overlap,1:Offset]
// Display Spring Factory 'Cutouts'
display_cutouts=0; // [1:Yes,0:No]
// Display "Functional" view vs. "Printable" view
display_printable=1; // [0:Functional,1:Printable]
// Sync "Factory" ("Screw" and "Cap" = "Bolt") parameters
sync_factory=1; // [1:Yes,0:No]

/* ["The Bolt" Parameters] */
// Display Bolt
display_bolt=1; // [1:Yes,0:No]
// Diameter of the Bolt.
custom_bolt_diameter=8; // [.01:.01:210]
// Length (Z) of the Bolt
custom_bolt_length=47.5; // [10:.1:250]
// Pitch of the Bolt
custom_bolt_pitch=2.4; // [0.2:0.01:6]
// Reference Internal?
custom_bolt_internal=0; // [1:Yes,0:No]
// Length (X) of the Bolt grip
custom_bolt_grip_length=59.935; // [0:.001:100]
// Width (Y) of the Bolt grip
custom_bolt_grip_width=5.835; // [0:.001:10]
// Height (Z) of the Bolt grip
custom_bolt_grip_height=5.7835; // [0:.001:10]
// Diameter of Bolt Base
custom_bolt_base_diameter=31.983; // [20:.1:80]

/* ["The Screw" Parameters] */
// Display Screw
display_screw=1; // [1:Yes,0:No]
// Diameter of Screw/Nut
custom_screw_diameter=8; // [.2:0.01:54]
// Clearance Offset
custom_offset=0.15; // [0.0:0.01:0.4]
// Length (X) of the Screw grip
custom_screw_grip_length=47.8; // [0:.1:100]
// Pitch of the Screw
custom_screw_pitch=2.4; // [0.2:0.01:6]
// Width (Y) of the Screw grip
custom_screw_grip_width=5.835; // [1:.1:210]
// Height (Z) of the Screw grip
custom_screw_grip_height=6.62; // [1:.1:250]
// Diameter of Screw Base
custom_screw_base_diameter=14.9836; // [1:1:210]

/* ["The Cap" Parameters] */
// Display Cap
display_cap=1; // [1:Yes,0:No]
// Diameter of Screw/Nut
custom_cap_diameter=8; // [0.1:0.01:54]
// Rotations (R) of the Cap
custom_cap_rotations=1.6; // [0.1:0.001:54]
// Pitch of the Screw
custom_cap_pitch=2.4; // [0.2:0.01:6]
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Derived Variables
*/
/* [Hidden] */
//$fa = 0.1;
//$fs = 0.1;
// The Bolt
bolt_diameter=custom_bolt_diameter;
bolt_length=custom_bolt_length;
bolt_pitch=custom_bolt_pitch;
bolt_internal=custom_bolt_internal;
bolt_grip_length=custom_bolt_grip_length;
// set base width/height/diameter relative to bolt_grip_length
bolt_grip_width=(bolt_grip_length==59.935) ? custom_bolt_grip_width :
                ((custom_bolt_grip_width!=5.835) ? custom_bolt_grip_width :
                bolt_grip_length*(5.385/59.935));
bolt_grip_height=(bolt_grip_width==5.7835) ? custom_bolt_grip_height :
                ((custom_bolt_grip_height!=bolt_grip_width) ? custom_bolt_grip_height :
                bolt_grip_width);
bolt_base_diameter=(bolt_grip_length==59.935) ? custom_bolt_base_diameter :
                ((custom_bolt_base_diameter!=31.983) ? custom_bolt_base_diameter :
                bolt_grip_length*(31.983/59.935));

// The Screw
screw_diameter=(sync_factory) ? bolt_diameter : custom_screw_diameter;
screw_offset=custom_offset;
screw_pitch=(sync_factory) ? bolt_pitch : custom_screw_pitch;            
screw_grip_length=(sync_factory) ? bolt_grip_length*(47.8/bolt_grip_length) : custom_screw_grip_length;
// set width/height/diameter relative to screw_grip_length
screw_grip_width=(sync_factory) ? screw_grip_length*(5.835/47.8) :
                ((custom_screw_grip_width!=5.835) ? custom_screw_grip_width :
                screw_grip_length*(5.835/47.8));
screw_grip_height=(sync_factory) ? screw_grip_width*(6.62/5.835) :
                ((custom_screw_grip_height!=6.62) ? custom_screw_grip_height :
                screw_grip_width*(6.62/5.835));
screw_base_diameter=(sync_factory) ? bolt_diameter*(14.9836/8) :
                    ((custom_screw_base_diameter!=14.9836) ? custom_screw_base_diameter :
                    screw_grip_length*(14.9836/47.8));

//The Cap
cap_diameter=(sync_factory) ? bolt_diameter :
            ((custom_cap_diameter==0) ? bolt_diameter :
            custom_cap_diameter);
cap_pitch=(sync_factory) ? bolt_pitch :
            ((custom_cap_pitch==0) ? bolt_pitch :
            custom_cap_pitch);
cap_rotations=custom_cap_rotations*cap_pitch;
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
/*///////////////////////////////////////////////////////
// Module: show_reference_objects()
//
    Description:
        Wrapper module to display original STL files for comparison

    Arguments:
        N/A
*/
// Example: Make sample objects
if(show_reference_model){
    show_reference_objects();
}
///////////////////////////////////////////////////////*/
module show_reference_objects(){
    offset=(offset_reference_model) ? (bolt_base_diameter*.5)+(screw_grip_length) : 0;
    // The Bolt
    if(display_bolt){
        // Shift Import to [0,0,0]
        x_origin=-(93.489);
        y_origin=-(3.0);
        z_origin=1.792;
        
        // Set Color
        c=[106,90,205]/255;
        // Offset/Printable
        x=offset;
        y=0;
        z=0;
        
        translate([x,y,z]) color(c=c)
            translate([x_origin,y_origin,z_origin])
                import("./reference/SpringFactory1.2_TheBolt.stl");
    }
    // The Screw
    if(display_screw){
        // Shift object to [0,0,0]
        x_origin=-(57.8);
        y_origin=34.422;
        z_origin=-(4.1013);
        
        // Set Color
        c=[186,85,211]/255;
        // Offset
        x=(display_printable) ?
            ((display_bolt) ?
                offset+(bolt_base_diameter*.4)+(screw_base_diameter*.5) :
                offset) :
            offset;
        y=(display_bolt) ? x-offset : 0;
        z=(display_printable) ? 0 : bolt_length*(.95-(screw_pitch/100));
        r_x=(display_printable) ? 0 : 180;
        r_z=(display_printable) ? -45 : 0;

        translate([x,y,z]) rotate([r_x,0,r_z]) color(c=c,alpha=0.75)
            translate([x_origin,y_origin,z_origin])
                import("./reference/SpringFactory1.2_TheScrew.stl");
    }
    // The Cap
    if(display_cap){
        // Shift object to [0,0,0]
        x_origin=-(133.15);
        y_origin=-(3.9175);
        z_origin=0;
        
        // Set Color
        c=[138,43,226]/255;
        // Offset
        x=(display_bolt || display_screw) ? offset + (bolt_base_diameter/2)+(cap_diameter*1.2) : offset;
        r=-15;
        translate([x,0,0]) rotate([0,0,r]) color(c=c,alpha=0.75)
            translate([x_origin,y_origin,z_origin])
                import("./reference/SpringFactory1.2_TheCap.stl");
    }
}


/*///////////////////////////////////////////////////////
// Module: make_SpringFactory()
//
    Description:
        Wrapper module to create all Spring Factory objects

    Arguments:
        N/A
*/
// Example: Make sample objects
    make_SpringFactory();
///////////////////////////////////////////////////////*/
module make_SpringFactory(){
    if(display_bolt){
        make_bolt(bolt_diameter, bolt_length, bolt_pitch,
                bolt_grip_length, bolt_grip_width, bolt_grip_height,
                bolt_base_diameter);
    }
    if(display_screw){
        x=(display_printable) ?
            ((display_bolt) ?
                (bolt_base_diameter*.4)+(screw_base_diameter*.5) :
                0) :
            0;
        y=x;
        z=(display_printable) ? 0 : bolt_length*(.95-(screw_pitch/100));
        r_x=(display_printable) ? 0 : 180;
        r_z=(display_printable) ? 45 : -90;
        translate([x,y,z]) rotate([r_x,0,r_z]) 
                make_screw(screw_diameter+screw_offset, screw_grip_height, screw_pitch,
                            screw_grip_length, screw_grip_width, screw_grip_height,
                            screw_base_diameter);
    }
    if(display_cap){
        x=(display_bolt || display_screw) ? (bolt_base_diameter/2)+(cap_diameter*1.2) : 0;
        translate([x,0,0])
            make_cap(cap_diameter, cap_rotations, cap_pitch);
    }
}



/*///////////////////////////////////////////////////////
// Module: make_bolt()
//
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
//   make_bolt(bolt_diameter, bolt_length, bolt_pitch, bolt_grip_length, bolt_grip_width, bolt_grip_height, bolt_base_diameter);
///////////////////////////////////////////////////////*/
module make_bolt(d,l,pitch,
                grip_length, grip_width, grip_height,
                base_diameter){
    union(){
        // Base
        if($VERBOSE) echo("--> Make \"Bolt\" Base");
        make_bolt_base(base_diameter,grip_height);
        // Grip
        if($VERBOSE) echo("--> Make \"Bolt\" Grip");
        make_bolt_grip(grip_width,grip_length,grip_height);
        // Threads
        if($VERBOSE) echo("--> Make \"Bolt\" Threads");
        translate([0,0,grip_height])
            make_bolt_thread(d, l, pitch);
        // Wire Eyelet
        if($VERBOSE) echo("--> Make \"Bolt\" Wire Eyelet");
        make_bolt_wire_eyelet(grip_width, grip_height, (grip_height*1.71)-grip_height, base_diameter/2, angle=27, z_rotation=3);
        // Wire Catch
        if($VERBOSE) echo("--> Make \"Bolt\" Wire Catch");
        make_bolt_wire_catch(grip_width, grip_height, (grip_height*1.71)-grip_height, base_diameter/2, angle=25.4, z_rotation=-20.83);
    }
}
/*///////////////////////////////////////////////////////
// Module: make_bolt_base()
//
    Description:
        Creates "base" part for inclusion in the larger Bolt object

    Arguments:
        d = The diameter of the circular base of the mold
        h = The height of base of the mold
        cutout_angle = The off-set angle (from zero-degrees) for the wire catch relief
*/
// Example: Make sample object
//   make_bolt_base(base_diameter,grip_height);
///////////////////////////////////////////////////////*/
module make_bolt_base(d, h, cutout_angle=13){
    if($VERBOSE) echo("----> Begin \"Bolt\" Base Creation");
    if($VERBOSE) echo(str("**======> Base Diameter (D=X/Y): ",d,"**"));
    if($VERBOSE) echo(str("**======> Base Height (Z): ",h,"**"));
    if($VERBOSE) echo(str("**======> Base Cutout Rotation Angle: ",cutout_angle,"**"));
    difference(){
        // Base
        cylinder(h=h,d=d,$fn=360);
        // Cutout
        rotate([0,0,cutout_angle]) translate([d*.143,-d/2,h*.89]) {
            if(display_cutouts){
                #cube([d*.2,d,h*.13]);
            } else {
                cube([d*.25,d,h*.13]);
            }
        }
    }
}
/*///////////////////////////////////////////////////////
// Module: make_bolt_grip()
//
    Description:
        Creates "grip" part for inclusion in the larger Bolt object

    Arguments:
        x = The "width" distance on the X-axis
        y = The "length" distance on the Y-axis
        z = The "height" distance on the Z-axis
*/
// Example: Make sample object
//   make_bolt_base(bolt_grip_width, bolt_grip_length, bolt_grip_height);
///////////////////////////////////////////////////////*/
module make_bolt_grip(x,y,z){
    if($VERBOSE) echo("----> Begin \"Bolt\" Grip Creation");
    if($VERBOSE) echo(str("**======> Grip Width (X): ",x,"**"));
    if($VERBOSE) echo(str("**======> Grip Length (Y): ",y,"**"));
    if($VERBOSE) echo(str("**======> Grip Height (Z): ",z,"**"));
    translate([0,0,((z*.97)/2)+(z*.014)])
        cuboid([x,y,(z*.97)], fillet=1);
}
/*///////////////////////////////////////////////////////
// Module: make_bolt_thread()
//
    Description:
        Creates "thread" part for inclusion in the larger Bolt object

    Arguments:
        d = The outside diameter of the threaded rod (inner diameter + pitch/2)
        l = The length of the thraded rod base to end
        pitch = The lenght between threads
*/
// Example: Make sample object
//   make_bolt_thread(bolt_diameter, bolt_length, bolt_pitch);
///////////////////////////////////////////////////////*/
module make_bolt_thread(d,l,pitch){
    if($VERBOSE) echo("----> Begin \"Bolt\" Thread Creation");
    if($VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
    if($VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
    if($VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
    translate([0,0,l/2])
        threaded_rod(d=d, l=l, pitch=pitch,internal=bolt_internal, $fa=1, $fs=1);
}
/*///////////////////////////////////////////////////////
// Module: make_bolt_wire_eyelet()
//
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
///////////////////////////////////////////////////////*/
module make_bolt_wire_eyelet(width,height,extension,radius, angle=0, z_rotation=0){
    combined_height=height+extension;
    if($VERBOSE) echo("----> Begin \"Bolt\" Eyelet Creation");
    if($VERBOSE) echo(str("**======> Eyelet Width (X): ",width,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Height (Z): ",combined_height,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Radius (r): ",radius,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Extrusion Length: ",angle,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Eyelet
    rotate([0,0,z_rotation+angle/2]) {       // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                rotate_extrude(angle=angle, $fn=360) translate([radius-(width/2),0,0])
                    square([width/2,combined_height]);
            // Construct Eyelet
            translate([radius-width/4,width*.102,combined_height*.75]) rotate([45,0,-20]){
                if(display_cutouts){
                    #cube([width,width/3,width/3],center=true);
                } else {
                    cube([width,width/3,width/3],center=true);
                }
            }
        }
    }
}
/*///////////////////////////////////////////////////////
// Module: make_bolt_wire_catch()
//
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
///////////////////////////////////////////////////////*/
module make_bolt_wire_catch(width,height,extension,radius, angle=0, z_rotation=0, base_height){
    combined_height=height+extension;
    if($VERBOSE) echo("----> Begin \"Bolt\" Catch Creation");
    if($VERBOSE) echo(str("**======> Catch Width (X): ",width,"**"));
    if($VERBOSE) echo(str("**======> Catch Height (Z): ",combined_height,"**"));
    if($VERBOSE) echo(str("**======> Catch Radius (r): ",radius,"**"));
    if($VERBOSE) echo(str("**======> Catch Extrusion Length: ",angle,"**"));
    if($VERBOSE) echo(str("**======> Catch Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Catch
    rotate([0,0,z_rotation]) {     // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                rotate_extrude(angle=angle, $fn=360) translate([radius,0,0])
                    square([width/2,combined_height]);
            // Construct Slot for Wire in Wire Catch
            translate([radius-width/4,0,height]){
                difference(){    
                    translate([height/4,0,0]) {
                        union() {
                            a=[height/2,width*angle/18];
                            b=[0,width*angle/18];
                            s=[height/4,0];
                            h=height*.84;
                            if(display_cutouts){
                                #prismoid(size1=a,size2=b,shift=-s,h=h);
                                #translate([-height*0.18,0,0])
                                    prismoid(size1=b,size2=a,shift=s,h=h);
                            } else {
                                prismoid(size1=a,size2=b,shift=-s,h=h);
                                translate([-height*0.18,0,0])
                                    prismoid(size1=b,size2=a,shift=s,h=h);
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



/*///////////////////////////////////////////////////////
// Module: make_screw()
//
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
//   make_screw(screw_diameter, screw_grip_height, screw_pitch, screw_grip_length, screw_grip_width, screw_grip_height, screw_base_diameter);
///////////////////////////////////////////////////////*/
module make_screw(d,l,pitch,
                grip_length,grip_width,grip_height,
                base_diameter){
    union(){
        difference(){
            union(){
                // Base
                h=l*1.1775;
                if($VERBOSE) echo("--> Make \"Screw\" Base");
                if($VERBOSE) echo("----> Begin \"Screw\" Base Creation");
                if($VERBOSE) echo(str("**======> Base Diameter (D=X/Y): ",base_diameter,"**"));
                if($VERBOSE) echo(str("**======> Base Height (Z): ",h,"**"));
                translate([0,0,h/2]) cylinder(h=h,d=base_diameter,center=true,$fn=360);
                // Grip
                if($VERBOSE) echo("--> Make \"Screw\" Grip");
                if($VERBOSE) echo("----> Begin \"Screw\" Grip Creation");
                if($VERBOSE) echo(str("**======> Grip Width (X): ",grip_width,"**"));
                if($VERBOSE) echo(str("**======> Grip Length (Y): ",grip_length,"**"));
                if($VERBOSE) echo(str("**======> Grip Height (Z): ",grip_height,"**"));
                translate([0,0,((grip_height*.97)/2)++(grip_height*.0125)])
                    cuboid([grip_width,grip_length,(grip_height*.97)], fillet=1);
            }
            // Threads
            if($VERBOSE) echo("--> Make \"Screw\" Threads");
            if($VERBOSE) echo("----> Begin \"Screw\" Thread Creation");
            if($VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
            if($VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
            if($VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
            if(display_cutouts){
                #threaded_rod(d=d, l=l*2.5, pitch=pitch, internal=bolt_internal, $fa=1, $fs=1);
            } else {
                threaded_rod(d=d, l=l*2.5, pitch=pitch, internal=bolt_internal, $fa=1, $fs=1);
            }
        }
        // Wire Eyelet
        if($VERBOSE) echo("--> Make \"Screw\" Wire Eyelet");
        make_screw_wire_eyelet(grip_width*1.0276, grip_height*1.8115, base_diameter/2, angle=100, z_rotation=-98);
    }
}
/*///////////////////////////////////////////////////////
// Module: make_screw_wire_eyelet()
//
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
///////////////////////////////////////////////////////*/
module make_screw_wire_eyelet(width,height,radius, angle=0, z_rotation=0){
    if($VERBOSE) echo("----> Begin \"Screw\" Eyelet Creation");
    if($VERBOSE) echo(str("**======> Eyelet Width (X): ",width,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Height (Z): ",height,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Radius (r): ",radius,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Extrusion Length: ",angle,"**"));
    if($VERBOSE) echo(str("**======> Eyelet Z-Rotation Offset Angle: ",z_rotation,"**"));
    // Wire Eyelet
    rotate([0,0,z_rotation+angle/2]) {       // Rotate Off-Center
        difference(){
            // Construct Frame
            rotate([0,0,-angle/2]) // Align to X axis
                difference(){
                    rotate_extrude(angle=angle, $fn=360) translate([radius-(width/4),0,0])
                        square([width*.5,height]);
                    translate([radius*.5,-radius*.1,height]) mirror([0,0,1]){
                        if(display_cutouts){
                            #interior_fillet(width*1.45,height,ang=104, $fn=360);
                        } else {
                            interior_fillet(radius*1.45,height,ang=104, $fn=360);
                        }
                    }
                }
            // Construct Eyelet
            translate([radius-width*.15,width*.03,height*.77]) rotate([45,0,-45]){
                if(display_cutouts){
                    #cube([width,width/4,width/4],center=true);
                } else {
                    cube([width*1.3,width*.25,width*.25],center=true);
                }
            }
        }
    }
}



/*///////////////////////////////////////////////////////
// Module: make_cap()
//
    Description:
        Creates Cap object to create a flat surface on the end of the spring

    Arguments:
        base_diameter = The diameter of the circular base of the mold

        diameter = The outside diameter of the threaded rod (inner diameter + pitch/2)
        length = The length of the thraded rod base to end
        pitch = The length between threads
*/
// Example: Make sample object
//   make_cap(cap_diameter, cap_rotations, cap_pitch);
///////////////////////////////////////////////////////*/
module make_cap(d,l,pitch){
    base=d*1.124;
    // Threads
    if($VERBOSE) echo("--> Make \"Cap\" Threads");
    if($VERBOSE) echo("----> Begin \"Cap\" Thread Creation");
    if($VERBOSE) echo(str("**======> Thread Diameter (X/Y): ",d,"**"));
    if($VERBOSE) echo(str("**======> Thread Height (Z): ",l,"**"));
    if($VERBOSE) echo(str("**======> Thread Pitch (P): ",pitch,"**"));
    translate([0,0,l/2]) {
        difference(){
            union(){
                threaded_rod(d=d, l=l, pitch=pitch, internal=bolt_internal, $fa=1, $fs=1);
                //cylinder(h=l,d=d*1.124,center=true, $fn=360);
                translate([0,0,-l/2]) linear_extrude(pitch*.24)
                    circle(d=base, $fn=360);
            }
            if(display_cutouts){
                #cylinder(h=l*1.5,d=d-pitch*1.81, center=true, $fn=360);
            } else {
                cylinder(h=l*1.5,d=base*.389, center=true, $fn=360);                    
            }
        }
    }
}