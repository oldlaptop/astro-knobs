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
 * Pop-out tuner knob for the radio in a 2004 Chevrolet Astro (and surely other
 * GM factory radios from the late 1990s and early 2000s). All measurements are
 * in inches. Nearly identical to the volume knob, but (strangely) has slightly
 * different dimensions.
 */

use <volume-knob.scad>

knob_height = 0.625;
cyl_height = 0.5;
stem_id = 0.19;
stem_flat = 0.15;

knob(
	knob_height = knob_height,
	cyl_height = cyl_height,
	stem_id = stem_id,
	stem_flat = stem_flat
);
