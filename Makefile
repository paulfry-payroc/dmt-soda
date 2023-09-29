SHELL = /bin/sh

#================================================================
# Usage
#================================================================
# make installations	# install the package for the first time, managing dependencies & performing a housekeeping cleanup too
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

#=======================================================================
# Variables
#=======================================================================
.EXPORT_ALL_VARIABLES:

# load variables from separate file
include config.mk
#=======================================================================
# Targets
#=======================================================================
all: deps install clean
.PHONY: all

VENV := source .venv/bin/activate

deps:
	@echo && echo "----------------------------------------------------------------------------------------------------------------------"
	@echo "${YELLOW}# Target: 'deps'. Download the relevant pip package dependencies.${COLOUR_OFF}"
	@echo "----------------------------------------------------------------------------------------------------------------------" && echo
	@echo "Step 1: Create a virtualenv (.venv) with the required Python libraries (see requirements.txt)"
	@python3 -m venv .venv; \
	chmod +x ./.venv/bin/activate; \
	. ./.venv/bin/activate && pip install -r requirements.txt -q;
	@echo "Step 2: Generate .env file"
	@cp src/templates/jinja_templates/.env.j2 .env
	@echo "Step 3: Generate soda config files (configuration.yml & checks.yml)"
	@cp src/templates/jinja_templates/configuration.yml configuration.yml
	@j2 src/templates/jinja_templates/checks.yml.j2 -o checks.yml
	@echo "Step 4: Verify soda is installed, run 'soda --help'" && echo
	@. ./.venv/bin/activate && soda --help && echo
	@echo "Step 5: Test connectivity to the source db" && echo
	@make -s test_connection
.PHONY: deps

run:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target: 'run'. Run the setup and install targets.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@source .venv/bin/activate
.PHONY: run

test:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target 'test'. Perform any required tests.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@echo "Target 'test' called"
.PHONY: test

clean:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@rm -rf .venv
	@rm -rf configuration.yml
	@rm -rf checks.yml
	@rm -rf .env
.PHONY: clean

# Phony targets
.PHONY: all deps install test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"

#---------------------------
# Supplementary targets
#---------------------------
test_connection:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'test_connection'. Test connectivity to a data source.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@echo "Verify source db connection" && echo
	@. ./.venv/bin/activate && soda test-connection -d snowflake_db -c configuration.yml | grep "Successfully connected"
.PHONY: test_connection
