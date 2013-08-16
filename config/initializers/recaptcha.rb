Recaptcha.configure do |config|
  config.public_key  = Settings.recaptcha_pkey
  config.private_key = Settings.recaptcha_skey
end