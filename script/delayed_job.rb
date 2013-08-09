#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))
require 'delayed/command'
Delayed::Command.new(ARGV).daemonize

class RecurringJob 
  include Jobs::ScheduledJob
 
#run_every 1.minutes
 
  def perform
    puts "perform job"
    
    log = ContactLog.new
    log.contactid = 1
    log.contactname = "Test"
    log.logdate = Time.now
    log.created_at = Time.now
    log.updated_at = Time.now
    log.save
    
  end
end

rj = RecurringJob.new
rj.perform
