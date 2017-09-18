Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/4] minor fixes
Date: Mon, 18 Sep 2017 20:53:46 +0300
Message-Id: <20170918175350.38471-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>


Tomohiro Kusumi (4):
  add "invalid IO size" to "first direct IO errored." message
  add fio_set_directio() error message for platforms without direct I/O
  lib/memalign: don't malloc size twice
  fix strncpy(3) copy length

 filesetup.c        | 2 ++
 ioengines.c        | 4 ++--
 lib/memalign.c     | 2 +-
 os/windows/posix.c | 3 ++-
 server.c           | 2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.9.5


