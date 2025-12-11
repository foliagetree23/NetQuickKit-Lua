-- network_utils.lua
-- Network functions module for Network Utility IT

local config = require("config")
local utils = require("utils")

local NetworkUtils = {}

-- Function for ping
function NetworkUtils.ping(host, count)
    if not host then
        utils.print_formatted("Host cannot be empty", "error", "red")
        return false
    end
    
    count = count or 4
    local cmd = string.format("ping -c %d %s", count, host)
    
    utils.print_formatted("Pinging " .. host, "info", "blue")
    
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    if result:match("64 bytes from") then
        local time_match = result:match("time=([0-9.]+) ms")
        if time_match then
            local avg_time = tonumber(time_match)
            utils.print_formatted("Ping successful - RTT: " .. avg_time .. " ms", "success", "green")
            return true
        else
            utils.print_formatted("Host is reachable", "success", "green")
            return true
        end
    else
        utils.print_formatted("Host is unreachable", "error", "red")
        return false
    end
end

-- Function for DNS lookup
function NetworkUtils.dns_lookup(host)
    if not host then
        utils.print_formatted("Host cannot be empty", "error", "red")
        return false
    end
    
    utils.print_formatted("Performing DNS lookup for " .. host, "info", "blue")
    
    -- Resolve hostname to IP
    local cmd = "nslookup " .. host
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    local ip_addresses = {}
    for ip in result:gmatch("Address: ([0-9.]+)") do
        table.insert(ip_addresses, ip)
    end
    
    if #ip_addresses > 0 then
        utils.print_formatted("IP Address(es): " .. table.concat(ip_addresses, ", "), "success", "green")
        return ip_addresses
    else
        utils.print_formatted("DNS lookup failed", "error", "red")
        return false
    end
end

-- Function for reverse DNS lookup
function NetworkUtils.reverse_dns(ip)
    if not ip then
        utils.print_formatted("IP address cannot be empty", "error", "red")
        return false
    end
    
    utils.print_formatted("Performing reverse DNS lookup for " .. ip, "info", "blue")
    
    local cmd = "nslookup " .. ip
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    local name_match = result:match("name = ([^%s]+)")
    if name_match then
        utils.print_formatted("Hostname: " .. name_match, "success", "green")
        return name_match
    else
        utils.print_formatted("Reverse DNS lookup failed", "error", "red")
        return false
    end
end

-- Function to get network interface information
function NetworkUtils.get_interface_info()
    utils.print_formatted("Getting network interface information", "info", "blue")
    
    local cmd = "ip addr show"
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    local interfaces = {}
    for interface_block in result:gmatch("^[0-9]+: ([^:]+):.-\n(.-)\n" ) do
        local info = {
            name = interface_block:match("^([^:]+)"),
            ip_addresses = {}
        }
        
        for ip in interface_block:gmatch("inet ([0-9./]+)") do
            table.insert(info.ip_addresses, ip)
        end
        
        table.insert(interfaces, info)
    end
    
    if #interfaces > 0 then
        for _, iface in ipairs(interfaces) do
            utils.print_colored("Interface: " .. iface.name, "cyan")
            for _, ip in ipairs(iface.ip_addresses) do
                utils.print_colored("  IP: " .. ip, "white")
            end
        end
        return interfaces
    else
        utils.print_formatted("Cannot get interface information", "error", "red")
        return false
    end
end

