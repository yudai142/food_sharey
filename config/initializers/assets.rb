# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added by default.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Explicitly precompile all images from app/assets/images
if ENV['RAILS_ENV'] == 'production'
  images_path = Rails.root.join('app/assets/images')
  if File.directory?(images_path)
    Dir.glob(images_path.join('**/*')).each do |file|
      next if File.directory?(file)
      relative_path = file.sub(images_path.to_s + '/', '')
      Rails.application.config.assets.precompile << relative_path
    end
  end
end

# Configure SASS to look for partials in app/javascript/packs
# (only for fallback, not primary compilation)
Rails.application.config.sass.load_paths << Rails.root.join('app/javascript/packs')
Rails.application.config.sass.load_paths << Rails.root.join('app/javascript/stylesheets')
