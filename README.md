# Decryptor

Rails 5 introduced `secrets` to manage sensitive information, later renamed `credentials` in Rails 5.2. It comes with useful
commands like `rails credentials:show` to see the decrypted content but they come a bit short when working with git.

`decryptor` is a small ruby script which tries to make working with both like a breeze.

## Installation

`decryptor` comes as a single ruby file that you can copy wherever you want. Most common places are within a single repository
`tmp` or `script` directory, or at your user root directory if you intend to use it in more than one repository. In the rest of
this README, examples will use an instalation at `~/.scripts/decryptor`. 

To avoid having to prefix all your commands with `ruby`, you can add executables rights to the script with the following
command (UNIX-like only) :

```bash
$> chmod +x ~/.scripts/decryptor
```

## Configuration

`decryptor` uses the same ENV variable `RAILS_MASTER_KEY` to find the master key.


## Diff

One of the first thing we'll want to do is seeing the changes done to the encrypted file. If you use `git diff`, git will
diff the encrypted content, making it less than useful. Hopefully, you can configure git to convert files before diffing them. 

First, we'll need to define our conversion "protocol" in the git configuration file `.git/config` :

```git
[diff "enc"]
  textconv = ~/.scripts/decryptor
  cachetextconv = false
```

It adds the conversion script and disable cahing from the conversion (we do not want our uncrypted credentials to be cached). 
Then we can tell git, using the git attributes, to use this protocol during diffing our credentials file(s). We can
add this line in a `.gitattributes` file within our project:

```
*.yml.enc diff=enc -merge
```

Now git will use our `enc` protocol for diffing our credentials file, and we'll be able to see our actual changes. Yay! Notice the `-merge`, we'll talk about it below.

## Merge / Rebase

We can now see the changes we make to the credentials, but what happens when we stumble upon a conflict on our credentials file during a merge (or a rebase)? By default, git will try to resolve conflict with the two encrypted file, failed to do so and leave you to resolve it. But worst, it will modify the credentials file in a "git way" (you know the `<<<<<<` I'm talking about), making it un-diffable.    

We can tell git to disable merging file (the `-merge` flag we talk about above). This will keep our credentials file 
