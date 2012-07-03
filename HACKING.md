# HACKING FLATFISH 

## Hello Brave Soul
Thank you for your interest in contributing to Flatfish!

### Background
Flatfish is built on Rails (Active Support + Active Record) and Nokogiri.  The first thing to note is that many Rails helpers (but not all) are available, but Flatfish is not a webapp--the directory structure is different, there is no MVC, etc.  So you will find that Flatfish is *Rails-like*, but does some hackery like creating dynamic models.  Active Record enables Flatfish to parse a CSV and save a data model representing it on-the-fly.

Nokogiri is an XML/HTML parser that supports CSS Selectors--basically, you get jQuery in Ruby.  It's awesome. Flatfish primarily uses Nokogiri for 1) specificity, as in only grabbing the HTML we want and 2) updating the links, images, and files.  Links, images, and files have their paths corrected and tokenized: additionally, files and images are saved as blobs in the database.

### Basic Process Flow
A Flatfish object is instantiated with a YAML config file.  The YAML includes DB info, some general options, and specifics on the Types of web pages to be processed.  Each Type has a CSV and URL Host.  A table for each Type is created if necessary and an Active Record subclass is generated dynamically.  Each row of the CSV is parsed, allowing Flatfish to:
1. Grab the HTML from a remote host or a local directory
2. Attempt to handle both HTTPS Redirects and Basic Authentication
3. Correct all link, image, and file paths
4. Tokenize all links, images, and files
5. Update or create all files and images saving them to the DB--eg, multiple copies of the same image are possible with unique URLs
6. Update or create the HTML saving it to the DB--again, the URL is the unique identifier

### Odds and Ends
Although all Active Record tables have an ID column, the URL is the unique identifier and all business logic is tied to it.

If you are new to Ruby, we suggest using rbenv to download the latest MRI Ruby (1.9.3 at the moment) and manage your gems.

Please write tests for any areas lacking them and certainly for any new code.  We are using Test::Unit.
