module WPScan
  # Override of the CMSScanner::XMLRPC to include the references
  class XMLRPC < CMSScanner::XMLRPC
    # @return [ Hash ]
    def references
      {
        url: [
          'https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner',
          'https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos',
          'https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login',
          'https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access',
          'http://codex.wordpress.org/XML-RPC_Pingback_API'
        ]
      }
    end
  end
end
