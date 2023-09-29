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
SODA_CONFIG := soda/configuration.yml
SODA_TEST_CMD := ${VENV_ACTIVATE} && soda scan -d ${SODA_DATA_SRC} -c ${SODA_CONFIG}

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
	@${SODA_TEST_CMD} soda/checks/examples/checks_dim_contact_unique.yml
