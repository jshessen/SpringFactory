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
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/





/*?????????????????????????????????????????????????????????????????
??
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
// Select your unit of measure:
METRIC=1; // [1:Metric,0:Imperial]

/* [Spring Dimensions] */
// Common Wire Diameters (ASTM A228)
//common_d=A228_common_wire_diameter;
//echo(str("[",pipe_list_builder(STANDARD_PIPE_LIST),"]"));
// (d)              Wire Diameter:
d_wire=0;           //[0:.001:25]
// (Do|De|Do)       Outer Diameter of Spring:
D_outer=0;          //[0:.001:25]
//L1/L2/L3/L4 = F1/F2/F3/F4
// (L|L0|Lf|L_free)    Free length (no load):
L_free=0;           //[0:.001:25]
// (Na|N_active)    Number of Active Coils
N_active=0;         //[0:.001:25]
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Defined/Derived Variables
*/
/* [Hidden] */
d   = d_wire;
Do  = D_outer;
L0  = L_free;
Na  = N_active;

background=[250,210];
background_color=[192,192,192];
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
/*///////////////////////////////////////////////////////
// Module: connector()
//
    Description:
        Creates a "Connector" object

    Parameter(s):
        l      (undef) = The "length" distance on the X-axis
        b1     (undef) = The "width" of the "bottom" of the profile on Y-axis
        b2     (undef) = The "width" of the "top" of the profile on Y-axis
        h      (undef) = The "height" distance on the Z-axis
        border (undef) = Boolean used to create a right trapezoid
*/
/* Example: Make sample object
//   connector(connector_length,width_bottom,width_top,height,connections=3);
//   translate([40,0,0]) connector(0,width_bottom,width_top,
///////////////////////////////////////////////////////*/
spring_characteristics();
module spring_characteristics(){
    //Metric
    d   = 0.965; //mm
    Do  = 12.700; //mm
    L0  = 25.400; //mm
    Na  = 4.000;

/*    https://www.efunda.com/designstandards/springs/calc_comp_designer.cfm
Rates & Loads
  Spring Rate (or Spring constant), k :    1.329 N/mm
  True Maximum Load, True Fmax :    27.985 N
  Maximum Load Considering Solid Height, Solid Height Fmax :    24.776 N
Safe Travel
  Potential True Maximum Travel w/ Longer Free Length, True Travelmax :    21.060 mm
  Maximum Travel Considering Solid Height, Solid Height Travelmax :    18.645 mm
  Minimum Loaded Height :    6.755 mm*/
    
    spring_dimensions(d,Do,L0,Na);
}
module spring_dimensions(d,Do,L0,Na){
    form="B";
    ends=spring_ends[search(form,spring_ends)[0]][1];
    
    D=D(Do,d);
    Di=Di(Do,d);
    Ne=Ne(Closed=true,Ground=false);
    Nt=Nt(Na,Ne,Form=form);
    Ls=Ls(d,Nt,Form=form);
    C=C(D,d);
    p=p(L0,d,Na);
    a=a(p,D);
    
    prefix=pad("",5,"-");
    tab="\t";
    dimensions=str(
        "Pysical Dimensions","\n",
        prefix,get_description("d",symbols),":",tab,tab,            d,     " mm", "\n", //  0.965 mm
        prefix,prefix,get_description("Do",symbols),":",tab,tab,    Do,    " mm", "\n", // 12.700 mm
        prefix,prefix,get_description("Di",symbols),":",tab,tab,    Di,    " mm", "\n", // 10.770 mm
        prefix,prefix,get_description("D",symbols),":",tab,tab,     D,     " mm", "\n", // 11.735 mm
        prefix,prefix,get_description("L",symbols),":",tab,         L0,    " mm", "\n", // 25.400 mm
        prefix,prefix,get_description("Ls",symbols),":",tab,        Ls,    " mm", "\n", //  6.755 mm
        prefix,get_description("Na",symbols),":",tab,tab,           Na,           "\n", //  4.000
        prefix,get_description("Ne",symbols),":",tab,tab,           Ne,           "\n", //  2.000
        prefix,get_description("Nt",symbols),":",tab,tab,           Nt,           "\n", //  6
        prefix,"Type of Ends:",tab,tab,tab,                         ends,         "\n", //  Closed|Squared
        prefix,get_description("C",symbols),":",tab,tab,tab,        C,            "\n", // 12.161
        prefix,get_description("p",symbols),":",tab,tab,tab,        p,     " mm", "\n", //  5.626 mm
        prefix,get_description("a",symbols),":",tab,tab,            a,     " rad","\n", //  8.68 Radians
        "Material Type","\n",
        prefix,"Music Wire ASTM A228");
    echo(dimensions);
    
    echo( (-1)?"negative":false);
    E   = 0;
    G   = 0;
    //Kc=Kb/Ks = (2*C*(4*C +2))/((4*C-3)*(2*C+1));
    //Na = (Gd)/((8C^3k)(1+0.5/C^2))
    //Na = Gd^4y_max/(8D^3Fmax)
    //(Lo)cr=2.63*D/greek(a)
    // greek(a) = 2.63*D/Lo
    // greek(a) = end-condition constant
    // ycr = critical deflection
    // ys = Fmax/k*
    // L0=Ls+ys
    // D=C*d
    //Over a rod
    // D=drod+d+allow
    //In a hole
    // D=dhole-d-allow
    // Free
    //      As Wound    Ssy=A/d^m
    //      Set Removed Ssy=0.65*A/d^m
    //fom=-(relative cost)(Ypi^2*d%2*Nt*D)/4
    // (Kd)                 = Shear stress correction factor
    // (Sut)                = Minimum tensile strength of material (Wire Strength)
    // (A)                  = A kpsi/Mpa
    // (m)                  = Exponent
    A=0;
    m=1;
    //Caution: Use Ap in ksi with d in inches, and Ap in MPa with d in mm.
    //https://www.drtempleman.com/spring-resources/spring-design-formulas
    // (Sut)                = Tensile Strength
    Sut=A/pow(d,m);


    // (Ssy)                                = Torsional yeild strength (Wire Shear Strength)
    // 0.35 Sut <= Sy <= 0.52Sut
    // Ssy = Tall = .45Sut (cold-drawn carbon steel) - music wire               After set 60-70
    // Ssy = Tall = .50Sut (hardend and tempered carbon and low-alloy steel)                65-75
    // Ssy = Tall = .35Sut (austenitic stainless steel and nonferrous alloys) - austenitic stainless nonferrous alloys 55-65
    Ssy=0.50*Sut;

    // (F)                  = Static Load corresponding to the yield strength
    //F=(PI*pow(d,3)*Ssy)/8*Kd*D;

    // (k)                  = Spring Rate/Constant (stiffness)
    k = spring_rate(d,G,C,Na);
}
/*
  Compression spring
Total turns	7
Active turns	5
Wire diameter	1 mm
∗Free length	12.7 ± 0.4 mm
∗Solid length	7 mm max.
∗Outside coil diameter	7.6 mm max.
∗Inside coil diameter	5 mm
Rate	7850 N/m
∗Load at 9 mm	31 ± 4.5 N
Solid stress	881 N/mm2
∗Ends	Closed and ground
Wound	Right-hand or left-hand
∗Material	S202
∗Protective treatment	Cadmium-plate



Weights & Measures
 Weight of one spring, M :	0.0028 Lbs
 Weight per one thousand springs, M :	2.8063 Lbs
  Length of wire required to make one spring, Lwire :	8.7085 Inches
Stress Factors
  Material shear modulus, G :	11,492,970.929 psi
  Maximum shear stress possible, tmax :	150,870.000
  Wahl correction factor, W :	1.118
Possible Loads
0.557 lbF @ 0.927 Loaded Height	yes
2.230 lbF @ 0.706 Loaded Height	yes
Max Load For This Spring: 5.574 lbF
*/

/*
Stress Factor: 1 --> No Conversion Required
Force: 2.5 Newton --> 2.5 Newton No Conversion Required
Spring Index: 2 --> No Conversion Required
Diameter of spring wire: 1 Meter --> 1 Meter No Conversion Required

Substituting Input Values in Formula
𝜏 = k*(8*F*C)/(pi*d^2) --> 1*(8*2.5*2)/(pi*1^2)
Evaluating ... ...
𝜏 = 12.7323954473516

FINAL ANSWER
12.7323954473516 Pascal <-- Shear Stress
(Calculation completed in 00.016 seconds)
*/
module compression_spring_designer(Fo,Lo, Fi,Li){

/*
Springs --> Leaf Springs
        --> Helical Springs
                --> Compression Spring aka Open Coil Spring
                --> Tension Spring aka Closed Coil Spring (Extension)
                --> Torsion Spring
                --> Spiral Spring

What is a Compression Spring?
Compression springs are helically coiled wires wound one on top of the other to absorb shock or maintain a force between two surfaces.
Therefore containing or releasing energy when a load is applied.
*/


/*Limit the design solution space by setting some practical limits
 Preferred range for spring index
    4 <= C <=12
 Preferred range for number of active coils
    3 <= Na <=15
    Lx <= 1
        L0<= 4
        L0_cr Buckling Criteria
        ns >= 1.20 Factor of Safety
        figure of merit
        
        
        75% of the force deflection curve
        between F=0 and F=Fs
        Fmax<= 7/8*Fs
        Fractional Overrun to closure as curly
        Fs=(1+curly)Fmax
        Fs=(1+curly)(7/8)*Fs
        curly = 1/7 = 0.143 curly >= 0.15
        
        y=F/k
        d
        D
        C
        Od
        Na
        Ls
        Lo
        (Lo)cr
        (ns) = Ssy/Ts
        fom

        
        
*/
    // If there are no constraints on spring diameter

