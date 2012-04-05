require 'capistrano/blaze/message'

describe Capistrano::Blaze::Message do

  subject { Capistrano::Blaze::Message }
  let(:exception) { RuntimeError.new("woops") }

  before do
    subject.any_instance.stub(:user) { "your mom" }
  end

  it "sends a test message" do
    should_speak(":heart: basecamp!")
    context = stub(:application => "basecamp")
    subject.test(context)
  end

  context "with multistage extension" do

    let(:context) { stub(:stage => "production", :application => "basecamp") }

    it "displays a start message" do
      should_speak("your mom is deploying to the production stage of basecamp, via `#{command}`")
      subject.start(context)
    end

    it "displays a failure message" do
      should_speak(":warning: your mom failed to deploy to the production stage of basecamp, via `#{command}`: woops (RuntimeError)")
      subject.failure(context, exception)
    end

    it "displays success message" do
      should_speak("your mom succesfully deployed to the production stage of basecamp, via `#{command}`")
      subject.success(context)
    end

  end

  context "without multistage extension" do

    let(:context) { stub(:application => "basecamp") }

    it "displays a start message" do
      should_speak("your mom is deploying basecamp, via `#{command}`")
      subject.start(context)
    end

    it "displays success message" do
      should_speak("your mom succesfully deployed basecamp, via `#{command}`")
      subject.success(context)
    end

    it "displays failure message" do
      should_speak(":warning: your mom failed to deploy basecamp, via `#{command}`: woops (RuntimeError)")
      subject.failure(context, exception)
    end

  end

  def command
    [ 'cap', *ARGV ] * ' '
  end

  def should_speak(message)
    Capistrano::Blaze.should_receive(:speak).with(message)
  end

end
