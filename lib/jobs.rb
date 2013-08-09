module Jobs
  module ScheduledJob
    def self.included(base)
      puts "WORK !!!"
      base.extend(ClassMethods)
    end

    def perform_with_schedule
      Delayed::Job.enqueue self, 0, self.class.schedule.from_now.getutc
      perform_without_schedule
    end

    module ClassMethods
      def method_added(name)
        if name.to_s == "perform" && !@redefined
          @redefined = true
          alias_method_chain :perform, :schedule
        end
      end

      def schedule
        @schedule
      end

      def run_every(time)
        @schedule = time
      end
    end

  end

  class RecurringJob
    include Jobs::ScheduledJob

    def runjob
      #puts "perform job"

      log = ContactLog.new
      log.contactid = 1
      log.contactname = "Test"
      log.logdate = Time.now
      log.created_at = Time.now
      log.updated_at = Time.now
      log.save

    end
  end

end

