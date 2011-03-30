class LogSnapshot

  WORKER_ENVIRONMENTS = %w(staging demo preprod production)

  def initialize(ec2, options)
    @ec2 = ec2
    @options = options
  end

  def run
    output = ''
    running_windows_instances = @ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}
    if WORKER_ENVIRONMENTS.include?(@options.snap_env)
      instances = InstanceGroup.new(running_windows_instances).filter("worker_#{@options.snap_env}")
      date = date_for_filename
      instances.each do |i| 
        copy_log_for_instance_dated(i, date)
        output << add_output_message(i, date)
      end
    else
      i = InstanceIdentifier.find_unique(@ec2, @options.snap_env)
      date = date_for_filename
      copy_log_for_instance_dated(i, date)
      output << add_output_message(i, date)
    end
    puts output
  end

  def add_output_message(i, date)
    "#{i[:aws_instance_id][/^i-(.*)/, 1]}'s log copied to #{addressed_dated_filename(i[:ip_address], date)}.\n"
  end

  def copy_log_for_instance_dated(i, date)
    Net::SCP.start(i[:dns_name], 'Administrator', {:keys => [ENV['BRIANL_SSH_KEY_PATH']]}) do |scp|
      scp.download!("/c/shared/log/worker.log", addressed_dated_filename(i[:ip_address], date))
    end
  end

  def addressed_dated_filename(address, date=nil)
    "#{date ? date : date_for_filename}--#{address}.log"
  end

  def date_for_filename
    Time.now.strftime("%Y%m%d-%H%M%S")
  end

end
