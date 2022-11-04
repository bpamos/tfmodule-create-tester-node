# tfmodule-create-tester-node
Terraform Module to create a tester node for Redis






*********
# RIOT

The tester node follows the instrucitons from (https://developer.redis.com/riot/riot-redis/cookbook.html)
to install java and such.
Then downloads the most recent version of RIOT. (right now hardcoded)

To use RIOT the user can:
Go to tester node:
* redis-server
* open new ec2 terminal to access redis
* redis-cli
    - set some keys (ie. set key A)
* Test RIOT Migration
    - riot-redis-xxxxx/bin/riot-redis (then the command)
    -example: `riot-redis-2.18.5/bin/riot-redis -u redis://127.0.0.1:6379 replicate-ds -u redis://redis-16404.bamos-west.demo.redislabs.com:16404 -a test`