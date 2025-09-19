#!/usr/bin/env bash
# server-stats.sh - Simple server performance report

# CPU usage (1s sample)
get_cpu() {
  read -r _ u1 n1 s1 i1 _ < /proc/stat
  sleep 1
  read -r _ u2 n2 s2 i2 _ < /proc/stat
  busy=$(( (u2-u1) + (n2-n1) + (s2-s1) ))
  total=$(( busy + (i2-i1) ))
  awk -v b="$busy" -v t="$total" 'BEGIN{printf "%.1f", (b/t)*100}'
}

# Memory usage
get_mem() {
  mem_total=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
  mem_avail=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
  mem_used=$((mem_total - mem_avail))
  pct=$(awk -v u="$mem_used" -v t="$mem_total" 'BEGIN{printf "%.1f", (u/t)*100}')
  echo "$((mem_used*1024)) $((mem_total*1024)) $pct"
}

# Disk usage (all filesystems)
get_disk() {
  read -r total used < <(df -B1 --total | awk '/total/ {print $2, $3}')
  pct=$(awk -v u="$used" -v t="$total" 'BEGIN{printf "%.1f", (u/t)*100}')
  echo "$used $total $pct"
}

# Human readable bytes
hr() { numfmt --to=iec --suffix=B "$1"; }

# Top processes
top_cpu() { ps -eo pid,pcpu,pmem,cmd --sort=-pcpu | head -n 6; }
top_mem() { ps -eo pid,pcpu,pmem,cmd --sort=-pmem | head -n 6; }

# Extra info
extra() {
  . /etc/os-release
  echo "OS: $NAME $VERSION"
  echo "Uptime: $(uptime -p)"
  echo "Load avg: $(cut -d ' ' -f1-3 < /proc/loadavg)"
  echo "Logged-in users: $(who | wc -l)"
  fails=$(grep -ci "failed password" /var/log/auth.log 2>/dev/null || echo 0)
  echo "Failed login attempts: $fails"
}

# -------- Report --------
echo "=== Server Report $(date -u) ==="
echo "CPU: $(get_cpu)%"
read u t p < <(get_mem)
echo "Memory: Used $(hr "$u") / $(hr "$t") ($p%)"
read du dt dp < <(get_disk)
echo "Disk: Used $(hr "$du") / $(hr "$dt") ($dp%)"
echo
echo "Top 5 by CPU:"; top_cpu
echo
echo "Top 5 by Memory:"; top_mem
echo
extra
echo "=== Report Complete ==="
