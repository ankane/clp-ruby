# Clp Ruby

[Clp](https://github.com/coin-or/Clp) - linear programming solver - for Ruby

[![Build Status](https://github.com/ankane/clp-ruby/workflows/build/badge.svg?branch=master)](https://github.com/ankane/clp-ruby/actions)

## Installation

First, install Clp. For Homebrew, use:

```sh
brew install clp
```

And for Ubuntu, use:

```sh
sudo apt-get install coinor-libclp1
```

Then add this line to your application’s Gemfile:

```ruby
gem "clp"
```

## Getting Started

*The API is fairly low-level at the moment*

Load a problem

```ruby
model =
  Clp.load_problem(
    sense: :minimize,
    start: [0, 3, 6],
    index: [0, 1, 2, 0, 1, 2],
    value: [2, 3, 2, 2, 4, 1],
    col_lower: [0, 0],
    col_upper: [1e30, 1e30],
    obj: [8, 10],
    row_lower: [7, 12, 6],
    row_upper: [1e30, 1e30, 1e30]
  )
```

Solve

```ruby
model.solve
```

Write the problem to an MPS file (requires Clp 1.17.2+)

```ruby
model.write_mps("hello.mps")
```

Read a problem from an MPS file

```ruby
model = Clp.read_mps("hello.mps")
```

## Reference

Set the log level [unreleased]

```ruby
model.solve(log_level: 4)
```

Set the time limit in seconds [unreleased]

```ruby
model.solve(time_limit: 30)
```

## History

View the [changelog](https://github.com/ankane/clp-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/clp-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/clp-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/clp-ruby.git
cd clp-ruby
bundle install
bundle exec rake test
```
