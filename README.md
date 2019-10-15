# nginx-ruby

[![Docker Hub](https://img.shields.io/docker/cloud/automated/khoanguyent/nginx-ruby?style=for-the-badge)](https://hub.docker.com/r/khoanguyent/nginx-ruby)

## Docker Image Contents

* Nginx
* Ruby
* Unicorn

## Usage

This Docker image is intended to be used to build Ruby web applications, proxied by Nginx and served by Unicorn.

Your Ruby application should be copied into `/app`, with a configured `config.ru` file.
If you wish to replace the unicorn.rb file with your own, it is located at `/unicorn/unicorn.rb`

## Example

There is an example available under the `examples` subdirectory.

