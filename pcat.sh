# Strip empty and comment lines from file
function pcat() { grep -vE '(^[[:space:]]*[#;])|(^[[:space:]]*$)' "$@"; }