    // Fo    = Force at Length Lo
    // Fi    = Force at Length Li
    
    
//Peter R.N. Childs, in Mechanical Design Engineering Handbook, 2014
//    1.    Select a material and identify its shear modulus of elasticity G and an estimate of the design stress.
//    2.    Calculate a value for the wire diameter based on the spring material properties and assuming approximate values for C and Kw. Typical estimates for C and Kw of 7 and 1.2, respectively, are generally suitable.
//    d=sqrt((8*Kw*Fo*C)/(PI*τmax));
//    3.    Select a standard wire diameter.
//    4.    Determine the maximum number of active coils possible for the spring. The rationale here is that the solid length must be less than the operating length. The relationship between the solid length and the number of coils is a function of the end treatment. For squared and ground ends,
//                Ls=d*(Na+2);
//                Substituting Ls = Lo
//                Nmax = (Lo/d)-2;
//    5.    The designer can now select any number of active coils less than the maximum calculated value. Choosing a small value will result in larger clearances between adjacent coils and will use less wire per spring but will entail higher stresses for a given load. One approach is to try progressively fewer coils until the maximum permissible design stress is approached.
//    6.    Calculate the Spring Index using
//                C=pow((G*d)/(8*K*Na),1/3);
//    7.    The mean diameter can now be calculated from the definition of the Spring Index, D = Cd.
//    8.    Calculate the Wahl factor, Kw.
//    9.    Determine the expected stress due to the operating force and compare with the design stress.
//    10.    Calculate the solid length, the force on the spring at the solid length, and the shear stress in the spring at the solid length. Compare this value with the allowable shear stress and see whether it is safe.
//    11.    Check whether the spring is likely to buckle.
//    12.    Specify the spring dimensions.


// The design procedure requires access to tables of data for material properties and wire diameters.

//    Fo    = Force at Length Lo
//    Fi    = Force at Length Li
//    Odmax = Max Outer Diameter

//    1.    Select a material and identify its shear modulus of elasticity G.
//    2.    Identify the operating force, Fo, operating length, Lo, the installed force, Fi, and the installed length, Li.
//    3.    Determine the spring rate, k = (Fo − Fi)/(Li − Lo).
//    4.    Calculate the free length, L0 = Li + (Fi/k).
//    5.    Specify an initial estimate for the mean diameter.
//    6.    Specify an initial design stress. An estimate for the initial design stress can be made using Table 15.5 and Figure 15.12.
//    7.    Calculate a trial wire diameter, d, by rearranging Eqn (15.6) or Eqn (15.9) and assuming a value for Kd or Kw, which is unknown at this stage. Kw = 1.2 is generally a suitable estimate at this stage.
//    8.    Based on the value determined in (7), select a standard wire diameter from a wire manufacturer's catalog or using Table 15.4 as a guide.
//    9.    Calculate the Spring Index, C, and the Wahl factor, Kw.
//    10.    Determine the expected stress due to the operating force and compare with the design stress using Eqn (15.6) or Eqn (15.9).
//    11.    Determine the number of active coils required to give the desired deflection characteristics for the spring, Na = Gd/(8kC3).
//    12.    Calculate the solid length, the force on the spring at the solid length, and the shear stress in the spring at the solid length. Compare this value with the allowable shear stress and see whether it is safe. If the value for the shear stress is too high, alter the design parameters set above, such as the wire diameter or material, and reanalyze the results.
//    13.    Check whether the spring is likely to buckle.
//    14.    Specify the spring dimensions.
}
create_background(background, background_color);
module create_background(background, c, a) {
    translate([0,0,-0.5]) color(c=c/255, alpha=a) square(background);
}
/*///////////////////////////////////////////////////////
// Module: mirror_copy()
//
    Description:
        A custom mirror module that retains the original
        object in addition to the mirrored one.
    https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Create_a_mirrored_object_while_retaining_the_original
//
///////////////////////////////////////////////////////*/
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();
}
/*///////////////////////////////////////////////////////
// Module: line_up()
//
    Description:
        Translates the "child" objects along the [x, y, z] plane

    Parameter(s):
        v  ([x,y,z] = [0,0,0])
            v[0]    = X-axis
            v[1]    = Y-axis
            v[2]    = Z-axis
//
///////////////////////////////////////////////////////*/
module line_up(v) {
    x=(!is_undef(v[0])) ? v[0] : 0;
    y=(!is_undef(v[1])) ? v[1] : 0;
    z=(!is_undef(v[2])) ? v[2] : 0;
    for (i = [0 : 1 : $children-1])
        translate([x*i, y*i, z*i ]) children(i);
}
/*
/////////////////////////////////////////////////////////////////*/





