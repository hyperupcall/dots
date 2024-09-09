# bats-all

An aggregation of the three most popular [Bats](https://github.com/bats-core/bats-core) utility libraries

## Summary

The three repositories are managed with `git-subtree(1)`. They are the following:

- [bats-core/bats-support](https://github.com/bats-core/bats-support)
- [bats-core/bats-assert](https://github.com/bats-core/bats-assert)
- [bats-core/bats-file](https://github.com/bats-core/bats-file)

## Installation

### With npm

```sh
npm install --save-dev @hyperupcall/bats-all
```

### With Basalt

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to add this project as a dependency

```sh
basalt add hyperupcall/bats-all
```

You need to source this project manually (`basalt.load 'github.com/hyperupcall/bats-alls' 'load.bash'`) within your tests. Entries are not added to this projects' `sourceDirs` because that would mean this library would be sourced, even when not testing

### With Git

Using `git-submodules(1)`:

```sh
git submodule add https://github.com/hyperupcall/bats-all ./vendor/bats-all
```

Using `git-subtree(1)`:

```sh
git subtree --squash -P vendor/bats-all add https://github.com/hyperupcall/bats-all HEAD
```

## License

Original code is licensed under `CC0-1.0`. Modifications are licensed under `BSD-3-Clause`
