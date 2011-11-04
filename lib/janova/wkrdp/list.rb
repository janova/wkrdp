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
    qa_instances      = InstanceGroup.new(running_windows_instances).filter('worker_qa')
    preprod_instances = InstanceGroup.new(running_windows_instances).filter('worker_preprod')
    prod_instances    = InstanceGroup.new(running_windows_instances).filter('worker_production')

    output << "staging: #{staging_instances.length}\n"
    output << display_filter(staging_instances)
    output << "\ndemo: #{demo_instances.length}\n"
    output << display_filter(demo_instances)
    output << "\nqa: #{qa_instances.length}\n"
    output << display_filter(qa_instances)
    output << "\npreprod: #{preprod_instances.length}\n"
    output << display_filter(preprod_instances)
    output << "\nproduction: #{prod_instances.length}\n"
    output << display_filter(prod_instances)
    output << display_counts(staging_instances, qa_instances, demo_instances, preprod_instances, prod_instances)
    puts output
  end

  def display_counts(staging_instances, qa_instances, demo_instances, preprod_instances, prod_instances)
    output = "\n========= EC2 Worker Counts sponsored by RS =========\n"
    output << "    Staging: #{staging_instances.count.to_i}\n"
    output << "         QA: #{qa_instances.count.to_i}\n"
    output << "       Demo: #{demo_instances.count.to_i}\n"
    output << "    PreProd: #{preprod_instances.count.to_i}\n"
    output << "       Prod: #{prod_instances.count.to_i}\n"
  end

  def display_filter(instances)
    output = instances.map {|i| "#{i[:aws_instance_id].sub(/^i-/, '')}   #{i[:aws_launch_time].sub(/\.000Z/, '').sub(/T/, ' ')}   #{i[:private_ip_address].ljust(14)}   #{i[:ip_address].ljust(15)}" }
    output.join("\n")
  end
end
