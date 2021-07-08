function search_itunes_for --description 'Search the iTunes Search API for software matching the app and software kind specified.' --argument app kind

    set -l entity ""

    switch $kind
        case ios
            set entity software
        case ipados
            set entity iPadSoftware
        case macos
            set entity macSoftware
        case '*'
            printf %b "=> Unknown software kind, defaulting to iOS...\n"
            set kind ios
            set entity software
    end

    printf %b "=> Searching for software with name: \"$app\" and of type: \"$kind\"\n"
    printf %b "=> Constructing API request...\n"

    set -l itunes_api_endpoint "https://itunes.apple.com/search"
    set -l media software
    set -l country US
    set -l lang en_us
    set -l explicit No
    set -l limit 3
    set -l url "$itunes_api_endpoint?term=$app&entity=$entity&media=$media&country=$country&lang=$lang&explicit=$explicit&limit=$limit"

    printf %b "=> Constructed API request: \$url\n"
    printf %b "=> Making API request...\n"

    set -l json (curl \
      --silent \
      --header "Accept: application/json" \
      $url)

    printf %b "=> Done: curl --silent --header \$url\n"
    printf %b "=> Parsing API response...\n"

    set -l filter_top ".results[0].bundleId"
    set -l filter_all ".results[] | { trackId: .trackId, trackName: .trackName, trackViewUrl: .trackViewUrl, bundleId: .bundleId }"
    set -l result_count (echo $json | jq ".resultCount")
    set -l result_top (echo $json | jq $filter_top | string trim --chars="\"")
    set -l results_all (echo $json | jq $filter_all | string join "\n")

    printf %b "=> Done: jq \$filter_top\n"
    printf %b "=> Done: jq \$filter_all\n\n"

    printf %b "API request: $url\n\n"
    printf %b "# of results: $result_count\n"
    printf %b "top result: app://$result_top\n\n"
    printf %b "$results_all\n\n"

    printf %b "=> Done: search_itunes_for \"$app\" \"$kind\"\n"
end
