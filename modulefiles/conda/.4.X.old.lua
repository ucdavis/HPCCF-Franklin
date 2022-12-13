-- -*- lua -*-

whatis([[Name : conda]])
whatis([[Version : 4.X]])
whatis([[Target : x86_64]])


-- if { [info exists env(CONDA_EXE)] && [module-info command load] } {
if mode() == "load" and os.getenv("CONDA_EXE") then
    LmodError(
[[CONDA_EXE is currently defined: ]] .. os.getenv("CONDA_EXE") ..
[[This module will almost certainly interfere with your conda installation.
Remove existing conda installation and its shell hooks from your PATH before proceeding.
]])
end

-- if { [info exists env(CONDA_PREFIX)] && [module-info command unload] } {
if mode() == "unload" and os.getenv("CONDA_PREFIX") then
    LmodError(
[[CONDA_PREFIX is currently defined: ]] .. os.getenv("CONDA_PREFIX") ..
[[This means you have a conda environment active.
Make sure to `conda deactivate` before you unload this module.
]])
    os.exit(1)
end

setenv("CONDA_MOD_ROOT", "/share/apps/conda/miniconda")
prepend_path("PATH", pathJoin(os.getenv("CONDA_MOD_ROOT"), "bin"))
prepend_path("PATH", pathJoin(os.getenv("CONDA_MOD_ROOT"), "/condabin"))
prepend_path("MANPATH", pathJoin(os.getenv("CONDA_MOD_ROOT"), "/share/man"))

-- https://setuptools.pypa.io/en/latest/deprecated/distutils-legacy.html
setenv("SETUPTOOLS_USE_DISTUTILS", "stdlib")

if mode() == "load" then
    conda_helper_dir = "/share/apps/franklin/src/conda"
    active_shell = myShellName()
    LmodMessage([[Active shell: ]] .. active_shell)
    if active_shell == "bash" or active_shell == "sh" then
        source_sh("bash", pathJoin(conda_helper_dir, "shell-setup.bash"))
    elseif active_shell == "zsh" then
        source_sh("zsh", pathJoin(conda_helper_dir, "shell-setup.zsh"))
    elseif active_shell == "tcsh" then
        source_sh("tcsh", pathJoin(conda_helper_dir, "shell-setup.tcsh"))
    else
        LmodError([[Shell not supported: ]] .. active_shell ..
                  [[\nUse one of sh, bash, zsh, or tcsh.]])
    end
end

if mode() == "load" then
    LmodMessage([[
This module initializes a base conda install in your current shell environment.
It takes care of `conda init`, and as such, will interfere with locally-installed
conda; if you have a local install, it should have warned you and failed to load.

To view available environments, including your local environments and those
installed system-wide, use:

    conda env list

To activate an environment, use: 
    
    conda activate [ENVIRONMENT_NAME]

To create your own environment, you can use either the `conda` or `mamba` command.
`mamba` functions exactly the same as `conda`, and uses the same channels, while
solving and creating environments much more efficiently. For example, you could create
an environment containing python v3.10, pandas, and ipython with:

    mamba create -n my-pandas-env python=3.10 pandas ipython

and activate it with:

    conda activate my-pandas-env

For more information, see: https://conda.io/projects/conda/en/latest/user-guide/getting-started.html#managing-environments.
]])
end
