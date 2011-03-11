$LOAD_PATH.push File.join(File.dirname(__FILE__), 'janova', 'wkrdp') 
require 'app'
require 'options'
require 'rubygems'
require 'right_aws'
require 'list'
require 'log_snapshot'
require 'instance_group'

class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end
