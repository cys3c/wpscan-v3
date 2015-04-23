module WPScan
  module Finders
    module WpVersion
      # Unique Fingerprinting Version Finder
      class UniqueFingerprinting < CMSScanner::Finders::Finder
        include CMSScanner::Finders::Finder::Fingerprinter

        QUERY = 'SELECT md5_hash, path_id, version_id, ' \
                'versions.number AS version,' \
                'paths.value AS path ' \
                'FROM fingerprints ' \
                'LEFT JOIN versions ON version_id = versions.id ' \
                'LEFT JOIN paths on path_id = paths.id ' \
                'WHERE md5_hash IN ' \
                '(SELECT md5_hash FROM fingerprints GROUP BY md5_hash HAVING COUNT(*) = 1) ' \
                'ORDER BY version DESC'

        # @return [ WpVersion ]
        def aggressive(opts = {})
          fingerprint(unique_fingerprints, opts) do |version_number, url, md5sum|
            hydra.abort

            # dirty hack to avoid the progress bar to overlap with the " WordPress version 4.1.1 identified."
            # TODO: find a better way to do this
            puts if opts[:show_progression]

            return WPScan::WpVersion.new(
              version_number,
              found_by: 'Unique Fingerprinting (Aggressive Detection)',
              confidence: 100,
              interesting_entries: ["#{url} md5sum is #{md5sum}"]
            )
          end
          nil
        end

        # @return [ Hash ] The unique fingerprints across all versions in the DB
        #
        # Format returned:
        # {
        #   file_path_1: {
        #     md5_hash_1: version_1,
        #     md5_hash_2: version_2
        #   },
        #   file_path_2: {
        #     md5_hash_3: version_1,
        #     md5_hash_4: version_3
        #   }
        # }
        def unique_fingerprints
          fingerprints = {}

          repository(:default).adapter.select(QUERY).each do |f|
            fingerprints[f.path] ||= {}
            fingerprints[f.path][f.md5_hash] = f.version
          end

          fingerprints
        end

        def progress_bar(opts = {})
          super(opts.merge(title: 'Fingerprinting the version -'))
        end
      end
    end
  end
end
