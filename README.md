# Fork from [wp-twentyseventeen](https://github.com/katychuang/wp-twentyseventeen)

## Using Nix

### Nix

[Nix](https://nixos.org/) is a package manager that goes beyond traditional ones (like Apt, NPM, Brew, etc.) as it
allows:

- full reproducibility (the same input guarantee to give exactly the same output)
- "local" packages, meaning you don't need to install globally
- describe in a Nix file everything you need to build or run an application, and Nix configures everything locally:
  - language dependencies like JDK 14 or GHC 8.10.7
  - build systems like Maven or Stack
  - system dependencies like Zlib or PostgreSQL
  - environment variables
  - etc.

You can find a high-level explanation of the different Nix files in [my Nix article](/posts/2021-12-23-Nix-the-Package-Manager.md)

### Run the project

```shell script
# Build the `site.hs` module
$ stack build
# Generate the blog
$ stack exec site build
# Run the blog locally (localhost:8000) and generate it at each change
$ stack exec site watch
```
