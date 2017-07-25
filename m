Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/4] documentation fix
Date: Tue, 25 Jul 2017 22:05:40 +0300
Message-Id: <20170725190544.66919-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The first 3 are the ones I found while syncing the man page with HOWTO.
(I'm at around L2000 of HOWTO, but still takes a bit of time)

The last one is from
http://www.spinics.net/lists/fio/msg06083.html

Tomohiro Kusumi (4):
  HOWTO: fix "should be to to"
  man: fix broken ioengine specific option format
  HOWTO: add missing [netsplice] for ioengine specific options
  drop logging when blkdev invalidation failed on unsupported platforms

 HOWTO       | 10 +++++-----
 filesetup.c |  2 --
 fio.1       | 12 ++++++------
 3 files changed, 11 insertions(+), 13 deletions(-)

-- 
2.9.4


