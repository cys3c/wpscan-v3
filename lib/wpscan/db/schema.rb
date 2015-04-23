module WPScan
  module DB
    # WP Version
    class Version
      include DataMapper::Resource

      storage_names[:default] = 'versions'

      has n, :fingerprints, constraint: :destroy

      property :id, Serial
      property :number, String, required: true, unique: true
    end

    # Path
    class Path
      include DataMapper::Resource

      storage_names[:default] = 'paths'

      has n, :fingerprints, constraint: :destroy

      property :id, Serial
      property :value, String, required: true, unique: true
    end

    # Fingerprint
    class Fingerprint
      include DataMapper::Resource

      storage_names[:default] = 'fingerprints'

      belongs_to :version, key: true
      belongs_to :path, key: true

      property :md5_hash, String, required: true, length: 32
    end
  end
end
