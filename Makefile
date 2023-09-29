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
SODA_TEST_CMD := . ./.venv/bin/activate && soda scan -d snowflake_db -c soda/configuration.yml
SODA_CHECKS_EXAMPLES_DIR := soda/checks/examples
SODA_CHECKS_DIR := soda/checks/v1/

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

#------------------------
# test examples
#------------------------
test_simple_1_row_count:
	@#pipe the output of the command to remove the snowflake connection messages
	@(${SODA_TEST_CMD} ${SODA_CHECKS_EXAMPLES_DIR}/simple/1_row_count_dim_service.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_simple_2_mids:
	@(${SODA_TEST_CMD} ${SODA_CHECKS_EXAMPLES_DIR}/simple/2_duplicate_col_dim_merchant_mid.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_simple_3_invalid_email:
	@(${SODA_TEST_CMD} ${SODA_CHECKS_EXAMPLES_DIR}/simple/3_invalid_email_dim_sales_partner.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

#------------------------
# template example
#------------------------
template_eg:
	# TODO
	# See: https://docs.soda.io/soda-cl/check-template.html
	@(${SODA_TEST_CMD} soda/checks/TODO -T templates.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

#------------------------
# V1 tests
#------------------------
test_dim_contact:
	@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/v1/4_dim_contact_unique.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_dim_merchant:
	# TODO
	#@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/v1/wip_check_dim_merchant.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_dim_sales_partner:
	# TODO
	#@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/v1/wip_check_dim_sales_partner.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}

test_dim_sales_rep:
	# TODO
	#@(${SODA_TEST_CMD} ${SODA_CHECKS_DIR}/v1/wip_check_dim_sales_rep.yml) 2>&1 | ${RM_EXTRA_OP} | ${RM_EXTRA_OP_2}
