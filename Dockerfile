FROM fluent/fluentd:v1.9.1-1.0

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        build-base ruby-dev postgresql-client postgresql-dev ruby-bigdecimal jq sed \
 && gem install bigdecimal \
 && gem install pg \
 && gem install fluent-plugin-postgres \
 && rm -f /fluentd/etc/fluent.conf

COPY fluent.conf /fluentd/etc/fluent.conf.template
COPY entry.sh /bin/entry.sh

USER fluent

EXPOSE 24224 5140

ENTRYPOINT ["tini", "--", "/bin/entry.sh"]

CMD ["fluentd"]