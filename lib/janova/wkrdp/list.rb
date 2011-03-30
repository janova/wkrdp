class List

  def initialize(ec2, options)
    @ec2 = ec2
    @options = options
  end

  def run
    output = "Here is a list of worker instances.\n"
    running_windows_instances = @ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}

    staging_instances = InstanceGroup.new(running_windows_instances).filter('worker_staging')
    demo_instances    = InstanceGroup.new(running_windows_instances).filter('worker_demo')
    preprod_instances = InstanceGroup.new(running_windows_instances).filter('worker_preprod')
    prod_instances    = InstanceGroup.new(running_windows_instances).filter('worker_production')

    output << "staging:\n"
    output << display_filter(staging_instances)
    output << "\ndemo:\n"
    output << display_filter(demo_instances)
    output << "\npreprod:\n"
    output << display_filter(preprod_instances)
    output << "\nproduction:\n"
    output << display_filter(prod_instances)
    puts output
  end

  def display_filter(instances)
    output = instances.map {|i| "#{i[:aws_instance_id].sub(/^i-/, '')}   #{i[:aws_launch_time].sub(/\.000Z/, '').sub(/T/, ' ')}   #{i[:private_ip_address].ljust(14)}   #{i[:ip_address].ljust(15)}" }
    output.join("\n")
  end
end
