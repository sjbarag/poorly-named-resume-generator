OUTFILE_BASE := barag_resume

TXT_TEMPLATES := $(shell find ./template/plain_text/ -type f)
FMT_TEMPLATES := $(shell find ./template/formatted_text/ -type f)
TEX_TEMPLATES := $(shell find ./template/latex/ -type f)
PY_SOURCES := $(shell find . -type f -name '*.py')
YAML := raw_source.yaml
SOURCES := $(TXT_TEMPLATES) $(FMT_TEMPLATES) $(TEX_TEMPLATEES) $(PY_SOURCES) $(YAML)

GENERATE := python3 generate_resume.py --output-name $(OUTFILE_BASE) --destination output raw_source.yaml

.PHONY: resume
resume: output/$(OUTFILE_BASE).txt output/$(OUTFILE_BASE)_formatted.txt output/$(OUTFILE_BASE).pdf

output/$(OUTFILE_BASE).txt: $(TXT_TEMPLATES) $(PY_SOURCES) $(YAML)
	$(GENERATE)
output/$(OUTFILE_BASE)_formatted.txt: $(FMT_TEMPLATES) $(PY_SOURCES) $(YAML)
	$(GENERATE)
output/$(OUTFILE_BASE).tex: $(TEX_TEMPLATES) $(PY_SOURCES) $(YAML)
	$(GENERATE)

output/barag_resume.pdf: $(TEX_TEMPLATES) output/$(OUTFILE_BASE).tex static-content/barag_resume.cls
	cp static-content/barag_resume.cls output/
	@# luatex must be run twice to support TikZ graphics
	cd output && \
		lualatex $(OUTFILE_BASE).tex && \
		lualatex $(OUTFILE_BASE).tex

DOCKER := $(shell command -v podman || command -v docker)
.PHONY: docker
docker: Dockerfile Makefile $(SOURCES)
	$(DOCKER) build --tag poorly-named-resume-generator .
	@# Double dollar-sign ($$) evaluates to a single one
	$(DOCKER) run -it -v $$PWD:/pnrg poorly-named-resume-generator
