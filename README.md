# Colenso Documents

## Requirements

In addition to the [standard requirements for Ruby on Rails](http://guides.rubyonrails.org/getting_started.html#installing-rails)
you will need a copy of the [BaseX database engine](http://basex.org/).

Make sure you install dependencies with `bundle install`.

## Setup

Before running a local server you will need to start a BaseX server on port 1984 (for development/test environments)
or 15005 (for the production environment). You can then start the server using `bundle exec rails server`.

The `openshift` branch contains database seed data (documents provided for the assignment) for you to use if you wish.
To add this to the database, run `git checkout openshift && ruby db/seeds.rb`.
