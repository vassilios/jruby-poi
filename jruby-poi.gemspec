require File.expand_path("../lib/poi/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "jruby-poi"

  s.version = POI.version
  s.authors = ["Scott Deming", "Jason Rogers"]
  s.date = "2016-11-04"
  s.description = "A rubyesque library for manipulating spreadsheets and other document types for jruby, using Apache POI."
  s.email = ["sdeming@makefile.com", "jacaetevha@gmail.com"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = `git ls-files -z`.split("\0")
  s.files += Dir['lib/**/*.jar']
  s.test_files = `git ls-files -z spec/`.split("\0")
  s.homepage = "http://github.com/kameeoze/jruby-poi"
  s.licenses = ["Apache"]

  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Apache POI class library for jruby"

  s.requirements << 'jar org.apache.poi, poi, 5.2.3'
  s.requirements << 'jar org.apache.poi, poi-ooxml, 5.2.3'
  s.requirements << 'jar org.apache.logging.log4j, log4j-core, 2.18.0'

  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("jar-dependencies", "~> 0.4.0")
  s.add_development_dependency("ruby-maven", "~> 3.3.11")
end
