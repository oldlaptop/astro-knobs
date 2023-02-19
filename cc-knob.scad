/*
 * Copyright (c) 2023 Peter Piwowarski <peterjpiwowarski@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this model for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE MODEL IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS MODEL INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS MODEL.
 *
 * Climate-control knob (there are three that appear identical) for a 2004
 * Chevrolet Astro, and presumably other late-90s and early-2000s GM products
 * (particularly light trucks?). All measurements are in inches.
 *
 * On an FDM machine, I recommend placing the angled "nose" of the part facedown
 * on the print bed, which should allow the part to print with little or no
 * support. (I've tried using a tiny bit near where the fascia approaches the
 * print bed, where the overhang is steepest, but I don't think that did
 * anything.) Translucent material is suggested, given that the original knob is
 * illuminated.
 */

use <volume-knob.scad>

outer_dia = 1.250;
limiting_pin_x = 0.155;
limiting_pin_y = 0.085;
limiting_pin_z = 0.170;

// Distance from the outer rim of the knob to the outer edge of the limiting pin
limiting_pin_offset = 0.165;

/*
 * I did not end up modeling this narrow 'rim' around the back of the knob that
 * I carefully measured on the original; perhaps this was meant to keep light
 * from leaking around the edge?
rim_thickness = 0.050,
rim_depth = 0.035,
 */

rim_thickness = 0.050;
rim_depth = 0.035;

stem_od = 0.410;
stem_length = 0.450;

/*
 * These are very finicky, given that you want a tight friction fit - but not
 * one that requires enough force to break things - on a shaft that's about
 * 0.2in wide. Even the moisture content of PETG filament is believed to be able
 * to make the difference between too tight and too loose for the same stem_id
 * value. Planning to use the original metal liner may or may not make this more
 * forgiving, but will require modestly larger values.
 */
stem_id = 0.203;
stem_chord = 0.165;

fascia_thickness = 0.185;

grip_x = 0.33;
grip_y = outer_dia;
grip_z = 0.50;

$fn = 256;

module cc_knob(
	outer_dia = outer_dia,

	limiting_pin_x = limiting_pin_x,
	limiting_pin_y = limiting_pin_y,
	limiting_pin_z = limiting_pin_z,
	limiting_pin_offset = limiting_pin_offset,

	stem_od = stem_od,
	stem_length = stem_length,
	stem_id = stem_id,
	stem_chord = stem_chord,

	fascia_thickness = fascia_thickness,

	grip_x = grip_x,
	grip_y = outer_dia,
	grip_z = grip_z,
)
{
	union()
	{
		rotate([0, 0, 90])
		{
			/*
			 * In terms of the original volume knob's dimensions,
			 * the "length" is the distance from the back face of
			 * the knob to the top of the stem - zero in this case
			 * because there is no "well" in this knob as in the
			 * volume knob - and the "inset" is negative because the
			 * stem protrudes out from the back face of the knob,
			 * rather than being, well, set in to it.
			 */
			stem(
				total_height = 0,
				inset = -stem_length,
				id = stem_id,
				od = stem_od,
				flat = stem_chord
			);
		}
		limiting_pin();
		fascia();
		translate([0, 0, fascia_thickness])
		{
			grip();
		}
	}
}

module fascia(
	dia = outer_dia,
	thickness = fascia_thickness
)
{
	cylinder(h = thickness, d = dia);
}

module limiting_pin(
	x = limiting_pin_x,
	y = limiting_pin_y,
	z = limiting_pin_z,
	offs = ((outer_dia / 2) - limiting_pin_offset),
	pincolor = [0, 255/255, 0]
)
{
	cube_x = x - y;

	translate([0, -offs, -z])
	{
		color(pincolor)
		{
			translate([-cube_x / 2, 0, 0])
			{
				cube([cube_x, y, z]);
			}
			for (xsign = [+1, -1])
			{
				translate([xsign * cube_x / 2, y / 2, 0])
				{
					cylinder(h = z, d = y);
				}
			}
		}
	}
}

module grip(
	x = grip_x,
	y = grip_y,
	z = grip_z
)
{
	intersection()
	{
		translate([-(x / 2), -(y / 2), 0])
		{
			union()
			{
				polyhedron([
					[0, y, 0],
					[x, y, 0],
					[0, y - x, 0],
					[x, y - x, 0],
					[0, y - x, z],
					[x, y - x, z]
				], [
					[0, 2, 3, 1],
					[0, 1, 5, 4],
					[0, 4, 2],
					[1, 3, 5],
					[4, 5, 3, 2]
				]);
				cube([x, y - x, z]);
			}
		}
		cylinder(d = y, h = z);
	}
}

cc_knob();
