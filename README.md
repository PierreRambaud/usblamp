# WebMail Notifier with Ruby (Dream Cheeky)

[![Build Status](https://travis-ci.org/PierreRambaud/usblamp.png?branch=master)](https://travis-ci.org/PierreRambaud/usblamp)

Ruby script to power the Dreamcheeky USB webmail notifier gadget. <http://www.dreamcheeky.com/webmail-notifier>

## Requirements

- Ruby 1.9.2 or newer

## Installation

Assuming RubyGems isn't down you can install the Gem as following:

```
$ gem install usblamp
```

## Usage

```
Usage: usblamp [COMMAND] [OPTIONS]

Options:

    -v, --version      Shows the current version
    -r, --red          Red
    -g, --green        Green
    -b, --blue         Blue
    -c, --color        Color
    -h, --help         Display this help message.

Available commands:

  fadein   Fade in effect
  blink    Blink effect
```

## Troubleshooting

Should be run as root unless the necessary udev rules are set.
Create the file `/etc/udev/rules.d/42-usblamp.rules`
And add this content by replacing `got` by your username:
```
SUBSYSTEM !="usb_device", ACTION !="add", GOTO="datalogger_rules_end"
SYSFS{idVendor} =="1d34", SYSFS{idProduct} =="0004", SYMLINK+="datalogger"
MODE="0666", OWNER="got", GROUP="root"
LABEL="datalogger_rules_end"
```

## Running tests

Install dependencies:

`$ bundle install`

To run tests:
`$ bundle exec rake`


