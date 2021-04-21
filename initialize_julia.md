# Initialize Julia Workspace

1. Create a working directory `my_home/my_project`.  
2. Open the workspace with `VS Code`.
3. Start Julia interpreter `Ctrl-Shift-P`, `Julia: Start REPL`
4. `]` enter package mode, Use `activate .` to active current directory as the working directory.
5. Add some packages
   1. `add Revise`
   2. `add Debugger`
6. Two files are created after adding packages.  Commit both files for a workspace directory, and only `Project.toml` for a package directory.