require 'spec_helper'

describe Legato::Management::Profile do
  context "The Profile class" do
    def self.subject_class_name
      "profiles"
    end

    it_behaves_like "a management finder"

    it 'creates a new profile instance from a hash of attributes' do
      user = stub
      profile = Legato::Management::Profile.new({"id" => 12345, "name" => "Profile 1"}, user)
      profile.user.should == user
      profile.id.should == 12345
      profile.name.should == "Profile 1"
    end

    it 'returns an array of all profiles available to a user under an account' do
      account = stub(:user => 'user', :path => 'accounts/12345')
      Legato::Management::Profile.stubs(:all)

      Legato::Management::Profile.for_account(account)

      Legato::Management::Profile.should have_received(:all).with('user', 'accounts/12345/web_properties/~all/profiles')
    end

    it 'returns an array of all profiles available to a user under an web property' do
      web_property = stub(:user => 'user', :path => 'accounts/~all/web_properties/12345')
      Legato::Management::Profile.stubs(:all)

      Legato::Management::Profile.for_web_property(web_property)

      Legato::Management::Profile.should have_received(:all).with('user', 'accounts/~all/web_properties/12345/profiles')
    end
  end

  context "A Profile instance" do
    it 'builds the path for the profile from the id' do
      web_property = Legato::Management::Profile.new({"id" => 12345}, stub)
      web_property.path.should == '/accounts/~all/web_properties/~all/profiles/12345'
    end
  end
end
