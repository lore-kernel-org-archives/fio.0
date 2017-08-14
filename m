Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v3 0/4] Sync fio(1) man page with HOWTO (remaining sections)
Date: Mon, 14 Aug 2017 18:30:22 +0300
Message-Id: <20170814153026.44260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

2017-08-14 17:59 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
>> Sync fio(1) man page with HOWTO (remaining sections)
>> http://www.spinics.net/lists/fio/msg06158.html
>
> Patch #1 is throwing rejects now, I pulled in a few fixes this morning.
> Since those are big hunks, can you double check and send a v3? Bad
> timing, sorry...

Sure, sorry I didn't notice you committed changes, while I made v2 a few hours ago.

These are v3 of below series of patches, which resolves above merge conflicts
with recently committed 997b5680d139ce82c2034ba3a0d602cfd778b89b
which added serialize_overlap= to fio.1 and HOWTO.

[PATCH 0/4] Sync fio(1) man page with HOWTO (remaining sections)
http://www.spinics.net/lists/fio/msg06158.html

Tomohiro Kusumi (4):
  man: sync "JOB PARAMETERS" section with HOWTO
  man: sync "OUTPUT" section and after with HOWTO
  man: minor fixes for sections before "JOB PARAMETERS" for consistency
  HOWTO: minor fixes and backports from man page

 HOWTO |  193 ++-
 fio.1 | 4258 +++++++++++++++++++++++++++++++++++++----------------------------
 2 files changed, 2539 insertions(+), 1912 deletions(-)

-- 
2.9.4