/*#################################################################
## Section: Functions - Springs
*/
/*#######################################################
## Function: inside_diameter()
##
    Description:
        Inside Diameter (Di) is defined as the width of the inside of a coil spring's diameter measured from the center of the helix.
    Parameter(s):
        (Do,d | Do=,d=)
            Do  = Outer Diameter of Spring Coil is defined as the outside diameter of the spring coil winding.
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (D=,d=)
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters.
            d   = Diameter of spring wire is the diameter length of helical spring wire
    Formula(s):
        Di = Do-2*D;
        Di = D-d;
##
#######################################################*/
function inside_diameter(Do,d,  D) = (
    let(Di=(!is_undef(D)  && !is_undef(d)) ? D-d : Do-2*d)
    (!$VERBOSE)
    ?   Di
    :   let(reference = str("Di"))
        let(formula   = (!is_undef(D) && !is_undef(d)) ? str("D-d")   : str("Do-2*d"))
        let(equation  = (!is_undef(D) && !is_undef(d)) ? str(D,"-",d) : str(Do,"-",2,"*",d))
        echo(verbose(reference,formula,equation,Di))
        Di
);
function Di(Do,d,  D) = inside_diameter(Do,d,  D);
/*#######################################################
## Function: outside_diameter()
##
    Description:
        Outer Diameter (Do) of Spring Coil is the width of the spring measured from outside the coil.
    Parameter(s):
        (Di,d | Di=,d=)
            Di  = Inside Diameter is defined as the width of the inside of a coil spring's diameter measured from the center of the helix
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (D=,d=)
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters.
            d   = Diameter of spring wire is the diameter length of helical spring wire
    Formula(s):
        Di = Do+2*D;
        Di = D+d;
##
#######################################################*/
function outside_diameter(Di,d,  D) = (
    let(Do=(!is_undef(D)  && !is_undef(d)) ? D+d : Di+2*d)
    (!$VERBOSE)
    ?   Do
    :   let(reference = str("Do"))
        let(formula   = (!is_undef(D) && !is_undef(d)) ? str("D+d")   : str("Di+2*d"))
        let(equation  = (!is_undef(D) && !is_undef(d)) ? str(D,"+",d) : str(Di,"+",2,"*",d))
        echo(verbose(reference,formula,equation,Do))
        Do
);
function Do(Di,d,  D) = outside_diameter(Di,d,  D);
/*#######################################################
## Function: diameter()
##
    Description:
        Diameter of spring wire (d) is the diameter length of helical spring wire
    Parameter(s):
        (Do,Di|Do=,Di=)
            Do  = Outer Diameter of Spring Coil is defined as the outside diameter of the spring coil winding
            Di  = Inside Diameter is defined as the width of the inside of a coil spring's diameter measured from the center of the helix
    Formula(s):
        d = (Do-Di)/2;
    
##
#######################################################*/
function diameter(Do,Di) = (
    let(d=(Do-Di)/2)
    (!$VERBOSE)
    ?   d
    :   let(reference = "d")
        let(formula   = str("(Do-Di)/2"))
        let(equation  = str("(",Do,"-",Di,")","/",2))
        echo(verbose(reference,formula,equation,d))
        d
);
function d(Do,Di) = diameter(Do,Di);
/*#######################################################
## Function: mean_diameter()
##
    Description:
        Mean Coil Diameter (D) is defined as the average of the outer and inner coil diameters.
        
        In spring design, the Mean Coil Diameter is used more for calculating the rate and ultimate stress in the spring rather than for fit.
    Parameter(s):
        (Do,d|Do=,d=)
            Do  = Outer Diameter of Spring Coil is defined as the outside diameter of the spring coil winding
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (Di=,d=)
            Di  = Inside Diameter is defined as the width of the inside of a coil spring's diameter measured from the center of the helix
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (Do=,Di=)
            Do  = Outer Diameter of Spring Coil is defined as the outside diameter of the spring coil winding
            Di  = Inside Diameter is defined as the width of the inside of a coil spring's diameter measured from the center of the helix
        (d=,C=)
            d   = Diameter of spring wire is the diameter length of helical spring wire
            C   = Spring Index is defined as the ratio of Mean Coil Diameter of the spring to the diameter of the spring wire
    Formula(s):
        D = Do-d;
        D = Di+d;
        D = C/d;
        D = (Do+Di)/2;
##
#######################################################*/
function mean_diameter(Do,d,  Di,  C) = (
    let(D=
        (!is_undef(Do) && !is_undef(Di)) ? (Do+Di)/2        :
        (!is_undef(C)  && !is_undef(d))  ? C/d              :
        (!is_undef(Di) && !is_undef(d))  ? Di+d             :
                                           Do-d)
    (!$VERBOSE)
    ?   D
    :   let(reference = "D")
        let(formula   = 
            (!is_undef(Do) && !is_undef(Di)) ? str("(Do+Di)/2") :
            (!is_undef(C)  && !is_undef(d))  ? str("C/d")     :
            (!is_undef(Di) && !is_undef(d))  ? str("Di+d")
                                             : str("Do-d"))
        let(equation  = 
            (!is_undef(Do) && !is_undef(Di)) ? str("(",Do,"+",Di,")","/",2) :
            (!is_undef(C)  && !is_undef(d))  ? str(C,"/",d)         :
            (!is_undef(Di) && !is_undef(d))  ? str(Di,"+",d)
                                             : str(Do,"-",d))
        echo(verbose(reference,formula,equation,D))
        D
);
function D(Do,d,  Di,  C) = mean_diameter(Do,d,  Di,  C);
/*#######################################################
## Function: mean_radius()
##
    Description:
        Mean Coil Radius (R) is defined as the Mean Coil Diameter divided by 2
    Parameter(s):
        (D|D=)
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters
    Formula(s):
        R = D/2;
##
#######################################################*/
function mean_radius(D) = (
    let(R=D/2)
    (!$VERBOSE)
    ?   R
    :   let(reference = "R")
        let(formula   = str("D/2"))
        let(equation  = str(D,"/",2))
        echo(verbose(reference,formula,equation,R))
        R
);
function R(D) = mean_radius(D);
/*#######################################################
## Function: radius()
##
    Description:
        Radius of spring wire (r) is the radius length of helical spring wire
    Parameter(s):
        (d|d=)
            d   = Diameter of spring wire is the diameter length of helical spring wirefrom the center of the helix
    Formula(s):
        r = d/2;
    
##
#######################################################*/
function radius(d) = (
    let(r=d/2)
    (!$VERBOSE)
    ?   r
    :   let(reference = "r")
        let(formula   = str("d/2"))
        let(equation  = str(d,"/",2))
        echo(verbose(reference,formula,equation,r))
        r
);
function r(d) = radius(d);
/*#######################################################
## Function: spring_index()
##
    Description:
        C   = Spring Index (C) is defined as the ratio of Mean Coil Diameter of the spring to the diameter of the spring wire
        
        When designing a rectangular wire helical spring, it is preferable to set the Spring Index within the range of 4 to 12.
        Be careful as a decrease in the Spring Index leads to an increase in the local stress.
    Parameter(s):
        (D,d|D=,d=)
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters
            d   = Diameter of spring wire is the diameter length of helical spring wire
    Formula(s):
        C = D/d;
##
#######################################################*/
function spring_index(D,d) = (
    let(C=D/d)
    (!$VERBOSE)
    ?   C
    :   let(reference = "C")
        let(formula   = str("D/d"))
        let(equation  = str(D,"/",d))
        echo(verbose(reference,formula,equation,C))
        C
);
function C(D,d) = spring_index(D,d);
/*#######################################################
## Function: end_coils()
##
    Description:
        Ne      = Number of end/inert coils
    Parameter(s):
        (Form|Form=)
            Form    = ISO-2162-2-1993 Form Type (A-F)
        (Open|Closed)
            Open    = Boolean
            Closed  = Boolean
            Ground  = Boolean
##
#######################################################*/
function end_coils(Form,  Open,Closed, Ground) = (
    let(Open=(!is_undef(Closed))? !Closed   :
             (!is_undef(Open))  ? Open      : undef)
    let(Ground=(!is_undef(Ground)) ? Ground : undef)
    let(Form=(!is_undef(Form))  ? Form      :
             (Open && !Ground)  ? "A"       :
             (!Open && !Ground) ? "B"       :
             (Open && Ground)   ? "C"       :
             (!Open && Ground)  ? "D"       : undef)
    let(Ne=(Form == "A") ? 0 :
           (Form == "C") ? 1
                         : 2)
    (!$VERBOSE)
    ?   Ne
    :   let(reference = "Ne")
        let(formula   = str("#"))
        let(equation  = str(Ne))
        echo(verbose(reference,formula,equation,Ne))
        Ne
);
function Ne(Form,  Open,Closed, Ground) = end_coils(Form,  Open,Closed, Ground);
/*#######################################################
## Function: total_coils()
##
    Description:
        Nt      = Number of Total Coils
    Parameter(s):
        (Na,Ne|Na=,Ne=)
            Na      = Number of Active Coils
            Ne      = Number of End Coils
        (Na=,Form=)
            Form    = ISO-2162-2-1993 Form Type (A-F)
        (Open=|Closed=,Ground=)
            Open    = Boolean
            Closed  = Boolean
            Ground  = Boolean
    Formula(s):
        Nt = Na+Ne;
##
#######################################################*/
function total_coils(Na,Ne,  Form,  Open,Closed, Ground) = (
    let(Open=(!is_undef(Closed))? !Closed   :
             (!is_undef(Open))  ? Open      : undef)
    let(Ground=(!is_undef(Ground)) ? Ground : undef)
    let(Form=(!is_undef(Form))  ? Form      :
             (Open && !Ground)  ? "A"       :
             (!Open && !Ground) ? "B"       :
             (Open && Ground)   ? "C"       :
             (!Open && Ground)  ? "D"       : undef)
    let(Ne=(!is_undef(Ne))      ? Ne        : Ne(Form=Form))
    let(Nt=Na+Ne)
    (!$VERBOSE)
    ?   Nt
    :   let(reference = "Nt")
        let(formula   = str("Na+Ne"))
        let(equation  = str(Na,"+",Ne))
        echo(verbose(reference,formula,equation,Nt))
        Nt
);
function Nt(Na,Ne,  Form,  Open,Closed, Ground) = total_coils(Na,Ne,  Form,  Open,Closed, Ground);
/*#######################################################
## Function: pitch()
##
    Description:
        pitch      = Distance between coils
    Parameter(s):
        (L0,d,Na,Form|L0=,d=,Na=,Form=)
            L0      = Free Length (no load)
            d       = Diameter of spring wire is the diameter length of helical spring wire
            Na      = Number of Active Coils
            Form    = ISO-2162-2-1993 Form Type (A-F)
        (L0=,d=,Na=,Form=,Open=|Closed=,Ground=)
            L0      = Free Length (no load)
            d       = Diameter of spring wire is the diameter length of helical spring wire
            Na      = Number of Active Coils
            Open    = Boolean
            Closed  = Boolean
            Ground  = Boolean
    Formula(s):
        p = (L0-d)/Na;
        p = (L0-3*d)/Na;
        p = L0/(Na+1);
        p = (L0-2*d)/Na;
##
#######################################################*/
function pitch(L0,d,Na,  Form,  Open,Closed, Ground) = (
    let(Open=(!is_undef(Closed))? !Closed   :
             (!is_undef(Open))  ? Open      : undef)
    let(Ground=(!is_undef(Ground)) ? Ground : undef)
    let(Form=(!is_undef(Form))  ? Form      :
             (Open && !Ground)  ? "A"       :
             (!Open && !Ground) ? "B"       :
             (Open && Ground)   ? "C"       :
             (!Open && Ground)  ? "D"       : undef)
    let(p =(!is_undef(Ne))      ? Ne        :
           (Form == "A")        ? (L0-d)/Na :
           (Form == "B")        ? (L0-3*d)/Na :
           (Form == "C")        ? L0/(Na+1)
                                :(L0-2*d)/Na)
    (!$VERBOSE)
    ?   p
    :   let(reference = "p")
        let(arguments=[
            ((!is_undef(Form))  ? str("Form                         : ",Form) : ""),
            ((!is_undef(Open))  ? str("Open                         : ",Open) : ""),
            ((!is_undef(Ground))? str("Ground                       : ",Ground) : "")
        ])
        let(formula   = 
            (Form == "A")       ? str("(L0-d)/Na") :
            (Form == "B")       ? str("(L0-3*d)/Na") :
            (Form == "C")       ? str("L0/(Na+1)")
                                : str("(L0-2*d)/Na)"))
        let(equation  = 
            (Form == "A")       ? str("(",L0,"-",d,")/",Na) :
            (Form == "B")       ? str("(",L0,"-",3,"*",d,")/",Na) :
            (Form == "C")       ? str("",L0,"/(",Na,"+",1,")")
                                : str("(",L0,"-",2,"*",d,")/",Na,")"))
        echo(verbose(reference,formula,equation,p))
        p
);
function p(L0,d,Na,  Form,  Open,Closed, Ground) = pitch(L0,d,Na,  Form,  Open,Closed, Ground);
/*#######################################################
## Function: rise_angle()
##
    Description:
        Angular Deflection
    Parameter(s):
        (p,D|p=,D=)
            p   = Pitch
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters.
    Formula(s):
        a = atan(p/(PI*D);
##
#######################################################*/
function rise_angle(p,D) = (
    let(a=atan(p/(PI*D)))
    (!$VERBOSE)
    ?   a
    :   let(reference = "a")
        let(pi=get_symbol("PI",symbols))
        let(formula   = str("atan(p/(",pi,"*D)"))
        let(equation  = str("atan(",p,"/","(",pi,"*",D,")"))
        echo(verbose(reference,formula,equation,a))
        a
);
function a(p,D) = rise_angle(p,D);
/*#######################################################
## Function: free_length()
##
    Description:
        L0          = Free Length (no load)
    Parameter(s):
        (p,d,Na,Form|p=,d=,Na=,Form=)
            p       = Distance between coils
            d       = Diameter of spring wire is the diameter length of helical spring wire
            Na      = Number of Active Coils
            Form    = ISO-2162-2-1993 Form Type (A-F)
        (p=,d=,Na=,Form=,Open=|Closed=,Ground=)
            p       = Distance between coils
            d       = Diameter of spring wire is the diameter length of helical spring wire
            Na      = Number of Active Coils
            Open    = Boolean
            Closed  = Boolean
            Ground  = Boolean
    Formula(s):
##
#######################################################*/
function free_length(p,d,Na,  Form,  Open,Closed, Ground) = (
    let(Open=(!is_undef(Closed))? !Closed   :
             (!is_undef(Open))  ? Open      : undef)
    let(Ground=(!is_undef(Ground)) ? Ground : undef)
    let(Form=(!is_undef(Form))  ? Form      :
             (Open && !Ground)  ? "A"       :
             (!Open && !Ground) ? "B"       :
             (Open && Ground)   ? "C"       :
             (!Open && Ground)  ? "D"       : undef)
    let(L0=(!is_undef(Ne))      ? Ne        :
           (Form == "A")        ? p*Na+d    :
           (Form == "B")        ? p*Na+3*d  :
           (Form == "C")        ? P*(Na+1)
                                : P*Na+2*d)
    (!$VERBOSE)
    ?   L0
    :   let(reference = "L0")
        let(arguments=[
            ((!is_undef(Form)) ? str("Form                         : ",Form) : "" ),
            ((!is_undef(Open)) ? str("Open                         : ",Open) : "" ),
            ((!is_undef(Ground))? str("Ground                       : ",Ground) : "" )
        ])
        let(formula   = 
            (Form == "A")       ? str("p*Na+d") :
            (Form == "B")       ? str("p*Na+3*d") :
            (Form == "C")       ? str("p*(Na+1)")
                                : str("p*Na+2*d"))
        let(equation  = 
            (Form == "A")       ? str(p,"*",Na,"+",d) :
            (Form == "B")       ? str(p,"*",Na,"+",3,"*",d) :
            (Form == "C")       ? str(p,"*(",Na,"+",d,")")
                                : str(p,"*",Na,"+",2,"*",d))
        echo(verbose(reference,formula,equation,L0))
        L0
);
function L0(p,d,Na,  Form,  Open,Closed, Ground) = free_length(p,d,Na,  Form,  Open,Closed, Ground);
/*#######################################################
## Function: solid_length()
##
    Description:
        Ls          = Solid Length Length
    Parameter(s):
        (d=,Nt=,Form=,Open=|Closed=,Ground=)
            d       = Diameter of spring wire is the diameter length of helical spring wire
            Nt      = Number of Total Coils
            Form    = ISO-2162-2-1993 Form Type (A-F)
            Open    = Boolean
            Closed  = Boolean
            Ground  = Boolean
    Formula(s):
        Ls = d*Nt;
        Ls = d*(Nt+1);
##
#######################################################*/
function solid_length(d,Nt,  Form,  Open,Closed, Ground) = (
    let(Open=(!is_undef(Closed))? !Closed   :
             (!is_undef(Open))  ? Open      : undef)
    let(Ground=(!is_undef(Ground))  ? Ground :
               (!is_undef(Form) && (Form == "C" || Form == "D")) ? 1 : 0)
    let(Ls=(Ground) ? d*Nt : d*(Nt+1))
    (!$VERBOSE)
    ?   Ls
    :   let(reference = "Ls")
        let(arguments=[
            ((!is_undef(Form))  ? str("Form                         : ",Form) : "" ),
            ((!is_undef(Open))  ? str("Open                         : ",Open) : "" ),
            ((!is_undef(Ground))? str("Ground                       : ",Ground) : "" )
        ])
        let(formula   = (Ground)  ? str("d*Nt")   : str("d*(Nt+1)"))
        let(equation  = (Ground)  ? str(d,"*",Nt) : str(d,"*(",Nt,"+",1,")"))
        echo(verbose(reference,formula,equation,Ls))
        Ls
);
function Ls(d,Nt,  Form,  Open,Closed, Ground) = solid_length(d,Nt,  Form,  Open,Closed, Ground);
/*#######################################################
## Function: direct_shear_factor()
##
    Description:
        Kd  = Factor to account for Direct Shear Stress
        It is commonly recommended that Kd be used for modeling a spring under static loading only.
    Parameter(s):
        (C|C=)
            C   = Spring Index is defined as the ratio of Mean Coil Diameter of the spring to the diameter of the spring wire
        (D=,d=)    
            d   = Diameter of spring wire is the diameter length of helical spring wire
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters
    Formula(s):
        Kd=(2*C+1)/(2*C);
        Kd=(C+0.5)/C;
        Kd=1+(1/(2*C));
        Kd=1+((0.5)/C);
        
        Kd=1+(0.5*d/D);
        Kd=1+(d/2*D);        
##
#######################################################*/
function direct_shear_factor(C,  D,d) = (
    let(Kd=(!is_undef(D) && !is_undef(d)) ? 1+(d/2*D) : 1+(1/(2*C)))
    (!$VERBOSE)
    ?   Kd
    :   let(reference = "Kd")
        let(formula   = 
            (!is_undef(D)  && !is_undef(d))  ? str("1+(d/2*D)")
                                             : str("1+(1/(2*C)"))
        let(equation  =
            (!is_undef(D)  && !is_undef(d))  ? str(1,"+","(",d,"/",2,"*",D,")")
                                             : str(1,"+","(",1,"/","(",2,"*",C,")"))
        echo(verbose(reference,formula,equation,Kd))
        Kd
);
function Kd(C,  D,d) = direct_shear_factor(C,  D,d);
/*#######################################################
## Function: stress_factor()
##
    Description:
        K   =   Stress Factor
        In order to take into account the effect of direct shear (Kd) and change in coil curvature (Kc) a stress factor is defined K=Kd*Kc.
        It is commonly recommended that K be used for modeling fatigue.
    Parameter(s):
        (C|C=)
            C   = Spring Index is defined as the ratio of Mean Coil Diameter of the spring to the diameter of the spring wire
    Formula(s):
        *Recommended - Include shifted origin concept
        Kw  = Wahl[1929]            =   ((4*C-1)/(4*C-4))   + (0.615/C);
        Honegger[1930]              =   (C/(C-1))           + (0.615/C);
        *Kb = Bergstraesser[1933]   =   (C + 0.5)/(C-0.75);
        Sopwith[1942]               =   (C + 0.2)/(C-1);
        
        Not-Recommended - Does not include the shifted origin concept (high deviation)
        Rover[1913]                 =   (C/(C-1))           + (1/(4*C));
        Wood[1934]                  =   (C/(C-1))           + (1/(2*C));
##
#######################################################*/
//Recommended
function wahl_factor(C)                 = (
    let(Kw=((4*C-1)/(4*C-4))+(0.615)/C)
    (!$VERBOSE)
    ?   Kw
    :   let(reference = "Kw")
        let(formula   = str("((4*C -1)/(4*C-4)) + (0.615)/C)"))
        let(equation  = str("(","(",4,"*",C,"-",1,")","/","(",4,"*",C,"-",4,")",")","+","(",0.615,")","/",C))
        echo(verbose(reference,formula,equation,Kw))
        Kw
);
function Kw(C) = wahl_factor(C);
function bergstraesser_factor(C)        = (
    let(Kb=(C+0.5)/(C-0.75))
    (!$VERBOSE)
    ?   Kb
    :   let(reference = "Kb")
        let(formula   = str("(C+0.5)/(C-0.75)"))
        let(equation  = str("(",C,"+",0.5,")","/","(",C,"-",0.75,")"))
        echo(verbose(reference,formula,equation,Kb))
        Kb
);
function Kb(C) = bergstraesser_factor(C);
//Acceptable
function sopwith_factor(C)              = (C+0.2)/(C-1);
function honegger_factor(C)             = (C/(C-1))+(0.615/C);
//Not-Recommended
function rover_factor(C)                = (C/(C-1))+(1/(4*C));
function wood_factor(C)                 = (C/(C-1))+(1/(2*C));

