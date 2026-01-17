## How to copy files

```sh
# important not to use tilda, it affects `--parents`
cp -r --parents .config/copyq ~/dotfiles

# delete or rename file/folder
# rm .config/copyq -rf
mv .config/copyq .config/copyq.bak

stow .
```
