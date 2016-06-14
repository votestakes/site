FILES := public

.PHONY: all
all: build

.PHONY: ci
ci: check

# RUN SERVER ###################################################################

IP = $(shell ipconfig getifaddr en0 || ipconfig getifaddr en1)
PORT ?= 9292

.PHONY: run
run: build
	bundle exec rackup --host 0.0.0.0 --port $(PORT)

.PHONY: launch
launch: build
	eval "sleep 3; open http://$(IP):$(PORT)" & $(MAKE) run

# DEPENDENCY INSTALLATION ######################################################

VENDOR := vendor
GEMS := $(VENDOR)/*

.PHONY: depends
depends: $(GEMS)
$(GEMS): Gemfile*
	bundle install --path $(VENDOR)
	@ touch $(GEMS)

# BUILD SITE ###################################################################

.PHONY: build
build: depends $(VENDOR)/.images-optimized.flag

$(VENDOR)/.images-optimized.flag: $(FILES)
	bundle exec image_optim --skip-missing-workers --recursive $(FILES)
	@ touch $@

# STATIC ANALYSIS ##############################################################

.PHONY: check
check: build
	bundle exec htmlproof $(FILES) --href-ignore "#"

# DEPLOYMENT ###################################################################

.PHONY: deploy
deploy: depends
	bundle exec rake deploy_to_github_pages

# CLEANUP ######################################################################

.PHONY: clean
clean:

.PHONY: clean-all
clean-all:
	rm -rf $(VENDOR)
