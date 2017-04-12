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

### How to create a new project in Redcap

Add a new instrument which will represent the project:

![create instrument](https://cloud.githubusercontent.com/assets/6057298/24911074/a34309ce-1ec1-11e7-8045-e3a00c310bb3.png)

![create instrument 2](https://cloud.githubusercontent.com/assets/6057298/24911076/a3463dce-1ec1-11e7-9c76-6e864bdabf27.png)

and define the name of the project. **The name must start with "project:" following by the name itself:**
![define project name](https://cloud.githubusercontent.com/assets/6057298/24911072/a33d3490-1ec1-11e7-94cf-7ee4dccc617e.png)

Define the main information of the project:

Name
- **field type must be "text box"**
- **field label must be "name"**
- **variable name must be "proj_name_name_of_the_project"**
- **the name display on the website must be defined in the field annotation**
![name project](https://cloud.githubusercontent.com/assets/6057298/24911071/a33d1bcc-1ec1-11e7-94e9-21896f5320ad.png)

Description
- **field name must be "description"**
- **variable name must be "proj_desc_name_of_the_project"**
- **field annotation must contains the description value**
![project description](https://cloud.githubusercontent.com/assets/6057298/24911069/a32cddd4-1ec1-11e7-896f-3b0cd0a71bf7.png)

Status
- **field label must be "status"**
- **variable name must be proj_status_the_project_name**
- **field annotation must be either "archived" or "current"**
![status project](https://cloud.githubusercontent.com/assets/6057298/24911068/a32a4970-1ec1-11e7-9ff7-393ad75862b6.png)

You should now have the three main fields defined in your instrument:
![main project fields](https://cloud.githubusercontent.com/assets/6057298/24911067/a320f4ce-1ec1-11e7-883d-0a5c86f0db82.png)

There are two types of consent field that can be added to the project "yes - no" and "text". **All the variable names must start with "consent_1_name_of_the_project". Don't forget to increment the consent number of the variable names!**

yes/no
- **the field type must be "Yes - No"**
- **the field label must contain the consent question**

![yes no consent](https://cloud.githubusercontent.com/assets/6057298/24911066/a31f6974-1ec1-11e7-8ee1-fbe847739f07.png)

- You can define if the consent is required (the user must answer yes)

![conset yes no required](https://cloud.githubusercontent.com/assets/6057298/24911070/a32d03a4-1ec1-11e7-89cf-1655eb5ed08c.png)

text
- **the variable name is no consent_2_name_of_the_project**
![text consent](https://cloud.githubusercontent.com/assets/6057298/24911064/a3179e24-1ec1-11e7-9b1e-7fb7b18c8d57.png)

You can now see the project on the website:
![project website](https://cloud.githubusercontent.com/assets/6057298/24911065/a31926c2-1ec1-11e7-9760-1d14a137d1d3.png)

you can see the history for each user consents - when the user consent to the project or when a consent has been updated manually by the team by clicking on th "h" button:
![history](https://cloud.githubusercontent.com/assets/6057298/24913963/b368dffa-1eca-11e7-8720-ec8a8d697bc9.png)
### Data Storage

#### PostgreSQL

We are using PostgreSQL to store our basic user account details (name, email, password hash).

#### Redcap

More detailed user data, including consent is stored in Redcap, to allow the TTRR team easy access. Redcap is also used for the creation of data such as consent questions, and project info. This is then pulled through to the site to be displayed to the user.

### Tests

We use [excoveralls](https://github.com/parroty/excoveralls) for test coverage. To see the current coverage run `mix coveralls`. To generate an html coverage report, run `mix coveralls.html`. This can then be found in the `cover` directory, and will show you exactly which lines of code are and aren't covered.

### Editing Site Content

The Contents for the 'Who We Are' page and the 'FAQs' page are stored in JSON files in the [`web/static/assets`](https://github.com/research-resource/research_resource/blob/master/web/static/assets/) directory. If you're not familiar with git, you can still edit these files directly on github:

1. Visit the file you want to change:
 - [Who We Are](https://github.com/research-resource/research_resource/blob/master/web/static/assets/who_we_are.json)
 - [FAQs](https://github.com/research-resource/research_resource/blob/master/web/static/assets/faqs.json)

2. Click the pencil (edit button) in the top right corner of the file:  
<img src="https://cloud.githubusercontent.com/assets/8939909/24963401/675dfdd0-1f96-11e7-9da2-549682aff521.png" width="320">

3. Edit or add the content. The format for a new team member is as follows:
```
{
    "name": "Jane Doe",
    "title": "TTRR Assistant",
    "description": "Jane assists with TTRR",
    "links": [
      {
        "name": "What the link will show as",
        "url": "http://www.google.com"
      },
      {
        "name": "A second link",
        "url": "http://www.twitter.com"
      }
    ],
    "image": "jane.jpg"
}
```
The images are found in the [`web/static/assets/images/ttrr_team`](https://github.com/research-resource/research_resource/blob/master/web/static/assets/images/ttrr_team) directory.  
The format for the faqs:
```
{
  "question": "Is this the question?",
  "answer": "Yes, and this is the answer"
}
```
Each person's record in the file must be followed by a comma, unless it is the last one. The same is true of the links, and the faqs:
```
{
    question: "Question 1",
    answer: "Answer 1"
},
{
    question: "Question 2",
    answer: "Answer 2"
}
```
To make sure the json file will work correctly, validate it by pasting it into: http://jsonlint.com/.  
More info about JSON: http://www.elated.com/articles/json-basics/

4. If the json is valid, and you're happy with it, propose the change by opening a pull request:  
<img src="https://cloud.githubusercontent.com/assets/8939909/24964351/f6894580-1f98-11e7-84ab-972edc89dee1.png" width="320"/>  
Make sure you check 'Create a new branch for this commit and start a pull request'. This will allow another member of the team to review the change before pushing it to the live site.

5. If you are reviewing someone's change, you can view the changes by going to `Pull requests`:  
<img src="https://cloud.githubusercontent.com/assets/8939909/24964915/725044ba-1f9a-11e7-9662-9bac58e96111.png" width="320"/>  
Then going to `Files changed`:  
<img src="https://cloud.githubusercontent.com/assets/8939909/24964941/82c2efbe-1f9a-11e7-9c28-2eadea87484b.png" width="320" />  
If you are happy with the change, go back to `Conversation`:  
<img src="https://cloud.githubusercontent.com/assets/8939909/24965007/b13fa40e-1f9a-11e7-8827-63b70636c30e.png" width="320"/>  
And click 'Merge pull request'  
<img src="https://cloud.githubusercontent.com/assets/8939909/24964968/95204bb6-1f9a-11e7-85e7-cc6ce83dfff3.png" width="320"/>  
This will deploy the change to the site in a few minutes.
