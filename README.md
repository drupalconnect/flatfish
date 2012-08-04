# Flatfish
Bottom-feeding fun!

## Description
Flatfish is a lib to scrape HTML based on a CSV with CSS selectors and configurable attributes (eg, page titles).
The ultimate goal of Flatfish is to prep and load the HTML into Drupal.

## INSTALLATION
Flatfish is on Rubygems, so you can just `gem install flatfish`. But if you are starting from scratch:

1. We're using Ruby 1.9.3, so install that with RVM, rbenv+ruby-build, or on your own. Note there are some soft dependencies in Ruby that you should get, google or see http://goo.gl/YSvmp.
2. At the moment, Flatfish is setup to use MySQL, so you will need to install the mysql2 gem dependencies, notably libmysqlclient-dev.
3. Flatfish uses Nokogiri to pare the HTML, so you will also need to install its dependencies, libxslt-dev and libxml2-dev.
4. From here you should be able to `gem install flatfish` without any issues.

## NOTES
As Flatfish scrapes the HTML over-the-wire, it can be a bit slow (say 10 minutes for 500 pages), but you can speed things up by pointing to a local copy of your site by entering a value for `local_source` in the config.yml file (see the example directory).

## USAGE INSTRUCTIONS
1. Create a MySQL database
2. Make a directory for you CSV and configuration file
3. Create CSVs of URLs with CSS selectors (see the example directory), one for each Drupal Content Type
4. Configure your yaml with project specifics (see config.yml in the example directory)
5. Run `flatfish` in your project directory (with the CSV and the config file)
6. Additional Flatfish runs will update (IE, overwrite) database content based on URL.

## License
(The MIT License)

Copyright (c) 2012 Tim Loudon

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
