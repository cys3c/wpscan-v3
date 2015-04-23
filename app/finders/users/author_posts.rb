module WPScan
  module Finders
    module Users
      # Author Posts
      class AuthorPosts < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        #
        # @return [ Array<User> ]
        def passive(opts = {})
          found_by_msg = 'Author Posts - %s (Passive Detection)'

          usernames(opts).reduce([]) do |a, e|
            a << WPScan::User.new(
              e[0],
              found_by: format(found_by_msg, e[1]),
              confidence: e[2]
            )
          end
        end

        # @param [ Hash ] opts
        #
        # @return [ Array<Array>> ]
        def usernames(_opts = {})
          res   = Browser.get(target.url)
          found = potential_usernames(res)

          return found unless found.empty?

          res.html.css('header.entry-header a').each do |post_url_node|
            url = post_url_node['href']

            next if url.nil? || url.empty?

            found += potential_usernames(Browser.get(url))
          end

          found.compact.uniq
        end

        # @param [ Typhoeus::Response ] res
        #
        # @return [ Array<Array> ]
        def potential_usernames(res)
          usernames = []

          target.in_scope_urls(res, '//a', %w(href)) do |url, node|
            uri = Addressable::URI.parse(url)

            if uri.path =~ %r{/author/([^/\b]+)/?\z}i
              usernames << [Regexp.last_match[1], 'Author Pattern', 100]
            elsif uri.query =~ /author=[0-9]+/
              usernames << [node.text.to_s.strip, 'Display Name', 30]
            end
          end

          usernames.uniq
        end
      end
    end
  end
end
