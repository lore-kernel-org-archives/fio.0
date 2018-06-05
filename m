Return-Path: <axboe@kernel.dk>
Received: from [192.168.1.167] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id g138-v6sm6425079iog.62.2018.06.05.07.54.17
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jun 2018 07:54:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: gcc 8/8.1 warnings
Message-ID: <9785b178-92bc-d927-4a79-80ea5beb87e6@kernel.dk>
Date: Tue, 5 Jun 2018 08:54:16 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

If someone is looking for a little project, compiling fio with
gcc 8/8.1 triggers a new set of overflow warnings. I've included
them below.

FIO_VERSION = fio-3.7-5-g85e9
In file included from filesetup.c:9:
filesetup.c: In function ‘generic_open_file’:
fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 101 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
fio.h:482:2: note: in expansion of macro ‘__td_verror’
  __td_verror((td), (err), strerror((err)), (func)); \
  ^~~~~~~~~~~
filesetup.c:699:3: note: in expansion of macro ‘td_verror’
   td_verror(td, __e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from fio.h:11,
                 from filesetup.c:9:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 36 or more bytes (assuming 163) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from filesetup.c:9:
fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 101 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
fio.h:484:3: note: in expansion of macro ‘__td_verror’
   __td_verror((td)->parent, (err), strerror((err)), (func)); \
   ^~~~~~~~~~~
filesetup.c:699:3: note: in expansion of macro ‘td_verror’
   td_verror(td, __e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from fio.h:11,
                 from filesetup.c:9:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 36 or more bytes (assuming 163) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from verify.h:6,
                 from verify.c:12:
verify.c: In function ‘open_state_file’:
verify-state.h:104:28: warning: ‘-’ directive output may be truncated writing 1 byte into a region of size between 0 and 4095 [-Wformat-truncation=]
  snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
                            ^
In file included from /usr/include/stdio.h:862,
                 from fio.h:11,
                 from verify.c:11:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 17 or more bytes (assuming 4112) into a destination of size 4096
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from filesetup.c:9:
filesetup.c: In function ‘recurse_dir’:
fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 100 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
fio.h:482:2: note: in expansion of macro ‘__td_verror’
  __td_verror((td), (err), strerror((err)), (func)); \
  ^~~~~~~~~~~
filesetup.c:1743:3: note: in expansion of macro ‘td_verror’
   td_verror(td, errno, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from fio.h:11,
                 from filesetup.c:9:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 37 or more bytes (assuming 164) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from filesetup.c:9:
fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 100 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
fio.h:484:3: note: in expansion of macro ‘__td_verror’
   __td_verror((td)->parent, (err), strerror((err)), (func)); \
   ^~~~~~~~~~~
filesetup.c:1743:3: note: in expansion of macro ‘td_verror’
   td_verror(td, errno, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from fio.h:11,
                 from filesetup.c:9:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 37 or more bytes (assuming 164) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/filecreate.c:11:
engines/filecreate.c: In function ‘open_file’:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 93 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:482:2: note: in expansion of macro ‘__td_verror’
  __td_verror((td), (err), strerror((err)), (func)); \
  ^~~~~~~~~~~
engines/filecreate.c:43:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/filecreate.c:7:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 44 or more bytes (assuming 171) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/filecreate.c:11:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 93 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:484:3: note: in expansion of macro ‘__td_verror’
   __td_verror((td)->parent, (err), strerror((err)), (func)); \
   ^~~~~~~~~~~
engines/filecreate.c:43:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/filecreate.c:7:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 44 or more bytes (assuming 171) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/net.c:21:
engines/net.c: In function ‘fio_netio_init’:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 98 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:482:2: note: in expansion of macro ‘__td_verror’
  __td_verror((td), (err), strerror((err)), (func)); \
  ^~~~~~~~~~~
engines/net.c:1044:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, str);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/net.c:7:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 39 or more bytes (assuming 166) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/net.c:21:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 98 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:484:3: note: in expansion of macro ‘__td_verror’
   __td_verror((td)->parent, (err), strerror((err)), (func)); \
   ^~~~~~~~~~~
engines/net.c:1044:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, str);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/net.c:7:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 39 or more bytes (assuming 166) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from server.c:26:
verify-state.h: In function ‘verify_state_gen_name.constprop’:
verify-state.h:104:26: warning: ‘%s’ directive output may be truncated writing up to 4095 bytes into a region of size between 128 and 255 [-Wformat-truncation=]
  snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
                          ^~                           ~~~~~
In file included from /usr/include/stdio.h:862,
                 from server.c:1:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output between 17 and 4249 bytes into a destination of size 256
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/falloc.c:15:
engines/falloc.c: In function ‘open_file’:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 97 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:482:2: note: in expansion of macro ‘__td_verror’
  __td_verror((td), (err), strerror((err)), (func)); \
  ^~~~~~~~~~~
engines/falloc.c:45:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/falloc.c:11:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 40 or more bytes (assuming 167) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from engines/falloc.c:15:
engines/../fio.h:471:45: warning: ‘%s’ directive output may be truncated writing up to 127 bytes into a region of size 97 [-Wformat-truncation=]
    snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));  \
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                      ~~~~~~
engines/../fio.h:484:3: note: in expansion of macro ‘__td_verror’
   __td_verror((td)->parent, (err), strerror((err)), (func)); \
   ^~~~~~~~~~~
engines/falloc.c:45:3: note: in expansion of macro ‘td_verror’
   td_verror(td, e, buf);
   ^~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from engines/falloc.c:11:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output 40 or more bytes (assuming 167) into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diskutil.c: In function ‘__init_per_file_disk_util’:
diskutil.c:245:25: warning: ‘%s’ directive writing up to 255 bytes into a region of size between 0 and 4095 [-Wformat-overflow=]
   sprintf(temppath, "%s/%s", slavesdir, dirent->d_name);
                         ^~
In file included from /usr/include/stdio.h:862,
                 from diskutil.c:1:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: ‘__builtin___sprintf_chk’ output between 2 and 4352 bytes into a destination of size 4096
   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       __bos (__s), __fmt, __va_arg_pack ());
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diskutil.c:258:25: warning: ‘%s’ directive writing up to 4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=]
   sprintf(temppath, "%s/%s/dev", slavesdir, slavepath);
                         ^~                  ~~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from diskutil.c:1:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: ‘__builtin___sprintf_chk’ output between 6 and 8196 bytes into a destination of size 4096
   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       __bos (__s), __fmt, __va_arg_pack ());
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diskutil.c:260:26: warning: ‘%s’ directive writing up to 4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=]
    sprintf(temppath, "%s/%s/device/dev", slavesdir, slavepath);
                          ^~                         ~~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from diskutil.c:1:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: ‘__builtin___sprintf_chk’ output between 13 and 8203 bytes into a destination of size 4096
   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       __bos (__s), __fmt, __va_arg_pack ());
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diskutil.c:274:25: warning: ‘%s’ directive writing up to 4095 bytes into a region of size between 0 and 4095 [-Wformat-overflow=]
   sprintf(temppath, "%s/%s", slavesdir, slavepath);
                         ^~              ~~~~~~~~~
In file included from /usr/include/stdio.h:862,
                 from diskutil.c:1:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:33:10: note: ‘__builtin___sprintf_chk’ output between 2 and 8192 bytes into a destination of size 4096
   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       __bos (__s), __fmt, __va_arg_pack ());
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- 
Jens Axboe


