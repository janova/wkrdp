class LogSnapshot

  def initialize(ec2, options)
    @ec2 = ec2
    @options = options
  end

  def run
    output = ''
    running_windows_instances = @ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}

    instances = InstanceGroup.new(running_windows_instances).filter("worker_#{@options.snap_env}")

    remote_commands = instances.map{|i| "ssh -i #{ENV['BRIANL_SSH_KEY_PATH']} -l Administrator #{i[:dns_name]} '/usr/bin/cat /cygdrive/c/shared/log/worker.log'"}
    remote_commands.each{|c| output << %x{#{c}} }

    puts output
  end

end
