local function get_dotfiles_environment()
    --[[
        In order to find out what this computer is (desktop | laptop | etc), we run a check against dotfiles config file.
        My dotfiles write the property ENV at ~/.config/dotfiles_config, and we will read it.

        `Env` variable can be `desktop`, `laptop`, or ...

        Why use this? In `desktop`, for example, isn't needed to load battery or brightness widgtes.
    --]]

    local env = "fallback"
    local dotfiles_config_path = os.getenv("HOME") .. "/.config/dotfiles_config"

    local f = io.open(dotfiles_config_path, "rb")

    if f then
        for line in io.lines(dotfiles_config_path) do 
            local _, _, extractedValue = line:find("ENV=(%S+)")

            if extractedValue then
    		    env = extractedValue
                break
            end
        end
        f:close()
    end 

    return env
end

return {
    get_dotfiles_environment = get_dotfiles_environment
}
