# Changelog

## v5.2.0

- Merge latest `bats-core/bats-assert` into `./bats-assert`
- Merge latest `bats-core/bats-file` into `./bats-file`
- Merge latest `bats-core/bats-support` into `./bats-support`

## v5.1.1

- Improve installation instructions in `README.md`

## v5.1.0

### Features

- Add `package.json` with package name `@hyperupcall/bats-all`

### Fixes

- The `{assert,refute}_regex` files from `bats-assert` are now properly `source`'d

## v5.0.0

### Breaking Changes

Use upstream repositories from the `bats-core` organization instead of my own forks.

I originally created the forks because I wanted to make some changes (and upstream seemed inactive). But now, upstream is moving faster and there is little reason to not use upstream directly.

## v4.6.0

### Features

- Merge latest `bats-core/bats-assert` into `hyperupcall/bats-assert`
- Merge latest `bats-core/bats-file` into `hyperupcall/bats-file`

## v4.5.0

### Features

- Merge latest `bats-core/bats-assert` into `hyperupcall/bats-assert`
- Merge latest `bats-core/bats-file` into `hyperupcall/bats-file`

## v4.4.0

### Features

- Merge latest `bats-core/bats-assert` into `hyperupcall/bats-assert`
- Merge latest `bats-core/bats-file` into `hyperupcall/bats-file`
- Merge latest `bats-core/bats-support` into `hyperupcall/bats-support`

## v4.3.0

### Features

- Merge latest `bats-core/bats-assert` into `hyperupcall/bats-assert`
  
## v4.2.0

### Features

- Merge latest `bats-core/bats-assert` into `hyperupcall/bats-assert`

## v4.1.0

### Features

- Allow negative indexes in line assertions [commit](https://github.com/hyperupcall/bats-assert/commit/6ba332f34526819d06461704c57b7642f0f1e024) [merge commit](https://github.com/hyperupcall/bats-all/commit/545ad58c0224227739b470a5afcd5c53b2a96d75)

### Fixes

- Properly load function that contains `assert_not_equal` in `load.bash` [commit](https://github.com/hyperupcall/bats-all/commit/dbf8040164603351bb621e5b5b2090bfea9684db)

## v4.0.0

Uses `git-subtree(1)` for repository management instead of `git-submodule(1)`

Removing the old sources means those changes will be lost. There is no difference in features or bugfixes

### Features

- Add support for `assert_not_equal` [commit]([38bfbf61443c046acf91b678a5a8eb5a0ab13000](https://github.com/hyperupcall/bats-assert/commit/38bfbf61443c046acf91b678a5a8eb5a0ab13000)) [merge commit](https://github.com/hyperupcall/bats-all/commit/d0a44dd2db7c75fbd510834c7bc056ec313abc9e)

## v3.0.1

This simply correctly sets the version string in `basalt.toml`

## v3.0.0

First release
