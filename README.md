# Wolox on Rails - Batchifier
[![Gem Version](https://badge.fury.io/rb/wor-batchifier.svg)](https://badge.fury.io/rb/wor-batchifier)
[![Dependency Status](https://gemnasium.com/badges/github.com/Wolox/wor-batchifier.svg)](https://gemnasium.com/github.com/Wolox/wor-batchifier)
[![Build Status](https://travis-ci.org/Wolox/wor-batchifier.svg)](https://travis-ci.org/Wolox/wor-batchifier)
[![Code Climate](https://codeclimate.com/github/Wolox/wor-batchifier/badges/gpa.svg)](https://codeclimate.com/github/Wolox/wor-authentication)
[![Test Coverage](https://codeclimate.com/github/Wolox/wor-batchifier/badges/coverage.svg)](https://codeclimate.com/github/Wolox/wor-batchifier/coverage)

Gem that allows you to easily divide requests that send a lot of information into several requests with smaller chunks of data, taking care of the response from each one and providing it joint together based on different strategies for parsing said response.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wor-batchifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wor-batchifier

## Usage

### Basic use:

The first step is to define a parent controller from which all other controllers will have to extend to have access to the batchifier's methods. So, let's do that in our `ApplicationController.rb`:

```ruby
class ApplicationController < ActionController::Base
  include Wor::Batchifier
end
```

You can also include the batchifier just in the controllers you intend to use it in.

The final step, is to find any request you wish to perform with smaller chunks of data and utilize the batchifier's methods to divide it into smaller tasks.

For example, let's pretend we have an endpoint called bulk_request that communicates with a third API and sends a lot of information to be utilized.

```ruby
def bulk_request
  ThirdAPI.bulk_request(params[:information])
end
```

Now we will partition that request into chunks using the batchifier:

```ruby
def bulk_request
  execute_in_batches(params[:information], batch_size: 100, strategy: :add) do |chunks|
    ThirdAPI.bulk_request(chunks)
  end
end
```

The batchifier will take three parameters, the first one being the information that needs to be partitioned, then the batch_size we wish to utilize and finally the symbol of the strategy that will be implemented on the response of each batch.

### Available strategies

- Add: For each request, it joins together each response no matter the result.
- Maintain-Unique: It will only add the results that are not present already in the response.
- No-Response: It will not provide any response whatsoever.

### Adding new strategies

Should you desire to add new strategies, it's as simple as creating a new class and defining a method called `merge_strategy` which will hold the logic that will be implemented to parse the response. Let's look at an example:

```ruby
module Wor
  module Batchifier
    class MaintainUnique < Strategy
      def merge_strategy(response,memo)
        return response.merge(memo) { |_, v1, _| v1 }
      end
    end
  end
end
```

The `merge_strategy` will receive two parameters, the first being "response" which is the total response which will be returned from `execute_in_batches`, and "memo" is the recursive response from each batch that will be added to response in each iteration. If you want to merge or do something else entirely, you have the option to do so.

All strategies have a `base_case` which by default is `{}` but if you wish to override it, you can define your own in your strategy by simply adding a method called `base_case` which should return the value you desire for your own personal case.

```ruby
def base_case
 # Your base value for your batches.
end
```

The new class that will hold the method `merge_strategy` should inherit the class `Strategy`. If the strategy doesn't define the method, an exception will be raised when trying to utilize it
warning that it does not respect the contract set by the `Strategy` Interface.

You can also define a merge strategy via `Proc`, without the need of creating a new class. The `Proc` should receive two parameters: the first being "response" and the second one being "memo", both of which work the same way as they do when you create a class and define its `merge strategy`. All `Procs` have `{}` as their base case which cannot be changed. Let's look at an example:

```ruby
merge_strategy = Proc.new do |response, memo|
  memo = [] if memo.empty?
  memo + response
end

execute_in_batches(collection, batch_size: 10, strategy: merge_strategy) do |chunk|
  ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## About ##

This project is maintained by [Diego Raffo](https://github.com/enanodr) along with [Pedro Jara](https://github.com/redwarewolf) and it was written by [Wolox](http://www.wolox.com.ar).
![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**wor-batchifier** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/wor-batchifier/master/LICENSE.md).

    Copyright (c) 2017 Wolox

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
