Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
References: <9785b178-92bc-d927-4a79-80ea5beb87e6@kernel.dk>
In-Reply-To: <9785b178-92bc-d927-4a79-80ea5beb87e6@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 6 Jun 2018 03:23:16 +0900
Message-ID: <CAHndrBkcbNMqeK4FTkDUmtKhzYGhzg5r=-FD-xYAQJ5_fVQJ3Q@mail.gmail.com>
Subject: Re: gcc 8/8.1 warnings
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi

2018=E5=B9=B46=E6=9C=885=E6=97=A5(=E7=81=AB) 23:56 Jens Axboe <axboe@kernel=
.dk>:
>
> Hi,
>
> If someone is looking for a little project, compiling fio with
> gcc 8/8.1 triggers a new set of overflow warnings. I've included
> them below.

What's the CFLAGS being used ?
I see lots of warnings on Fedora 28 (gcc 8.1.1), but only with
additional -Wextra.

>
> FIO_VERSION =3D fio-3.7-5-g85e9
> In file included from filesetup.c:9:
> filesetup.c: In function =E2=80=98generic_open_file=E2=80=99:
> fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output may be trunc=
ated writing up to 127 bytes into a region of size 101 [-Wformat-truncation=
=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> fio.h:482:2: note: in expansion of macro =E2=80=98__td_verror=E2=80=99
>   __td_verror((td), (err), strerror((err)), (func)); \
>   ^~~~~~~~~~~
> filesetup.c:699:3: note: in expansion of macro =E2=80=98td_verror=E2=80=
=99
>    td_verror(td, __e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from fio.h:11,
>                  from filesetup.c:9:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 36 or more bytes (assuming 163) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from filesetup.c:9:
> fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output may be trunc=
ated writing up to 127 bytes into a region of size 101 [-Wformat-truncation=
=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> fio.h:484:3: note: in expansion of macro =E2=80=98__td_verror=E2=80=99
>    __td_verror((td)->parent, (err), strerror((err)), (func)); \
>    ^~~~~~~~~~~
> filesetup.c:699:3: note: in expansion of macro =E2=80=98td_verror=E2=80=
=99
>    td_verror(td, __e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from fio.h:11,
>                  from filesetup.c:9:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 36 or more bytes (assuming 163) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from verify.h:6,
>                  from verify.c:12:
> verify.c: In function =E2=80=98open_state_file=E2=80=99:
> verify-state.h:104:28: warning: =E2=80=98-=E2=80=99 directive output may =
be truncated writing 1 byte into a region of size between 0 and 4095 [-Wfor=
mat-truncation=3D]
>   snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
>                             ^
> In file included from /usr/include/stdio.h:862,
>                  from fio.h:11,
>                  from verify.c:11:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 17 or more bytes (assuming 4112) into a d=
estination of size 4096
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from filesetup.c:9:
> filesetup.c: In function =E2=80=98recurse_dir=E2=80=99:
> fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output may be trunc=
ated writing up to 127 bytes into a region of size 100 [-Wformat-truncation=
=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> fio.h:482:2: note: in expansion of macro =E2=80=98__td_verror=E2=80=99
>   __td_verror((td), (err), strerror((err)), (func)); \
>   ^~~~~~~~~~~
> filesetup.c:1743:3: note: in expansion of macro =E2=80=98td_verror=E2=80=
=99
>    td_verror(td, errno, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from fio.h:11,
>                  from filesetup.c:9:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 37 or more bytes (assuming 164) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from filesetup.c:9:
> fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output may be trunc=
ated writing up to 127 bytes into a region of size 100 [-Wformat-truncation=
=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> fio.h:484:3: note: in expansion of macro =E2=80=98__td_verror=E2=80=99
>    __td_verror((td)->parent, (err), strerror((err)), (func)); \
>    ^~~~~~~~~~~
> filesetup.c:1743:3: note: in expansion of macro =E2=80=98td_verror=E2=80=
=99
>    td_verror(td, errno, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from fio.h:11,
>                  from filesetup.c:9:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 37 or more bytes (assuming 164) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/filecreate.c:11:
> engines/filecreate.c: In function =E2=80=98open_file=E2=80=99:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 93 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:482:2: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>   __td_verror((td), (err), strerror((err)), (func)); \
>   ^~~~~~~~~~~
> engines/filecreate.c:43:3: note: in expansion of macro =E2=80=98td_verror=
=E2=80=99
>    td_verror(td, e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/filecreate.c:7:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 44 or more bytes (assuming 171) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/filecreate.c:11:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 93 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:484:3: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>    __td_verror((td)->parent, (err), strerror((err)), (func)); \
>    ^~~~~~~~~~~
> engines/filecreate.c:43:3: note: in expansion of macro =E2=80=98td_verror=
=E2=80=99
>    td_verror(td, e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/filecreate.c:7:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 44 or more bytes (assuming 171) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/net.c:21:
> engines/net.c: In function =E2=80=98fio_netio_init=E2=80=99:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 98 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:482:2: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>   __td_verror((td), (err), strerror((err)), (func)); \
>   ^~~~~~~~~~~
> engines/net.c:1044:3: note: in expansion of macro =E2=80=98td_verror=E2=
=80=99
>    td_verror(td, e, str);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/net.c:7:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 39 or more bytes (assuming 166) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/net.c:21:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 98 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:484:3: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>    __td_verror((td)->parent, (err), strerror((err)), (func)); \
>    ^~~~~~~~~~~
> engines/net.c:1044:3: note: in expansion of macro =E2=80=98td_verror=E2=
=80=99
>    td_verror(td, e, str);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/net.c:7:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 39 or more bytes (assuming 166) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from server.c:26:
> verify-state.h: In function =E2=80=98verify_state_gen_name.constprop=E2=
=80=99:
> verify-state.h:104:26: warning: =E2=80=98%s=E2=80=99 directive output may=
 be truncated writing up to 4095 bytes into a region of size between 128 an=
d 255 [-Wformat-truncation=3D]
>   snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
>                           ^~                           ~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from server.c:1:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output between 17 and 4249 bytes into a destinat=
ion of size 256
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/falloc.c:15:
> engines/falloc.c: In function =E2=80=98open_file=E2=80=99:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 97 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:482:2: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>   __td_verror((td), (err), strerror((err)), (func)); \
>   ^~~~~~~~~~~
> engines/falloc.c:45:3: note: in expansion of macro =E2=80=98td_verror=E2=
=80=99
>    td_verror(td, e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/falloc.c:11:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 40 or more bytes (assuming 167) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from engines/falloc.c:15:
> engines/../fio.h:471:45: warning: =E2=80=98%s=E2=80=99 directive output m=
ay be truncated writing up to 127 bytes into a region of size 97 [-Wformat-=
truncation=3D]
>     snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=3D%s, erro=
r=3D%s", __FILE__, __LINE__, (func), (msg));  \
>                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~                      ~~~~~~
> engines/../fio.h:484:3: note: in expansion of macro =E2=80=98__td_verror=
=E2=80=99
>    __td_verror((td)->parent, (err), strerror((err)), (func)); \
>    ^~~~~~~~~~~
> engines/falloc.c:45:3: note: in expansion of macro =E2=80=98td_verror=E2=
=80=99
>    td_verror(td, e, buf);
>    ^~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from engines/falloc.c:11:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__built=
in___snprintf_chk=E2=80=99 output 40 or more bytes (assuming 167) into a de=
stination of size 128
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diskutil.c: In function =E2=80=98__init_per_file_disk_util=E2=80=99:
> diskutil.c:245:25: warning: =E2=80=98%s=E2=80=99 directive writing up to =
255 bytes into a region of size between 0 and 4095 [-Wformat-overflow=3D]
>    sprintf(temppath, "%s/%s", slavesdir, dirent->d_name);
>                          ^~
> In file included from /usr/include/stdio.h:862,
>                  from diskutil.c:1:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: =E2=80=98__built=
in___sprintf_chk=E2=80=99 output between 2 and 4352 bytes into a destinatio=
n of size 4096
>    return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        __bos (__s), __fmt, __va_arg_pack ());
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diskutil.c:258:25: warning: =E2=80=98%s=E2=80=99 directive writing up to =
4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=3D]
>    sprintf(temppath, "%s/%s/dev", slavesdir, slavepath);
>                          ^~                  ~~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from diskutil.c:1:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: =E2=80=98__built=
in___sprintf_chk=E2=80=99 output between 6 and 8196 bytes into a destinatio=
n of size 4096
>    return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        __bos (__s), __fmt, __va_arg_pack ());
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diskutil.c:260:26: warning: =E2=80=98%s=E2=80=99 directive writing up to =
4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=3D]
>     sprintf(temppath, "%s/%s/device/dev", slavesdir, slavepath);
>                           ^~                         ~~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from diskutil.c:1:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: =E2=80=98__built=
in___sprintf_chk=E2=80=99 output between 13 and 8203 bytes into a destinati=
on of size 4096
>    return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        __bos (__s), __fmt, __va_arg_pack ());
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diskutil.c:274:25: warning: =E2=80=98%s=E2=80=99 directive writing up to =
4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=3D]
>    sprintf(temppath, "%s/%s", slavesdir, slavepath);
>                          ^~              ~~~~~~~~~
> In file included from /usr/include/stdio.h:862,
>                  from diskutil.c:1:
> /usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: =E2=80=98__built=
in___sprintf_chk=E2=80=99 output between 2 and 8192 bytes into a destinatio=
n of size 4096
>    return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        __bos (__s), __fmt, __va_arg_pack ());
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

