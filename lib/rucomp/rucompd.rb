require 'thor'
require 'rucomp/server'

module Rucomp
  class RucompD < Thor
    desc 'serve [options]', 'start the rucompd server'
    method_option :ruby_src_path,
                  aliases: '-c',
                  desc: 'Use the given path for std lib completions',
                  type: :string

    method_option :logging,
                  aliases: '-l',
                  desc: 'Turn on stdout logging.',
                  type: :boolean,
                  default: false

    method_option :log_file,
                  aliases: '-L',
                  desc: 'Use the specified file for logging',
                  type: :string,
                  default: '~/.rucompd/rucompd.log'

    method_option :port,
                  aliases: '-p',
                  desc: 'Listen on this port',
                  type: :numeric,
                  default: 3789

    method_option :addr,
                  aliases: '-a',
                  desc: 'Listen on this address',
                  type: :string,
                  default: '127.0.0.1'

    method_option :secret_file,
                  aliases: '-s',
                  desc: 'Path to the HMAC secret file. '\
                  'File will be destroyed after use',
                  type: :string
    def serve
      Rucomp::Server.new(options).start
    end
  end
end
