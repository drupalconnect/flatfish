# Flatfish 
Bottom-feeding fun!

## Description 
Flatfish is a lib to scrape HTML based on a CSV w/ CSS selectors and configurable attributes (eg, page titles).
The ultimate goal of Flatfish is to prep and load the HTML into Drupal.

## INSTALLATION
Flatfish is still in development, so it's not on Rubygems just yet.  You'll need to build and install the gem manually, this is really pretty easy.  Assuming you're starting from scratch:

1. We're using Ruby 1.9.3, so install that with RVM, rbenv+ruby-build, or on your own.
2. Flatfish has a few dependencies, which are listed in the Gemfile, you can install the bundler gem and then use it to grab the rest of the gems at the versions specified in the Gemfile.lock--this is probably a good idea.  The gems can also be installed by hand--there are only a few.
3. We've set up a quick Rake task to build and install the Flatfish gem, so if you're using RVM (system-wide flavor) just run 'rake install\_gem'.  Otherwise, you can just 'gem build flatfish.gemspec' and 'gem install flatfish-VERSION.gem' according to your setup.

## NOTES
As Flatfish scrapes the HTML over-the-wire, it can be a bit slow (say 10 minutes for 500 pages), you can speed things up by pointing to a local copy of your site.

## USAGE INSTRUCTIONS
1. Create a MySQL database
2. Make a directory for you CSV and configuration file
3. Create CSVs of URLs w/ CSS selectors (see the example directory), one for each Drupal Content Type
4. Configure your yaml w/ project specifics (see Pleuronectiformes.yaml as a sample or the example directory)
5. Run 'flatfish' in your project directory (with the CSV and the config file)
6. Additional Flatfish runs will update (IE, overwrite) database content based on URL.

## License

(The MIT License)

Copyright (c) 2012 Tim Loudon

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