//function stress_factor(C) = Kw(C);
function stress_factor(C) = Kb(C);
function K(C) = stress_factor(C);
/*#######################################################
## Function: spring_rate()
##
    Description:
        k                    = Spring Rate/Constant (stiffness)
        
        Spring rate, also known as spring constant, is the constant amount of force or spring rate of force it takes an extension or compression spring to travel one unit (inch or millimeter).

        It is a constant value which helps you calculate how much load you will need with a specific distance traveled and it will also help you calculate how much travel you will achieve with a certain load.
    Parameter(s):
        (d,G,C,Na|d=,G=,C=,Na=)
            d   = Diameter of spring wire is the diameter length of helical spring wire
            G   = Shear Modulus of Elasticity in Shear or Torsion
            C   = Spring Index is defined as the ratio of Mean Coil Diameter of the spring to the diameter of the spring wire
            Na  = Number of Active Coils
        (d=,G=,D=,Na=)
            d   = Diameter of spring wire is the diameter length of helical spring wire
            D   = Mean Coil Diameter is defined as the average of the outer and inner coil diameters
            Na  = Number of Active Coils
        (F=,x=)
            F   = Force is any interaction that, when unopposed, will change the motion of an object.
            x   = Distance/Deflection of Spring (Hooke’s Law)
    Formula(s):
        k=(d*G)/(8*pow(C,3)*Na);
        k=(G*pow(d,4))/(8*pow(D,3)*Na);
        k=F/x;    
##
#######################################################*/
function spring_rate(d,G,C,Na,  D,  F,x) = (
    let(k=
        (!is_undef(F)   && !is_undef(x)) ? F/x              :
        (!is_undef(D))                   ? (G*pow(d,4))/(8*pow(D,3)*Na)
                                         : (d*G)/(8*pow(C,3)*Na))
    (!$VERBOSE)
    ?   k
    :   let(reference = "k")
        let(formula   = 
            (!is_undef(F)   && !is_undef(x)) ? str("F/x")                   :
            (!is_undef(D))                   ? str("(G*d^4))/(8*D^3)*Na)")
                                             : str("(d*G)/(8*C^3)*Na)"))
        let(equation  =
            (!is_undef(F)   && !is_undef(x)) ? str(F,"/",x)                   :
            (!is_undef(D))                   ? str("(",G,"*",d,"^",4,")",")","/","(",8,"*",D,"^",3,"*",Na,")")
                                             : str("(",d,"*",G,")","/","(",8,"*",C,"^",3,")","*",Na,")"))
        echo(verbose(reference,formula,equation,k))
        k
);
function k(d,G,C,Na,  D,  F,x) = spring_rate(d,G,C,Na,  D,  F,x);
/*#######################################################
## Function: hooke_law()
##
    Description:
        Hooke's law is a law of physics that states that the force (F) needed to extend or compress a spring by some distance (x) scales linearly with respect to that distance.
    Parameter(s):
        (k,x|k=,x=)
            k   = Spring Rate/Constant
            x   = Distance/Deflection of Spring (Hooke’s Law)
    Formula(s):
        F=k*x;
##
#######################################################*/
function hooke_law(k,x) = k/x;
function F(k,x) = hooke_law(k,x);
/*#######################################################
## Function: polar_moment()
##
    Description:
        The polar moment (of inertia), also known as second (polar) moment of area
        Is a quantity used to describe resistance to torsional deformation (deflection)
    Parameter(s):
        (d|d=)
            d   = Diameter of spring wire is the diameter length of helical spring wire
    Formula(s):
        Iz=(PI*pow(d,4))/32;        // For Solid Circle
##
#######################################################*/
function polar_moment(d) = (
    let(Iz=(PI*pow(d,4))/32)
    (!$VERBOSE)
    ?   Iz
    :   let(reference = "Iz")
        let(pi=get_symbol("PI",symbols))
        let(formula   = str("(",pi,"*d^4)/32"))
        let(equation  = str("(",pi,"*",d,"^",4,")","/",32))
        echo(verbose(reference,formula,equation,Iz))
        Iz
);
function Iz(d) = polar_moment(d);
/*#######################################################
## Function: polar_section_modulus()
##
    Description:
        The polar section modules (also called section modulus of torsion), Zp,
        for cirucular sections may be found by dividing the polar moment of inertia, Iz,
        by the distance c from the center of gravity to the most remote fiber
    Parameter(s):
        (d|d=)
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (c=|r=)
            c|r = Cross-section of wire
    Formula(s):
        Zp=Iz/c;
        Zp=Iz/r;
        Zp=Iz/(d/2);
        Zp=(2*Iz)/d
            Iz=(PI*pow(d,4))/32;
        Zp=((2*(PI*pow(d,4)))/32)/d;
        Zp=((PI*pow(d,4))/16)/d;
        Zp=(PI*pow(d,3))/16;
##
#######################################################*/
function polar_section_modulus(d,  c,r,  Iz) = (
    let(d=(!is_undef(r)) ? r*2 :
          (!is_undef(c)) ? c*2 : d)
    let(Zp=(!is_undef(Iz)) ? Iz/(d/2) : (PI*pow(d,3))/16)
    (!$VERBOSE)
    ?   Zp
    :   let(reference = "Zp")
        let(pi=get_symbol("PI",symbols))
        let(formula   = 
            (!is_undef(Iz)) ? str("Iz/(d/2)")
                            : str("(",pi,"*d^3)/16"))
        let(equation  =
            (!is_undef(Iz)) ? str(Iz,"/","(",d,"/",2,")")
                            : str("(",pi,"*",d,"^",3,")","/",16))
        echo(verbose(reference,formula,equation,Zp))
        Zp
);
function Zp(d,  c,r,  Iz) = polar_section_modulus(d,  c,r,  Iz);
/*#######################################################
## Function: max_torsional_shear()
##
    Description:
        Maximum Torsional Stress accounts for the stress distribution across the wire cross section (c)
        For pure torssional stress, the shear stress is a maximum at the outer fiber of the wire and zero at the center of the wire        
    Parameter(s):
        (F,D,d|F=,D=,d=)
            F   = Force is any interaction that, when unopposed, will change the motion of an object.
            D   = Mean Coil Diameter
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (T=,c=|r=,Iz=)
            T   = Torque
            c|r = Cross-section of wire
            Iz  = Polar Moment of Inertia
        (T=,d=,Iz=)
            T   = Torque
            d   = Diameter of spring wire is the diameter length of helical spring wire
            Iz  = Polar Moment of Inertia
    Formula(s):
        Tt_max=(T*c)/Iz;
        Tt_max=(T*r)/Iz;
        Tt_max=(T*(d/2))/Iz;
        Tt_max=(T*d)/(2*Iz);
            Iz=(PI*pow(d,4))/32;
        Tt_max=(T*d)/(2*((PI*pow(d^4))/32));
        Tt_max=(32*T*d)/(2*PI*pow(d^4));
        Tt_max=(16*T*d)/(PI*pow(d,4));
        Tt_max=(16*T)/(PI*pow(d,3));
            T=R*F
        Tt_max=(16*R*F)/(PI*pow(d,3));
        Tt_max=(16*F*(D/2))/(PI*pow(d,3));
        Tt_max=(8*F*D)/(PI*pow(d,3));
##
#######################################################*/
function max_torsional_shear(F,D,d,  T,c,r, Iz) = (
    let(r=(!is_undef(d)) ? d/2 :
          (!is_undef(c)) ? c   : r)
    let(Tt_max=(!is_undef(Iz)) ? (T*r)/Iz  : (8*F*D)/(PI*pow(d,3)))
    (!$VERBOSE)
    ?   Tt_max
    :   let(reference = "Tt_max")
        let(pi=get_symbol("PI",symbols))
        let(formula   = 
            (!is_undef(Iz)) ? str("(T*r)/Iz")
                            : str("(8*F*D)/(",pi,"*d^3)"))
        let(equation  =
            (!is_undef(Iz)) ? str(T,"*",r,")","/",Iz)
                            : str("(",8,"*",F,"*",D,")","/","(",pi,"*",d,"^",3,")"))
        echo(verbose(reference,formula,equation,Tt_max))
        Tt_max
);
function Tt_max(F,D,d,  T,c,r, Iz) = max_torsional_shear(F,D,d,  T,c,r, Iz);
/*#######################################################
## Function: max_transverse_shear()
##
    Description:
        Maximum Transverse Stress accounts for the transverse (or direct) shear
    Parameter(s):
        (F,d|F=,d=)
            F   = Force is any interaction that, when unopposed, will change the motion of an object.
            d   = Diameter of spring wire is the diameter length of helical spring wire
        (F=,A=)
            F   = Force is any interaction that, when unopposed, will change the motion of an object.
            A   = The area of a circle is the space occupied by the circle in a two-dimensional plane.
    Formula(s):
        Td_max=F/A;
            A=PI*pow(d,2)/4;
        Td_max=F/(PI*pow(d,2)/4);
        Td_max=(4*F)/(PI*pow(d,2));
##
#######################################################*/
function max_transverse_shear(F,d,  A) = (
    let(Td_max=(!is_undef(F) && !is_undef(A)) ? F/A : (4*F)/(PI*pow(d,2)))
    (!$VERBOSE)
    ?   Tt_max
    :   let(reference = "Td_max")
        let(pi=get_symbol("PI",symbols))
        let(formula   = 
            (!is_undef(F) && !is_undef(A)) ? str("F/A")
                                           : str("(4*F)/(",pi,"*d^2)"))
        let(equation  =
            (!is_undef(F) && !is_undef(A)) ? str(F,"/",A)
                                           : str("(",4,"*",F,")","/","(",pi,"*",d,"^",2,")"))
        echo(verbose(reference,formula,equation,Td_max))
        Td_max
);
function Td_max(F,d,  A) = max_transverse_shear(F,d,  A);
/*#######################################################
## Function: max_shear_stress()
##
    Description:
        The maximum shearing stress is the sum of
            the direct shearing stress τt = F/A and
            the torsional shearing stress τd = Tc/Ix, with T = FR.
    Parameter(s):
        (F,D,d,K|F=,D=,d=,K=)
            F   = Force is any interaction that, when unopposed, will change the motion of an object.
            D   = Mean Coil Diameter
            d   = Diameter of spring wire is the diameter length of helical spring wire
            K   = Shear Correction Factor
        (K=,Tt_max=,Td_max=)
            K   = Shear Correction Factor
            Tt_max = Maximum Torsional Stress accounts for the stress distribution across the wire cross section
            Td_max = Maximum Transverse Stress accounts for the transverse (or direct) shear
    Formula(s):
        T_max=Tt_max + Td_max;
            Tt_max=(8*F*D)/(PI*pow(d,3))
            Td_max=(4*F)/(PI*pow(d,2)) = ((4*F)*(2*D*d))/((PI*pow(d,2))*(2*D*d)) = ((8*F*D)*d)/((PI*pow(d,3))*(2*D))
        T_max=((8*F*D)/(PI*pow(d,3))) + (((8*F*D)*d)/((PI*pow(d,3))*(2*D)));
        T_max=((8*F*D)/(PI*pow(d,3))) + (((8*F*D)*d)/((PI*pow(d,3))*(2*D)));
        T_max=((8*F*D)/(PI*pow(d,3)))*(1+(d/2*D));
        T_max=((8*F*D)/(PI*pow(d,3)))*(1+(0.5*d/D));
            C=D/d;
            Kd=1+(0.5/C) = 1+(0.5d/D);
        T_max=(Kd*(8*F*D)/(PI*pow(d,3)));
            K=Kd*Kc;        //Account for Curviture
        T_max=(K*(8*F*D)/(PI*pow(d,3)));    
##
#######################################################*/
function max_shear_stress(F,D,d,K,  Tt_max,Td_max) = (
    let(T_max=(!is_undef(Tt_max) && !is_undef(Td_max)) ? K*(Tt_max+Td_max) : K*(8*F*D)/(PI*pow(d,3)))
    (!$VERBOSE)
    ?   T_max
    :   let(reference = "T_max")
        let(pi=get_symbol("PI",symbols))
        let(formula   = 
            (!is_undef(Tt_max) && !is_undef(Td_max)) ? str("K*(Tt_max+Td_max)")
                                                     : str("K*(8*F*D)/(",pi,"*d^3)"))
        let(equation  =
            (!is_undef(Tt_max) && !is_undef(Td_max)) ? str(K,"*","(",Tt_max,"+",Td_max,")")
                                                     : str(K,"*","(",8,"*",F,"*",D,")","/","(",pi,"*",d,"^",3,")"))
        echo(verbose(reference,formula,equation,T_max))
        T_max
);
function T_max(F,D,d,K,  Tt_max,Td_max) = max_shear_stress(F,D,d,K,  Tt_max,Td_max);
/*#######################################################
## Function: shear_modulus()
##
    Description:
        G   = Shear Modulus of Elasticity in Shear or Torsion
        G=E/(2(1+v));
        
        Modulus of Elasticity is the measurement of stiffness and rigidity of spring material, or its elastic ability. The higher the value (modulus), the stiffer the material.
        
        This is the coefficient of stiffness for extension and compression springs.
    Parameter(s):
        E   = Modulus of Elasticity in Tension or Bending (Young’s Modulus)
        v   = Poisson’s Ratio
##
#######################################################*/
function shear_modulus(E,v) = (
    let(G=E/(2*(1+v)))
    (!$VERBOSE)
    ?   G
    :   let(reference = "G")
        let(formula   = str("E/(2*(1+v))"))
        let(equation  = str(E,"/","(",2,"*","(",1,"+",v,")",")"))
        echo(verbose(reference,formula,equation,G))
        G
);
function G(E,v) = shear_modulus(E,v);
/*#######################################################
## Function: tension_modulus()
##
    Description:
        E   = Modulus of Elasticity in Tension or Bending (Young’s Modulus)
        E=G*(2*(1+v));
        
        This is the coefficient of stiffness used for torsion and flat springs (Young's Modulus).
    Parameter(s):
        G   = Shear Modulus of Elasticity in Shear or Torsion
        v   = Poisson’s Ratio
##
#######################################################*/
function tension_modulus(G,v) = (
    let(E=G*(2*(1+v)))
    (!$VERBOSE)
    ?   E
    :   let(reference = "E")
        let(formula   = str("G*(2*(1+v))"))
        let(equation  = str(G,"*","(",2,"*","(",1,"+",v,")",")"))
        echo(verbose(reference,formula,equation,E))
        E
);
function E(G,v) = tension_modulus(G,v);
/*#######################################################
## Function: poisson_ratio()
##
    Description:
        v   = Poisson’s Ratio
        
        v=(E/(2*G))-1;
        Poisson's Ratio is the ratio of transverse strain to corresponding axial strain on a material 
    Parameter(s):
        E   = Modulus of Elasticity in Tension or Bending (Young’s Modulus)
        G   = Shear Modulus of Elasticity in Shear or Torsion
##
#######################################################*/
function poisson_ratio(E,G) = (
    let(v=(E/(2*G))-1)
    (!$VERBOSE)
    ?   v
    :   let(reference = "v")
        let(formula   = str("(E/(2*G))-1"))
        let(equation  = str("(",E,"/","(",2,"*",G,")",")","-",1))
        echo(verbose(reference,formula,equation,v))
        v
);
function v(E,G) = poisson_ratio(E,G);
/*
#################################################################*/





