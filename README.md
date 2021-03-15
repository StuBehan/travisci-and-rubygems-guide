# A guide for setting up your repo for use with Travis CI [![Build Status](https://travis-ci.com/StuBehan/guides.svg?branch=main)](https://travis-ci.com/StuBehan/guides)

Travis is a Continuous Integration(CI) platform that automatically builds and tests your repos.

More info [here](https://docs.travis-ci.com/user/for-beginners/). You'll need to login through github [here](https://travis-ci.com/)

To integrate travis with a ruby repo we're gonna need a few things:
* Some `ruby code` to test.
* A test suite, we're mostly using `RSpec` so lets do that.
* Some kind of automation tool to tell TravisCI what to do on the build, we'll use `rake`.

## Gemfile & Gemfile.lock

Lets start with our `Gemfile`, `touch Gemfile`, `Gemfile.lock` is genereated automatically when bundle is run.

More on `Gemfile` [here](https://bundler.io/man/gemfile.5.html).

inside we need to add the following: 

```
source 'https://rubygems.org'

gem 'rake'
gem 'rspec'

```

run `bundle install`, you'll see `Gemfile.lock` appear now.

Travis runs your code on a virtual machine running Unbuntu which is a linux distro, so we need to add this to the platforms list or it wont work

run `bundle lock --add-platform x86_64-linux`

In the Gemfile.lock we can see it has been added: 

```
PLATFORMS
  x64-mingw32
  x86_64-linux
```
## RSpec 

Run RSpec with `rspec --init`, this will create the `./spec/ folder`, `.rspec` and `spec_helper.rb`.

## Rake

Rake is an automation tool for ruby, there is a lot you can do with it but we will be just using it to run RSpec for now, for the purposes of making TravisCI work. You can find out more about rake [here](https://github.com/ruby/rake).

Create a `Rakefile`, `touch Rakefile`.

We want to automate RSpec:

```
require 'rspec/core/rake_task'

task :default do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/*_spec.rb'
  end
  Rake::Task["spec"].execute
end
```

If you're like me and you prefer the RSpec to display in the comment style when ran, instead of the dots, add `--color --format documentation` to your .rspec file:

```
--require spec_helper
--color --format documentation
```
You can run `rake` instead of `rspec` now and it does the same thing!

## Travis CI 

To get travis to look at our repo and run it we need to tell it a few things.

Start with `touch .travis.yml`.

Populate it as follows, with whatever ruby version you are using:

```
language: ruby
rvm:
 - 2.6.6
```

Once this is in, stage everything and then commit and push. Head over to [TravisCI](https://travis-ci.com/) and the repo will get automatically tested, errors will show as they do in terminal.

# Some other gems you might want 

## Run rubocop with auto-correct after each RSpec 

Add `rubocop` to your `Gemfile`

```
gem 'rubocop', '1.11.0'
```
Run `bundle install`, in your `Rakefile`, to the top of the file add:
```
require 'rubocop/rake_task'
```

And add the following inside your default task: 
```
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--auto-correct']
  end
  Rake::Task["rubocop"].execute
```
Now when you run `rake` it will also auto-correct the simpler/formatting errors! Rubocop will only run with a successful set of tests from rspec.

A good thing to add for rubocop is a config file called `.rubocop.yml`, so touch `touch .rubocop.yml` and we'll need to populate it, the easiest way is to make use of the Makers academy [scaffolint](https://github.com/makersacademy/scaffolint) file for rubocop:

Add this to your `.rubocop.yml`:
```
inherit_from:
  - https://raw.githubusercontent.com/makersacademy/scaffolint/v1.1.0/.rubocop.yml
```

Now this breaks for me, it says some of the cop names have changed or been removed, I copied the cops from this sauce and changed/removed the obsolete ones. Feel freel to copy my .yml.

## Simplecov - ideal for TDD apps

Like we've seen in the projects, it's beneficial to see how much of your code is actually tested by your tests. Add simplecov to any repo:

In the `Gemfile`:
```
gem 'simplecov'
gem 'simplecov-console'
```
Run `bundle install` and then in the top of your `rspec_helper.rb`:
```
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::Console,
  # Want a nice code coverage website? Uncomment this next line!
  # SimpleCov::Formatter::HTMLFormatter
])
SimpleCov.start
```

Finally, add the directory `/coverage` to `.gitignore`.

And now after successful rspec test suite, simplecov will tell you your test coverage.