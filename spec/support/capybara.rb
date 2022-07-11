RSpec.configure do |config|
  config.before(:each, type: :system) do
      driven_by :selenium, using: :headless_chrome #←ブラウザの表示無
     #driven_by :selenium_chrome　←ブラウザの表示有
  end
end
