// Prototype ProEM 512 mount for Metric 25mm pitch M6 breadboard
// for 3D printer 

width = 190;    //x
depth = 127;    //y
thick = 10;     //z
c_r = 5;       //corner radius

module socket_cap_hole (inner, outer, atx, aty, zthick, cap)
{
    translate([atx, aty, 0]) cylinder(r=inner, h=zthick, $fn=50);
    translate([atx, aty, zthick-cap]) cylinder(r=outer, h=cap, $fn=50);
}

module 8_32_cap_hole (atx, aty, zthick)
{
    8_32_cap_diam = 8;
    8_32_cap_thick = 5;
    8_32_clearance = 5;
    socket_cap_hole (8_32_clearance / 2, 8_32_cap_diam / 2, atx, aty, zthick, 8_32_cap_thick);
}    
 
module M6_cap_hole (atx, aty, zthick)
{
    M6_clearance = 7;
    M6_cap_thick = 6;
    M6_cap_diam = 12;
    socket_cap_hole (M6_clearance / 2, M6_cap_diam / 2, atx, aty, zthick, M6_cap_thick);
}

module rounded_slab (width, depth, c_r, thick)
{
    translate([c_r,0,0]) cube([width-2*c_r, depth, thick]);
    translate([0,c_r,0]) cube([width, depth-2*c_r, thick]);   
    translate([c_r,c_r,0]) cylinder(r=c_r, h=thick, $fn=50);
    translate([width - c_r,c_r,0]) cylinder(r=c_r, h=thick, $fn=50);
    translate([c_r, depth - c_r,0]) cylinder(r=c_r, h=thick, $fn=50);
    translate([width-c_r, depth-c_r, 0]) cylinder(r=c_r, h=thick, $fn=50);    
}

difference() 
{
    union()
    {
        difference()
        {
            //frame with central cut-outs
            rounded_slab(width, depth, c_r, thick/2);
            translate([18,32,0])   rounded_slab(72, 68, c_r, thick/2);
            translate([100,32,0])   rounded_slab(72, 68, c_r, thick/2);    

            //negative beams
            translate([5,35,3])   rounded_slab(8, 60, 2, 2); 
            translate([width-13,35,3])   rounded_slab(8, 60, 2, 2);
        
        
            //signature  
            translate([97,35,3]) 
                linear_extrude(height = 2) 
                {
                    rotate ([0,0,90])
                    {
                        text("KP ProEM512 mount 0.2", size=4, direction = "ltr");
                    }       
                }
            }  
        //end bars (union with base frame)
        translate([0, 0, 5])   rounded_slab(190, 30, c_r, 5);   
        translate([0, 102, 5])  rounded_slab(190, 25, c_r, 5);  
    }   
    
    //8-32 facing towards camera (away from baseplate)
    for (i = [0 : 8]){
        translate([width/2-28.3, 11+i, 10]) rotate ([0,180,0])   8_32_cap_hole (0, 0, 10);
        translate([width/2+28.3, 11+i, 10]) rotate ([0,180,0])   8_32_cap_hole (0, 0, 10);
    }
    
    //baseplate mounting (M6) - check pitch!!!!
    for (i = [0 : 2 : 8]){
        M6_cap_hole(width/2-79+i, 15, 10);
        M6_cap_hole(width/2+71+i, 15, 10);
        M6_cap_hole(width/2-79+i, 115, 10);
        M6_cap_hole(width/2+71+i, 115, 10);
        
    //cutout under distant bar
    translate([35, 107, 0])   rounded_slab(120, 15, c_r, 5); 


    }
    
}