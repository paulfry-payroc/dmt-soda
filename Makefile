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
include src/makefile/config.mk # load variables from separate file
include src/makefile/setup.mk # contains setup scripts

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

test:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target 'test'. Perform example Soda tests.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	${VENV_ACTIVATE} && soda scan ${SODA_COMMON_ARGS} checks.yml
	# ${VENV_ACTIVATE} && soda scan ${SODA_COMMON_ARGS} checks.yml -srf test.json

#---------------------------
# Supplementary targets
#---------------------------
test_connection:
	@echo && echo "------------------------------------------------------------------"
	@echo "${YELLOW}# Target 'test_connection'. Test connectivity to a data source.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	${VENV_ACTIVATE} && soda test-connection ${SODA_COMMON_ARGS} | grep "Successfully connected"
