Go through lecture notes from 2018-02-01. Make sense of what's going on and get the example code to work. These notes should include the bare essentials to get a project running. Include links to more in-depth information

* Do the form example from class
    * ~~Decide how to handle cross-site-request-forgery tokens~~ (Don't)
* ~~Get the tick example from class going~~
* Read Hex docs about channels and take notes
* Get the Hangman example from class working
* Move the memory game logic server-side

## Specific Assignment Questions
* Should the delay after clicking be done by the browser or the server?
    * The `Process.send_after` function may be helpful

## Elixir Processes and Shared State
### Creating and Running a Stand-Alone Elixir Project
* Use `mix new <project_name>` to create a new Elixir project
* Use `mix run -e <ModuleName>.<moduleFunction>` to run the main method
* Mix commands
    * https://hexdocs.pm/mix/Mix.html
    * https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html
    * Start compiled projects with `iex -S mix`
    * `mix compile`
    * `mix test`
    * `mix run`
    * `mix help`

### Understanding the example code
* https://elixir-lang.org/getting-started/processes.html
* _tick.ex_
    * ...
* _shared_state.ex_
    * ...
* _pmap.ex_
    * ...

## Creating a Phoenix application
* The "Guides" section at https://hexdocs.pm/phoenix/overview.html is very helpful
*  `mix phx.new <app_name> --no-ecto` creates a new Phoenix app without an external database
    * Install the dependencies and read the prompts
* "The rest of our greater Elixir application lives inside *lib/<app_name>*, and you structure code here like any other Elixir application."
* "Phoenix generates a router file for us in new applications at *lib/hello_web/router.ex*"
* To add a new page ...
    1. Add a new route (a verb/path & controller/action pair) to the scope in the *router.ex* file
    2. Add a new controller under the *controllers/* folder
    3. Add a new view to the *views/* folder (make sure the name is consistent)
    4. Add a new template for the page in its on folder under *templates/*
    5. Navigate to *localhost:4000/<page_name>* to see the new page
* To pass a message to a page as part of a URL ...
    1. Add a new route
    2. Add a new action
    3. Add a new template for the action

## Websockets with Phoenix and Elixir
    * See https://hexdocs.pm/phoenix/channels.html

[Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
