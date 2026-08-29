#!/bin/bash

input=$(cat)

# --- Parse fields ---
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
weekly_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
model_raw=$(echo "$input" | jq -r '.model.display_name // .model // empty')
cwd_raw=$(echo "$input" | jq -r '.cwd // empty')

# --- Format token numbers ---
format_tokens() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "null" ]; then echo ""; return; fi
  echo "$n" | awk '{
    if ($1 >= 1000000) printf "%.1fM", $1/1000000
    else if ($1 >= 1000) printf "%.1fk", $1/1000
    else printf "%d", $1
  }'
}

# --- Colored 10-char progress bar ---
# green < 50%, yellow 50-75%, red > 75%
make_bar() {
  local label="$1"
  local pct="$2"
  local int
  int=$(printf "%.0f" "$pct")
  [ "$int" -lt 0 ] && int=0
  [ "$int" -gt 100 ] && int=100
  local filled=$(( int * 12 / 100 ))
  local bar="" i
  for i in $(seq 1 12); do
    if [ "$i" -le "$filled" ]; then bar="${bar}▓"
    else bar="${bar}░"
    fi
  done
  local color
  if [ "$int" -lt 50 ]; then color=$'\033[32m'      # green
  elif [ "$int" -le 75 ]; then color=$'\033[33m'    # yellow
  else color=$'\033[31m'                            # red
  fi
  printf '%s%s %s %d%%\033[0m' "$color" "$label" "$bar" "$int"
}

# --- Model display name (raw from input) ---
model_display="$model_raw"

# --- Working directory ---
if [ -n "$cwd_raw" ] && [ "$cwd_raw" != "null" ]; then
  work_dir="$cwd_raw"
else
  work_dir=$(pwd)
fi
dir_name=$(basename "$work_dir")

# --- Git branch ---
branch=""
if git -C "$work_dir" rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "$work_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# --- Token total ---
total_tok=$(( total_in + total_out ))
tok_fmt=$(format_tokens "$total_tok")

# --- Assemble single line ---
parts=()
[ -n "$model_display" ] && parts+=("$model_display")
parts+=("📁 ${dir_name}")
[ -n "$branch" ] && parts+=("$branch")
[ -n "$ctx_used" ] && parts+=("$(make_bar "context" "$ctx_used")")
[ -n "$session_used" ] && parts+=("$(make_bar "session" "$session_used")")
[ -n "$weekly_used" ] && parts+=("$(make_bar "weekly" "$weekly_used")")
[ "$total_tok" -gt 0 ] && [ -n "$tok_fmt" ] && parts+=("tok:${tok_fmt}")

line=""
for part in "${parts[@]}"; do
  if [ -z "$line" ]; then line="$part"
  else line="$line | $part"
  fi
done

printf "%s" "$line"
