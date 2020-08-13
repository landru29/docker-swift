#! /bin/bash

function wait {
    HOST=`echo "$1" | sed -e "s/:.*//"`
    PORT=`echo "$1" | sed -e "s/.*://"`

    while [ 1 ]; do
        echo "trying to reach ${HOST}:${PORT} ..."
        nc -z ${HOST} ${PORT} 1>/dev/null 2>&1
        if [ $? != 0 ]; then
            echo "${HOST}:${PORT} not ready yet"
            sleep 5
            continue
        fi
        echo "Found ${HOST}:${PORT}"
        break
    done
}

wait keystone:35357


echo "**** CREATE A USER ****"
curl -X POST \
     -H "X-Auth-Token:7a04a385b907caca141f" \
     -H "Content-type: application/json" \
     -d '{"user":{"name":"sea-race","email":"sea-race@gmail.com","enabled":true,"password":"sea-race"}}' \
     "http://keystone:35357/v3/users"


echo "**** CONNECT USER ****"
curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "sea-race",
          "domain": { "id": "default" },
          "password": "sea-race"
        }
      }
    }
  }
}' \
  "http://keystone:5000/v3/auth/tokens" ; echo
