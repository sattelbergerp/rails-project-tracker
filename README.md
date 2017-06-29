### About
A rails version of a project tracker I wrote in sinatra. It has a few added features over the original.

* Create, edit, and delete tasks from the project page
* Sign in with github
* Give projects alerts displayed at the top of the project (Mostly added to so I could have a nested form)
* View only overdue projects

### Installation

    git clone https://github.com/sattelbergerp/rails-project-tracker.git
    cd rails-project-tracker
    bundle install
    rake db:migrate
    rails s

For github login you must set GITHUB_KEY and GITHUB_SECRET environment variables
Your Authorization callback URL must be set to 'http://localhost:3000/'
