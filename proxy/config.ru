require 'sinatra/base'
require 'redis'
require File.expand_path('../src/writer', __FILE__)

run Writer
