podman create --detach -e RAILS_LOG_TO_STDOUT=true --publish 0.0.0.0:3000:3000 --name rails rails:0.1
podman start rails
