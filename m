Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/3] Solaris related patches
Date: Fri,  3 Nov 2017 18:46:00 +0200
Message-Id: <20171103164603.31819-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add missing ones in Solaris header.
Compiled and tested on illumos.

Tomohiro Kusumi (3):
  solaris: #include <pthread.h>
  solaris: add os_phys_mem() implementation
  solaris: add get_fs_free_size() implementation

 os/os-solaris.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

-- 
2.9.5


