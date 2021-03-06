//
// NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//

//
//! Simple model of ball bearings with seals, the colour of which can be specified. If silver they are assumed to be metal and the
//! part number gets a ZZ suffix. Any other colour is assumed to be rubber and the suffix is -2RS.
//!
//! If a ball bearing has a child it is placed on its top surface, the same as nuts and washers, etc.
//!
//! Also single bearing balls are modelled as just a silver sphere and a BOM entry.
//
include <../utils/core/core.scad>
include <../utils/tube.scad>

function bb_name(type)     = type[0]; //! Part code without shield type suffix
function bb_bore(type)     = type[1]; //! Internal diameter
function bb_diameter(type) = type[2]; //! External diameter
function bb_width(type)    = type[3]; //! Width
function bb_colour(type)   = type[4]; //! Shield colour, "silver" for metal
function bb_rim(type)      = type[5]; //! Outer rim thickness guesstimate
function bb_hub(type)      = type[6]; //! Inner rim thickness guesstimate

module ball_bearing(type) { //! Draw a ball bearing
    shield = bb_colour(type);
    suffix = shield == "silver" ? "ZZ " : "-2RS ";
    vitamin(str("ball_bearing(BB", bb_name(type), "): Ball bearing ", bb_name(type), suffix, bb_bore(type), "mm x ", bb_diameter(type), "mm x ", bb_width(type), "mm"));
    rim = bb_rim(type);
    hub = bb_hub(type);
    h = bb_width(type);
    or = bb_diameter(type) / 2;
    ir = bb_bore(type) / 2;

    color("silver") {
        $fn = 360;

        rim_chamfer = rim / 6;
        rotate_extrude()
            hull() {
                translate([or - rim / 2, 0])
                    square([rim, h - 2 * rim_chamfer], center = true);

                translate([or - rim / 2 - rim_chamfer, 0])
                    square([rim - rim_chamfer, h], center = true);
            }

        hub_chamfer = hub / 6;
        rotate_extrude()
            hull() {
                translate([ir + hub / 2, 0])
                    square([hub, h - 2 * hub_chamfer], center = true);

                translate([ir + hub / 2 + hub_chamfer, 0])
                    square([hub - hub_chamfer, h], center = true);
            }
    }

    color(shield) tube(or - rim - eps, ir + hub + eps, h - 1);

    if($children)
        translate_z(bb_width(type) / 2)
            children();
}

module bearing_ball(dia) { //! Draw a steel bearing ball
    vitamin(str(" bearing_ball(", dia, "): Steel ball ", dia, "mm"));
    color("silver") sphere(d = dia);
}