/*#################################################################
## Section: Functions - General Physics/Mechanics/Mathematics
*/
/*#######################################################
## Function: area_circle()
##
    Description:
        The area of a circle is the space occupied by the circle in a two-dimensional plane.
    Parameter(s):
        (r|r=)
            r   = Radius
        (d=)
            d   = Diameter
    Formula(s):
        A=PI*pow(r,2);
        A=PI*pow(d/2,2);
        A=PI*pow(d,2)/4;
##
#######################################################*/
function area_circle(r,  d) =
    (!is_undef(d)) ? (PI*pow(d,2))/4 : PI*pow(r,2);
function A(r,  d) = area_circle(r,  d);
/*#######################################################
## Function: torque()
##
    Description:
        In physics and mechanics, torque is the rotational equivalent of linear force.
        It is also referred to as the moment, moment of force, rotational force or turning effect, depending on the field of study.
        It represents the capability of a force to produce change in the rotational motion of the body. 
    Parameter(s):
        (r,F,a|r=,F=,a=)
            r   = Radius or position vector
            F   = Force
            a   = Angle between F and the lever arm
        (D=)
            d   = Diameter
    Formula(s):
        T=r*F;
        T=r*F*sin(a);
        T=(d/2)*F;
##
#######################################################*/
function torque(r,F,a,  d) = (
    let(a=(!is_undef(a))    ? sin(a) : 1)
    (!is_undef(d))
    ?   (d/2)*F*a
    :   r*F*a
);
function T(r,F,a,  d) = torque(r,F,a,  d);
/*#######################################################
## Function: round_float()
##
    Description:
        round floating-point number to the specified number of digits
    Parameter(s):
        number     (undef)      = Required. The number that you want to round.
        num_digits (undef)      = The "width" of the "top" of the profile on X-axis
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
*/
/* Example: Make sample object
##  echo(round_float(5.356,2));
##  echo(round_float([5.356,7.265626,4.97987979],4));
#######################################################*/
function round_float(number,num_digits,  i,v=[]) = (
    (!is_list(number))
    ?   (num_digits==0)?round(number):decimal_shift(round(decimal_shift(number,num_digits)),-(num_digits))
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i==0)
            ?   concat(round_float(number[i],num_digits),v)
            :   round_float(number,num_digits,  i-1,concat(round_float(number[i],num_digits),v))
);
/*
#################################################################*/





