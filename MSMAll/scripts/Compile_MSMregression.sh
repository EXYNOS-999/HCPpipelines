#!/bin/bash

#~ND~FORMAT~MARKDOWN~
#~ND~START~
#
# # Compile_MSMregression.sh
#
# ## Copyright Notice
#
# Copyright (C) 2017 The Human Connectome Project
#
# * Washington University in St. Louis
# * University of Minnesota
# * Oxford University
#
# ## Author(s)
#
# * Timothy B. Brown, Neuroinformatics Research Group, Washington University in St. Louis
#
# ## Product
#
# [Human Connectome Project][HCP] (HCP) Pipelines
#
# ## License
#
# See the [LICENSE](https://github.com/Washington-Univesity/Pipelines/blob/master/LICENSE.md) file
#
# <!-- References -->
# [HCP]: http://www.humanconnectome.org
#
#~ND~END~

# ------------------------------------------------------------------------------
#  Main processing of script.
# ------------------------------------------------------------------------------

main()
{
	local app_name=MSMregression
	local output_directory=Compiled_${app_name}
	
	pushd ${HCPPIPEDIR}/MSMAll/scripts > /dev/null
	log_Msg "Working in ${PWD}"
	
	log_Msg "Creating output directory: ${output_directory}"
	mkdir --parents ${output_directory}

	log_Msg "Compiling ${app_name} application"
	${MATLAB_HOME}/bin/mcc -mv ${app_name}.m \
				  -a ss_svds.m \
				  -a ${HCPPIPEDIR}/global/matlab/cifitopen.m \
				  -a ${HCPPIPEDIR}/global/matlab/gifti-1.6 \
				  -d ${output_directory}
	
	popd > /dev/null
}

# ------------------------------------------------------------------------------
#  "Global" processing - everything above here should be in a function
# ------------------------------------------------------------------------------

set -e # If any commands exit with non-zero value, this script exits

# Verify that HCPPIPEDIR environment variable is set
if [ -z "${HCPPIPEDIR}" ]; then
	script_name=$(basename "${0}")
	echo "${script_name}: ABORTING: HCPPIPEDIR environment variable must be set"
	exit 1
fi

# Load function libraries
source ${HCPPIPEDIR}/global/scripts/log.shlib # Logging related functions
log_Msg "HCPPIPEDIR: ${HCPPIPEDIR}"

# Verify that other needed environment variables are set
if [ -z "${MATLAB_HOME}" ]; then
	log_Err_Abort "MATLAB_HOME environment variable must be set"
fi
log_Msg "MATLAB_HOME: ${MATLAB_HOME}"

# Invoke the main processing
main "$@"
