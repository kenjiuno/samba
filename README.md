smbclient on Cygwin!
=====================

Required Cygwin packages:

- gcc-g++
- make
- python2-devel
- libarchive-devel
- libgnutls-dev
- libgpgme-devel
- openldap-devel
- onc-rpc-devel

Required library not included in Cygwin:

- [jansson](https://github.com/akheron/jansson)
  - `./configure`
  - `make install`

How to configure samba:

```sh
./configure --without-pam
```

Compile and install under `/usr/local/samba`:

```sh
WAF_MAKE=1 python ./buildtools/bin/waf build install --targets client/smbclient,nmblookup,smbtree
```

Collect dependent shared libraries `cygXXX.dll`? Try:

```sh
cygcheck.exe ./smbclient | grep -Eoe "cyg[^\.]+\.dll" | uniq | xargs which | xargs.exe -I "SRC" cp SRC .
```

## smbtree

### Get workgroups and servers

Commands:
```bat
smbtree.exe --servers --user=anonymous
smbtree.exe --servers --broadcast --user=anonymous
```

Sample output:
```
WORKGROUP
        \\LS                            LinkStation
```

### Usage on help `smbtree.exe -?`

```
Usage: [OPTION...]
  -b, --broadcast                    Use broadcast instead of using the master browser
  -D, --domains                      List only domains (workgroups) of tree
  -S, --servers                      List domains(workgroups) and servers of tree

Help options:
  -?, --help                         Show this help message
      --usage                        Display brief usage message

Common samba options:
  -d, --debuglevel=DEBUGLEVEL        Set debug level
  -s, --configfile=CONFIGFILE        Use alternate configuration file
  -l, --log-basename=LOGFILEBASE     Base name for log files
  -V, --version                      Print version
      --option=name=value            Set smb.conf option from command line

Authentication options:
  -U, --user=USERNAME                Set the network username
  -N, --no-pass                      Don't ask for a password
  -k, --kerberos                     Use kerberos (active directory) authentication
  -A, --authentication-file=FILE     Get the credentials from a file
  -S, --signing=on|off|required      Set the client signing state
  -P, --machine-pass                 Use stored machine account password
  -e, --encrypt                      Encrypt SMB transport
  -C, --use-ccache                   Use the winbind ccache for authentication
      --pw-nt-hash                   The supplied password is the NT hash
```

## smbclient.exe

### List server shares

Command:
```bat
smbclient.exe -L DD7
```

Sample output:
```
Enter WORKGROUP\GUEST's password:

        Sharename       Type      Comment
        ---------       ----      -------
        C$              Disk      Default share
        ...
        IPC$            IPC       Remote IPC
        ...
Reconnecting with SMB1 for workgroup listing.

        Server               Comment
        ---------            -------
        ...
        DD7
        ...
        LS                   LinkStation
        ...

        Workgroup            Master
        ---------            -------
        WORKGROUP            DD7
```

### Usage on help `smbsmbclient.exe -?`

```
Usage: smbclient service <password>
  -R, --name-resolve=NAME-RESOLVE-ORDER     Use these name resolution services only
  -M, --message=HOST                        Send message
  -I, --ip-address=IP                       Use this IP to connect to
  -E, --stderr                              Write messages to stderr instead of stdout
  -L, --list=HOST                           Get a list of shares available on a host
  -m, --max-protocol=LEVEL                  Set the max protocol level
  -T, --tar=<c|x>IXFqgbNan                  Command line tar
  -D, --directory=DIR                       Start from directory
  -c, --command=STRING                      Execute semicolon separated commands
  -b, --send-buffer=BYTES                   Changes the transmit/send buffer
  -t, --timeout=SECONDS                     Changes the per-operation timeout
  -p, --port=PORT                           Port to connect to
  -g, --grepable                            Produce grepable output
  -q, --quiet                               Suppress help message
  -B, --browse                              Browse SMB servers using DNS

Help options:
  -?, --help                                Show this help message
      --usage                               Display brief usage message

Common samba options:
  -d, --debuglevel=DEBUGLEVEL               Set debug level
  -s, --configfile=CONFIGFILE               Use alternate configuration file
  -l, --log-basename=LOGFILEBASE            Base name for log files
  -V, --version                             Print version
      --option=name=value                   Set smb.conf option from command line

Connection options:
  -O, --socket-options=SOCKETOPTIONS        socket options to use
  -n, --netbiosname=NETBIOSNAME             Primary netbios name
  -W, --workgroup=WORKGROUP                 Set the workgroup name
  -i, --scope=SCOPE                         Use this Netbios scope

Authentication options:
  -U, --user=USERNAME                       Set the network username
  -N, --no-pass                             Don't ask for a password
  -k, --kerberos                            Use kerberos (active directory) authentication
  -A, --authentication-file=FILE            Get the credentials from a file
  -S, --signing=on|off|required             Set the client signing state
  -P, --machine-pass                        Use stored machine account password
  -e, --encrypt                             Encrypt SMB transport
  -C, --use-ccache                          Use the winbind ccache for authentication
      --pw-nt-hash                          The supplied password is the NT hash
```
