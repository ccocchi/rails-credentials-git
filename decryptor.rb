# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: decryptor.rb [options]"

  opts.on('--conflict') do
    options[:conflict] = true
  end

  opts.on('--compare=BRANCH') do |branch|
    options[:compare] = branch
  end
end.parse!

def decrypt(content, key)
  encrypted_data, iv, auth_tag = content.split("--").map { |v| ::Base64.strict_decode64(v) }
  secret = [ key ].pack("H*")

  cipher = OpenSSL::Cipher.new('aes-128-gcm')
  cipher.decrypt
  cipher.key = secret
  cipher.iv  = iv
  cipher.auth_tag = auth_tag
  cipher.auth_data = ""

  decrypted_data = cipher.update(encrypted_data)
  decrypted_data << cipher.final

  Marshal.load(decrypted_data)
end

path  = ENV['RAILS_MASTER_KEY'] || 'config/master.key'
key   = File.read(File.expand_path("../../#{path}", __FILE__)).strip

if options.empty?
  content_file = ARGV.empty? ? File.expand_path('../../config/credentials.yml.enc', __FILE__) : ARGV[0]
  content = File.read(content_file)
  puts decrypt(content, key)
else
  require 'open3'

  stdout, _, _ = if (target = options[:compare])
    Open3.capture3("git diff --color #{target}:config/credentials.yml.enc HEAD:config/credentials.yml.enc")
  else
    target = File.exists?(File.expand_path('../.git/REBASE_HEAD', __dir__)) ? 'REBASE_HEAD' : 'MERGE_HEAD'
    Open3.capture3("git diff --color HEAD:config/credentials.yml.enc #{target}:config/credentials.yml.enc")
  end

  stdout = 'Nothing changed' if stdout.empty?
  puts stdout
end
