Capistrano::Configuration.instance(:must_exist).load do

  at_exit do
    if exception = $!
      Capistrano::Blaze.failure(self, exception)
    end
  end

  namespace :campfire do

    task :success do
      Capistrano::Blaze.success(self)
    end

    task :test do
      Capistrano::Blaze.test(self)
    end

  end

  after "deploy:restart", "campfire:success"

end
