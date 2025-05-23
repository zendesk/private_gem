# Private Gem

 - rake tasks for building and pushing gems to a private gem server, with added protection against pushing to rubygems.org
 - generator for creating new private gems

## Rake Tasks

```ruby
# Rakefile
require 'private_gem/tasks'
```

 * `rake build` build a local `.gem` file
 * `rake install` build and install the local gem

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. run `bundle lock` to update `Gemfile.lock`,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/private_gem/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/private_gem/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.

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
