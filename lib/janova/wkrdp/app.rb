module Janova
  module Wkrdp
    class App

      def initialize(*argv)
        @options = Options.new(argv)    
        @access_key_id = ENV['AWS_ACCESS_KEY_ID']
        @secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        if @access_key_id.nil? || @secret_access_key.nil?
          puts 'AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY environment variables not set. Exiting.'
          exit 1
        end
      end
    
      def run
        ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key)
        puts 'wkrdp:'
        if @options.list
          puts "Here is a list of worker instances."
          running_windows_instances = ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}
          preprod_instances = running_windows_instances.select {|i| i[:aws_groups].include? 'preprod'}
          prod_instances = running_windows_instances.select {|i| i[:aws_groups].include? 'worker_production'}
          puts "preprod:"
          preprod_instances.each {|i| puts "#{i[:aws_instance_id]} #{i[:aws_launch_time]} #{i[:dns_name]}"}
          puts "production:"
          prod_instances.each {|i| puts "#{i[:aws_instance_id]} #{i[:aws_launch_time]} #{i[:dns_name]}"}
          exit 0
        end
        if @options.instance_id
          instance = ec2.describe_instances.select {|i| i[:aws_instance_id] =~ /^#{@options.instance_id}/}
          if instance.size > 1
            puts "Ambiguous aws_instance_id. Exiting."
            exit 1
          end
          if instance.size < 1
            puts "aws_instance_id not found. Exiting."
            exit 1
          end
          instance = instance.first
          command = "open rdp://administrator:esacegde@#{instance[:dns_name]}"
          puts "Here is the string to connect to your worker."
          puts command
          exec(command) if fork == nil
          Process.wait
          exit 0
        end
      end 
    end
  end
end

