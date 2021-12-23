---
title: Nix, the package manager
---

On my current team we all had different laptops, running different OS _(fedora, Ubuntu, MacOS)_... We also were juggling between different projects, in different languages, with different dependencies, and different environment variables...

Hence, we often were facing the following struggle:

> It works on my side

I also remember how hard it was to get a fully working Haskell environment when we started developing our project with this language (thank you 32bits `lzlib` on our 64 bits MacOS...)!

![](../images/nixpm-sweating.gif)

**Then, we discover [Nix](https://nixos.org/nix)!**

## What is Nix?

Actually, there are two different things behind this name:

- A package manager
- A simple lazy pure functional language that specializes in building packages

As I have a basic knowledge of the language (I am able to copy/paste/adapt, but not more for the moment) **this article will be about the Package Manager**.

## What does the package manager do?

I will not use the most appropriate terms to describe what exactly does this package manager, but **I will give you my comprehension, using my words**. Anyway, you can have a look on the official website about [How Nix works](https://nixos.org/guides/how-nix-works.html).

Naively, I want to say:

> Nix allows you to isolate the `build` of the package!

In details, for each package built by Nix, it first computes its `derivation` _(this is usually done by evaluating expressions written in the Nix language)_.

This `derivation` will lead in creating a file containing:

- mentions of all the files and other packages that will be required during the build
- build instructions for actually building the package,
- some metainformation about the package,
- most important, a store path under which the package will be installed: `/nix/store/<hash>-<name>-<version>` (where `hash` is a hash of all the other data in the derivation).

For example, since the recent changes on Docker pricing policies, we now use `colima`. But there was no Nix derivation available, here is how our custom one looks like:

```shell
{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  name = "colima";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = "colima";
    rev = "v${version}";
    sha256 = "sha256-vWNkYsT2XF+oMOQ3pb1+/a207js8B+EmVanRQrYE/2A=";
  };

  vendorSha256 = "075wd4xsx0dxqf733ha1hiy1x2hzkxdn6g8g0vn6q9bbqbrscp0p";

  meta = with lib; {
    description = "Colima - Container runtimes on macOS (and Linux) with minimal setup.";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ gsebil08 ];
  };
}
```

_Despite the lack of knowledge on the Nix language, this is pretty easy to understand. The original project is a Go module, available on https://github.com/abiosoft/colima. The most difficult part, is to find the `sha256`, but almost everything is explained in the official documentation_

Then, it _creates_ the derivation _(by running build instructions specified in it)_ **inside an isolated environment containing the dependencies and only the dependencies of the package**.

This way, Nix guarantees some really important properties:

- **Realising the same derivation will always get _(almost)_ the same output**, since the build commands only have access to the explicitly specified dependencies _(the output can differ if the build instruction uses some hardware-dependent information)_

- **The same store path** _(`/nix/store/<hash>-<name>-<version>`)_ **will always contain the result of _exactly_ the same commands**, since `<hash>` depends on all the variables that are explictly specified while to build this package.

Ok, that was for the theorical part.

**But how does Nix helps us everyday?**

## Some of the benefits

I guess there are some others, like the [Nix integration](https://docs.haskellstack.org/en/stable/nix_integration/) for [The Haskell Tool Stack](https://docs.haskellstack.org/en/stable/README/), but since I only use the `nix-shell`, I do not have any idea of possible other benefits...

### Reproducibility

This is the first one coming to my mind! And I guess, the real motivation behind Nix.

**Two people building the same package will always get the same output**, at least, if you are careful enough with pinning the versions of inputs in place. And in the case of different inputs, it will be very clear since the store path will change!

### Binary caching

Since the store path is known before building it and we are sure that the same store path will contain the same output, we can _replace_ that store path from some other location (as long as that location has that path and we trust the person building it).

To be clear, it is almost like substituting a function by its result since this function is pure and has no side-effects!

### Multiple versions of any package can be installed simultaneously

Every package is installed under its own prefix, so there are no collisions. This can be really handy during development – think Python’s virtualenvs but for any language!

To sum up, you can have two different versions of `docker-compose` (as long as they are both available...)!

### Distributed building

Since we know exactly what is needed to _create_ any derivation, it can be done remotely as long as the remote server has all the dependencies already (or can build them faster than the local machine).

### Easy onboarding

I remember projects with a `getting started` section requiring to globally install dozens of different packages, with sometimes, a very specific version... Then you spent hours, or even days to get your development environment ready because nothing goes exactly like explained in this `getting-started.md` file...

Thanks to Nix, you can provide a fully working `nix-shell`. Hence, the only required tool to install globally on your laptop is Nix. Within this provided `nix-shell` he will be able to find any referenced packages:

```shell
$ which docker-compose
docker-compose not found
$ cd my-project-with-nix-shell
$ nix-shell
[nix-shell:~/my-project-with-nix-shell]$ which docker-compose
/nix/store/kchjb4ncrk6c1qakdfd0xk11905fvy7f-docker-compose-1.29.2/bin/docker-compose
```

**How comfortable is that? A lot.**

## The ecosystem

### NixOS

Directly linked to the Nix package manager and the Nix language, an OS is available. I do not use it, but if I understand correctly:

NixOS is a GNU/Linux distribution using Nix as both a package manager and a configuration manager. Each configuration file is a derivation, and your whole system is a derivation, which depends on all the applications and config files you have explictly specified. Hence, we get all the benefits of Nix applied to the runtime environment.

To sum up, if two people install a NixOS system that has the exact same store path, they will always get exactly the same system on their computers! Good luck doing that with any other OS!

### Nixpkgs

`nixpkgs` is a massive collection of package descriptions using the Nix language. Once again, have a look on the [official wiki](https://nixos.wiki/wiki/Nixpkgs)

## You should give it a try

The `nix-shell` is definitively a game changer. Even our Product Manager is now able to easily run our applications without our help!

There are different ways to try it out, you can directly try NixOS on your machine, or on a VM. Or, as I do, you can install Nix and provide your own `nix-shell` for your different projects!

Feel free to have a look on the [Nix pills](https://nixos.org/guides/nix-pills/index.html) or even the [Nix cookbook](https://nix.dev/). They both are useful to understand the ecosystem and the glossary of this environment!
