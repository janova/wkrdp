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
        puts 'wkrdp:'
        if @options.list
          puts "Here is a list of worker instances."
          exit 0
        end
        if @options.instance_id
          puts "Here is the string to connect to your worker."
          exit 0
        end
      end 
    end
  end
end

