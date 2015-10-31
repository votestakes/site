.PHONY: all
all: depends

.PHONY: ci
ci: check

# RUN SERVER ###################################################################

IP = $(shell ipconfig getifaddr en0 || ipconfig getifaddr en1)

.PHONY: run
run: depends
	bundle exec rackup

.PHONY: launch
launch: depends
	eval "sleep 3; open http://$(IP):9292" & $(MAKE) run

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
