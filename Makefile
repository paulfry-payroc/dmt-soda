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
SODA_CHECKS_DIR := soda/checks/examples

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
	# all emails should be valid
	@${SODA_TEST_CMD} soda/checks/examples/checks_dim_contact_unique.yml

test_simple_1_row_count:
	@#pipe the output of the command to remove the snowflake connection messages
	@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/simple/1_row_count_dim_service.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_simple_2_mids:
	@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/simple/2_duplicate_col_dim_merchant_mid.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_simple_3_invalid_email:
	@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/simple/3_invalid_email_dim_sales_partner.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}
