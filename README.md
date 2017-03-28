# ResearchResource
[![Build Status](https://travis-ci.org/research-resource/research_resource.svg?branch=master)](https://travis-ci.org/research-resource/research_resource)
[![codecov](https://codecov.io/gh/research-resource/research_resource/branch/master/graph/badge.svg)](https://codecov.io/gh/research-resource/research_resource)

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The project requires a number of environment variables to run. These are in our shared Google Doc.

Add these environment variables to a `.env` file, then run `source .env` in the terminal window you'll be running the server in.

### Stack

We are using [Phoenix](https://github.com/phoenixframework/phoenix), [Elixir](https://github.com/elixir-lang/elixir), and [Tachyons](https://github.com/tachyons-css/tachyons), aka 'PET' from the [PETE stack](https://github.com/dwyl/technology-stack)

### User Sign Up Flow

* The Sign Up Module is available at the bottom of each page on the site, and linked to from the top of each page (both in the header, and in a box).
From this module the user fills in their First Name, Last Name and Email Address, and creates a Password (all fields are required).

* After signing up, the user is redirected to the consent page, where they must answer 'yes' to all required consent questions, and must answer ('yes' or 'no') the remaining questions.

* After consenting, the user is taken to the Qualtrics page, where the qualtrics survey is embedded in a iframe. After they have completed this, they are redirected to the projects page, where they can see current and archived projects.

### Data Storage

#### PostgreSQL

We are using PostgreSQL to store our basic user account details (name, email, password hash).

#### Redcap

More detailed user data, including consent is stored in Redcap, to allow the TTRR team easy access. Redcap is also used for the creation of data such as consent questions, and project info. This is then pulled through to the site to be displayed to the user.

### Tests

We use [excoveralls](https://github.com/parroty/excoveralls) for test coverage. To see the current coverage run `mix coveralls`. To generate an html coverage report, run `mix coveralls.html`. This can then be found in the `cover` directory, and will show you exactly which lines of code are and aren't covered.
