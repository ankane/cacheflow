module Cashflow
  class Railtie < Rails::Railtie
    initializer "cacheflow" do
      Cacheflow.activate
    end
  end
end
