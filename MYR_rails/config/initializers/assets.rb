# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( Markers/markersCreation.js )
Rails.application.config.assets.precompile += %w( Real_time/real_time.js )
Rails.application.config.assets.precompile += %w( Replay/replay.js )
Rails.application.config.assets.precompile += %w( Scores/triangularCourseScore.js )
Rails.application.config.assets.precompile += %w( jquery.dataTables.js )
<<<<<<< HEAD
Rails.application.config.assets.precompile += %w( layout.css )
=======
Rails.application.config.assets.precompile += %w( team.js )
>>>>>>> 4dc014ff2f99f9b5b194a2c87947ca893999c92e
