module Janova
  module Wkrdp
    class App

      attr_reader :ssh_key

      def initialize(*argv)
        @options = Options.new(argv)
        @log = Logger.new(STDOUT)
        @log.level = Logger::WARN
        # TODO: Change environment variables to AMAZON_ACCESS_KEY_ID
        # and AMAZON_SECRET_ACCESS_KEY for compatibility with 
        # the official amazon-ec2 gem.
        @access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
        @secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
        @worker_password = ENV['WORKER_PASSWORD']
        @ssh_key = ENV['BRIANL_SSH_KEY_PATH']
        if @access_key_id.nil? || @secret_access_key.nil? || @worker_password.nil? || @ssh_key.nil?
          puts 'AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY, WORKER_PASSWORD, or BRIANL_SSH_KEY_PATH environment variable(s) not set. Exiting.'
          exit 1
        end
      end

      def run
        ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :logger => @log)
        if @options.list
          list = List.new(ec2, @options)
          list.run
          exit 0
        end
        if @options.instance_id
          instance = ec2.describe_instances.select {|i| i[:aws_instance_id] =~ /^i-#{@options.instance_id}/}
          if instance.size > 1
            puts "Ambiguous aws_instance_id. Exiting."
            exit 1
          end
          if instance.size < 1
            puts "aws_instance_id not found. Exiting."
            exit 1
          end
          instance = instance.first
          command = "open rdp://administrator:#{@worker_password}@#{instance[:dns_name]}"
          puts "Here is the string to connect to your worker."
          puts command
          exec(command) if fork == nil
          Process.wait
          exit 0
        end
        if @options.snap_env
          log_snapshot = LogSnapshot.new(ec2, @options)
          log_snapshot.run
          exit 0
        end
      end 
    end
  end
end

