# holo-code-server
dc setup for cdr/code-server with nix-shell for holochain preloaded and all ports exposed for [hc run](https://developer.holochain.org/docs/create-new-app/#run-a-testing-holochain-conductor) and a node app

# Basics
as always, dcomposed repos strive to work with 2-3 commands
1. `git clone https://github.com/dcomposed/holo-code-server.git && cd holo-code-server` (or your fork or ssh url - as you prefer)
2. `mv .env.example .env`  (you'll need to edit .env and docker-compose to match your domain and traefik setup)
3. `docker-compose up -d && docker-compose logs -f`

### notes:
* the default htaccess user/pass is admin/12345
* the default code-server auth code is set in the docker-compose: 1234321!  (if you comment/remove [that line](https://github.com/dcomposed/holo-code-server/blob/b6dfc62d948e4edf340e5ed50f257173f1deb4e6/docker-compose.yml#L24) code-server will auto generate a password and print it in the server logs)

# Customization
* change the project to be pre-cloned and built via build ARGs or in the Dockerfile
* change the nix version via build ARGs or in the Dockerfile