/*#################################################################
## Section: Functions - Conversions
*/
/*#######################################################
## Function: decimal_shift()
##
    Description:
        Shift decimal a specific number of digits
            <0 shifts "left"
            >0 shifts "right"
    Parameter(s):
        number     (undef)      = Required. The number that you want to round.
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
*/
/* Example: Make sample object
##
#######################################################*/
function decimal_shift(number,num_digits,  i,v=[]) =
    (!is_list(number))
    ?   (num_digits==0)?number:(number*pow(10,num_digits))/pow(10,num_digits)
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i==0)
        ?   concat(decimal_shift(number[i],num_digits),v)
        :   decimal_shift(number,num_digits,  i-1,concat(decimal_shift(number[i],num_digits),v));
/*#######################################################
## Function: misc metric conversions()
##
    Description:
        Use decimal_shift to quickly shift metric values.
        (base 10) means that each successive unit is 10 times larger than the previous one
    Parameter(s):
        number     (undef)      = Required. The number that you want to round.
*/
/* Example: Make sample object
##
#######################################################*/
function mm2m(number) = decimal_shift(number, -3);
function m2mm(number) = decimal_shift(number, +3);
function cm2m(number) = decimal_shift(number, -2);
function m2cm(number) = decimal_shift(number, +2);
/*#######################################################
## Function: in2mm()
##
    Description:
        Convert number from Imperial-inches to Metric-millimeters (number*25.4)
    Parameter(s):
        number     (undef)      = Required. The number that you want to convert
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
##
#######################################################*/
function in2mm(number, i,v=[]) =
    (!is_list(number))
    ?   number*25.4
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i<0)
        ?   v
        :   in2mm(number,i-1,concat(in2mm(number[i]),v));
/*#######################################################
## Function: mm2in()
##
    Description:
        Convert number from Metric-millimeters to Imperial-inches (number*(1/25.4))
        Additional 
    Parameter(s):
        number     (undef)      = Required. The number that you want to convert
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
        round  (true)           = Boolean variable to apply rounding factor to converted number
*/
/* Examples:
##  echo(mm2in(diameter_metric));
##  echo(mm2in(diameter_metric, round=false));
#######################################################*/
function mm2in(number, i,v=[], round) =
    let(round=(!is_undef(round))?round:true)
    (!is_list(number))
    ?   let(in=number*(1/25.4))
        (round)
        ?   in
        :   (number>2)      ? round_float(in,3)
        :   (number>0.25)   ? round_float(in,4)
        :   round_float(in,5)
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i<0)
        ?   v
        :   mm2in(number,i-1,concat(mm2in(number[i],round=round),v),round=round);
/*#######################################################
## Function: psi2pascal()
##
    Description:
        Convert pound per square inch (psi) to pascal.
        Pa=psi*6894.75729;
        
        The pascal is the SI unit of pressure. It is defined as one newton per square meter.
        The commonly used multiple units of the pascal are:
            hectopascal (1 hPa ≡ 100 Pa)
            kilopascal (1 kPa ≡ 1000 Pa)
            megapascal (1 MPa ≡ 1,000,000 Pa).
    Parameter(s):
        number     (undef)      = Required. The number that you want to convert
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
##
#######################################################*/
function psi2pascal(number, i,v=[]) =
    (!is_list(number))
    ?   number*6894.75729
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i<0)
        ?   v
        :   psi2pascal(number,i-1,concat(psi2pascal(number[i]),v));
/*#######################################################
## Function: pascal2psi()
##
    Description:
        Convert pascal to pound per square inch (psi)
        psi=pa/6894.75729;
    Parameter(s):
        number     (undef)      = Required. The number that you want to convert
    *Recursion Parameters
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
##
#######################################################*/
function pascal2psi(number, i,v=[]) =
    (!is_list(number))
    ?   number/6894.75729
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i<0)
        ?   v
        :   pascal2psi(number,i-1,concat(pascal2psi(number[i]),v));
//example Nm^-1x(1lbfin^-1/175.13Nm^-1)=answer lb/in-
// Pa = N/(m^2) = kg*m^(-1)*s^(-2)
// N = kg*m/s^2 = kg*m*s^(-2)
// N/m = kg*s^-2
// Nm=J/rad=m^2*kg*s^-1
// kg/m^3 = m^(-3)*kg
/*
#################################################################*/





/*#######################################################
## Function: get_hex_digit()
##
    Description:
        Returns Hexidecimal Value from "string" character
    Parameter(s):
        (char)
            char  = string based character representation
##
#######################################################*/
function get_hex_digit(char="") = (
    (len(char) != 1)
    ? undef
    : char[0] == "-" ? -1 :
      char[0] == "0" ?  0 :
      char[0] == "1" ?  1 :
      char[0] == "2" ?  2 :
      char[0] == "3" ?  3 :
      char[0] == "4" ?  4 :
      char[0] == "5" ?  5 :
      char[0] == "6" ?  6 :
      char[0] == "7" ?  7 :
      char[0] == "8" ?  8 :
      char[0] == "9" ?  9 :
    
      char[0] == "a" ? 10 :
      char[0] == "b" ? 11 :
      char[0] == "c" ? 12 :
      char[0] == "d" ? 13 :
      char[0] == "e" ? 14 :
      char[0] == "f" ? 15 :
      (0/0) // 0/0=nan
);
/*
#################################################################*/





/*#################################################################
## Section: Functions - List/Array/Vectors
*/
/*#######################################################
## Function: flatten()
##
    Description:
        "Flatten" nested list
    Parameter(s):
        (v)
            v  = Nested List
##
#######################################################*/
function flatten(v) = (
    [ for (outer = v)          // Process Outer List
      for (inner = outer) inner ]   // Process Inner List
);
/*#######################################################
## Function: quicksort()
##
    Description:
        Sort a list of numbers by value
    Parameter(s):
        (v)
            v  = List of numbers
##
#######################################################*/
function quicksort(v) = (
    !(len(v)>0)
    ?   []
    :   let(
            pivot   = v[floor(len(v)/2)],
            lesser  = [ for (y = v) if (y  < pivot) y ],
            equal   = [ for (y = v) if (y == pivot) y ],
            greater = [ for (y = v) if (y  > pivot) y ]
        )
        concat(quicksort(lesser), equal, quicksort(greater))
);
/*
#################################################################*/