-- Function for port scanning
function NetworkUtils.port_scan(host, ports, timeout)
    if not host then
        utils.print_formatted("Host cannot be empty", "error", "red")
        return false
    end
    
    ports = ports or config.default_ports
    timeout = timeout or 1
    
    utils.print_formatted("Starting port scan on " .. host, "info", "blue")
    
    local open_ports = {}
    local total_ports = #ports
    local current_port = 0
    
    for _, port in ipairs(ports) do
        current_port = current_port + 1
        utils.print_colored(string.format("Scanning port %d/%d (%d)...", current_port, total_ports, port), "yellow")
        
        -- Try to connect to port using timeout
        local cmd = string.format("timeout %d bash -c 'cat < /dev/null > /dev/tcp/%s/%d' 2>/dev/null", timeout, host, port)
        local success = os.execute(cmd)
        
        if success == 0 then
            local service = config.services[port] or "Unknown"
            table.insert(open_ports, {port = port, service = service})
            utils.print_formatted("Port " .. port .. " (" .. service .. ") - OPEN", "success", "green")
        else
            utils.print_colored("Port " .. port .. " - CLOSED", "red")
        end
    end
    
    if #open_ports > 0 then
        utils.print_formatted(string.format("Scan complete. Found %d open ports.", #open_ports), "success", "green")
        return open_ports
    else
        utils.print_formatted("No open ports found", "warning", "yellow")
        return {}
    end
end

-- Function for traceroute
function NetworkUtils.traceroute(host)
    if not host then
        utils.print_formatted("Host cannot be empty", "error", "red")
        return false
    end
    
    utils.print_formatted("Performing traceroute to " .. host, "info", "blue")
    
    local cmd = "traceroute " .. host
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    if result and result:match("traceroute") then
        utils.print_colored(result, "white")
        return true
    else
        utils.print_formatted("Traceroute failed", "error", "red")
        return false
    end
end

-- Function for monitoring active connections
function NetworkUtils.monitor_connections()
    utils.print_formatted("Monitoring active connections", "info", "blue")
    
    local cmd = "netstat -tuln"
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    local connections = {}
    for line in result:gmatch("[^\n]+") do
        if line:match("^tcp") or line:match("^udp") then
            table.insert(connections, line)
        end
    end
    
    if #connections > 0 then
        utils.print_colored("Active Connections:", "cyan")
        for _, conn in ipairs(connections) do
            utils.print_colored(conn, "white")
        end
        return connections
    else
        utils.print_formatted("No active connections found", "warning", "yellow")
        return {}
    end
end

-- Function for bandwidth testing (simplified)
function NetworkUtils.bandwidth_test(host)
    if not host then
        utils.print_formatted("Host cannot be empty", "error", "red")
        return false
    end
    
    utils.print_formatted("Performing bandwidth test to " .. host, "info", "blue")
    
    -- Simple ping-based latency test
    local start_time = os.clock()
    local cmd = "ping -c 1 " .. host
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    local end_time = os.clock()
    
    if result:match("time=([0-9.]+)") then
        local latency = tonumber(result:match("time=([0-9.]+)"))
        utils.print_formatted("Latency: " .. latency .. " ms", "success", "green")
        
        -- Estimate bandwidth based on latency (rough estimate)
        local estimated_bandwidth
        if latency < 10 then
            estimated_bandwidth = "High (Latency < 10ms)"
        elseif latency < 50 then
            estimated_bandwidth = "Good (Latency 10-50ms)"
        elseif latency < 100 then
            estimated_bandwidth = "Fair (Latency 50-100ms)"
        else
            estimated_bandwidth = "Poor (Latency > 100ms)"
        end
        
        utils.print_formatted("Estimated bandwidth quality: " .. estimated_bandwidth, "info", "blue")
        return true
    else
        utils.print_formatted("Bandwidth test failed", "error", "red")
        return false
    end
end

-- Function for network statistics
function NetworkUtils.network_stats()
    utils.print_formatted("Getting network statistics", "info", "blue")
    
    local cmd = "cat /proc/net/dev"
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    utils.print_colored("Network Statistics:", "cyan")
    
    for line in result:gmatch("[^\n]+") do
        if line:match(":") then
            local parts = utils.split_string(utils.trim(line), "%s+")
            if #parts >= 10 then
                local interface = parts[1]:gsub(":", "")
                local rx_bytes = tonumber(parts[2]) or 0
                local tx_bytes = tonumber(parts[10]) or 0
                
                utils.print_colored("Interface " .. interface .. ":", "yellow")
                utils.print_colored("  RX: " .. utils.format_bytes(rx_bytes), "white")
                utils.print_colored("  TX: " .. utils.format_bytes(tx_bytes), "white")
            end
        end
    end
    
    return true
end


-- Function to check network connectivity
function NetworkUtils.check_connectivity()
    utils.print_formatted("Checking network connectivity", "info", "blue")
    
    -- Test with some common hosts
    local test_hosts = {
        "8.8.8.8",      -- Google DNS
        "1.1.1.1",      -- Cloudflare DNS
        "google.com"    -- Google
    }
    
    for _, host in ipairs(test_hosts) do
        utils.print_colored("Testing " .. host, "yellow")
        local cmd = "ping -c 1 -W 3 " .. host
        local file = io.popen(cmd)
        local result = file:read("*all")
        file:close()
        
        if result:match("64 bytes from") then
            utils.print_formatted(host .. " - REACHABLE", "success", "green")
        else
            utils.print_formatted(host .. " - UNREACHABLE", "error", "red")
        end
    end
    
    return true
end

-- Function to display ARP table
function NetworkUtils.display_arp_table()
    utils.print_formatted("Displaying ARP table", "info", "blue")
    
    local cmd = "arp -a"
    local file = io.popen(cmd)
    local result = file:read("*all")
    file:close()
    
    if result and result:match("%S") then
        utils.print_colored("ARP Table:", "cyan")
        utils.print_colored("======================================", "cyan")
        
        -- Parse ARP table entries
        local entries = {}
        for line in result:gmatch("[^\n]+") do
            if line:match("%d+%.%d+%.%d+%.%d+") then
                table.insert(entries, line)
            end
        end
        
        if #entries > 0 then
            for _, entry in ipairs(entries) do
                utils.print_colored(entry, "white")
            end
            utils.print_formatted(string.format("Found %d ARP entries", #entries), "success", "green")
        else
            utils.print_formatted("No ARP entries found", "warning", "yellow")
        end
    else
        utils.print_formatted("ARP table is empty or command failed", "warning", "yellow")
    end
    
    return true
end

return NetworkUtils

