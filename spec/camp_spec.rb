require 'capistrano/blaze'
require 'webmock'

describe Capistrano::Blaze do
  include WebMock::API

  it "can speak" do
    token = "abc"
    room_id = 1234
    account = "abcd"

    stub_request(:post, "http://#{token}:X@#{account}.campfirenow.com/room/#{room_id}/speak.json").
    with(:body => "{\"message\":{\"body\":\"Ik ben een gem aan het maken\"}}",
         :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Capistrano::Blaze'}).
         to_return(:status => 200, :body => "", :headers => {})

    subject.configure do |config|
      config.account = account
      config.room_id = room_id
      config.token   = token
      config.ssl     = false
    end

    subject.speak "Ik ben een gem aan het maken"

  end

  before do
    Capistrano::Blaze::Messages.any_instance.stub(:user) { "your mom" }
  end

  it "displays a start message" do
    subject.should_receive(:speak).with("your mom is deploying to the production stage of basecamp, via `#{command}`")
    context = stub(:stage => "production", :application => "basecamp")
    subject.start(context)
  end

  it "displays a failure message" do
    subject.should_receive(:speak).with(":warning: your mom failed to deploy to the production stage of basecamp, via `#{command}`: woops (RuntimeError)")
    context = stub(:stage => "production", :application => "basecamp")
    exception = RuntimeError.new("woops")
    subject.failure(context, exception)
  end

  it "displays success message" do
    subject.should_receive(:speak).with("your mom succesfully deployed to the production stage of basecamp, via `#{command}`")
    context = stub(:stage => "production", :application => "basecamp")
    subject.success(context)
  end

  it "sends a test message" do
    subject.should_receive(:speak).with(":heart: basecamp!")
    context = stub(:application => "basecamp")
    subject.test(context)
  end

  it "displays success message without a stage" do
    subject.should_receive(:speak).with("your mom succesfully deployed basecamp, via `#{command}`")
    context = stub(:application => "basecamp")
    subject.success(context)
  end

  it "displays failure message without a stage" do
    subject.should_receive(:speak).with(":warning: your mom failed to deploy basecamp, via `#{command}`: woops (RuntimeError)")
    context = stub(:application => "basecamp")
    exception = RuntimeError.new("woops")
    subject.failure(context, exception)
  end

  def command
    [ 'cap', *ARGV ] * ' '
  end

end
