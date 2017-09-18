Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 0/2] minor fixes
Date: Mon, 18 Sep 2017 21:23:53 +0300
Message-Id: <20170918182355.45590-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

v2 for the 2 patches out of 4 patches in v1.

1/2: Change "IO size" -> "block size".
2/2: Drop the conditional, since it's not really needed.

Tomohiro Kusumi (2):
  add "invalid block size" to "first direct IO errored." message
  add fio_set_directio() error message for platforms without direct I/O

 filesetup.c | 1 +
 ioengines.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.9.5


