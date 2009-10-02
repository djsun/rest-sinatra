# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rest-sinatra}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David James"]
  s.date = %q{2009-10-02}
  s.description = %q{Provides a DSL for making RESTful Sinatra actions with MongoMapper models.}
  s.email = %q{djames@sunlightfoundation.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "lib/rest-sinatra.rb",
     "rest-sinatra.gemspec",
     "spec/spec_helper.rb",
     "spec/unit/helpers/comments.rb",
     "spec/unit/helpers/posts.rb",
     "spec/unit/helpers/sinatra_stubs.rb",
     "spec/unit/helpers/sources.rb",
     "spec/unit/posts_and_comments_spec.rb",
     "spec/unit/sources_spec.rb"
  ]
  s.homepage = %q{http://github.com/djsun/rest-sinatra}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Easily write RESTful actions with Sinatra and MongoMapper}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/unit/helpers/comments.rb",
     "spec/unit/helpers/posts.rb",
     "spec/unit/helpers/sinatra_stubs.rb",
     "spec/unit/helpers/sources.rb",
     "spec/unit/posts_and_comments_spec.rb",
     "spec/unit/sources_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
