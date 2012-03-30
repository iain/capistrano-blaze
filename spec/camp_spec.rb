require 'capistrano/blaze'
require 'webmock'

describe Capistrano::Blaze do
  include WebMock::API

  it "can speak" do
    token   = "abc"
    room_id = 1234
    account = "abcd"

    stub_request(:post, "https://#{token}:X@#{account}.campfirenow.com/room/#{room_id}/speak.json").
    with(:body => "{\"message\":{\"body\":\"Ik ben een gem aan het maken\"}}",
         :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => "", :headers => {})

    subject.reset_configuration!
    subject.configure do |config|
      config.account = account
      config.room_id = room_id
      config.token   = token
      config.ssl     = true
    end
    subject.speak "Ik ben een gem aan het maken"
  end

  it "loads configuration from rc file" do
    rc_path = File.expand_path("#{File.dirname(__FILE__)}/blazerc.rb")
    subject.reset_configuration!
    subject.configure(rc_path)
    subject.config.token.should == "token-from-file"
  end

  it "explicit configuration overrides loaded configuration" do
    rc_path = File.expand_path("#{File.dirname(__FILE__)}/blazerc.rb")
    room_id = 1234

    subject.reset_configuration!
    subject.configure(rc_path) do |config|
      config.room_id = room_id
    end

    subject.config.room_id.should == room_id
  end

  before do
    subject.stub(:user) { "iain" }
  end

  it "displays a failure message" do
    subject.should_receive(:speak).with(":warning: iain failed to deploy to the production stage of basecamp, via `cap`: woops (RuntimeError)")
    context = stub(:stage => "production", :application => "basecamp")
    exception = RuntimeError.new("woops")
    subject.failure(context, exception)
  end

  it "displays success message" do
    subject.should_receive(:speak).with("iain succesfully deployed to the production stage of basecamp, via `cap`")
    context = stub(:stage => "production", :application => "basecamp")
    subject.success(context)
  end

  it "sends a test message" do
    subject.should_receive(:speak).with(":heart: basecamp!")
    context = stub(:application => "basecamp")
    subject.test(context)
  end

  it "can reset the configuration" do
    subject.configure do |config|
      config.account = "foo"
    end
    subject.reset_configuration!
    subject.config.should == nil
  end

end
