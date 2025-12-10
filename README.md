
# Network Utility IT

A comprehensive network utility program for IT Administrators built using Lua. This program provides various tools for network troubleshooting, monitoring, and security scanning.

## Main Features


### 1. Network Diagnostics
- **Ping Test**: Test connectivity to host with custom packet count
- **DNS Lookup**: Resolve hostname to IP address
- **Reverse DNS Lookup**: Resolve IP address to hostname
- **Traceroute**: Trace path to destination host
- **Network Connectivity Check**: Test connectivity to several common hosts

### 2. Network Interface Info
- **Interface Information**: View network interface information and IP addresses
- **Network Statistics**: Monitor traffic and network statistics
- **Active Connections Monitor**: Monitor active connections on the system

### 3. Port Scanner
- **Quick Port Scan**: Scan common ports (16 predefined ports)
- **Custom Port Scan**: Scan ports as needed with custom input

### 4. Network Performance
- **Bandwidth Test**: Test bandwidth and latency to target host

### 5. Security Tools
- **Basic Security Scan**: Scan high-risk ports and provide security recommendations


## System Requirements

- **Lua 5.1 or newer**
- **Linux/macOS** (some features require Unix commands)
- **Required command-line tools**:
  - `ping`
  - `nslookup`
  - `traceroute`
  - `netstat`
  - `ip`

## Installation

1. Make sure Lua is installed on your system
2. Clone or download the program files
3. Run the program:

```bash
lua main.lua
```

## Usage

### Running the Program
```bash
lua main.lua
```

### Menu Navigation
- The program uses an interactive number-based menu
- Select main menu (0-5)
- For submenu, select the corresponding number (0 to go back)
- Required input will be requested interactively


### Usage Examples

#### 1. Ping Test
```
Select menu: 1 (Network Diagnostics)
Select submenu: 1 (Ping Test)
Enter hostname/IP: google.com
Ping count (default: 4): 4
```

#### 2. Port Scan
```
Select menu: 3 (Port Scanner)
Select submenu: 1 (Quick Port Scan)
Enter hostname/IP: 192.168.1.1
```

#### 3. Custom Port Scan
```
Select menu: 3 (Port Scanner)
Select submenu: 2 (Custom Port Scan)
Enter hostname/IP: example.com
Enter ports: 80,443,8080,3306
```

#### 4. Security Scan
```
Select menu: 5 (Security Tools)
Select submenu: 1 (Basic Security Scan)
Enter hostname/IP: target-server.com
```


## File Structure

- `main.lua` - Main program with interactive menu
- `network_utils.lua` - Network functions module
- `utils.lua` - General utility functions
- `config.lua` - Program configuration (ports, service mapping, colors)
- `README.md` - Program documentation

## Configuration

Edit `config.lua` file to customize:
- Default ports for scanning
- Service names mapping
- Output colors
- Timeout values

## Security Features

This program also provides security scanning features to identify:
- Open high-risk ports
- Security recommendations for each port
- Risk levels (HIGH/MEDIUM)

### Monitored Risky Ports:
- **Port 21** (FTP) - Default credentials
- **Port 23** (Telnet) - Unencrypted
- **Port 25** (SMTP) - Open relay
- **Port 3389** (RDP) - Remote desktop exposure
- **Port 445** (SMB) - Vulnerability to ransomware
- **Port 1433** (SQL Server) - Database exposure
- **...**


## Troubleshooting

### Command not found
If any command is not available, the program will show a warning but can still run with limited features.

### Permission Error
Some features may require sudo/root permission for network information access.

### Network Timeout
Add longer timeout for slow networks in configuration.

## Contributions

This program can be further developed by adding:
- Real-time network monitoring features
- Logging and reporting
- Export scan results to file
- Support for other protocols
- Web interface

## License

This program is created for IT Administrator purposes and educational use.

## Support

For help or bug reports, please check:
1. System dependencies are installed
2. Network access permissions
3. Firewall configuration

---

**Created with ❤️ for IT Administrator**
