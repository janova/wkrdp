module Janova

  module Wkrdp

    class Options
      USAGE = <<ENDOFUSAGE
wkrdp: worker RDP
       Opens a remote desktop connection to an amazon worker.
Usage: wkrdp --list|-l || --conn|-c || --snap|-s --help|-h
Options:
--conn, -c : connect to instance id
--list, -l : list worker instances
--snap, -s : take snapshot of worker logs
--help, -h : show help
ENDOFUSAGE

      require 'getoptlong'

      attr_reader :instance_id, :list, :snap_env

      def initialize(argv)
        @instance_id, @list = false
        opts = GetoptLong.new(
          [ '--conn', '-c', GetoptLong::REQUIRED_ARGUMENT ],
          [ '--snap', '-s', GetoptLong::REQUIRED_ARGUMENT ],
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
            when '--snap'
              @snap_env = arg
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
