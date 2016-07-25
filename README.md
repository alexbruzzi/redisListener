# Redis Event Listener
A daemon to listen to redis pub/sub events (keyspace/keyevent notifications)


### Start

```
lang=bash
ruby redisListen.rb start
```

You can start multiple instances by running the above command multiple times.

### Get Status

```
lang=bash
ruby redisListen.rb status
```

### Stop

```
lang=bash
ruby redisListen.rb stop
```


### Logs

- Available at `PROJ_DIR/shared/logs/`
- Also check the `logfile` config at `config/config.yml`
