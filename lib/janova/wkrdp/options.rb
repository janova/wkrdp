module Janova

  module Wkrdp

    class Options
      USAGE = <<ENDOFUSAGE
wkrdp: worker RDP
       Opens a remote desktop connection to an amazon worker.
Usage: wkrdp --list|-l || --conn|-c || --snap|-s --help|-h
Options:
--conn, -c : connect to instance id
--env,  -e : list worker instances of a given environment
--list, -l : list worker instances
--snap, -s : take snapshot of worker logs
--help, -h : show help
ENDOFUSAGE
      EXCLUSIVE_OPTS = [:@instance_id, :@list, :@snap_env, :@list_env]

      require 'getoptlong'

      attr_reader :instance_id, :list, :snap_env, :list_env

      def initialize(argv)
        @instance_id, @list = false
        opts = GetoptLong.new(
          [ '--conn', '-c', GetoptLong::REQUIRED_ARGUMENT ],
          [ '--snap', '-s', GetoptLong::REQUIRED_ARGUMENT ],
          [ '--env',  '-e', GetoptLong::REQUIRED_ARGUMENT ],
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
            when '--env'
              @list_env = arg
            end
          end
        rescue
          puts USAGE
          exit 1
        end
      end

      def validate
        exclusive_opts_count = EXCLUSIVE_OPTS.count{|o| instance_variable_get(o)}
        if exclusive_opts_count > 1
          raise ArgumentError, "You specified too more than one exclusive option. Specify only one."
        end
      end

    end

  end

end
