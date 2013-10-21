# Gemfile
require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/reloader"
require "slim"
require File.dirname(__FILE__) + "/app.rb"

also_reload File.dirname(__FILE__) + "/app.rb"

set :run, false
set :raise_errors, true

run Sinatra::Application