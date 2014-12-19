# Private Gem

`private_gem` serves two purposes:

1. It provides rake tasks for building and pushing private gems to a private gem server. These tasks are based on the tasks in Bundler but with added protection against accidental pushes to rubygems.org.
2. It comes with a generator for creating skeletons for new private gems.

## The Rake Tasks

`private_gem` includes Rake tasks you can use to build, install, and push your private gem to a private gem server.
The tasks are based on the ones that come with Bundler.

You can install the tasks in your `Rakefile` like this:

```ruby
require 'private_gem/tasks'

```

This will provide 3 rake tasks:
 * `build` will build a local `.gem` file.
 * `install` will build and install the local gem.
 * `release` will tag and push your gem to your private gem server.

## The Private Gem Generator

`private_gem` comes with a generator you can use for making new private gems.

```
~ private_gem new my_private_library
   create  my_private_library/Gemfile
   create  my_private_library/Rakefile
   create  my_private_library/README.md
   create  my_private_library/.gitignore
   create  my_private_library/my_private_library.gemspec
   create  my_private_library/lib/my_private_library.rb
   create  my_private_library/lib/my_private_library/version.rb
   create  my_private_library/test/minitest_helper.rb
   create  my_private_library/test/test_my_private_library.rb
   create  my_private_library/.travis.yml
~
```

This will generate a new gem called `my_private_library` with the `private_gem` Rake tasks preinstalled.

## License
Copyright 2014 Zendesk

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at

www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
