class InstanceGroup

  def initialize(instances)
    @instances = instances
  end

  def filter(security_group)
    @instances.select {|i| i[:aws_groups].include? security_group }
  end

end
