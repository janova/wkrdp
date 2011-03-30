require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.platform          = Gem::Platform::RUBY
    s.name              = 'wkrdp'
    s.summary           = 'Worker Remote Desktop Protocol'
    s.description       = ''
    s.homepage          = 'http://www.digitalphenom.com'
    s.rubyforge_project = 'N/A'
    s.version           = '0.4'
    s.author            = 'Anthony Carlos'
    s.email             = 'anthony @nospam@ janova.us'
    s.files             = FileList['lib/**/*.rb'].to_a
    s.require_path      = 'lib'
    s.test_files        = Dir.glob('spec/*.rb')
    s.has_rdoc          = true
    s.extra_rdoc_files  = [ 'README' ]
    s.executables       = [ 'wkrdp' ]
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "Generated latest version."
end
