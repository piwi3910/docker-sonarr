echo "Finding latest Sabnzbd release and set it as a env.variable to use during docker build"
apt update -y
apt install curl grep -y
version=$(curl --silent "https://api.github.com/repos/Sonarr/Sonarr/tags" | jq -r '.[0].name')
echo "version=$version" >> vars.env

