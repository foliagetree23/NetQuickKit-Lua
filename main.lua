
-- main.lua
-- Network Utility IT - Main Program
-- Created for IT administrators and network troubleshooting

local utils = require("utils")
local NetworkUtils = require("network_utils")
local config = require("config")

-- Function to display main menu


function show_main_menu()
    utils.clear_screen()
    utils.print_header("NETWORK UTILITY IT")
    utils.print_colored("Network Utility Program for IT Administrator", "cyan")
    utils.print_colored("============================================", "cyan")
    print()
    
    utils.print_colored("1. Network Diagnostics", "white")
    utils.print_colored("   1.1 Ping Test", "yellow")
    utils.print_colored("   1.2 DNS Lookup", "yellow")
    utils.print_colored("   1.3 Reverse DNS Lookup", "yellow")
    utils.print_colored("   1.4 Traceroute", "yellow")
    utils.print_colored("   1.5 Network Connectivity Check", "yellow")
    print()
    
    utils.print_colored("2. Network Interface Info", "white")
    utils.print_colored("   2.1 Interface Information", "yellow")
    utils.print_colored("   2.2 Network Statistics", "yellow")
    utils.print_colored("   2.3 Active Connections Monitor", "yellow")
    print()
    
    utils.print_colored("3. Port Scanner", "white")
    utils.print_colored("   3.1 Quick Port Scan (Common Ports)", "yellow")
    utils.print_colored("   3.2 Custom Port Scan", "yellow")
    print()
    
    utils.print_colored("4. Network Performance", "white")
    utils.print_colored("   4.1 Bandwidth Test", "yellow")
    print()
    
    utils.print_colored("5. Security Tools", "white")
    utils.print_colored("   5.1 Basic Security Scan", "yellow")
    print()
    
    utils.print_colored("0. Exit", "red")
    print()
end



-- Function for Network Diagnostics submenu
function show_network_diagnostics_menu()
    utils.clear_screen()
    utils.print_header("NETWORK DIAGNOSTICS")
    print()
    
    utils.print_colored("1. Ping Test", "white")
    utils.print_colored("2. DNS Lookup", "white")
    utils.print_colored("3. Reverse DNS Lookup", "white")
    utils.print_colored("4. Traceroute", "white")
    utils.print_colored("5. Network Connectivity Check", "white")
    print()
    utils.print_colored("0. Back to Main Menu", "red")
    print()
end



-- Function for Network Interface Info submenu
function show_interface_menu()
    utils.clear_screen()
    utils.print_header("NETWORK INTERFACE INFO")
    print()
    
    utils.print_colored("1. Interface Information", "white")
    utils.print_colored("2. Network Statistics", "white")
    utils.print_colored("3. Active Connections Monitor", "white")
    print()
    utils.print_colored("0. Back to Main Menu", "red")
    print()
end

-- Function for Port Scanner submenu
function show_port_scanner_menu()
    utils.clear_screen()
    utils.print_header("PORT SCANNER")
    print()
    
    utils.print_colored("1. Quick Port Scan (Common Ports)", "white")
    utils.print_colored("2. Custom Port Scan", "white")
    print()
    utils.print_colored("0. Back to Main Menu", "red")
    print()
end

-- Function to display Security Tools menu
function show_security_menu()
    utils.clear_screen()
    utils.print_header("SECURITY TOOLS")
    print()
    
    utils.print_colored("1. Basic Security Scan", "white")
    print()
    utils.print_colored("0. Back to Main Menu", "red")
    print()
end


-- Function for Ping Test menu
function menu_ping_test()
    local target = utils.get_input("Enter hostname/IP for ping")
    if target == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    local count_input = utils.get_input("Ping count (default: 4)")
    local count = tonumber(count_input) or 4
    
    NetworkUtils.ping(target, count)
    utils.pause()
end

-- Function for DNS Lookup menu
function menu_dns_lookup()
    local host = utils.get_input("Enter hostname for DNS lookup")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    NetworkUtils.dns_lookup(host)
    utils.pause()
end

