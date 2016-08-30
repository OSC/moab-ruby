# Moab

Ruby wrapper for the Moab binaries. It uses the XML output of Moab for easy
parsing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moab'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install moab
```

## Usage

This gem provides a simple interface to the Moab binaries returning the results
in XML format. You first need to define a scheduler server:

```ruby
require 'moab'

# Define a scheduler server using the default environment
oakley = Moab::Scheduler.new(host: 'oak-batch.osc.edu')

# Define a scheduler server with custom environment
oakley = Moab::Scheduler.new(
  host: 'oak-batch.osc.edu',
  lib: '/opt/moab/lib',
  bin: '/opt/moab/bin',
  moabhomedir: '/var/spool/moab'
)
```

You can now call any Moab binaries for this given scheduler server:

```ruby
# Get all reservations
xml = oakley.call('mrsvctl', '-q', 'ALL')
#=> #(Document:...)

# Parse the given XML using Nokogiri methods
xml.xpath("//rsv").map { |x| x.xpath("@Name").to_s }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/moab/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
