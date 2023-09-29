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
include src/makefile/config.mk

#=======================================================================
# Targets
#=======================================================================
# Phony targets
.PHONY: all deps install run test clean test_connection

all: deps install run test clean

deps:
	@echo && echo "----------------------------------------------------------------------------------------------------------------------"
	@echo "${YELLOW}# Target: 'deps'. Download the relevant pip package dependencies.${COLOUR_OFF}"
	@echo "----------------------------------------------------------------------------------------------------------------------" && echo
	@echo "${PURPLE}Step 1: Create a virtualenv (.venv) with the required Python libraries (see requirements.txt)${COLOUR_OFF}"
	@python3 -m venv .venv && chmod +x ./.venv/bin/activate
	@. ./.venv/bin/activate && pip install -r requirements.txt -q
	@echo "${PURPLE}Step 2: Generate .env file${COLOUR_OFF}"
	@cp src/templates/jinja_templates/.env.j2 .env
	@echo "${PURPLE}Step 3: Generate soda config files (configuration.yml & checks.yml)${COLOUR_OFF}"
	@cp src/templates/jinja_templates/configuration.yml configuration.yml
	@cp -r src/soda/ .
	@echo "${PURPLE}Step 4: Verify soda is installed.\n\nRun command: 'soda --help'${COLOUR_OFF}" && echo
	@${VENV_ACTIVATE} && soda --help && echo
	@echo "${PURPLE}Step 5: Test connectivity to the source db${COLOUR_OFF}"
	@make -s test_connection

test_connection:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'test_connection'. Test connectivity to a data source.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@(${VENV_ACTIVATE} && soda test-connection -d ${SODA_DATA_SRC} -c ${SODA_CONFIG}) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}


clean:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@rm -rf .venv
	@rm -rf configuration.yml
	@rm -rf checks.yml
	@rm -rf .env
