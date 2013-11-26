opg-lpa-api
===========

[![Build Status](https://travis-ci.org/ministryofjustice/opg-lpa-api.png?branch=master)](https://travis-ci.org/ministryofjustice/opg-lpa-api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/opg-lpa-api.png)](https://codeclimate.com/github/ministryofjustice/opg-lpa-api)
[![Coverage Status](https://coveralls.io/repos/ministryofjustice/opg-lpa-api/badge.png?branch=master)](https://coveralls.io/r/ministryofjustice/opg-lpa-api?branch=master)


## Local installation

### Install mongodb

E.g. on mac osx:
> brew install mongodb

### Clone repo and install gems
> git clone https://github.com/ministryofjustice/opg-lpa-api.git

> cd opg-lpa-api

> bundle

### Create indexes
> bundle exec rake db:mongoid:create_indexes

### Run tests
> bundle exec guard

### Run server
> auth_service_url=http://localhost:9393  bundle exec rackup -p 9292

