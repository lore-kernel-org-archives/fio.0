Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/3] null ioengine fix
Date: Mon, 15 Jan 2018 21:52:09 +0200
Message-Id: <20180115195212.1349-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Resending these as I forgot to add signed-off-by, sorry.

Tomohiro Kusumi (3):
  null: fix compile time warning on OpenBSD
  null: make *impl_ private
  null: drop unneeded casts from void* to non-void*

 engines/null.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

-- 
2.13.6


