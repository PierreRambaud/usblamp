#WebMail Notifier with python (Dream Cheeky)

[![Build Status](https://travis-ci.org/PierreRambaud/usblamp.png?branch=master)](https://travis-ci.org/PierreRambaud/usblamp)

Python script to power the Dreamcheeky USB webmail notifier gadget. <http://www.dreamcheeky.com/webmail-notifier>

##Supported python version

This tool was test with python `3.2` and `3.3`.

##Installation

From Pypi

```
$ pip install usblamp
```

From Github

```
$ git clone https://github.com/PierreRambaud/usblamp.git
$ cd usblamp
$ ./usblamp --help
```

##Usage
```
usage: usblamp [-h] [-c COLOR] [-r RED] [-g GREEN] [-b BLUE]

Python script to power the Dreamcheeky USB webmail notifier gadget which is
shipped with windows only software. by Pierre Rambaud
<https://github.com/PierreRambaud/usblamp>

optional arguments:
  -h, --help            show this help message and exit
  -c COLOR, --color COLOR
                        Color as hexadecimal or string (#112233 or 'blue')
  -r RED, --red RED     Red
  -g GREEN, --green GREEN
                        Green
  -b BLUE, --blue BLUE  Blue
```

##Troubleshooting
Should be run as root unless the necessary udev rules are set.
Create the file `/etc/udev/rules.d/42-usblam.rules`
And add this content by replacing `got` by your username:
```
SUBSYSTEM !="usb_device", ACTION !="add", GOTO="datalogger_rules_end"
SYSFS{idVendor} =="1d34", SYSFS{idProduct} =="0004", SYMLINK+="datalogger"
MODE="0666", OWNER="got", GROUP="root"
LABEL="datalogger_rules_end"
```

## Running tests
Install dependencies:

`$ ./setup.py test`

To run unit tests:
`$ ./setup.py nose`
or
`$ nosetests`

To check code style:
`$ ./setup.py pep8`
or
`$ pep8 ./`


## License
   See [LICENSE.md](LICENSE.md) file



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/PierreRambaud/usblamp/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

