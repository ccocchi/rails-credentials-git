require "base64"
require "openssl"

module RailsCredentialsGit
  @@method = <<~RUBY
    def self.decrypt(content, key)
      encrypted_data, iv, auth_tag = content.split("--").map { |v| ::Base64.strict_decode64(v) }
      secret = [key].pack("H*")

      cipher = OpenSSL::Cipher.new("aes-128-gcm")
      cipher.decrypt
      cipher.key = secret
      cipher.iv  = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ""

      decrypted_data = cipher.update(encrypted_data)
      decrypted_data << cipher.final

      Marshal.load(decrypted_data)
    end
  RUBY

  def self.decrypt_method
    @@method
  end

  class_eval(@@method, __FILE__, __LINE__ + 1)
end
