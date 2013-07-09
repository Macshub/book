Using project :
- requires ruby and rails 1.9.3
- run bundle install
- create file config/database.yml
-- copy content of config/database.example.yml
-- edit to adapt for local parameters
- run rake db:create
- run rake db:migrate
- run rails s
You're done ;)