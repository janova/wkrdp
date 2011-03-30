module Janova
  module Wkrdp
    class App

      attr_reader :ssh_key

      def initialize(*argv)
        @options           = Options.new(argv)
        @log               = Logger.new(STDOUT)
        @log.level         = Logger::WARN
        @access_key_id     = ENV['AMAZON_ACCESS_KEY_ID']
        @secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
        @worker_password   = ENV['WORKER_PASSWORD']
        @ssh_key           = ENV['BRIANL_SSH_KEY_PATH']
      end

      def validate_environment_variables
        if @access_key_id.nil? || @secret_access_key.nil? || @worker_password.nil? || @ssh_key.nil?
          raise ArgumentError, "AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY, WORKER_PASSWORD, or BRIANL_SSH_KEY_PATH environment variable(s) not set. Exiting."
        end
      end

      def run
        validate_environment_variables
        @options.validate
        ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :logger => @log)
        if @options.list
          list = List.new(ec2, @options)
          list.run
          exit 0
        end
        if @options.instance_id
          instance = InstanceIdentifier.find_unique(ec2, @options.instance_id)
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

