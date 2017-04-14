Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/9]
Date: Sat, 15 Apr 2017 00:06:17 +0300
Message-Id: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

"Fix num2str() output when modulo != -1U" is a resend of below,
which I believe has been neither acked nor nacked.
http://www.spinics.net/lists/fio/msg05719.html

The patch is the same, but added a link to below comment to the commit message.
http://www.spinics.net/lists/fio/msg05720.html

All the rest are new ones.

Tomohiro Kusumi (9):
  Fix num2str() output when modulo != -1U
  Drop the only local variable declaration within a for-loop (C99)
  Make lib/strntol.c a stand-alone library
  Make lib/pattern.c a stand-alone library
  Make lib/rand.c a stand-alone library
  Make lib/zipf.c a stand-alone library
  Make lib/mountcheck.c a stand-alone library
  Make oslib/strlcat.c a stand-alone library
  Make oslib/linux-dev-lookup.c a stand-alone library

 lib/mountcheck.c         |  2 +-
 lib/num2str.c            | 34 +++++++++++++++++++++-------------
 lib/pattern.c            |  9 ++++++++-
 lib/rand.c               |  2 +-
 lib/strntol.c            |  2 +-
 lib/zipf.c               |  1 -
 oslib/linux-dev-lookup.c |  3 +--
 oslib/strlcat.c          |  2 +-
 parse.c                  |  3 ++-
 9 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.9.3


