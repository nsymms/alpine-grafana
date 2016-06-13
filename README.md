# Alpine-Grafana

An alpine based version of the grafana docker container.

Known differences from stock Grafana container:
* Alpine based
* Does not support AWS credentials on the command line due to bash dependency
in the run script. I guess I could always just install bash and run the
stock run.sh script. But installing bash almost triples the size of the
alpine base image. Maybe later; I don't need it for now.
