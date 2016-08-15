$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'attendease_sdk'
require 'active_support/all'
Dir["../attendease_sdk/lib/attendease_sdk/admin/*.rb"].each {|file| require file }
Dir["../attendease_sdk/lib/attendease_sdk/event/*.rb"].each {|file| require file }
Dir["../attendease_sdk/lib/attendease_sdk/organization/*.rb"].each {|file| require file }
