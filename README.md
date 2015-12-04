# WPScan

WPSCan v3 - Experimental Repo

#### INSTALL
Prerequisites:

- Ruby >= 2.1.0 - Recommended: 2.2.2
- Curl >= 7.21  - Recommended: latest - FYI the 7.29 has a segfault
- RubyGems      - Recommended: latest


### From the rubygems (not yet available):

```gem install wpscan```

### From the sources:
Prerequisites: Git

```git clone https://bitbucket.org/wpscan/wpscan-v3```

```cd wpscan```

```bundle install && rake install```


#### Usage

Open a terminal and type wpscan --help

The DB is located at ~/.wpscan/db

WPScan can load all options (including the --url) from files, the following locations are checked (order: first to last):

* ~/.wpscan/cli_options.json
* ~/.wpscan/cli_options.yml
* pwd/.wpscan/cli_options.json
* pwd/.wpscan/cli_options.yml

If those files exist, options from them will be loaded and overriden if found twice.

e.g:

~/.wpscan/cli_options.yml:
```
proxy: 'http://127.0.0.1:8080'
verbose: true
```

pwd/.wpscan/cli_options.yml:
```
proxy: 'socks5://127.0.0.1:9090'
url: 'http://target.tld'
```

Running ```wpscan``` in the current directory (pwd), is the same than ```wpscan -v --proxy socks5://127.0.0.1:9090 -u http://target.tld```