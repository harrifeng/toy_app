# decode_session_cookie.rb
# ------------------------
# The purpose of this script is to show that if I have the secret_key_base
# and a cookie to an active Rails session, I can decrypt it and gain access
# to key information about the user's session.

require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

def decrypt_session_cookie(cookie, key)
  cookie = CGI::unescape(cookie)

  # Default values for Rails 4 apps
  key_iter_num = 1000
  key_size     = 64
  salt         = "encrypted cookie"
  signed_salt  = "signed encrypted cookie"

  key_generator = ActiveSupport::KeyGenerator.new(key, iterations: key_iter_num)
  secret = key_generator.generate_key(salt)
  sign_secret = key_generator.generate_key(signed_salt)

  encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: ActiveSupport::MessageEncryptor::NullSerializer)
  puts encryptor.decrypt_and_verify(cookie)

end


# Time to test ... (With data from Arbeit327)
cookie = 'YW1VQ2FheTk5L3VOMHpjdmEzeUdkMTNqdkZ3TmU0ODgwWUhReXFkYnJxSGgrd2JNMGNNUzZYYzJDeHM2S2hNVmhUajVKcXQrczRURDF5ZnFYbFJzajcwQXVSdGNlREN6a0ZLZEE4MUtjZWNDbERJWWpiS2d3RDVmNDk3QUcyRmRKejIvamo3aDgxSWh5cldCN0NJQnJnPT0tLXVSUDBvRmJOclBGajZZa3o3bUJhS3c9PQ%3D%3D--2ad24741efa79a0f1a48fddc4afe93406cf8ad99'
# From toy_app/config/secrets.yml
key = '494c3142095837599fd664f7897dbc00024d22e591970ce689e7b17ccdc22587a17e22d6cf60d4957112b2acdeed9346ba1c7389faa5db7c658d82dfc37c9508'

decrypt_session_cookie(cookie, key)

# RESULT SHOULD BE:
# {"session_id"=>"ed15f10de5708322d240eca41b7bbcd0", "_csrf_token"=>"yJK0VWRE6ykxOTnllfMt6pZE7SBhXgfZSQS2Fft0l8w=",
#  "user_id"=>1, "project_ids"=>[1, 2, 3, 4], "role"=>"admin"}
