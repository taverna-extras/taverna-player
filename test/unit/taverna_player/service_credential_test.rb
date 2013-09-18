require 'test_helper'

module TavernaPlayer
  class ServiceCredentialTest < ActiveSupport::TestCase
    test "should not save credential without a uri" do
      cred = ServiceCredential.new
      cred.login = "test"
      cred.password = "test"
      cred.password_confirmation = "test"

      refute cred.save, "Saved the credential without a URI"
    end

    test "should not save credential without a login" do
      cred = ServiceCredential.new
      cred.uri = "test"
      cred.password = "test"
      cred.password_confirmation = "test"

      refute cred.save, "Saved the credential without a login"
    end

    test "should not save credential without a password" do
      cred = ServiceCredential.new
      cred.uri = "test"
      cred.login = "test"
      cred.password_confirmation = "test"

      refute cred.save, "Saved the credential without a password"
    end

    test "should not save credential without a password confirmation" do
      cred = ServiceCredential.new
      cred.uri = "test"
      cred.login = "test"
      cred.password = "test"

      refute cred.save, "Saved the credential without a password confirmation"
    end

    test "should not save credential without a confirmed password" do
      cred = ServiceCredential.new
      cred.uri = "test"
      cred.login = "test"
      cred.password = "test"
      cred.password_confirmation = "TEST"

      refute cred.save, "Saved the credential without a confirmed password"
    end

  end
end
