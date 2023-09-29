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

# VENV := source .venv/bin/activate
VENV_ACTIVATE := . ./.venv/bin/activate
SODA_DATA_SRC := snowflake_db
SODA_CONFIG := configuration.yml
SODA_COMMON_ARGS := -d ${SODA_DATA_SRC} -c ${SODA_CONFIG}

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
	@python3 -m venv .venv && chmod +x ./.venv/bin/activate;
	@${VENV_ACTIVATE} && pip install -r requirements.txt -q;
	@echo "${PURPLE}Step 2: Generate .env file${COLOUR_OFF}"
	@cp src/templates/jinja_templates/.env.j2 .env
	@echo "${PURPLE}Step 3: Generate soda config files (configuration.yml & checks.yml)${COLOUR_OFF}"
	@cp src/templates/jinja_templates/configuration.yml configuration.yml
	@j2 src/templates/jinja_templates/checks.yml.j2 -o checks.yml
	@echo "${PURPLE}Step 4: Verify soda is installed.\n\nRun command: 'soda --help'${COLOUR_OFF}" && echo
	@${VENV_ACTIVATE} && soda --help && echo
	@echo "${PURPLE}Step 5: Test connectivity to the source db${COLOUR_OFF}"
	@make -s test_connection

run:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target: 'run'. Run the setup and install targets.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@${VENV_ACTIVATE} soda scan -d adventureworks -c configuration.yml checks.yml

test:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target 'test'. Perform any required tests.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@echo "Target 'test' called"
	@${VENV_ACTIVATE}

clean:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@rm -rf .venv
	@rm -rf configuration.yml
	@rm -rf checks.yml
	@rm -rf .env

#---------------------------
# Supplementary targets
#---------------------------
test_connection:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'test_connection'. Test connectivity to a data source.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	${VENV_ACTIVATE} && soda test-connection ${SODA_COMMON_ARGS} | grep "Successfully connected"
