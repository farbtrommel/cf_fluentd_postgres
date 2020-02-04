FROM fluent/fluentd:v1.9.1-1.0

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        build-base ruby-dev postgresql-client postgresql-dev ruby-bigdecimal jq \
 && gem install bigdecimal \
 && gem install pg \
 && gem install fluent-plugin-postgres \
 && gem sources --clear-all \
 && apk del .build-deps # \
 # && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/
COPY entry.sh /bin/entry.sh

USER fluent

EXPOSE 24224 5140

ENTRYPOINT ["tini", "--", "/bin/entry.sh"]

CMD ["fluentd"]