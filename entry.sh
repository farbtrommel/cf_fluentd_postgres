#!/bin/sh

fluent_db_credentials=`echo $VCAP_SERVICES | jq -r '.aws_aurora[] | select(.name == "'$CF_FLUENT_DB'") | .credentials'`


export fluent_host=`[[ -z "$fluent_host" ]] && echo $(echo $fluent_db_credentials | jq -r '.hostname') || echo $fluent_host`
export fluent_port=`[[ -z "$fluent_port" ]] && echo $(echo $fluent_db_credentials | jq -r '.port') || echo $fluent_port`
export fluent_database=`[[ -z "$fluent_database" ]] && echo $(echo $fluent_db_credentials | jq -r '.name') || echo $fluent_database`
export fluent_username=`[[ -z "$fluent_username" ]] && echo $(echo $fluent_db_credentials | jq -r '.username') || echo $fluent_username`
export fluent_password=`[[ -z "$fluent_password" ]] && echo $(echo $fluent_db_credentials | jq -r '.password') || echo $fluent_password`


cat /fluentd/etc/fluent.conf.template \
  | sed 's/__fluent_host__/'$fluent_host'/g' \
  | sed 's/__fluent_port__/'$fluent_port'/g' \
  | sed 's/__fluent_database__/'$fluent_database'/g' \
  | sed 's/__fluent_username__/'$fluent_username'/g' \
  | sed 's/__fluent_password__/'$fluent_password'/g' \
  >  /fluentd/etc/fluent.conf

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