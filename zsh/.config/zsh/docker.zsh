# Docker utility functions
# Adapted from https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb

function dnames-fn {
    for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
        docker inspect "${ID}" | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
    done
}

function dip-fn {
    echo "IP addresses of all named running containers"
    for DOC in $(dnames-fn); do
        IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "${DOC}")
        OUT+=${DOC}'\t'${IP}'\n'
    done
    echo -e "${OUT}" | column -t
    unset OUT
}

function dex-fn {
    docker exec -it "$1" "${2:-bash}"
}

function di-fn {
    docker inspect "$1"
}

function dl-fn {
    docker logs -f "$1"
}

function drun-fn {
    docker run -it "$1" "$2"
}

function dcr-fn {
    docker compose run "$@"
}

function dsr-fn {
    docker stop "$1"
    docker rm "$1"
}

function drmc-fn {
    docker rm "$(docker ps --all -q -f status=exited)"
}

function drmid-fn {
    imgs=$(docker images -q -f dangling=true)
    [ -n "${imgs}" ] && docker rmi "${imgs}" || echo "no dangling images."
}

function dlab {
    docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
    docker compose "$*"
}

function d-aws-cli-fn {
    docker run \
        -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
        -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
        -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
        amazon/aws-cli:latest "$1" "$2" "$3"
}

alias daws=d-aws-cli-fn
alias dc=dc-fn
alias dcr=dcr-fn
alias dex=dex-fn
alias di=di-fn
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsr=dsr-fn
