#!/usr/bin/env bash
# generate config files automatically where possible, including
# - flask secret
# - self-signed certificate
# Note:
# - Script's first customer is hwa but could be used by other services as well.
# - Re-coding this as a python library would avoid mixing languages and
#   processes, which would reduce mechanism.
set -u
set -o pipefail
#set -x

svc=
secrets_dir=
op=

progname=$(basename $0)

usage()
{
    cat <<USAGE
Usage: $progname -mode {oper|test}
Description:
	Run id server, as appropriate for mode.
USAGE

    exit $1
}

#
# Return random alpha-numeric string of supplied length
#
random_string()
{
    len=$1
    secret_str=$(LC_CTYPE=C tr -dc '[:alnum:]' < /dev/urandom  | dd bs=$len count=1 2> /dev/null)
    echo $secret_str
}

#
# Need to supply blank lines to openssl questions for generating cert.
# Use here-document to do so
#
selfsigned_cert()
{
    pvtkey=$1
    cert=$2

    openssl req -x509 -newkey rsa:2048 -nodes -days 1001 -keyout $pvtkey -out $cert 2> /dev/null <<BLANK_LINES








BLANK_LINES
}

flask_secret_file()
{
    svc=$1
    flask_secret_str=$(random_string 24)
    cat <<FLASK_SECRET_FILE
{
    "${svc}_flask_secret_key": "$flask_secret_str"
}
FLASK_SECRET_FILE
}

#
# MAIN
#

while [ $# != 0 ]; do
    case $1 in
    -svc)
	shift
	svc=$1
	;;
    -dir)
	shift
	secrets_dir=$1
	;;
    -op)
	shift
	op=$1
	;;
    *)
	echo "$progname: FATAL: Unknown argument ($1)" >&2
	exit 1
	;;
    esac
    shift
done

if [ -z "$svc" ]; then
    echo "$progname: FATAL: secrets directory must be specified" >&2
    usage 1
fi

if [ -z "$secrets_dir" ]; then
    echo "$progname: FATAL: secrets directory must be specified" >&2
    usage 1
fi
if [ ! -d $secrets_dir ]; then # create secrets directory if needed
    mkdir -p $secrets_dir
fi

case "$op" in
flask)
    file=$secrets_dir/${svc}_flask_secrets.json
    if [ -f $file ]; then
	echo "$progname: FATAL: file $file already exists" >&2
	usage 1
    fi
    flask_secret_file ${svc} > $file
    ;;
cert)
    (cd $secrets_dir;
     selfsigned_cert ${svc}_server_cert.pvt_key ${svc}_server_cert.crt
    )
    ;;
"")
    echo "$progname: FATAL: op not specified" >&2
    usage 1
    ;;
*)
    echo "$progname: FATAL: Unknown mode ($mode)" >&2
    usage 1
    ;;
esac
