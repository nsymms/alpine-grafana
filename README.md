# Alpine-Grafana

An alpine based version of the grafana docker container,
intended to be as close to the official grafana container
as possible.

Known differences from stock Grafana container:
* Alpine based
* PhantomJS binary (63 MiB) is removed. Is this needed?
* AWS credentials on the command line is untested.
This is because the stock run.sh script uses bash and I
hacked the script to use sh instead. It should work, but
it is untested. The alternative is to install bash, but
that adds 11 MiB.
