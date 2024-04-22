#!/bin/bash

cp /home/user/new_user.sql /tmp

sed -i -e "s/NAME/$1/g" /tmp/new_user.sql

echo user | sudo -i -u  postgres psql -c "\i /tmp/new_user.sql"
