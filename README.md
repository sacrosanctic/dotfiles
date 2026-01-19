## Setup

install `git` and `stow`.

```sh
git clone https://github.com/sacrosanctic/dotfiles.git ~/dotfiles
stow .
ls
```

## How to copy files

```sh
cd ~
# important not to use tilda, it affects `--parents`
cp -r --parents .config/copyq ~/dotfiles
cd dotfiles
stow --adopt .

# alternative

# delete or rename file/folder
# rm .config/copyq -rf
# mv .config/copyq .config/copyq.bak
# stow .

```

## References

- https://youtu.be/y6XCebnB9gs
- https://github.com/dreamsofcode-io/dotfiles
- https://github.com/daviwil/dotfiles
- https://github.com/ThePrimeagen/.dotfiles
