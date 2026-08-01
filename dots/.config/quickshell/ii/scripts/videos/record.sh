#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
JSON_PATH=".screenRecord.savePath"

CUSTOM_PATH=$(jq -r "$JSON_PATH" "$CONFIG_FILE" 2>/dev/null)

RECORDING_DIR=""

if [[ -n "$CUSTOM_PATH" ]]; then
  RECORDING_DIR="$CUSTOM_PATH"
else
  RECORDING_DIR="$HOME/Videos" # Use default path
fi

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
      notify-send "Recording cancelled" "No region specified for --region" -a 'Recorder' &
      disown
      exit 1
    fi
  elif [[ "${ARGS[i]}" == "--sound" ]]; then
    SOUND_FLAG=1
  elif [[ "${ARGS[i]}" == "--fullscreen" ]]; then
    FULLSCREEN_FLAG=1
  fi
done

start_recording() {
  local cmd=("$@")
  # Launch wf-recorder in the background
  "${cmd[@]}" &
  local pid=$!
  # Write PID to file so Quickshell can detect it
  echo "$pid" > /tmp/wf-recorder.pid
  # Wait for the recording to finish (either by user stopping or pkill)
  wait "$pid"
  # Cleanup PID file when recording stops
  rm -f /tmp/wf-recorder.pid
}

if pgrep wf-recorder >/dev/null; then
  pkill wf-recorder &
else
  if [[ $FULLSCREEN_FLAG -eq 1 ]]; then
    # notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' &
    disown
    if [[ $SOUND_FLAG -eq 1 ]]; then
      start_recording wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --audio="$(getaudiooutput)"
    else
      start_recording wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t
    fi
  else
    # If a manual region was provided via --region, use it; otherwise run slurp as before.
    if [[ -n "$MANUAL_REGION" ]]; then
      region="$MANUAL_REGION"
    else
      if ! region="$(slurp 2>&1)"; then
        notify-send "Recording cancelled" "Selection was cancelled" -a 'Recorder' &
        disown
        exit 1
      fi
    fi

    # notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' &
    disown
    if [[ $SOUND_FLAG -eq 1 ]]; then
      start_recording wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$region" --audio="$(getaudiooutput)"
    else
      start_recording wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$region"
    fi
  fi
fi

