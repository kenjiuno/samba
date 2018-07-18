Cygwin で
=========

```sh
./configure -C --without-pam
buildtools/bin/waf distclean configure -C --without-pam
```

落とし穴が多い。`Cygwin DLL is 2.10.0. setup-x86.exe` で入手:

- python2-devel
- libarchive-devel
- libgnutls-dev
- libgpgme-devel
- openldap-devel
- onc-rpc-devel

私製 make install までが必要:

- [jansson](https://github.com/akheron/jansson)

```sh
$ export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
```
