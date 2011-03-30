class LogSnapshot

  WORKER_ENVIRONMENTS = %w(staging demo preprod production)

  def initialize(ec2, options)
    @ec2 = ec2
    @options = options
  end

  def run
    output = ''
    running_windows_instances = @ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}
    remote_commands = []
    if WORKER_ENVIRONMENTS.include?(@options.snap_env)
      instances = InstanceGroup.new(running_windows_instances).filter("worker_#{@options.snap_env}")
      remote_commands = instances.map{|i| "ssh -i #{ENV['BRIANL_SSH_KEY_PATH']} -l Administrator #{i[:dns_name]} '/usr/bin/cat /cygdrive/c/shared/log/worker.log'"}
    else
      i = InstanceIdentifier.find_unique(@ec2, @options.snap_env)
      remote_commands << "ssh -i #{ENV['BRIANL_SSH_KEY_PATH']} -l Administrator #{i[:dns_name]} '/usr/bin/cat /cygdrive/c/shared/log/worker.log'"
    end
    remote_commands.each{|c| output << %x{#{c}} }
    puts output
  end

end
