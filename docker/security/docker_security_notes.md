# AppArmor

- `apparmor_status`: check apparmor profile status.
- `docker run --security-opt apparmor=unconfined`: run container without apparmor profile.
- `docker run --cap-add SYS_ADMIN --security-opt seccomp=unconfined`: run container with AppArmor as only effective line of defense (seccomp disabled and capability not protecting); will deny things like bind mounts
- `docker run --cap-add SYS_ADMIN --security-opt seccomp=unconfined --security-opt apparmor=unconfined`: basically disable security
- `apparmor_parser 'profile'`: parser and check the apparmor profile (e.g. wparmor)
- `aa-genprof 'application'`: apparmor watches application; use application and then view events in terminal with `s` and decide whether to include events in profile or not; `f` when finished (e.g. firefox)
- `/etc/apparmor.d/usr.bin.'executable'`: location of apparmor profile (e.g. firefox)
- `aa-logprof 'application'`: same as above but amends a profile instead of generating a new one (e.g. firefox)
- `aa-complain 'profile'`: test and debug profiles; set profile to complain mode (e.g. /etc/apparmor.d/usr.bin./etc/apparmor.d/usr.bin.firefox)
- `dmesg`: view apparmor complaints

# Capabilities

- `docker run --cap-drop 'CAP'`: drop capabilities from the root account of a container
- `docker run --cap-add 'CAP'`: add capabilities to the root account of a container
- `docker run --cap-drop ALL --cap-add 'CAP'``: drop all capabilities and then explicitly add individual capabilities to the root account of a container (e.g. `docker run --rm -it --cap-drop ALL --cap-add CHOWN alpine chown nobody /`)
- [CAP Man Page](http://man7.org/linux/man-pages/man7/capabilities.7.html)
- `capsh` - lets you perform capability testing and limited debugging (e.g. `docker run --rm -it alpine sh -c 'apk add -U libcap; capsh --print'`)
- `setcap` - set capability bits on a file
- `getcap` - get the capability bits from a file
- `pscap` - list the capabilities of running processes
- `filecap` - list the capabilities of files
- `captest` - test capabilities as well as list capabilities for current process
- `setcap cap_net_raw=ep 'file'`: set capability as effective and permitted on file
- `filecap /path/to/file net_raw`: set capabilities on file
- `getcap 'file'`; `filecap /path/to/file`; `getfattr -n security.capability 'file'`: read out the capabilities from a file

# Distribution and Trust

- `export DOCKER_CONTENT_TRUST=1`: enable Docker Content Trust
- `docker tag; docker push`: now signs images during tagging and pushes trusted signed image
- The **root key** is the most important key in TUF as it can rotate any other key in the system. The root key should be kept offline, ideally in hardware crypto device. It is stored in `~/.docker/trust/private/root_keys` by default. The **tagging key** is the only local key required to push new tags to an existing repo, and is stored in `~/.docker/trust/private/tuf_keys` by default.
- `notary -s https://notary.docker.io -d ~/.docker/trust list docker.io/library/'repository'`: inspect repository on Docker hub
- [run your own Notary server](https://github.com/docker/labs/blob/master/security/trust/README.md#extra)

# Control Groups

- `docker run --cpuset-cpus 0`: run image on first cpu in system; useful for restricting cpu usage of a running docker container
- `docker run --cpu-shares 0-1024`: allocate cpu time per container; default is 1024; share is computed relative to the shares of other running containers (e.g. container 1 has 768 shares and container 2 has 256 shares results in a 75% share for container 1 and 25% share for container 2)
- [Compose file reference](https://docs.docker.com/compose/compose-file)
- `docker run --pids-limit 'num'`: limit the number of processes the container can create

# Seccomp

-

# User Namespaces

- `docker run --user uid:gid`: run docker container with specific user:group
- `dockerd --userns-remap=default`: enable user namespace support when docker daemon is stopped; remapping viewable in `/etc/sub[ug]id`; verify with `docker info`
- `docker run --privileged`: currently incompatible with user namespaces (1.12)

cp dockercon-workshop/apparmor/wordpress/docker-compose.yaml
cp dockercon-workshop/apparmor/wordpress/wparmor
cp labs/security/cgroups/cpu-stress/docker-compose.yml
