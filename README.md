# AdvancedMYR

Tracking system used in the World Robotic Sailing Championship.

2017 site: http://tracking.wrsc2017.com/

In this project, we collect GPS data with electronic devices and send them to the website. Then we provide functions for viewers and competitors such as real-time display and access to the GPS data to process scoring calculations.

To run the server locally for development:

    cd MYR_rails

    # gem is Ruby's package manager. You'll need to get that somehow.
    gem install bundle
    bundle install
    
    # It looks like this should only be needed in production, but I always
    # seem to need it. It should be a proper random token in production.
    export SECRET_KEY_BASE=blah
    
    # Go!
    bundle exec rails server -e development

Open http://localhost:3000/ in a browser to see it.

To run automated tests:

    bundle exec rake db:migrate RAILS_ENV=test  # First time only
    bundle exec rake test
