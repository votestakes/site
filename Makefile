.PHONY: all
all: depends

.PHONY: ci
ci: check

# RUN SERVER ###################################################################

IP = $(shell ipconfig getifaddr en0 || ipconfig getifaddr en1)
PORT ?= 9292

.PHONY: run
run: depends
	bundle exec rackup --host 0.0.0.0 --port $(PORT)

.PHONY: launch
launch: depends
	eval "sleep 1; open http://$(IP):$(PORT)" & $(MAKE) run

# DEPENDENCY INSTALLATION ######################################################

VENDOR := vendor
GEMS := $(VENDOR)/*

.PHONY: depends
depends: $(GEMS)
$(GEMS): Gemfile*
	bundle install --path $(VENDOR)
	@ touch $(GEMS)

# STATIC ANALYSIS ##############################################################

.PHONY: check
check: depends
	bundle exec htmlproof public --href-ignore "#"

# CLEANUP ######################################################################

.PHONY: clean
clean:

.PHONY: clean-all
clean-all:
	rm -rf $(VENDOR)
