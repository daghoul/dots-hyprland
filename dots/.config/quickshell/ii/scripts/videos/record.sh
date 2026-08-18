#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

read_config() {
    local key="$1"
    local default="$2"
    local value
    value=$(jq -r ".screenRecord.$key" "$CONFIG_FILE" 2>/dev/null)
    if [[ "$value" == "null" ]] || [[ -z "$value" ]]; then
        echo "$default"
    else
        echo "$value"
    fi
}

SAVE_PATH=$(read_config "savePath" "$HOME/Videos")
GPU_ENABLED=$(read_config "enableGPU" "false")
GPU_DEVICE=$(read_config "gpuDevice" "/dev/dri/renderD128")
DISABLE_DAMAGE=$(read_config "disableDamage" "false")

RECORDING_DIR="$SAVE_PATH"

if [ -n "$XDG_RUNTIME_DIR" ]; then
    RUNTIME_DIR="$XDG_RUNTIME_DIR"
else
    # Fallback to /tmp if XDG_RUNTIME_DIR is not set
    RUNTIME_DIR="/tmp"
fi

PIDFILE="$RUNTIME_DIR/wf-recorder.pid"

# Clean up PID file on exit or interruption
trap 'rm -f $PIDFILE' EXIT INT TERM

getdate() {
  date '+%Y-%m-%d_%H.%M.%S'
}
getaudiooutput() {
  pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
}
getactivemonitor() {
  hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

mkdir -p "$RECORDING_DIR"
cd "$RECORDING_DIR" || exit

# parse --region <value> without modifying $@ so other flags like --fullscreen still work
ARGS=("$@")
MANUAL_REGION=""
SOUND_FLAG=0
FULLSCREEN_FLAG=0
for ((i = 0; i < ${#ARGS[@]}; i++)); do
  if [[ "${ARGS[i]}" == "--region" ]]; then
    if ((i + 1 < ${#ARGS[@]})); then
      MANUAL_REGION="${ARGS[i + 1]}"
    else
      exit 1
    fi
  elif [[ "${ARGS[i]}" == "--sound" ]]; then
    SOUND_FLAG=1
  elif [[ "${ARGS[i]}" == "--fullscreen" ]]; then
    FULLSCREEN_FLAG=1
  fi
done

# VA-API recording support, fallback to cpu if not supported.
CODEC=""
ENCODE_DEVICE=""
NO_DAMAGE=""
if [ "$DISABLE_DAMAGE" == "true" ]; then
  NO_DAMAGE="--no-damage"
  echo "Using no damage (--no-damage)" # for debugging
fi
if [[ "$GPU_ENABLED" == "true" ]] && [ -e "$GPU_DEVICE" ]; then
  CODEC="h264_vaapi"
  ENCODE_DEVICE="-d $GPU_DEVICE"
  echo "Using VA-API GPU encoding (h264_vaapi)" # for debugging
else
  CODEC="libx264"
  ENCODE_DEVICE=""
  echo "Using CPU encoding (libx264)" # debugging
fi

start_recording() {
  local cmd=("$@")
  cmd+=("-c" "$CODEC")
  if [[ -n "$ENCODE_DEVICE" ]]; then
    cmd+=($ENCODE_DEVICE)
  fi
  if [[ -n "$NO_DAMAGE" ]]; then
    cmd+=($NO_DAMAGE)
  fi

  "${cmd[@]}" &
  local pid=$!
  echo "$pid" > "$PIDFILE"
  wait "$pid"
  rm -f "$PIDFILE"
}

if pgrep wf-recorder >/dev/null; then
  pkill wf-recorder &
else
  if [[ $FULLSCREEN_FLAG -eq 1 ]]; then
    if [[ $SOUND_FLAG -eq 1 ]]; then
      start_recording wf-recorder -o "$(getactivemonitor)" -f './recording_'"$(getdate)"'.mp4' --audio="$(getaudiooutput)"
    else
      start_recording wf-recorder -o "$(getactivemonitor)" -f './recording_'"$(getdate)"'.mp4'
    fi
  else
    # If a manual region was provided via --region, use it; otherwise run slurp as before.
    if [[ -n "$MANUAL_REGION" ]]; then
      region="$MANUAL_REGION"
    else
      if ! region="$(slurp 2>&1)"; then
        exit 1
      fi
    fi

    if [[ $SOUND_FLAG -eq 1 ]]; then
      start_recording wf-recorder -f './recording_'"$(getdate)"'.mp4' --geometry "$region" --audio="$(getaudiooutput)"
    else
      start_recording wf-recorder -f './recording_'"$(getdate)"'.mp4' --geometry "$region"
    fi
  fi
fi

