# Julia2925: learn a fast and intuitive programming language in two workdays. 

This course is currently under construction. All materials are work-in-progress.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/Beramos/DS-Julia2925/binder_pluto_server)

## Introduction

In case you do not want to install julia and jump straight in the course material, use binder instead. However, we do not recommend doing so since saving progress is tricky. 

## Getting started
### Installing Julia
1. Download the *Julia* binaries for your system [here](https://julialang.org/downloads/) we suggest to install the Long-term support release, v1.0.5
2. Yes, it is that simple :zap:

### First time running 
Download or clone this repository, navigate to the files and open the Julia REPL,

```julia
import Pkg
Pkg.activate(".")
Pkg.instantiate()
```
to install the dependencies.

### Opening the noteboos
Open the Julia REPL

```julia
import Pkg
Pkg.activate(".")

using Pluto
Pluto.run()
```

This should open a browser window with the Pluto notebooks.

## Meta
Authors: Bram De Jaegher, Michiel Stock, Daan Van Hauwermeiren
