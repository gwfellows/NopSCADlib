
include <../utils/core/core.scad>
include <C:\Users\gfellows\OneDrive - Eastside Preparatory School\Documents\GitHub\NopSCADlib\vitamins\ballscrews.scad>

function nut_sleeve_outer_diameter(type) = type[0];
function nut_flange_width(type) = type[1];
function nut_length(type) = type[2];
function nut_flange_thickness(type) = type[3];
function nut_flange_outer_diameter(type) = type[4];
function nut_hole_ring_diameter(type) = type[5];

function name_of_screw(type) = type[0];
function screw_diameter(type) = type[1];
function nut_for_screw(type) = type[2];

module half_nut_holes(type){
    nut_type = nut_for_screw(type);

    if (screw_diameter(type) <= 32){
            for (i=[-45:30:45]){
                rotate([0,0,i]){
                    translate([0,nut_hole_ring_diameter(nut_type)/2,0]){
                        cylinder(d=5, h = nut_length(nut_type)+100, center = true);
                    }
                }
            }
        }

    if (screw_diameter(type) >= 40){
            for (i=[-45:45:45]){
                rotate([0,0,i]){
                    translate([0,nut_hole_ring_diameter(nut_type)/2,0]){
                        cylinder(d=5, h = nut_length(nut_type)+100, center = true);
                    }
                }
            }
        }
}

module ballscrew(type, length){
    rotate([90,0,0]){
        color(silver){
            cylinder(d=screw_diameter(type), h = length, center = true);
        }
    }
}

module ballnut(type){
    nut_type = nut_for_screw(type);
    rotate([90,0,0]){
        color(grey60){
            difference(){
                union(){
                    cylinder(d=nut_sleeve_outer_diameter(nut_type), h = nut_length(nut_type), center = true);
                    d = nut_sleeve_outer_diameter(nut_type);
                    translate([0,0,nut_length(nut_type)/2]){
                        intersection(){
                            cylinder(d=nut_flange_outer_diameter(nut_type), h = nut_flange_thickness(nut_type));
                            translate([-nut_flange_width(nut_type)/2,-(nut_flange_width(nut_type)+100)/2,0]){
                                cube([nut_flange_width(nut_type),nut_flange_width(nut_type)+100,nut_flange_thickness(nut_type)]);
                            }
                        }
                    }
                }
                cylinder(d=screw_diameter(type), h = nut_length(nut_type)+100, center = true);
                half_nut_holes(type);
                mirror([0,1,0]){
                    half_nut_holes(type);
                }
            }
        }
    }
}

module ballscrew_assembly(type, pos, length){
    ballscrew(type, length);
    translate([0,pos,0]){
        ballnut(type);
    }
}