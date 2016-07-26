# Redis Event Listener
A daemon to listen to redis pub/sub events (keyspace/keyevent notifications)

### Install
- Clone the repo
- `git submodule init`
- Perform `bundle install`
- Open your redis.conf file, search for EVENT NOTIFICATION, uncomment the following line
  ```
  notify-keyspace-events Ex
  ```

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


### Check if everything is installed correctly
- Start redisListener after updating the conf file of redis
- There has to be a method which pushes a redis shadow key (check octocore/callbacks.rb)
- To check if redisListener is catching those expired shadow keys run the following
  ```
  tail -f redisListener/shared/logs/redisListen.output
  ```
- This will print the keys as and when they're expired

