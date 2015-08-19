Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35725 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbHSKPw (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:15:52 -0400
Received: by wicne3 with SMTP id ne3so116410686wic.0
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:15:51 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 0/6] Add support of formats for the pattern input
Date: Wed, 19 Aug 2015 12:15:37 +0200
Message-Id: <1439979343-1571-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

Hello, all.

The intention of this patchset is to support dynamic formats for pattern
input which is used for writing and verifying data, e.g. in the latest patch
I added '%o' format, which means that current block offset will be written to
the buffer and then verified back, i.e. this option can be used as the
following:

 verify_pattern=%o

and the hexdump of generated file in my case is (few last lines):

  ...
  000f5c00  00 5c 0f 00 00 00 00 00  00 5c 0f 00 00 00 00 00  |.\.......\......|
  *
  000fdc00  00 dc 0f 00 00 00 00 00  00 dc 0f 00 00 00 00 00  |................|
  *
  000ffc00  00 fc 0f 00 00 00 00 00  00 fc 0f 00 00 00 00 00  |................|
  *
  00100000

So, each block is filled in with block offset in little endian order and 8 bytes
long.

Unfortunately, 'buffer_pattern' option does not support formats, because it
turned out to be a lot of changes which should be made to pass correct
io_u->offset through the whole stack of calls. I left this task for future.

Additionally, I moved all 'pattern' parsing/substituting logic to separate
library file 'lib/pattern.[ch]'. Also, now 'verify_pattern' and 'buffer_pattern'
support combined input which can consist of strings, numbers and formats
(as was said formats are supported only by 'verify_pattern' option), e.g. let's
consider the following example, where 'in' is a 'verify_pattern' or
'buffer_pattern' and 'out' is an output buffer filled in with bytes regarding
specified pattern:

  #1                 #2                 #3        #4
    in="abcd"          in=-1024           in=66     in=0xFF0X1
   out=61 62 63 64    out=00 fc ff ff    out=42    out=ff 01

  #5                               #6
    in=%o                            in="123"0xFFeeCC
   out=00 00 00 00 00 00 00 00      out=31 32 33 ff ec cc

  #7
    in=-100xab"1"%o"2"
    out=f6 ff ff ff ab 31 00 00 00 00 00 00 00 00 32

  #8
    in=%o0xdeadbeef%o
   out=00 00 00 00 00 00 00 00 de ad be ef 00 00 00 00 00 00 00 00

  #9
     in=0xfefefefefefefefefefefefefefefefefefefefefe
    out=fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe

For %o format 8 bytes reserved in pattern, and when buffer is ready
substitution occurs.

The old behaviour is preserved: strings are in quotes, decimals are in the
range [INT_MIN, INT_MAX], hexidecimals start from 0[Xx] and can be of any
size (the limit is the maximum size of the pattern, which is 512).

New behaviour: now you can combine everything together and additionally
use formats (now %o is supported).

 --
 Roman

Roman Pen (6):
  lib/strntol: add 'strntol' function
  lib/pattern: add set of functions to parse combined pattern input
  replace 'fill_pattern' with 'cpy_pattern' from 'lib/pattern.c'
  verify: use 'cmp_pattern' from 'lib/pattern.c' to compare pattern and
    buffer
  add FIELD_SIZE macro to calculate the size of the specified field
  use 'lib/pattern' to parse patterns and paste formats into buffers

 HOWTO            |  20 ++-
 Makefile         |   9 +-
 fio.h            |   3 +-
 lib/pattern.c    | 464 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/pattern.h    |  47 ++++++
 lib/rand.c       |  31 +---
 lib/rand.h       |   1 -
 lib/strntol.c    |  31 ++++
 lib/strntol.h    |   6 +
 options.c        | 166 ++++----------------
 thread_options.h |   3 +
 verify.c         |  62 +++++---
 verify.h         |   5 +
 13 files changed, 656 insertions(+), 192 deletions(-)
 create mode 100644 lib/pattern.c
 create mode 100644 lib/pattern.h
 create mode 100644 lib/strntol.c
 create mode 100644 lib/strntol.h

-- 
2.4.4

