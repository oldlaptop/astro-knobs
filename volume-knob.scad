/*
 * Copyright (c) 2021 Peter Piwowarski <peterjpiwowarski@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this model for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Volume knob for the radio in a 2004 Chevrolet Astro (and surely others). All
 * measurements are in inches.
 */


knob_height = 0.560; // Approximate overall height, including the rounded front
cyl_height = 0.400;  // Approximate height of the cylindrical section
knob_diameter = 0.691;

cutout_diameter = 0.500;             // Inside diameter of the cutout in the back
cutout_chamfer_max_diameter = 0.550; // Diameter of the chamfer at the far back
cutout_chamfer_depth = 0.059;        // Depth of the chamfer at its narrowest

stem_id = 0.200;    // Internal diameter of the stem that fits on the radio's actuator
stem_od = 0.250;    // Adjust to suit printer and material, within reason
stem_inset = 0.170; // Distance between the back of the knob and the back of the stem
stem_flat = 0.190;  // Chord length of the flat portion on the inside of the stem

/*
 * Adjust to suit your printer's resolution/precision and/or debugging tastes;
 * this value provides both acceptable roundness and acceptable interactive
 * performance for me on a Ryzen 7 1700, with a final render time of about 45s.
 */
$fn = 256;

module knob_outline(overall_height, cyl_diameter)
{
	intersection()
	{
		cylinder(h = overall_height, d = cyl_diameter);
		sphere(overall_height);
	}
}

module knob_cutout(height, diameter, chamfer_depth, chamfer_max_diameter)
{
	union()
	{
		translate([0, 0, -0.1])
		{
			cylinder(h = height + 0.1, d = diameter);
		}

		translate([0, 0, -chamfer_depth])
		{
			cylinder(
				h = chamfer_depth * 2,
				d1 = chamfer_max_diameter * 2 - cutout_diameter,
				d2 = diameter
			);
		}
	}
}

module stem(total_height, inset, id, od, flat, maincolor = [225/225, 0, 0])
{
	complementcolor = [1, 1, 1] - maincolor;
	meancolor = maincolor + complementcolor / 2;

	translate([0, 0, inset])
	{
		difference()
		{
			color(maincolor)
			{
				cylinder(h = total_height - inset, d = od);
			}
			color(complementcolor)
			{
				translate([0, 0, -0.1])
				{
					height = total_height - inset + 0.1;
					difference()
					{
						cylinder(h = height, d = id);
						color(meancolor)
						{
							translate([sqrt((id / 2) ^ 2 - (flat / 2) ^ 2), -(flat / 2), 0])
							{
								cube(size = [flat, flat, height]);
							}
						}
					}
				}
			}
		}
	}
}

union()
{
	difference()
	{
		color("DarkGrey")
		{
			knob_outline(knob_height, knob_diameter);
		}
		color("HotPink")
		{
			knob_cutout(cyl_height, cutout_diameter, cutout_chamfer_depth, cutout_chamfer_max_diameter);
		}
	}
	stem(cyl_height, stem_inset, stem_id, stem_od, stem_flat);
}
