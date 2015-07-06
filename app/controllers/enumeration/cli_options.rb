module WPScan
  module Controller
    # Enumeration CLI Options
    class Enumeration < CMSScanner::Controller::Base
      def cli_options
        cli_enum_choices + cli_plugins_opts + cli_themes_opts +
          cli_timthumbs_opts + cli_config_backups_opts + cli_medias_opts + cli_users_opts
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      # rubocop:disable Metrics/MethodLength
      def cli_enum_choices
        [
          OptMultiChoices.new(
            ['--enumerate [OPTS]', '-e', 'Enumeration Process'],
            choices: {
              vp: OptBoolean.new(['--vulnerable-plugins']),
              ap: OptBoolean.new(['--all-plugins']),
              p:  OptBoolean.new(['--plugins']),
              vt: OptBoolean.new(['--vulnerable-themes']),
              at: OptBoolean.new(['--all-themes']),
              t:  OptBoolean.new(['--themes']),
              tt: OptBoolean.new(['--timthumbs']),
              cb: OptBoolean.new(['--config-backups']),
              u:  OptIntegerRange.new(['--users', 'User ids range. e.g: u1-5'], value_if_empty: '1-10'),
              m:  OptIntegerRange.new(['--medias', 'Media ids range. e.g m1-15'], value_if_empty: '1-100')
            },
            value_if_empty: 'vp,vt,tt,cb,u,m',
            incompatible: [[:vp, :ap, :p], [:vt, :at, :t]]
          ),
          OptRegexp.new(
            [
              '--exclude-content-based REGEXP_OR_STRING',
              'Exclude all responses having their body matching (case insensitive) during parts of the enumeration.',
              'Regexp delimiters are not required.'
            ], options: Regexp::IGNORECASE
          )
        ]
      end
      # rubocop:enable Metrics/MethodLength

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_plugins_opts
        [
          OptFilePath.new(['--plugins-list FILE-PATH', 'List of plugins\' location to use'], exists: true),
          OptChoice.new(
            ['--plugins-detection MODE',
             'Use the supplied mode to enumerate Plugins, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          ),
          OptBoolean.new(['--plugins-version-all', 'Check all the plugins version locations'])
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_themes_opts
        [
          OptFilePath.new(['--themes-list FILE-PATH', 'List of themes\' location to use'], exists: true),
          OptChoice.new(
            ['--themes-detection MODE',
             'Use the supplied mode to enumerate Themes, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          ),
          OptBoolean.new(['--themes-version-all', 'Check all the themes version locations'])
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_timthumbs_opts
        [
          OptFilePath.new(
            ['--timthumbs-list FILE-PATH', 'List of timthumbs\' location to use'],
            exists: true, default: File.join(DB_DIR, 'timthumbs-v3.txt')
          ),
          OptChoice.new(
            ['--timthumbs-detection MODE',
             'Use the supplied mode to enumerate Timthumbs, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          )
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_config_backups_opts
        [
          OptFilePath.new(
            ['--config-backups-list FILE-PATH', 'List of config backups\' filenames to use'],
            exists: true, default: File.join(DB_DIR, 'config_backups.txt')
          ),
          OptChoice.new(
            ['--config-backups-detection MODE',
             'Use the supplied mode to enumerate Configs, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          )
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_medias_opts
        [
          OptChoice.new(
            ['--medias-detection MODE',
             'Use the supplied mode to enumerate Medias, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          )
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_users_opts
        [
          OptFilePath.new(
            ['--users-list FILE-PATH',
             'List of users to check during the users enumeration from the Login Error Messages'],
            exists: true
          ),
          OptChoice.new(
            ['--users-detection MODE',
             'Use the supplied mode to enumerate Users, instead of the global (--detection-mode) mode.'],
            choices: %w(mixed passive aggressive), normalize: :to_sym
          )
        ]
      end
    end
  end
end
