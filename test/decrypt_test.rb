require "test_helper"
require "active_support/message_encryptor"

class DecryptTest < Minitest::Test
  def setup
    @key = "12acd5ebf1764131951ba9c06e136084"
  end

  def test_decrypt_encrypted_message
    encryptor = ActiveSupport::MessageEncryptor.new([@key].pack("H*"), cipher: 'aes-128-gcm')
    data = { "secret_key" => "very_secret" }

    str = encryptor.encrypt_and_sign(data)
    assert_equal data, RailsCredentialsGit.decrypt(str, @key)
  end
end
