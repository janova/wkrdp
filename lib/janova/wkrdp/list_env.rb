class ListEnv

  def initialize(ec2, options)
    @ec2 = ec2
    @options = options
  end

  def run
    running_windows_instances = @ec2.describe_instances.select {|i| i[:aws_platform] == 'windows' && i[:aws_state] == 'running'}

    staging_instances = InstanceGroup.new(running_windows_instances).filter('worker_staging')
    demo_instances    = InstanceGroup.new(running_windows_instances).filter('worker_demo')
    qa_instances      = InstanceGroup.new(running_windows_instances).filter('worker_qa')
    preprod_instances = InstanceGroup.new(running_windows_instances).filter('worker_preprod')
    prod_instances    = InstanceGroup.new(running_windows_instances).filter('worker_production')

    case @options.list_env
    when 'staging'
      puts display_filter(staging_instances)
    when 'demo'
      puts display_filter(demo_instances)
    when 'qa'
      puts display_filter(qa_instances)
    when 'preprod'
      puts display_filter(preprod_instances)
    when 'production', 'prod'
      puts display_filter(prod_instances)
    end
  end

  def display_filter(instances)
    output = instances.map {|i| "#{i[:aws_instance_id].sub(/^i-/, '')}   #{i[:aws_launch_time].sub(/\.000Z/, '').sub(/T/, ' ')}   #{i[:private_ip_address].ljust(14)}   #{i[:ip_address].ljust(15)}    #{i[:aws_image_id]}" }
    output.join("\n")
  end
end
