## About

With rest-sinatra, success is all but guaranteed in writing RESTful Web Services. (Provided that you are using a [Sinatra](http://sinatrarb.com) + [MongoMapper](http://github.com/jnunemaker/mongomapper) stack.)

## Installation

It might not be a bad idea to make sure you are running the latest RubyGems:

    sudo gem update --system

I recommend a user-level install (no sudo needed):

    gem install djsun-rest-sinatra
    
Note: in general, beware of `sudo gem install <project_name>` -- it gives elevated privileges. Do you trust `<project name>`? Better to be safe and use a local install to `~/.gem`.

## Usage

For a basic example of what this looks like when integrated into a real-world Sinatra app, see [sources.rb](http://github.com/sunlightlabs/datacatalog-api/blob/master/controllers/sources.rb). For an example of nested resources, see [users.rb](http://github.com/sunlightlabs/datacatalog-api/blob/master/controllers/users.rb) and [users_keys.rb](http://github.com/sunlightlabs/datacatalog-api/blob/master/controllers/users_keys.rb).

## History

This code was extracted from the [National Data Catalog](http://groups.google.com/group/datacatalog), a project of the [Sunlight Labs](http://sunlightlabs.com).
