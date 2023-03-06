## CLI Tools
we spend a lot of our time in the terminal. There's a lot of helpful CLI tools, which can make your life in the command line easier, faster and generally more fun.

## Troubleshooting
- bandwich
Note that since `bandwhich` sniffs network packets, it requires root privileges - so you might want to use it with (for example) `sudo`.

On Linux, you can give the `bandwhich` binary a permanent capability to use the required privileges, so that you don't need to use `sudo bandwhich` anymore:

```fish
sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep (which bandwhich)
```

`cap_sys_ptrace,cap_dac_read_search` gives `bandwhich` capability to list `/proc/<pid>/fd/` and resolve symlinks in that directory. It needs this capability to determine which opened port belongs to which process. `cap_net_raw,cap_net_admin` gives `bandwhich` capability to capture packets on your system.

- diff-so-fancy
```sh
diff -u file1.txt file2.txt | diff-so-fancy
```

- hyperfine
```sh
hyperfine ls exa
```

- micro
```sh
ip a | micro
```

- navi
```sh
navi repo browse
```
