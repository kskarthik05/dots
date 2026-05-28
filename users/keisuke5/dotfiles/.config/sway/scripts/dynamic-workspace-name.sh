#!/usr/bin/env bash

get_workspace_apps() {
    swaymsg -t get_tree | jq -r '
        def nodes:
            .nodes[]?, .floating_nodes[]?;

        recurse(nodes)
        | select(.type == "workspace")
        | .name as $ws
        | recurse(nodes)
        | select(.type == "con")
        | select(.app_id != null or .window_properties.class != null)
        | [
            $ws,
            (
                .app_id //
                .window_properties.class
            )
        ]
        | @tsv
    '
}

rename_workspaces() {
    declare -A ws_apps

    while IFS=$'\t' read -r ws app; do

        ws_num="${ws%%:*}"

        name=$(echo "$app" \
            | awk -F. '{print $NF}' \
            | tr '[:upper:]' '[:lower:]' \
            | sed 's/[[:space:]]\+/-/g')

        current="${ws_apps[$ws_num]}"

        if [[ -z "$current" ]]; then
            ws_apps[$ws_num]="$name"
        else
            if [[ ! "+$current+" =~ \+$name\+ ]]; then
                ws_apps[$ws_num]+="+$name"
            fi
        fi

    done < <(get_workspace_apps)

    swaymsg -t get_workspaces | jq -r '.[].name' | while read -r current_ws; do

        ws_num="${current_ws%%:*}"

        [[ -z "$ws_num" ]] && continue

        apps="${ws_apps[$ws_num]}"

        if [[ -n "$apps" ]]; then
            new_name="$ws_num: $apps"
        else
            new_name="$ws_num: blank"
        fi

        if [[ "$current_ws" != "$new_name" ]]; then
            swaymsg rename workspace "$current_ws" to "$new_name" >/dev/null
        fi

    done
}

rename_workspaces

swaymsg -m -t subscribe '["window","workspace"]' | while read -r _; do
    rename_workspaces
done