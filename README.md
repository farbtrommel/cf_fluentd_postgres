# fluent daemon for cloud foundry

Set the service name of the database to the enviroment variable `CF_FLUENT_DB` and start the container in your cloud foundry space.

Or you can configure the postgres manually by enviroment variables

    fluent_host="localhost"
    fluent_port=5432
    fluent_database="dbname"
    fluent_username="user"
    fluent_password="secret"

## Cloud Foundry Routing

    cf add-network-policy <fluntd-service-name> --destination-app <your-app> --port 24224 --protocol tcp