-- Function for Reverse DNS Lookup menu
function menu_reverse_dns()
    local ip = utils.get_input("Enter IP address for reverse DNS lookup")
    if ip == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    if not utils.is_valid_ip(ip) then
        utils.print_formatted("Invalid IP address format", "error", "red")
        utils.pause()
        return
    end
    
    NetworkUtils.reverse_dns(ip)
    utils.pause()
end

-- Function for Traceroute menu
function menu_traceroute()
    local host = utils.get_input("Enter hostname/IP for traceroute")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    NetworkUtils.traceroute(host)
    utils.pause()
end

-- Function for Network Connectivity Check menu
function menu_connectivity_check()
    NetworkUtils.check_connectivity()
    utils.pause()
end

-- Function for Interface Information menu
function menu_interface_info()
    NetworkUtils.get_interface_info()
    utils.pause()
end

-- Function for Network Statistics menu
function menu_network_stats()
    NetworkUtils.network_stats()
    utils.pause()
end

-- Function for Active Connections Monitor menu
function menu_monitor_connections()
    NetworkUtils.monitor_connections()
    utils.pause()
end


-- Function for Quick Port Scan menu
function menu_quick_port_scan()
    local host = utils.get_input("Enter hostname/IP for port scan")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    utils.print_colored("Ports to scan: " .. table.concat(config.default_ports, ", "), "cyan")
    local confirm = utils.get_input("Continue? (y/n)")
    if confirm:lower() == "y" then
        NetworkUtils.port_scan(host, config.default_ports)
    else
        utils.print_formatted("Port scan cancelled", "warning", "yellow")
    end
    utils.pause()
end

-- Function for Custom Port Scan menu
function menu_custom_port_scan()
    local host = utils.get_input("Enter hostname/IP for port scan")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    local ports_input = utils.get_input("Enter ports (comma separated, e.g., 80,443,8080)")
    if ports_input == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    local ports = {}
    for port_str in ports_input:gmatch("%d+") do
        local port = tonumber(port_str)
        if port and utils.is_valid_port(port) then
            table.insert(ports, port)
        end
    end
    
    if #ports == 0 then
        utils.print_formatted("Invalid ports", "error", "red")
        utils.pause()
        return
    end
    
    NetworkUtils.port_scan(host, ports)
    utils.pause()
end

-- Function for Bandwidth Test menu
function menu_bandwidth_test()
    local host = utils.get_input("Enter hostname/IP for bandwidth test")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    NetworkUtils.bandwidth_test(host)
    utils.pause()
end

-- Function for Basic Security Scan menu
function menu_basic_security_scan()
    local host = utils.get_input("Enter hostname/IP for security scan")
    if host == "" then
        utils.print_formatted("Input cannot be empty", "error", "red")
        utils.pause()
        return
    end
    
    utils.print_header("BASIC SECURITY SCAN")
    utils.print_formatted("Starting security scan for " .. host, "info", "blue")
    
    -- Scan risky ports
    local risky_ports = {21, 23, 25, 53, 135, 139, 445, 1433, 3389}
    local open_risky_ports = NetworkUtils.port_scan(host, risky_ports)
    

    if #open_risky_ports > 0 then
        utils.print_formatted("WARNING: Found open risky ports:", "warning", "yellow")
        local has_high_risk = false
        for _, port_info in ipairs(open_risky_ports) do
            local risk_level = "MEDIUM"
            if port_info.port == 21 or port_info.port == 23 or port_info.port == 3389 then
                risk_level = "HIGH"
                has_high_risk = true
            end
            utils.print_colored("  Port " .. port_info.port .. " (" .. port_info.service .. ") - " .. risk_level .. " RISK", "red")
        end
        
        utils.print_formatted("\nSecurity Recommendations:", "info", "blue")
        for _, port_info in ipairs(open_risky_ports) do
            if port_info.port == 21 then
                utils.print_colored("- FTP: Ensure not using default credentials and use FTPS", "yellow")
            elseif port_info.port == 23 then
                utils.print_colored("- Telnet: Insecure, use SSH instead", "yellow")
            elseif port_info.port == 3389 then
                utils.print_colored("- RDP: Ensure using strong authentication and VPN", "yellow")
            elseif port_info.port == 25 then
                utils.print_colored("- SMTP: Ensure not becoming open relay", "yellow")
            elseif port_info.port == 445 then
                utils.print_colored("- SMB: Ensure not vulnerable to attacks like WannaCry", "yellow")
            elseif port_info.port == 1433 then
                utils.print_colored("- SQL Server: Ensure database not accessible from internet", "yellow")
            end
        end
        
        if has_high_risk then
            utils.print_formatted("⚠️  High risk found! Take immediate action.", "warning", "red")
        end
    else
        utils.print_formatted("No risky ports found open", "success", "green")
    end
    
    utils.pause()
