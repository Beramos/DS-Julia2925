def setup_plutoserver():
  return {
    "command": ["julia", "--optimize=0", "-e","import Pkg; Pkg.add(\"https://github.com/Beramos/Pluto.jl#DS-Julia-2925\")" ,"import Pluto; Pluto.run(host=\"0.0.0.0\", port={port}, launch_browser=false, require_secret_for_open_links=false, require_secret_for_access=false)"],
    "timeout": 60,
    "launcher_entry": {
        "title": "Pluto.jl",
    },
  }
