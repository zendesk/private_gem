# Private Gem [![Build Status](https://travis-ci.org/zendesk/private_gem.png)](https://travis-ci.org/zendesk/private_gem)

 - rake tasks for building and pushing gems to a private gem server, with added protection against pushing to rubygems.org
 - generator for creating new private gems


## Rake Tasks

```ruby
# Rakefile
require 'private_gem/tasks'
```

 * `rake build` build a local `.gem` file
 * `rake install` build and install the local gem
 * `rake release` tag and push gem to private gem server

(Based on the tasks from `bundler/gem_tasks`)


## Private Gem Generator

```bash
private_gem new my_private_library
   create  my_private_library/Gemfile
   create  my_private_library/Rakefile
   create  my_private_library/README.md
   ...
```

Generates a new local gem called `my_private_library` with the `private_gem` Rake tasks preinstalled.


## License

Copyright 2014 Zendesk

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at

www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
