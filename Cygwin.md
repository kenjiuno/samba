Cygwin で
=========

```sh
./configure --without-pam --prefix=~/samba-20180719
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

必要なものだけビルドしてとっととインストールする

```sh
$ WAF_MAKE=1 python ./buildtools/bin/waf build install --targets client/smbclient,client/smbclient4,nmblookup,nmblookup4,smbtree
```

# `cannot find -ltalloc` と申す

From:
```python
	bindir = self.install_path
```

To:
```python
	bindir = self.install_path or self.samba_abspath
```
