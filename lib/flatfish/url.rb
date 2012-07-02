module Flatfish 
  module Url
    #methods for handling URLs
    class << self
      attr_accessor :creds


      # Handle SSL Redirects + HTTP Auth
      # to catch linked files @ runtime
      def open_url url
        begin
          html = open(url).read
        rescue Exception => e
          redirect = URI.parse(url)
          if e.message =~ /redirection forbidden/ && redirect.scheme == 'http'
            html = open_url("https://" + redirect.host + redirect.path)
          end
          if e.message =~ /(Authorization Required|Unauthorized)/
            html = open(url, @creds).read
          end
        end
        return html
      end

      # take a URL, return an absolute URL
      def absolutify url, cd 
        url = url.to_s
        # deal w/ bad URLs, already absolute, etc
        begin
          u = URI.parse(url)
        rescue
          # GIGO, no need for alarm
          return url
        end

        return url if u.absolute? # http://example.com/about
        c = URI.parse(cd)
        return c.scheme + "://" + c.host + url if url.index('/') == 0 # /about
        return cd + url if url.match(/^[a-zA-Z]+/) # about*

        # only relative from here on in; ../about, ./about, ../../about
        u_dirs = u.path.split('/')
        c_dirs = c.path.split('/')

        # move up the directory until there are no more relative paths
        u.path.split('/').each do |x|
          break unless (x == '' || x == '..' || x == '.')
          u_dirs.shift
          c_dirs.pop unless x == '.'
        end
        return c.scheme + "://" + c.host + c_dirs.join('/') + '/' +  u_dirs.join('/')
      end

    end
  end

end
