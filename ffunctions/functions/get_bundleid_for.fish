function get_bundleid_for --description 'Get the bundle identifier of a macOS application.' --argument macos_app

    osascript -e "id of app \"$macos_app\""
end
