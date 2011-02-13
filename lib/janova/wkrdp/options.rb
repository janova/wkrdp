module Janova
  
  module Wkrdp
  
    class Options
      USAGE = <<ENDOFUSAGE
wkrdp: worker RDP
       Opens a remote desktop connection to an amazon worker.
Usage: wkrdp --list|-l || --conn|-c || --help|-h
Options:
--conn, -c : connect to instance id
--list, -l : list worker instances
--help, -h : show help
ENDOFUSAGE

      require 'getoptlong'

      attr_reader :instance_id, :list

      def initialize(argv)
        @instance_id, @list = false
        opts = GetoptLong.new(
          [ '--conn', '-c', GetoptLong::REQUIRED_ARGUMENT ],
          [ '--list', '-l', GetoptLong::NO_ARGUMENT ],
          [ '--help', '-h', GetoptLong::NO_ARGUMENT ]
        )
        begin
          opts.each do |opt, arg|
            case opt
            when '--help'
              puts USAGE
              exit 0
            when '--conn'
              @instance_id = arg
            when '--list'
              @list = true
            end
          end
        rescue
          puts USAGE
          exit 1
        end
        if @instance_id && @list
          puts "--conn and --list are exclusive options. Choose only one."
          puts USAGE
          exit 1
        end
      end
    
    end

  end

end