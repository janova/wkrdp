class InstanceIdentifier

  # Return a uniquely identified instance, or raise an ArgumentError.
  def self.find_unique(ec2, id)
    instance = ec2.describe_instances.select {|i| i[:aws_instance_id] =~ /^i-#{id}/}
    if instance.size > 1
      raise ArgumentError, "Ambiguous aws_instance_id. Exiting."
    end
    if instance.size < 1
      raise ArgumentError, "aws_instance_id not found. Exiting."
    end
    instance.first
  end

end
