# subr: sub redux

Subr is inspired and based off of [sub.](https://github.com/37signals/sub) The primary change is support for any number of levels of directories for organizing your commands. Like sub, subr provides a handy way to organize commands, a built-in help and tab completion system.

## Using subr

Place your executables inside `libexec/` or any sub-directory therein. For example if you created an executable in `libexec/uptime` you'd could run it by calling `subr uptime`. Alternatively, you can create sub-directories and include your executable in there. For example, the executable `libexec/awesome/example/who` can be called via `subr awesome example who`.

You can also create executables in the `bin/` directory to act as shortcuts to a particular sub-directory within `libexec/`. Here's a bash script to be created as `bin/example` that creates a shortcut to the `libexec/awesome/example` directory in the previous example and allows you to call the `who` executable as `example who`.

``` bash
#!/bin/bash
export _SUBR_SUB_COMMAND="awesome example"
exec subr "$@"
```

If you ever need to reference files inside of your installation, say to access a file in the `share` directory, subr exposes the directory path of the environment via the variable `_SUBR_ROOT`.

## Self-documenting subcommands

Each subcommand can opt into self-documentation, which allows the subcommand to provide information when `subr` and `subr help [SUBCOMMAND]` is run.

This is all done by adding a few magic comments. Here's an example:

``` bash
#!/usr/bin/env bash
# Usage: subr who
# Summary: Check who's logged in
# Help: This will print out when you run `subr help who`.
# You can have multiple lines even!
#
#    Show off an example indented
#
# And maybe start off another one?

set -e

who
```

Now, when you run `subr`, the "Summary" magic comment will now show up:

    usage: sub <command> [<args>]

    Some useful sub commands are:
       commands               List all sub commands
       who                    Check who's logged in

And running `subr help who` will show the "Usage" magic comment, and then the "Help" comment block:

    Usage: subr who

    This will print out when you run `subr help who`.
    You can have multiple lines even!

       Show off an example indented

    And maybe start off another one?

That's not all you get by convention with subr...

## Autocompletion

subr loves autocompletion. It's the mustard, mayo, or whatever topping you'd like that day for your commands. Just like real toppings, you have to opt into them! Subr provides two kinds of autocompletion:

1. Automatic autocompletion to find subcommands (What can this sub do?)
2. Opt-in autocompletion of potential arguments for your subcommands (What can this subcommand do?)

Opting into autocompletion of subcommands requires that you add a magic comment of:

    # Provide subr completions

and then your script must support parsing of a flag: `--complete`. Here's an example for `who`:

``` bash
#!/usr/bin/env bash
set -e

# Provide subr completions
if [ "$1" = "--complete" ]; then
  echo "-a"
  echo "-b"
  echo "-d"
  # etc.
  exit
fi

exec who "$@"
```

Passing the `--complete` flag to this subcommand short circuits the real command, and then runs another subcommand instead. The output from your subcommand's `--complete` run is sent to your shell's autocompletion handler for you, and you don't ever have to once worry about how any of that works!

Run the `init` subcommand to get subr loading automatically in your shell.

## Installing subr

Here's one way you could install your sub in your `$HOME` directory:

    git clone git://github.com/lukebaker/subr.git .subr

For bash users:

    echo 'eval "$($HOME/.subr/bin/subr init -)"' >> ~/.bash_profile
    exec bash

You could also install subr in a different directory, say `/usr/local`. This is just one way you to install subr.

## Differences between sub

 * commands can be placed in sub-directories beneath `libexec/`
 * short-cut commands can be created to specific sub-directories within `libexec/`
 * exposed variable names and magic comments are constant and not dependent on the sub (e.g., $_SUBR_ROOT and the magic comment indicating tab-completion support)
 * when calling `--complete` to get completions, script will receive any additional parameters that were already specified by the user. This allows you to tailor the completions based on the parameters that will be passed in.

## License

MIT. See `LICENSE`.