/*#################################################################
## Section: Functions - VERBOSE/Console Helpers
*/
/*#######################################################
## Function: verbose()
##
    Description:
        Helper function to format a larger block of VERBOSE output to the console
    Parameter(s):
        (array|array=)
            array   = Vector containing the common self-documenting function/module components
            array[0]= Title of Function/Module
            array[1]= Vector of input parameter/arguments
            
            fx=true
            array[2]= String representation of function formula with variables
            array[3]= String representation of function formula with arguments
            array[4]= Return value of function
            
            mod     = Boolean to differentiate between "function" and "module"
            fx      = Boolean to differentiate between "function" and "module"
##
#######################################################*/
function verbose(reference,formula,equation,solution, fx=true,mod) = (
    let(fx=(!is_undef(mod)) ? !mod : fx)
    let(symbol=str(get_symbol(reference,symbols)))
    let(equals=" = ")
    ($VERBOSE==1)
    ?   str(symbol,equals,formula,equals,equation,equals,solution)
    :   ($VERBOSE==2)
        ?   let(prefix=(fx)?pad("",5,"#"):pad("",5,"/"))    // len("ECHO:") = 5
            let(tab="\t")
            let(indent=pad("",4))
            let(substitution="Substituting Argument(s) in Formula:")
                    
            let(description=str(get_description(reference,symbols)))
            let(title=(!is_undef($parent_modules))? str(description," ==> ","[",stack(verbose=$VERBOSE-1),"]"): str(description))
            let(output=str(
                        title,"\n",
                        ((fx)? str(prefix,tab,substitution,"\n"):""),
                        ((fx)? str(prefix,tab,indent,symbol,equals,formula ,"\n"):""),
                        ((fx)? str(prefix,tab,indent,symbol,equals,equation,"\n"):""),
                        ((fx)? str(prefix,tab,indent,symbol,equals,solution)     :"")))
            output
        : formula2equation(formula)           // Helper to build "equation" string in functions
);
/*#######################################################
## Function: get_symbol()
##
    Description:
        Helper function to retrieve the preferred display symbol provided a reference and array to parse
        
        Searches the first index position of "symbols" for "reference"
        Parses the second index based upon "delimiter" and return the first matching value as the return "symbol"
    Parameter(s):
        (reference,symbols, delimiter)
            reference   = String of characters to be used in searching the symbols array components
            symobols    = Two-Dimensional array containing common symbol data
            delimiter   = String delimiter separating multiple symbol aliases
##
#######################################################*/
function get_symbol(reference, symbols, delimiter) = (
    let(delimiter=(!is_undef(delimiter)) ? delimiter : "|")
    let(index=search([reference],symbols, num_returns_per_match=1)[0])
    (index==[])
    ?   undef
    :   let(aliases=symbols[index][1])
        let(length=(search(delimiter,aliases, num_returns_per_match=1)[0]))
        (!is_undef(length))
        ?   substring(aliases,0,length)
        :   aliases
);
/*#######################################################
## Function: get_description()
##
    Description:
        Helper function to retrieve the preferred display description provided a reference and array to parse
        
        Searches the first index position of "symbols" for "reference"
        Parses the third index based upon "delimiter" and return the first matching value as the return "symbol"
    Parameter(s):
        (reference,symbols, delimiter)
            reference   = String of characters to be used in searching the symbols array components
            symobols    = Two-Dimensional array containing common symbol data
            delimiter   = String delimiter separating multiple symbol aliases
##
#######################################################*/
function get_description(reference, symbols) = (
    let(index=search([reference],symbols, num_returns_per_match=1)[0])
    (index==[])
    ?   undef
    :   let(description=symbols[index][2])
        (!is_undef(description))
        ?   str(description," ","(",reference,")")
        :   ""
);
/*#######################################################
## Function: stack()
##
    Description:
        Helper function to construct a pseudo call stack
    Parameter(s):
        ()
##
#######################################################*/
function stack(idx, verbose=$VERBOSE) = (
    (is_undef($parent_modules))
    ?   "<top-level>"
    :   let(idx=(!is_undef(idx))?idx:$parent_modules-1)
        let(call=str(idx,"-",parent_module(idx),"()"))
        let(separator=(verbose==1) ? "" : "\n\t")
        (idx > 0)
        ?   str(call," : ",separator,stack(idx - 1))
        :   call
);
/*#######################################################
## Function: formula2equation()
##
    Description:
        Helper function to construct an "equation" output string.
        This can be used to save time in building the equation from an existing "formula" string
    Parameter(s):
        formula     = String representation of a formula
    *Recursion Parameters
        i      (len(v-1)   = Index variable to faciliate tail recursion
        v                  = v which contains the known PEMDAS characters
##
#######################################################*/
function formula2equation(formula,  i, v) = (
    let(PEMDAS=str("(",")","^","*","/","+","-"))
    let(v=(!is_undef(v)) ? v : quicksort(flatten(search(PEMDAS,formula,0))))
    let(i=(!is_undef(i)) ? i : len(v)-1)
    (i<0)
    ?   str("\nstr(",formula,")\n")
    :   let(comma=((v[i]+1)==(v[i+1])) ? "" : (is_undef(v[i+1])) ? "" : ",")
        formula2equation(str(
            substring(formula,0,v[i]),
            ((v[i]!=0)?",":""),"\"",formula[v[i]],"\"",comma,
            substring(formula,v[i]+1,len(formula)-1-v[i])),i-1,v
        )
);
/*
#################################################################*/





/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%% Appendices
*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ Appendix - Variable/Symbols
@@
    Description:
        List of Variables and Symbols which may be referenced
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
symbols=[
//  [<refernce>,<symbol|alias>,     <description>,                                          <units>],
    ["A",       "A",                "Cross-sectional Area",                                 "m^2"],
    ["a",       "θ|theta",          "Angular Deflection",                                   "rad"],
    ["C",       "C",                "Spring Index",                                         ""],
    ["c",       "r",                "Radius of Cross-Section",                              "m"],
    ["D",       "D",                "Mean Coil Diameter",                                   "m"],
    ["Do",      "De|D_outer",       "Outside Diameter",                                     "m"],
    ["Di",      "Di|D_inner",       "Inside Diameter",                                      "m"],
    ["d",       "d",                "Wire Diameter",                                        "m"],
    ["E",       "E",                "Modulus of Elasticity (Young's Modulus)",              "Pa"],
    ["F",       "P",                "Force",                                                "N"],
    ["Fm",      "Fm|Fmax",          "Max Force",                                            "N"],
    ["G",       "G",                "Shear Modulus of Elasticity",                          "Pa"],
    ["g",       "g",                "Gravitational Acceleration",                           "m/(s^2)"],
    ["h",       "h",                "Height",                                               "m"],
    ["I",       "I",                "Second Moment of Area (Area Moment of Inertia)",       "m^4"],
    ["Iz",      "Iz|J",             "Polar Moment of Inertia|Second (Polar) Moment of Area","m^4"],
    ["K",       "K",                "Shear Correction Factor",                              ""],
    ["Kb",      "Kb",               "Bergsträsser Factor",                                  ""],
    ["Kc",      "Kc",               "Curviture Shear Factor",                               ""],
    ["Kd",      "Kd|Ks",            "Transverse (Direct) Shear Factor",                     ""],
    ["Ki",      "Ki",               "Spring Stress Concentration Factor",                   ""],
    ["Kw",      "Kw",               "Wahl Factor",                                          ""],
    ["k",       "k",                "Spring Rate/Constant",                                 "N/m"],
    ["kt",      "kt",               "Spring Rate/Constant considering torsional loading",   "N/m"],
    ["ka",      "ka",               "Angular Spring Rate",                                  "Nm/rev"],
    ["L",       "L0|Lf|L_free",     "Free Length (no load)",                                "m"],
    ["Ls",      "Ls|L_solid",       "Shut height or Solid Length",                          "m"],
    ["La",      "La|L_after|L_pre", "Installed Length (preload) | Length After",            "m"],
    ["Lo",      "Lo|L_operate",     "Operating Length",                                     "m"],
    ["Lm",      "Lm|Lmax",          "Operating Length (Max working load) Load max",         "m"],
    ["l",       "l",                "Length",                                               "m"],
    ["M",       "M",                "Moment",                                               "N-m"],
    ["m",       "m",                "Slope",                                                ""],
    ["N",       "N",                "Number of Coils",                                      ""],
    ["Na",      "Na|N_active",      "Number of Active Coils",                               ""],
    ["Ne",      "Ne|N_end",         "Number of End Coils",                                  ""],
    ["Nt",      "Nt|N_total",       "Number of Total Coils",                                ""],
    ["p",       "p",                "Pitch",                                                "m"],
    ["PI",      "π|pi",             "Mathematical Constant ~ 3.14159",                      ""],
    ["R",       "R",                "Mean Coil Radius",                                     "m"],
    ["r",       "r",                "Radius of Wire",                                       "m"],
    ["Rd",      "Rd",               "Diameter Ratio",                                       ""],
    ["Ssu",     "Ssu",              "Shear Ultimate Strength",                              "Pa"],
    ["Ssy",     "Ssy",              "Shear Yield Strength",                                 "Pa"],
    ["Sy",      "Sy",               "Yield Stress",                                         "Pa"],
    ["Sut",     "Sut",              "Tensile Ultimate Stress",                              "Pa"],
    ["T",       "τ|tau",            "Torque",                                               "N-m"],
    ["T_max",   "τ,max",            "Maximum Shear Stress",                                 "N/m^2"],
    ["Td_max",  "τd,max",           "Maximum Transverse Shear Stress",                      "N/m^2"],
    ["Tt_max",  "τt,max",           "Maximum Torsional Shear Stress",                       "N/m^2"],
    ["tm",      "tm",               "Temperature",                                          "K"],
    ["x",       "δ|delta",          "Deflection",                                           "m"],
    ["v",       "ν|nu",             "Poisson's Ratio",                                      ""],
    ["rho",     "ρ|rho",            "Density",                                              "kg/m^3"],
    ["s",       "σ|sigma",          "Stress",                                               "Pa"],
    ["t",       "τ|tau",            "Shear Stress",                                         "Pa"],
    ["Zp",      "Zp",               "Polar Modulus",                                        "m^4"]
    ];
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ Appendix - Force
@@
    Description:
        List of parameters/arguments which impact Force
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
force_chart=[["More Force (MF)",["Smaller (Od)","Less Coils (Na)","Thicker Wire (d)","More Travel (Ld)"]],
             ["Less Force (LF)",["Larger (Od)" ,"More Coils (Na)","Thinner Wire (d)","Less Travel (Ld)"]]];
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ Appendix - Tensile Strength
@@
    Description:
        Sut = Minimum tensile strength of material (Wire Strength)
        A   = A kpsi/Mpa
        m   = Exponent
        
        Since helical springs experience shear stress, shear yield strength is needed.
-- If actual data is not available, estimate from tensile strength
-- Assume yield strength is between 60-90% of tensile strength
        0.6*Sut<= Ssy<=0.9*Sut
-- Assume the distortion energy theory can be employed to relate the shear strength to the normal strength.
        Ssy = 0.577*Sy
-- This results in
        0.35*Sut<=Ssy<=0.52*Sut
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*
Materia             ASTM    A in kpsi   A in Mpa    m
music wire          A228    186         2060        0.163
oil-temtered wire   A229    146         1610        0.193
hard-drawn wire     A227    137         1510        0.201
chrome vanadium     A232    173         1790        0.155
chrome silicon      A401    218         1960        ksi 0.091


Shigley’s Mechanical Engineering Design Table 10.4
                    Size range                   Exponent   Constant,Ap
