-- utils.lua
-- General utility functions for Network Utility IT

local config = require("config")

-- Function to print with color
function print_colored(text, color)
    color = color or "white"
    print(config.colors[color] .. text .. config.colors.reset)
end

-- Function to print header
function print_header(text)
    local header = string.format(config.formats.header, text)
    print_colored(string.rep("=", #header), "cyan")
    print_colored(header, "bold")
    print_colored(string.rep("=", #header), "cyan")
end

-- Function to print with format
function print_formatted(text, format_type, color)
    format_type = format_type or "info"
    color = color or "white"
    local formatted = string.format(config.formats[format_type], text)
    print_colored(formatted, color)
end

-- Function for input with validation
function get_input(prompt)
    io.write(prompt .. ": ")
    return io.read("*l")
end

-- Function for IP address validation
function is_valid_ip(ip)
    if not ip or ip == "" then return false end
    
    local parts = {}
    for part in ip:gmatch("%d+") do
        table.insert(parts, tonumber(part))
    end
    
    if #parts ~= 4 then return false end
    
    for _, part in ipairs(parts) do
        if part < 0 or part > 255 then return false end
    end
    
    return true
end

-- Function for hostname validation
function is_valid_hostname(hostname)
    if not hostname or hostname == "" then return false end
    if hostname:len() > 253 then return false end
    
    -- Pattern for valid hostname
    local pattern = "^[a-zA-Z0-9]([a-zA-Z0-9%-]{0,61}[a-zA-Z0-9])?([%.][a-zA-Z0-9]([a-zA-Z0-9%-]{0,61}[a-zA-Z0-9])?)*$"
    return hostname:match(pattern) ~= nil
end

-- Function for port validation
function is_valid_port(port)
    if not port or port == "" then return false end
    local num = tonumber(port)
    return num and num >= 1 and num <= 65535
end

-- Function for delay
function sleep(seconds)
    os.execute("sleep " .. seconds)
end

-- Function to clear screen
function clear_screen()
    os.execute("clear")
end

-- Function for pause
function pause()
    print_colored("\nPress Enter to continue...", "yellow")
    io.read("*l")
end

-- Function to format bytes
function format_bytes(bytes)
    if bytes < 1024 then
        return bytes .. " B"
    elseif bytes < 1024 * 1024 then
        return string.format("%.2f KB", bytes / 1024)
    elseif bytes < 1024 * 1024 * 1024 then
        return string.format("%.2f MB", bytes / (1024 * 1024))
    else
        return string.format("%.2f GB", bytes / (1024 * 1024 * 1024))
    end
end

-- Function to format time
function format_time(seconds)
    if seconds < 1 then
        return string.format("%.2f ms", seconds * 1000)
    else
        return string.format("%.2f s", seconds)
    end
end

-- Function to split string
function split_string(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Function to trim string
function trim(str)
    return str:match("^%s*(.-)%s*$")
end

-- Function to check command availability
function command_exists(command)
    local file = io.popen("which " .. command)
    local result = file:read("*all")
    file:close()
    return result:match(command) ~= nil
end

-- Export functions
return {
    print_colored = print_colored,
    print_header = print_header,
    print_formatted = print_formatted,
    get_input = get_input,
    is_valid_ip = is_valid_ip,
    is_valid_hostname = is_valid_hostname,
    is_valid_port = is_valid_port,
    sleep = sleep,
    clear_screen = clear_screen,
    pause = pause,
    format_bytes = format_bytes,
    format_time = format_time,
    split_string = split_string,
    trim = trim,
    command_exists = command_exists
}

