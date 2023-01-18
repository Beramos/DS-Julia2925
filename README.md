# Julia2925: learn a fast and intuitive programming language in two workdays. 
This page contains the Pluto notebooks accompanying the [Julia2925 doctoral schools](https://event.ugent.be/registration/event/122f756b-8a04-4713-9d6e-d8fc56eea628) hosted at Ghent University.

## Introduction
This course gives an in-depth introduction to the Julia programming language. The first day will introduce the essential elements (variables, printing, plotting, looping, collections, etc.) of Julia programming along with a peek behind the curtains of the type system. On the second day, we will cover the type system comprehensively and discuss its relation to multiple dispatch and illustrate how this translates into extensible and user-friendly programs. We cover the subject matter interactively in notebooks. 

## Getting started
There are two ways to download the notebooks.
1. If you are used to github, you can clone this repository to your computer.
2. Download the notebooks from this link **(WIP)**

### Installing Julia
1. Download the *Julia* binaries for your system [here](https://julialang.org/downloads/) we suggest to install the Current Stable Release v1.8.5.
2. Yes, it is that simple :zap:

### Starting Julia
For *windows* users, it is as simple as double-clicking the Julia application (after unzipping). For *Linux* users the Julia REPL can be started by executing the binary (after unzipping).

```bash
/path/to/julia-1.x.x/bin/julia
```
For ease-of-use we recommend adding an alias to your dotfiles (.bashrc, .zshrc).

```bash
alias julia=~/julia-1.x.x/bin/julia
```
### Running the notebooks
Open the Julia REPL

1. Open the (just) installed Julia application.
2. Install Pluto by copy-pasting the following instruction in the REPL (the terminal that just appeared): `using Pkg; Pkg.add("Pluto")`. This will take two minutes.
3. Launch Pluto by copy-pasting `using Pluto; Pluto.run()`. It will open in your browser.
4. In the slot "open a notebook" navigate to the notebook by typing the location of the notebooks on your computer (e.g. `C:/Users\jef\notebooks\day1\01-basics.jl` or `/home/jef/notebooks/day1/01-basics.jl` for Linux users). 

This should open a browser window with the Pluto notebooks. The first time it can take a while (up to 10 minutes) since it is installing all the dependencies.

## Contact
UGent Doctoral School member and Julia questions? Chat with us on Gitter!

[![Gitter](https://badges.gitter.im/DS-Julia2925/community.svg)](https://gitter.im/DS-Julia2925/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Meta
Authors: Bram De Jaegher, Michiel Stock, Daan Van Hauwermeiren
