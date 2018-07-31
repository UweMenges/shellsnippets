# Remove a host's traces in ~/.ssh/known_hosts and add current data
# 2018-07-31 uwe: rm host+ip from ssh known_hosts and add current
rmssh () {
    local ip=$(getent hosts $1 | cut -d\  -f 1)
    ssh-keygen -R $1
    ssh-keygen -R $ip
    ssh-keyscan -H -t ecdsa $1 $ip >> ~/.ssh/known_hosts
}
