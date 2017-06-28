Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/2] updates for offset= in percentage
Date: Wed, 28 Jun 2017 17:21:04 +0300
Message-Id: <20170628142106.31846-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

due to the fact that str_to_decimal() supports conversion from
'%' format to low-level format.

Tomohiro Kusumi (2):
  HOWTO/manpage: update percentage explanation using '%'
  add FD_PARSE debug print for size= option (which exists in offset=)

 HOWTO     | 4 ++--
 fio.1     | 6 +++---
 options.c | 2 ++
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.9.4


