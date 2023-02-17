/*
 * Copyright (c) 2021 Peter Piwowarski <peterjpiwowarski@gmail.com>
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
 * Volume knob for the radio in a 2004 Chevrolet Astro (and surely other GM
 * factory radios from the late 1990s and early 2000s). All measurements are in
 * inches. (Fancy colors are meant solely to make troubleshooting the geometry a
 * bit easier.)
 *
 * On an FDM machine, I recommend printing with knob_chamfer = true, oriented
 * with the front of the knob facedown on the print bed. A brim is likely
 * necessary given the small contact patch.
 */

knob_height = 0.525; // Approximate overall height, including the rounded front
cyl_height = 0.400;  // Approximate height of the cylindrical section
knob_diameter = 0.691;

/*
 * If false, will render a spherical front profile like the original knob,
 * instead of an FDM-printer-friendly chamfer.
 */
knob_chamfer = true;
knob_chamfer_frac = 0.5; // 0 is no chamfer at all, 1 is a sharp-pointed cone

cutout_diameter = 0.500;             // Inside diameter of the cutout in the back
cutout_chamfer_max_diameter = 0.550; // Diameter of the chamfer at the far back
cutout_chamfer_depth = 0.059;        // Depth of the chamfer at its narrowest

/*
 * Internal diameter of the stem that fits on the radio's actuator. This
 * dimension is very sensitive, and appropriate values may depend on whether you
 * use the original metal 'liner' piece, and of course on your
 * particular printer, material, the phase of the moon, etc.
 */
stem_id = 0.202;

stem_od = 0.35;     // Adjust to suit printer and material, within reason
stem_inset = 0.170; // Distance between the back of the knob and the back of the stem
stem_flat = 0.190;  // Chord length of the flat portion on the inside of the stem

/*
 * Adjust to suit your printer's precision and/or your debugging tastes. This is
 * the result of "crank it up until I can't see the flats anymore", and probably
 * a tad excessive.
 */
$fn = 256;

module knob(
	knob_height = knob_height,
	cyl_height = cyl_height,
	knob_diameter = knob_diameter,

	knob_chamfer = true,
	knob_chamfer_frac = knob_chamfer_frac,

	cutout_diameter = cutout_diameter,
	cutout_chamfer_max_diameter = cutout_chamfer_max_diameter,
	cutout_chamfer_depth = cutout_chamfer_depth,

	stem_id = stem_id,
	stem_od = stem_od,
	stem_inset = stem_inset,
	stem_flat = stem_flat,
)
{
	union()
	{
		difference()
		{
			color("DarkGrey")
			{
				knob_outline(
					knob_height,
					cyl_height,
					knob_diameter,
					chamfer = knob_chamfer,
					chamfer_frac = knob_chamfer_frac
				);
			}
			color("HotPink")
			{
				knob_cutout(cyl_height, cutout_diameter, cutout_chamfer_depth, cutout_chamfer_max_diameter);
			}
		}
		stem(cyl_height, stem_inset, stem_id, stem_od, stem_flat);
	}
}

module knob_outline(overall_height, cyl_height, cyl_diameter, chamfer = false, chamfer_frac = 1)
{
	if (chamfer)
	{
		union()
		{
			cylinder(h = cyl_height, d = cyl_diameter);
			translate([0, 0, cyl_height])
			{
				cylinder(
					h = overall_height - cyl_height,
					d1 = cyl_diameter,
					d2 = cyl_diameter * chamfer_frac
				);
			}
		}
	} else
	{
		intersection()
		{
			cylinder(h = overall_height, d = cyl_diameter);
			sphere(overall_height);
		}
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
				d1 = chamfer_max_diameter * 2 - diameter,
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

knob();
