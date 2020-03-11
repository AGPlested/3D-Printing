// Prime95B mount for Metric 25mm pitch M6 breadboard
// For 39mm high mounting (on 25 mm posts)
// For 3D printer 
// Andrew Plested and Benjamin Koenig, Humboldt University and Leibniz FMP


width = 160;   //x 
depth = 200;   //y along optical axis
thick = 14;    //z thickness of plate
cam_w = 109;   //width of Prime 95B from datasheet + 0.6 mm 
c_r = 5;       //corner radius
aff = thick-2; //affordance over M6 mounting holes

module socket_cap_hole (inner, outer, atx, aty, zthick, cap)
{
    translate([atx, aty, 0]) cylinder(r=inner, h=zthick, $fn=50);
    translate([atx, aty, zthick-cap]) cylinder(r=outer, h=cap, $fn=50);
}

module 1_4_20_cap_hole (atx, aty, zthick)
{
    8_32_cap_diam = 12;
    8_32_cap_thick = 6;
    8_32_clearance = 7.2;
    socket_cap_hole (8_32_clearance / 2, 8_32_cap_diam / 2, atx, aty, zthick, 8_32_cap_thick);
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
    M6_clearance = 7.5;
    M6_cap_thick = 6.5;
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

module rounded_side_block (base, top, high, depth)
{
    translate ([0,depth,0])
    rotate ([90,0,0])  
    linear_extrude(height = depth) 
    {
        hull() 
        {
        square (.1);
        translate ([base, 0, 0]) square (.1);
        translate ([0, high, 0]) square (.1);
        translate ([top-5, high-5, 0]) scale([1/50, 1/50, 1/50]) circle (200);
        }
    }
}

difference() 
{
    union()
    {
        difference()
        {
            //frame with central cut-outs
            rounded_slab(width, depth, c_r, thick/2);
            translate([17.5,40,0])   rounded_slab(55, 115, c_r, thick/2);
            translate([87.5,40,0])   rounded_slab(55, 115, c_r, thick/2);    

            //negative beams
            beam = 3;
            translate([5,45,thick/2-beam])   rounded_slab(8, 110, 2, beam); 
            translate([width-13,45,thick/2-beam])   rounded_slab(8, 110, 2, beam);
         
            
            
            //signature  
            translate([80,50,thick/2-2]) 
                linear_extrude(height = 2) 
                {
                    rotate ([0,0,90])
                    {
                        text("KP Prime95B mount 0.2", size=4, direction = "ltr");
                    }       
                }
            }  
        //end bars (union with base frame)
        translate([0, 0, thick/2])   rounded_slab(width, 40, c_r, thick/2);   
        translate([0, 155, thick/2])  rounded_slab(width, 45, c_r, thick/2);  
            
        //mid tabs (union with base frame)
        translate([width-35, 55, 0]) rounded_slab(35, 30, c_r, thick-2); 
        translate([0, 55, 0]) rounded_slab(35, 30, c_r, thick-2); 
            
        //Side mounting (union with base frame)
        translate ([width/2 + cam_w/2, 5, thick]) 
            rounded_side_block (15, 10, 70, 35);
        translate ([width/2 - cam_w/2, 5, thick]) 
            mirror([1,0,0]) rounded_side_block (15, 10, 70, 35);  
        
    }   
    
    // loop to elongate holes
    // 1/4-20 mounting holes facing towards camera (away from baseplate)
    for (i = [0 : 8]){
        translate([width/2, 20+i, thick]) 
            rotate ([0,180,0])   1_4_20_cap_hole (0, 0, thick);
        translate([width/2, 20+146.7+i, thick]) 
            rotate ([0,180,0])   1_4_20_cap_hole (0, 0, thick);
        
     // 1/4-20 transverse mounting holes   
        translate([width/2+cam_w/2, 20+i, thick+cam_w/2]) 
            rotate ([0,90,0])   1_4_20_cap_hole (0, 0, 12);
        translate([width/2-cam_w/2, 20+i, thick+cam_w/2]) 
            rotate ([0,-90,0])   1_4_20_cap_hole (0, 0, 12);   
    }
    
    //affordances subtracted from endbars above M6 cap holes 
    translate([0, 155, aff])   cube([width/2 - cam_w/2 + 40, 45, 2]);   
    translate([width/2 + cam_w/2 - 40, 155, aff])  cube([width - cam_w/2 + 40, 45, 2]); 
    translate([width/2 - cam_w/2, 0, aff])   cube([40, 40, 2]);   
    translate([width/2 + cam_w/2 - 40, 0, aff])  cube([40, 40, 2]); 
    
    //baseplate mounting (M6) 25 mm pitch 
    //loop to elongate holes
    for (i = [0 : 2 : 8]){
        M6_cap_hole(width/2 -41.5 +i, 10, aff);
        M6_cap_hole(width/2 +33.5 +i, 10, aff);
        M6_cap_hole(width/2 -41.5 +i, 185, aff);
        M6_cap_hole(width/2 +33.5 +i, 185, aff);
        M6_cap_hole(width/2 -66.5 +i, 170, aff);
        M6_cap_hole(width/2 +58.5 +i, 170, aff);
        M6_cap_hole(width/2 -66.5 +i, 70, aff);
        M6_cap_hole(width/2 +58.5 +i, 70, aff);

    }
    
}