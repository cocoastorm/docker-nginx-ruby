FROM alpine:3

ARG NGINX_VER=1.16.1
ARG RUBY_VER=2.6.5

LABEL description="nginx + unicorn + ruby image based on Alpine" \
      maintainer="Khoa Nguyen <khoa.tan.nguyen.96@gmail.com>" \
      nginx_version="nginx v$NGINX_VER built from source" \
      ruby_version="ruby v$RUBY_VER built from source"

ENV UID=991 GID=991

ARG NGINX_CONF="\
  --prefix=/nginx \
  --sbin-path=/usr/local/sbin/nginx \
  --http-log-path=/nginx/logs/access.log \
  --error-log-path=/nginx/logs/error.log \
  --pid-path=/nginx/run/nginx.pid \
  --lock-path=/nginx/run/nginx.lock \
  --with-threads \
  --with-file-aio \
  --without-http_geo_module \
  --without-http_autoindex_module \
  --without-http_split_clients_module \
  --without-http_memcached_module \
  --without-http_empty_gif_module \
  --without-http_browser_module"

ARG RUBY_CONF="\
  --disable-install-doc \
  --disable-install-rdoc \
  --disable-install-capi"

ARG BUILD_DEPS=" \
  linux-headers \
  libtool \
  build-base \
  pcre-dev \
  zlib-dev \
  wget \
  gnupg \
  autoconf \
  gcc \
  g++ \
  libc-dev \
  make \
  pkgconf \
  curl-dev"

COPY rootfs /

RUN apk -U add \
   ${BUILD_DEPS} \
   ca-certificates \
   openssl \
   openssl-dev \
   s6 \
   su-exec \
   curl \
   pcre \
   zlib \
  && mkdir -p /usr/src \
  && NB_CORES=$(getconf _NPROCESSORS_CONF) && RUBY_VER_ONE=$(echo $RUBY_VER | cut -d. -f1-2) \
  && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
  && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
  && wget https://cache.ruby-lang.org/pub/ruby/${RUBY_VER_ONE}/ruby-${RUBY_VER}.tar.gz -O /tmp/ruby-${RUBY_VER}.tar.gz \
  && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
  && tar xzf /tmp/ruby-${RUBY_VER}.tar.gz -C /usr/src \
  # Build NGINX
  && cd /usr/src/nginx-${NGINX_VER} \
  && ./configure --with-cc-opt="-O3 -fPIE -fstack-protector-strong" ${NGINX_CONF} \
  && make -j ${NB_CORES} \
  && make install \
  # Build Ruby
  && cd /usr/src/ruby-${RUBY_VER} \
  && ./configure ${RUBY_CONF} \
  && make -j ${NB_CORES} \
  && make install \
  && gem install unicorn \
  && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
  && apk del ${BUILD_DEPS} \
  && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
  && mkdir -p /nginx/logs /nginx/run /unicorn/logs /unicorn/run

CMD ["run.sh"]

EXPOSE 8080

