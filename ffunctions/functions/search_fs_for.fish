function search_fs_for --description 'Search the filesystem for the given resource (file or folder).' --argument resource

    # Create/update the locate database:
    # refresh_locatedb

    # Search the locate database for the resource:
    printf %b "=> Searching for resource: $resource\n"
    locate $resource
end
