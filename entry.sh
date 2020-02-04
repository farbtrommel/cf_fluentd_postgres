#!/bin/sh

fluent_db_credentials=`echo $VCAP_SERVICES | jq -r '.aws_aurora[] | select(.name == "'$CF_FLUENT_DB'") | .credentials'`

fluent_host=`echo $fluent_db_credentials | jq -r '.hostname'`
fluent_port=`echo $fluent_db_credentials | jq -r '.port'`
fluent_database=`echo $fluent_db_credentials | jq -r '.name'`
fluent_username=`echo $fluent_db_credentials | jq -r '.username'`
fluent_password=`echo $fluent_db_credentials | jq -r '.password'`


#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi
fi

exec "$@"