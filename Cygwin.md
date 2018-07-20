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
$ WAF_MAKE=1 python ./buildtools/bin/waf build install --targets client/smbclient,nmblookup,smbtree
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

# `File '/cygdrive/d/Git/samba/bin/default/lib/util/cygsamba-util.dll' does not exist`

```
* installing bin/default/lib/util/cygsamba-util.dll as /home/USER/samba-20180720/lib/cygsamba-util.dll.0.0.1
File '/cygdrive/d/Git/samba/bin/default/lib/util/cygsamba-util.dll' does not exist
Waf: Leaving directory `/cygdrive/d/Git/samba/bin'
Could not install the file '/home/USER/samba-20180720/lib/cygsamba-util.dll.0.0.1'
```
