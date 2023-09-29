# setup colour formatting
RED := \033[0;31m
YELLOW := \033[0;33m
GREEN := \033[0;32m
PURPLE := \033[0;35m
CYAN := \033[0;36m
COLOUR_OFF := \033[0m # Text Reset

RM_EXTRA_OP := grep -v -E 'Lock [0-9]+ acquired|Lock [0-9]+ released|Attempting to acquire lock|Attempting to release lock'
RM_EXTRA_OP_2 := sed 's/\[[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\] //'