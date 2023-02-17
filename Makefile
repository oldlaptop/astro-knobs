.POSIX:

.SUFFIXES: .scad .stl .png

OPENSCAD = openscad
OPENSCAD_FLAGS =

.scad.stl:
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<
.scad.png:
	$(OPENSCAD) --autocenter --viewall $(OPENSCAD_FLAGS) -o $@ $<

MODELS = volume-knob.stl tuner-knob.stl cc-knob.stl
models: $(MODELS)

PREVIEWS = volume-knob.png tuner-knob.png cc-knob.png
previews: $(PREVIEWS)

clean:
	rm -f $(MODELS) $(PREVIEWS)

help:
	@echo "available targets: models, previews, clean"
	@echo "influential macros:"
	@echo "    OPENSCAD:       openscad binary, currently: $(OPENSCAD)"
	@echo "    OPENSCAD_FLAGS: flags to pass to openscad, currently: $(OPENSCAD_FLAGS)"

tuner-knob.scad: volume-knob.scad
	touch $@
cc-knob.scad: volume-knob.scad
	touch $@
