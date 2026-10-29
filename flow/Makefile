PYTHON ?= python3

.PHONY: all catalogue screen validate canary-synth canary-librelane clean

all: catalogue screen validate

catalogue:
	$(PYTHON) enumerate_libs.py

screen:
	$(PYTHON) screen_libs.py

validate:
	$(PYTHON) validate_selection.py --selection selection.example.json

canary-synth:
	$(MAKE) -C canary/ics55_h7cr_core_a synth-digital

canary-librelane:
	$(MAKE) -C canary/ics55_h7cr_core_a librelane-digital

clean:
	rm -f libraries.json libraries.yaml libraries.md
	rm -f screening*.json screening*.md
