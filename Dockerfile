FROM ruby:latest

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

# Set the working directory
WORKDIR /railsapp

# Copy the Gemfile and Gemfile.lock into the working directory
COPY ./Gemfile /railsapp/Gemfile

# COPY Gemfile.lock /railsapp/Gemfile.lock

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . /railsapp

# Precompile assets
# RUN bundle exec rake assets:precompile

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
