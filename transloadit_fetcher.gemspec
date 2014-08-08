Gem::Specification.new do |s|
  s.name        = 'transloadit_fetcher'
  s.version     = '0.0.2'
  s.date        = '2014-08-06'
  s.summary     = "Simplifies the process of integrating with Transloadit for local development"
  s.description = "If you're using Transloadit with the callback URL options, this gem will fetch assemblies from Transloadit periodically and post them to your local environment allowing for substantially easier development."
  s.authors     = ["Ben McFadden"]
  s.email       = 'ben@forgeapps.com'
  s.files       = Dir.glob("bin/**/*") + Dir.glob("lib/**/*") + %w(LICENSE Readme.md)
  s.homepage    = 'https://github.com/ForgeApps/Transloadit_Fetcher'
  s.license     = 'MIT'
  s.executables << 'transloadit_fetcher'
  s.add_runtime_dependency "transloadit","~> 1.1"  
  s.add_runtime_dependency "trollop"
end