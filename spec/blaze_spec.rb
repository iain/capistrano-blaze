require 'capistrano/blaze'
require 'webmock'

describe Capistrano::Blaze do
  include WebMock::API

  around do |example|
    $stderr = StringIO.new
    example.run
    $stderr = STDERR
  end

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

end
