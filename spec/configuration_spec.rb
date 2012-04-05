require 'capistrano/blaze/configuration'

describe Capistrano::Blaze::Configuration do

  REQUIRED = %W(account room_id token)

  before do
    REQUIRED.each do |option|
      subject[option] = "foo"
    end
  end

  REQUIRED.each do |option|
    it "requires #{option} to be set" do
      subject[option] = nil
      expect { subject.validate! }.to raise_error("Please specify the #{option} option")
    end
  end

end
