# Server Performance Stats
A Bash script to analyze basic Linux server performance metrics.

## Features
- CPU usage (approximate, sampled over 1s)
- Memory usage (used vs available, with percentage)
- Disk usage (aggregate used vs total)
- Top 5 processes by CPU
- Top 5 processes by Memory
- Extra info: OS version, uptime, load average, logged-in users, failed login attempts

## Requirements
- Linux system with Bash, awk, ps, df
- Access to `/proc`
- No external dependencies required

## Installation
Clone this repo and make the script executable:

```bash
git clone https://github.com/<your-username>/server-performance-stats.git
cd server-performance-stats
chmod +x server-stats.sh

https://roadmap.sh/projects/server-stats
Check wiki for full Documentation - https://github.com/Zoharthelight/Server-Performance-Stats/wiki
