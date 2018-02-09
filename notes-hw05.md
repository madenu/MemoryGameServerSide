Go through lecture notes from 2018-02-01. Make sense of what's going on and get the example code to work. These notes should include the bare essentials to get a project running. Include links to more in-depth information

* ~~Skim Elixir docs about processes~~
* ~~Do the form example from class~~
    * ~~Decide how to handle cross-site-request-forgery tokens~~ (Don't)
* ~~Get the tick example from class going~~
* Channels
    * ~~Create a new project and do the walkthrough~~
    * ~~Get the Hangman example from class working~~
    * ~~Render a simple square and change color on click (server-side)~~
* TODO item click logic
* TODO review assignment instructions and persistent state
    * Look at GenServer and Agent from the Elixir stdlib
* TODO user token authorization

* Get the channel token authentication working

```
<div>
    <form action="/form" method="post">
        <input type="text" name="textboxA"/><br/>
        <input type="submit"/><br/>
    </form>
    <p><%= @name %></p>
</div>
```

## Specific Assignment Questions
* Should the delay after clicking be done by the browser or the server?
    * The `Process.send_after` function may be helpful

## Creating and Running a Stand-Alone Elixir Project
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

## Elixir Processes and Shared State
### Spawning Processes
* https://elixir-lang.org/getting-started/processes.html
    * Visit this link for an example on state as well
* Processes are the basis for concurrency in Elixir and they provide means for building distributed and fault-tolerant programs
* `spawn/1` takes afunction which it will execute in another process
    * `spawn_link/1` links the parent process so that errors propogate up
* `self/0` returns the PID of the current process
* `send/2` takes a PID and values
    * It is possible for a process to send messages to itself
* `receive/2` pattern matches on the message received (tuples are useful here)

```
iex> receive do
...>   {:hello, msg}  -> msg
...> after
...>   1_000 -> "nothing after 1s"
...> end
"nothing after 1s"
```

### Using Tasks to Spawn processes
* Tasks are abstractions built on top of `spawn/1` and `spawn_link/1`
* Tasks return `{:ok, pid}`
* Methods Available:
    * `Task.start/1` (instead of `spawn/1`)
    * `Task.start_link/1` (instead of `spawn_link/1`)
    * `Task.async/1`
    * `Task.await/1`

### Example Code for Processes
* _tick.ex_
* _shared_state.ex_
* _pmap.ex_

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
* Create a channel in **lib/your_app_web/channels/user_socket.ex**
* Create a new module in **lib/your_app_web/channels/channel_name_channel.ex**
    * Implement `join/3` in your new channel module
* Update **assets/js/socket.js**
* Import **socket.js** in **assets/js/app.js**
* Check the console in the browser for "Joined successfully"
* Now in **socket.js** or another JS file
    * Connect to the socket `socket.connect()`
    * Pick a channel `let channel = socket.channel("topic:sub", {})`
    * Add event listeners in the DOM for front-to-back messages
        * `.addEventListener(...)`
    * Add event listeners on the channel for back-to-front
        * `channel.on(...)`
* Implement `handle_in/3` in your channel's module
* `assign(socket, ...)` is also useful

[Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
