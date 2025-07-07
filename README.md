# Julia2925: learn a fast and intuitive programming language in two workdays. 
This page contains the Pluto notebooks accompanying the [Julia2925 doctoral schools](https://event.ugent.be/registration/event/122f756b-8a04-4713-9d6e-d8fc56eea628) hosted at Ghent University.

![Logo Doctoral schools](/img/doctoralschoolsprofiel_hq_rgb_web.png)
![Logo Flanders](/img/logo_flanders+richtingmorgen.png)

## Introduction
This course gives an in-depth introduction to the Julia programming language. The first day will introduce the essential elements (variables, printing, plotting, looping, collections, etc.) of Julia programming along with a peek behind the curtains of the type system. On the second day, we will cover the type system comprehensively and discuss its relation to multiple dispatch and illustrate how this translates into extensible and user-friendly programs. We cover the subject matter interactively in notebooks. 

## Getting started
There are two ways to download the notebooks.
1. If you are used to Github, you can clone this repository to your computer.
2. Download the notebooks from [this link](https://beramos.github.io/DS-Julia2925/#course-content)

### Installing Julia

For *windows users*, if you have the choice to use windows subsystem for linux use it, it will make things easier.

There are multiple ways to install julia on your system: install via your package manager, download the binaries, or use the `Juliaup` installation manager.

We *strongly* recommend the `Juliaup` installation manager, it will make your life a lot easier.

In the current version of the course we will be using the latest stable release `1.11.5`.

#### using the binaries

1. Go to [this page](https://julialang.org/downloads/#official_binaries_for_manual_download) on the official Julia website and select the binary you want to download given the version and your system specification. 
2. Have a look [here](https://julialang.org/downloads/platform/) to see the installation instruction for different platforms.

#### Juliaup

1. Follow the [installation instructions](https://github.com/JuliaLang/juliaup#installation) for your specific platform.
2. Check out the [using Juliaup](https://github.com/JuliaLang/juliaup?tab=readme-ov-file#using-juliaup) details for how to launch Juliaup and execute some commands for your specific system.
3. Install version `1.11.5`: `juliaup add 1.11.5`
4. Make this version the default version: `juliaup default 1.11.5`.

### Starting Julia
For *windows* users:
- if you are using the binaries: it is as simple as double-clicking the Julia application (after unzipping). 
- if you are using `Juliaup`: there is a start menu shortcut and it will show up as a profile in Windows Terminal. 

For *Linux* users:
- if you are using the binaries: the Julia REPL can be started by executing the binary (after unzipping), e.g. ```/path/to/julia-1.x.x/bin/julia```. For ease of use, we recommend adding an alias to your dotfiles (.bashrc, .zshrc): ```alias julia=~/julia-1.x.x/bin/julia```
- if you are using `Juliaup`: julia is added to your path and can be started by executing `julia` in a shell.

Note that the VS Code extension will also automatically find this Julia installation.

### Running the notebooks
Open the Julia REPL using any of the methods described in the previous section.

1. Open the (just) installed Julia application.
2. Install Pluto by copy-pasting the following instruction in the REPL (the terminal that just appeared): `using Pkg; Pkg.add("Pluto")`. This will take two minutes.
3. Launch Pluto by copy-pasting `using Pluto; Pluto.run()`. It will open in your browser.
4. In the slot "open a notebook" navigate to the notebook by typing the location of the notebooks on your computer (e.g. `C:/Users\jef\notebooks\day1\01-basics.jl` or `/home/jef/notebooks/day1/01-basics.jl` for Linux users). 

This should open a browser window with the Pluto notebooks. The first time it can take a while (up to 10 minutes) since it is installing all the dependencies.

## Tips & Common problems
Pluto notebooks create and run the code in a separate environment, this sometimes creates an issue with the Plots library not being installed properly and crashing the notebooks importing this library (e.g. *01-basics.jl*). If this occurs the best fix is to already install `Plots` in the environment running the Pluto server and forcing Pluto to use that environment. 

```julia
import Pkg; 
Pkg.activate("."); # if this line fails replace with Pkg.instantiate(); 
Pkg.add("Plots"); 
Pkg.add("Pluto");

using Pluto; Pluto.run()
```

Open the notebook and before running the notebook add a new cell to load this environment,

```julia
import Pkg; Pkg.activate(".");
```

This should resolve problems with the Plots package not being installed.

## Contact
UGent Doctoral School member and Julia questions? Send one of us an email!

## Meta
Authors: [Bram De Jaegher](mailto:bram.de.jaegher@gmail.com), [Michiel Stock](Michiel.Stock@UGent.be), [Daan Van Hauwermeiren](Daan.VanHauwermeiren@UGent.be)
