difference()
    {
    union()
        {
        translate([4,0,0]) cube([43,29.5,2]);
        translate([0,4,0]) cube([51,21.5,2]);   
        translate([4,4,0]) cylinder(r=4,h=2, $fn=50);
        translate([47,4,0]) cylinder(r=4,h=2, $fn=50);
        translate([4,25.5,0]) cylinder(r=4,h=2, $fn=50);
        translate([47,25.5,0]) cylinder(r=4,h=2, $fn=50);
        }
    translate([25.5,14.75,0]) cylinder(r=8.85,h=2, $fn=50);
    translate([25.5,14.75,1.65]) cylinder(r=12.6,h=0.35, $fn=50);
    translate([8,27,0]) 
        linear_extrude(height = 1) {
            rotate ([0,180,90]){
            text("KP CSH 0.2", size=3, direction = "ltr");
    }       
}
}
    
    