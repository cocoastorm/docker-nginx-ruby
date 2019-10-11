#!/bin/sh
for dir in /unicorn /unicorn/logs /nginx /nginx/logs /tmp /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    chown -R $UID:$GID $dir 
  fi
done

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d

