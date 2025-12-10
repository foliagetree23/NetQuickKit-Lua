-- config.lua
-- Configuration for Network Utility IT

return {
    -- Timeout in seconds
    timeout = 5,
    
    -- Default ports for scanning
    default_ports = {
        21,    -- FTP
        22,    -- SSH
        23,    -- Telnet
        25,    -- SMTP
        53,    -- DNS
        80,    -- HTTP
        110,   -- POP3
        143,   -- IMAP
        443,   -- HTTPS
        993,   -- IMAPS
        995,   -- POP3S
        3306,  -- MySQL
        3389,  -- RDP
        5432,  -- PostgreSQL
        5900,  -- VNC
        8080   -- HTTP-alt
    },
    
    -- Service names mapping
    services = {
        [21] = "FTP",
        [22] = "SSH",
        [23] = "Telnet",
        [25] = "SMTP",
        [53] = "DNS",
        [80] = "HTTP",
        [110] = "POP3",
        [143] = "IMAP",
        [443] = "HTTPS",
        [993] = "IMAPS",
        [995] = "POP3S",
        [3306] = "MySQL",
        [3389] = "RDP",
        [5432] = "PostgreSQL",
        [5900] = "VNC",
        [8080] = "HTTP-alt"
    },
    
    -- Colors for output
    colors = {
        reset = "\27[0m",
        red = "\27[31m",
        green = "\27[32m",
        yellow = "\27[33m",
        blue = "\27[34m",
        magenta = "\27[35m",
        cyan = "\27[36m",
        white = "\27[37m",
        bold = "\27[1m"
    },
    
    -- Output formats
    formats = {
        header = "=== %s ===",
        success = "✓ %s",
        error = "✗ %s",
        info = "ℹ %s",
        warning = "⚠ %s"
    }
}

