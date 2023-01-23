-- -*- lua -*-
whatis([[Name : crYOLO]])
whatis([[Version : 1.8.4-cuda-11]])
whatis([[Target : x86_64]])

depends_on("conda/base/4.X")

execute {
    cmd = "conda activate cryolo-1.8.4-cuda-11",
    modeA = {"load"}
}

if (mode() == "unload") then
    -- When starting an interactive session, the unload script is run when
    -- conda is not yet initalized. This causes unncessary warnings to be
    -- printed. Thus stderr is suppressed to avoid confusion
    local deactivate = ""
    if (myShellType() == "sh") then
        deactivate = "conda deactivate"
    end
    if (myShellType() == "csh") then
        deactivate = "conda deactivate >& /dev/null"
    end

    execute {
       cmd = deactivate,
       modeA = {"unload"}
    }
end
