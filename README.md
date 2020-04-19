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


## Diff

One of the first thing we'll want to do is seeing the changes done to the encrypted file. If you use `git diff`, git will
diff the encrypted content, making it less than useful. Hopefully, you can configure git to convert files before diffing them. 


