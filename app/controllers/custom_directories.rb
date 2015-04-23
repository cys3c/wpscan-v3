module WPScan
  module Controller
    # Controller to ensure that the wp-content and wp-plugins
    # directories are found
    class CustomDirectories < CMSScanner::Controller::Base
      def cli_options
        [
          OptString.new(['--wp-content-dir DIR']),
          OptString.new(['--wp-plugins-dir DIR'])
        ]
      end

      def before_scan
        target.content_dir = parsed_options[:wp_content_dir] if parsed_options[:wp_content_dir]
        target.plugins_dir = parsed_options[:wp_plugins_dir] if parsed_options[:wp_plugins_dir]

        fail 'Unable to identify the wp-content dir, ' \
             'please supply it with --wp-content-dir' unless target.content_dir
      end
    end
  end
end
