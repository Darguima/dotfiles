-- https://gist.github.com/h1k3r/089d43771bdf811eefe8
local function getHostname()
    local f = io.popen("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname = string.gsub(hostname, "\n$", "")
    return hostname
end

local function convertHostnameToEnvirnment(hostname)
    -- Check the complete list of hostnames on '/etc/hosts'
    local dotfiles_environment

    if hostname == "darguimaDesktop" then
        dotfiles_environment = "desktop"
    elseif hostname == "darguimaLaptop" then
        dotfiles_environment = "laptop"
    else
        dotfiles_environment = "desktop"
    end

    return dotfiles_environment
end

local function get_dotfiles_environment()
    --[[
        Althought `DOTFILES_ENVIRONMENT` bash variable is setted when installing my
        dotfiles from https://github.com/Darguima/dotfiles, this LUA script can't access it.
        So to find out what this computer is, we run a check with its hostname. Every computer
        has is unique hostname and the complete list can be cheched at `/etc/hosts` file.

        `dotfiles_environment` variable can be `desktop`, `laptop`, or ...

        Why use this? In `desktop`, for example, isn't needed to load battery or brightness widgtes.
    --]]
    return convertHostnameToEnvirnment(getHostname())
end

return {
    get_dotfiles_environment = get_dotfiles_environment
}
