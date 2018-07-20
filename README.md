smbclient for Cygwin!
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
