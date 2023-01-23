-- -*- lua -*-

whatis([[Name : conda]])
whatis([[Version : 4.X]])
whatis([[Target : x86_64]])

local root = "/share/apps/conda/mambaforge"

-- **load**
if (myShellType() == "sh") then
    --execute { 
    --    cmd = "export "..save_prompt_env_var_name.."=\"$PS1\"",
    --    modeA = {"load"}
    --}

    local __conda_setup = "\"$('" .. pathJoin(root, "bin/conda") .. "' 'shell." .. myShellName() ..
                              "' 'hook' 2> /dev/null)\""
    execute {
        cmd = "eval " .. __conda_setup,
        modeA = {"load"}
    }
    -- Initialize mamba if using bash shell
    execute {
        cmd = "source " .. pathJoin(root, "etc/profile.d/mamba.sh"),
        modeA = {"load"}
    }
end

if (myShellType() == "csh") then
    --execute{
    --    cmd = "setenv "..save_prompt_env_var_name.." \"$prompt\"",
    --    modeA = {"load"}
    --}
    execute {
        cmd = "source " .. pathJoin(root, "etc/profile.d/conda.csh"),
        modeA = {"load"}
    }
end

-- **unload**
if (mode() == "unload") then
    -- When starting an interactive session, the unload script is run when
    -- conda is not yet initalized. This causes unncessary warnings to be
    -- printed. Thus stderr is suppressed to avoid confusion
    local deactivate = ""
    if (myShellType() == "sh") then
        deactivate = "conda deactivate 2> /dev/null"
    end
    if (myShellType() == "csh") then
        deactivate = "conda deactivate >& /dev/null"
    end
    local shell_level = tonumber(os.getenv("CONDA_SHLVL"))
    for i = shell_level, 1, -1 do
        execute {
            cmd = deactivate,
            modeA = {"unload"}
        }
    end
    remove_path("PATH", pathJoin(root, "bin"))
    remove_path("PATH", pathJoin(root, "condabin"))
end
vars = {"__add_sys_prefix_to_path", "__conda_activate", "__conda_exe", "__conda_hashr", "__conda_reactivate",
        "_CE_CONDA", "_CONDA_EXE", "_CONDA_ROOT", "conda", "CONDA_EXE", "CONDA_PYTHON_EXE", "CONDA_SHLVL", "mamba"}
for i, var in pairs(vars) do
    if (myShellType() == "sh") then
        execute {
            cmd = "unset " .. var,
            modeA = {"unload"}
        }
    end
    if (myShellType() == "csh") then
        execute {
            cmd = "unsetenv " .. var,
            modeA = {"unload"}
        }
    end
end
if (myShellType() == "csh") then
    execute {
        cmd = "unalias conda",
        modeA = {"unload"}
    }
end
