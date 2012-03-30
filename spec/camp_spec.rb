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

    subject.configure do |config|
      config.account = account
      config.room_id = room_id
      config.token   = token
      config.ssl     = true
    end
    subject.speak "Ik ben een gem aan het maken"
  end

  it "loads token from rc_file if found" do
    rc_path = File.expand_path("#{File.dirname(__FILE__)}/blazerc")
    token   = "token-from-file"
    room_id = 1234
    account = "abcd"

    stub_request(:post, "https://#{token}:X@#{account}.campfirenow.com/room/#{room_id}/speak.json").
    with(:body => "{\"message\":{\"body\":\"Ik ben een gem aan het maken\"}}",
         :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => "", :headers => {})

    subject.configure do |config|
      config.account = account
      config.room_id = room_id
      config.ssl     = true
      config.rc_file = rc_path
    end
    subject.speak "Ik ben een gem aan het maken"
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

end
