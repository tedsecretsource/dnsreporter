#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Run this script with bash -x (script name) to execute commands one a time

#/ Usage: ./mx.sh --domains path/to/list/of/domains --record MX
#/ Description: Get a list of DNS records from a list of domains in a 
#/              report format. For example, if I want the NS record for
#/              100 domains, this is your baby.
#/ Examples: (same as usage above)
#/ Options:
#/   --help: Display this help message
#/   --domains: path to a list of domains with one domain on each line
#/   --record: the record you are looking to find, e.g.: MX
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# tiny logging framework
readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

# what to do when the script exists, for any reason
function cleanup() { 
    # Remove temporary files
    # Restart services
    exit 0
} 

# get the named parameters
while [ "${1:-}" != "" ]; do
    case $1 in
        -d | --domains )         shift
                                domains=${1:-}
                                ;;
        -r | --record )         shift
                                record=${1:-A}
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# and finally, the actual script
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT
    
    if [ -f "${domains:-}" ]
    then
        while read LINE 
        do
            if [ -n "$LINE" ]
            then
                set +e
                RES=$(dig +noall +answer +short $LINE ${record:-A})
                set -e
                echo '"'$LINE'"','"'$RES'"' | sed -e 's/ /","/g'
            fi
        done < "${domains:-}"
    else
        echo 'cannot find domains'
    fi
fi