Material             in.             mm          m           ksi MPa
Music wire           0.004-0.250     0.10-6.5    0.146       196 2170
Oil-tempered wire    0.020-0.500     0.50-12     0.186       149 1880
Hard-drawn wire      0.028-0.500     0.70-12     0.192       136 1750
Chromium vanadium    0.032-0.437     0.80-12     0.167       169 2000
Chromium silicone    0.063-0.375     1.6-10      0.112       202 2000
302 stainless steel  0.013-0.10      0.33-2.5    0.146       169 1867
                     0.10-0.20       2.5-5       0.263       128 2065
                     0.20-0.4        05-10       0.478       90  2911
Phosphor-bronze      0.004-0.022     0.1-0.6     0           145 1000
                     0.022-0.075     0.6-2       0.028       121 913
                     0.075-0.30      2-7.5       0.064       110 932
Table  17.2:    Coefficients  used  in  Eq.  (17.2)  for  selected  spring  materials.
Fundamentals of Machine Elements, 3rd ed. Schmid, Hamrock and Jacobson
*/


// Common Wire Diameter (metric)
A228_common_wire_diameter= [0.100,0.200,0.300,0.400,0.610,0.810,
                            1.00,1.30,1.60,
                            2.00,2.54,
                            3.18,3.56,3.81,
                            4.50,
                            5.26,
                            6.35];
//mechanical_design_peter_r_n_childs
//Table 11.4
/*Preferred wire diameters
Diameter    Diameter    Diameter    Diameter
(in)        (mm)        (in)        (mm)
0.004       0.10        0.081       2.00
0.005       0.12        0.085       2.20
0.006       0.16        0.092       
0.008       0.20        0.098       2.50
0.010       0.25        0.105
0.012       0.30        0.112       2.80
0.014       0.35        0.125       3.00
0.016       0.40       0.135       3.50
0.018       0.45       0.148
0.020       0.50       0.162       4.00
0.022       0.55       0.177       4.50
0.024       0.60       0.192       5.00
0.026       0.65       0.207       5.50
0.028       0.70       0.225       6.00
0.030       0.80       0.250       6.50
0.035       0.90       0.281       7.00
0.038       1.00       0.312       8.00
0.042       1.10       0.343       9.00
0.045                   0.362
0.048       1.20       0.375
0.051                   0.406       10.0
0.055       1.40        0.437       11.0
0.059                   0.469       12.0
0.063       1.60        0.500       13.0
0.067                   0.531       14.0
0.072       1.80        0.562       15.0
0.076                   0.625       16.0
*/
/*
                            ElasticShearDensity,Maximummodulus,modulus,Ε,serviceE,G,kg/m3   temperature,
High-carbon steels
    Music wire(ASTMA228)            207(30.0)   79.3(11.5)  7840(0.283) 120(248)
    Hard drawn(ASTMA227)            207(30.0)   79.3(11.5)  7840(0.283) 120(248)
Stainless steels
    Martensitic(AISI410,420)        200(29.0)   75.8(11.0)  7750(0.280) 250(482)
    Austenitic(AISI301,302)         193(28.0)   68.9(9.99)  7840(0.283) 315(600)
Copper­based alloys
    Spring brass(ASTMB134)          110(15.9)   41.4(6.00)  8520(0.308) 90(194)
    Phosphor bronze(ASTMB159)       103(14.9)   43.4(6.29)  8860(0.320) 90(194)
    Beryllium copper(ASTMB197)      131(19.0)   44.8(6.50)  8220(0.297) 200(392)
Nickel-­based alloys 
    Inconnel 600                    214(31.0)   75.8(11.0)  8500(0.307) 315(600)
    InconelX-750                    214(31.0)   75.8(11.0)  8250(0.298) 600(1110)
    Ni-Span C-0                     186(27.0)   66.2(9.60)  3140(0.294) 90(194)
Table 17.1 Typical properties of common spring materials. Source: Adapted from Relvas [1996]
Fundamentals of Machine Elements, 3rd ed. Schmid, Hamrock and Jacobson (pg 494)


mechanical_design_peter_r_n_childs
Selected data reproduced from Joerres,1996
Table 11.3
Typical properties of common spring materials
                                Young’s             Modulus of          Density         Maximum service
                                modulus (GPa)       rigidity (GPa)      (kg/m)          temperature (°C)
Material
Music wire                      207                 79.3                7860            120
Hard drawn wire                 207                 79.3                7860            150
Oil tempered                    207                 79.3                7860            150
Valve spring                    207                 79.3                7860            150
Chrome vanadium alloy steel wire 207                79.3                7860            220
Chrome silicon alloy steel wire 207                 79.3                7860            245
302 stainless steel             193                 69                  7920            260
17-7 PH stainless steel         203                 75.8                7810            315
Phosphor bronze (A)             103                 43.4                8860            95
Silicon bronze (A)              103                 38.6                8530            95
Silicon bronze (B)              117                 44.1                8750            95
Beryllium copper                128                 48.3                8260            205
Inconel 600                     214                 75.8                8430            320
Inconel X750                    214                 79.3                8250            595
AISI 1050                       207                 79.3                7860            95
AISI 1065                       207                 79.3                7860            95
AISI 1074                       207                 79.3                7860            120
AISI 1095                       207                 79.3                7860            120

*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ Appendix - Common Wire Materials
@@
    Description:
        material=[<"designation">,<"common name">,
                  E[psi*10^6,MPa*10^3],G[psi*10^6,MPa*10^3]];
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
// High Carbon Spring Wire
A227=[["ASTM A227","Hard Drawn",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A228=[["ASTM A228","Music Wire",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A229=[["ASTM A229","Oil Tempered",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A230=[["ASTM A230","Carbon Valve",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A679=[["ASTM A679","High Tensile Hard Drawn",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
high_carbon=[["High Carbon",concat(A227,A228,A229,A230,A679)]];

// Carbon & Alloy-Specialty Spring Grade
GradeA=[["ASTM A1000","Grade A Chrome Silicon",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
GradeB=[["ASTM A1000","Grade B Carbon",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
GradeC=[["ASTM A1000","Grade C Chrome Vanadium",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
GradeD=[["ASTM A1000","Grade D Chrome Vanadium",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
specialty=[["Carbon & Alloy Specialty",concat(GradeA,GradeB,GradeC,GradeD)]];

// Alloy Steel Wire
A231=[["ASTM A231","Chrome Vanadium",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A232=[["ASTM A232","Chrome Vanadium Valve",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A401=[["ASTM A401","Chrome Silicon",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A877=[["ASTM A877","Chrome Silicon Valve",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
A878=[["ASTM A313","Chrome Vanadium Valve Modified",
      [30*pow(10,6),207*pow(10,3)], [11.5*pow(10,6),79.3*pow(10,3)]]];
alloy=[["Alloy Steel Wire",concat(A231,A232,A401,A877,A878)]];

// Stainless Steel Wire
AISI_302_304=[["ASTM A313","302/304",
      [28*pow(10,6),193*pow(10,3)], [10*pow(10,6),69.0*pow(10,3)]]];
AISI_316=[["ASTM A313","302/304",
      [28*pow(10,6),193*pow(10,3)], [10*pow(10,6),69.0*pow(10,3)]]];
17_7_PH=[["ASTM A303","302/304",
      [29.5*pow(10,6),203*pow(10,3)], [11*pow(10,6),75.8*pow(10,3)]]];
stainless=[["Stainless Steel Wire",concat(AISI_302_304,AISI_316,17_7_PH)]];

// Non-Ferrous Alloy Wire
B159=[["ASTM B159","Phosphor Bronze Grade A",
      [15*pow(10,6),103*pow(10,3)], [6.25*pow(10,6),43.1*pow(10,3)]]];
B197=[["ASTM B197","Beryllium Copper",
      [18.5*pow(10,6),129*pow(10,3)], [7.0*pow(10,6),48.3*pow(10,3)]]];
Monel400=[["AMS 7233","Monel 400",
      [26*pow(10,6),179*pow(10,3)], [9.5*pow(10,6),65.5*pow(10,3)]]];
MonelK500=[["","Monel K 500",
      [26*pow(10,6),179*pow(10,3)], [9.5*pow(10,6),65.5*pow(10,3)]]];
nonferrous=[["Non-Ferrous Alloy Wire",concat(B159,B197,Monel400,MonelK500)]];

// High Temperature Alloy Wire
A286=[["A286","A286 Alloy",
      [29*pow(10,6),200*pow(10,3)], [10.4*pow(10,6),71.7*pow(10,3)]]];
Inconel600=[["","Inconel 600",
      [31*pow(10,6),214*pow(10,3)], [11.0*pow(10,6),75.0*pow(10,3)]]];
Inconel718=[["","Inconel 718",
      [29*pow(10,6),200*pow(10,3)], [11.2*pow(10,6),77.2*pow(10,3)]]];
Inconelx750=[["","Inconel x750",
      [31*pow(10,6),214*pow(10,3)], [12.0*pow(10,6),82.7*pow(10,3)]]];
hightemp_alloy=[["High Temperature Alloy Wire",concat(A286,Inconel600,Inconel718,Inconelx750)]];
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@ Appendix - Spring Ends
@@
    Description:
        ISO 2162-2:1993 - https://www.iso.org/standard/6954.html?browse=tc
        Form, Execution, Ne, Nt, L0, Ls, P
    Fundamentals of Machine Elements, Third Edition (SI Version)
    page 498, Table 17.3
                        A=Plain      C=Plain+Ground  B=Squard|Closed D=Squared+Ground
    End coils,Ne        0           1               2               2
    Total coils, Nt     Na          Na+1            Na+2            Na+2
    Free length, L0     pNa+d       p(Na+1)         pNa+3d          pNa+2d
    Solid length, Ls    d(Nt + 1)   dNt             d(Nt + 1)       dNt
    Pitch, p            (L0-d)/Na   L0/Na+1)        (L0-3d)/Na     (L0-2d)/Na
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
spring_ends = [["A","Open|Plain"    ,"Not Ground"],
               ["B","Closed|Squared","Not Ground"],
               ["C","Open|Plain"    ,"Ground"],
               ["D","Closed|Squared","Ground"],
               ["E","Closed|Squared","Pigtail"],
               ["F","Closed|Squared","Bent to Center"]];
/*
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/