end


-- Main function to run the program
function run_main_program()
    while true do
        show_main_menu()
        local choice = utils.get_input("Select menu (0-5)")
        
        if choice == "0" then
            utils.clear_screen()
            utils.print_formatted("Thank you for using Network Utility IT", "success", "green")
            utils.print_colored("Exiting program...", "cyan")
            break
        elseif choice == "1" then
            -- Network Diagnostics Submenu
            while true do
                show_network_diagnostics_menu()
                local sub_choice = utils.get_input("Select submenu (0-5)")
                
                if sub_choice == "0" then
                    break
                elseif sub_choice == "1" then
                    menu_ping_test()
                elseif sub_choice == "2" then
                    menu_dns_lookup()
                elseif sub_choice == "3" then
                    menu_reverse_dns()
                elseif sub_choice == "4" then
                    menu_traceroute()
                elseif sub_choice == "5" then
                    menu_connectivity_check()
                else
                    utils.print_formatted("Invalid choice", "error", "red")
                    utils.pause()
                end
            end
        elseif choice == "2" then
            -- Network Interface Info Submenu
            while true do
                show_interface_menu()
                local sub_choice = utils.get_input("Select submenu (0-3)")
                
                if sub_choice == "0" then
                    break
                elseif sub_choice == "1" then
                    menu_interface_info()
                elseif sub_choice == "2" then
                    menu_network_stats()
                elseif sub_choice == "3" then
                    menu_monitor_connections()
                else
                    utils.print_formatted("Invalid choice", "error", "red")
                    utils.pause()
                end
            end
        elseif choice == "3" then
            -- Port Scanner Submenu
            while true do
                show_port_scanner_menu()
                local sub_choice = utils.get_input("Select submenu (0-2)")
                
                if sub_choice == "0" then
                    break
                elseif sub_choice == "1" then
                    menu_quick_port_scan()
                elseif sub_choice == "2" then
                    menu_custom_port_scan()
                else
                    utils.print_formatted("Invalid choice", "error", "red")
                    utils.pause()
                end
            end
        elseif choice == "4" then
            -- Network Performance
            menu_bandwidth_test()
        elseif choice == "5" then
            -- Security Tools
            while true do
                show_security_menu()
                local sub_choice = utils.get_input("Select submenu (0-1)")
                
                if sub_choice == "0" then
                    break
                elseif sub_choice == "1" then
                    menu_basic_security_scan()
                else
                    utils.print_formatted("Invalid choice", "error", "red")
                    utils.pause()
                end
            end
        else
            utils.print_formatted("Invalid choice", "error", "red")
            utils.pause()
        end
    end
end

-- Check dependencies
function check_dependencies()
    local required_commands = {"ping", "nslookup", "traceroute", "netstat", "ip"}
    local missing_commands = {}
    
    for _, cmd in ipairs(required_commands) do
        if not utils.command_exists(cmd) then
            table.insert(missing_commands, cmd)
        end
    end
    

    if #missing_commands > 0 then
        utils.print_formatted("WARNING: The following commands were not found:", "warning", "yellow")
        for _, cmd in ipairs(missing_commands) do
            utils.print_colored("  - " .. cmd, "red")
        end
        utils.print_formatted("Some features may not work properly", "warning", "yellow")
        utils.pause()
    end
end

-- Main execution
if arg[0]:match("main.lua") then
    check_dependencies()
    run_main_program()

else
    utils.print_formatted("This program must be run as main.lua", "error", "red")
end
