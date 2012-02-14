# loc_counter [![Build Status](https://secure.travis-ci.org/7even/loc_counter.png)](http://travis-ci.org/7even/loc_counter)

`loc_counter` is a command-line tool for measuring LOC (line-of-code) count in your Ruby project or some set of arbitrary Ruby source files.

## Installation

``` bash
gem install loc_counter
```

## Usage

The gem install a single executable `loc_counter`.

### On a project

If you want to count LOCs in your Rails app or in a gem, you can just pass a path to that project's directory to `loc_counter`:

``` bash
$ loc_counter /path/to/project
48 files processed
Total     1826 lines
Empty     331 lines
Comments  372 lines
Code      1123 lines
```

In 'project mode' it scans `app`, `bin`, `config`, `lib` and top-level directories of your project, processing the following files:

- `Capfile`
- `Gemfile`
- `Rakefile`
- `*.gemspec`
- `*.rake`
- `*.rb`
- `*` in `bin` directory

### On arbitrary files

You can also give `loc_counter` any files you want to measure.

``` bash
$ loc_counter ~/*.rb              
5 files processed
Total     118 lines
Empty     27 lines
Comments  4 lines
Code      87 lines
```

## Contributing

If you want to contribute to the project, fork the repository, push your changes to a topic branch and send me a pull request.

`loc_counter` is tested under MRI `1.8.7`, `1.9.2` and `1.9.3`. If something is working incorrectly or not working at all in one of these environments, this should be considered a bug. Any bug reports are welcome at Github issues.