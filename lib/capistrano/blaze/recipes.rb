Capistrano::Configuration.instance(:must_exist).load do

  at_exit do
    if exception = $!
      Capistrano::Blaze::Message.failure(self, exception)
    end
  end

  namespace :campfire do

    task :start do
      Capistrano::Blaze::Message.start(self)
    end

    task :success do
      Capistrano::Blaze::Message.success(self)
    end

    desc "Sends a test message to Campfire"
    task :test_config do
      Capistrano::Blaze::Message.test(self)
    end

  end

  before "deploy",            "campfire:start"
  before "deploy:migrations", "campfire:start"
  after "deploy:restart",     "campfire:success"

end
