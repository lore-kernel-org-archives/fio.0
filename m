Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 0/4] Sync fio(1) man page with HOWTO (remaining sections)
Date: Mon, 14 Aug 2017 17:54:54 +0300
Message-Id: <20170814145458.41333-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These are v2 of the below series of patches.
Patch 1/4, 2/4, 3/4 are basically the same (1 line change in total).
Patch 4/4 (minor fixes for HOWTO) has some minor corrections.

Sync fio(1) man page with HOWTO (remaining sections)
http://www.spinics.net/lists/fio/msg06158.html

Tomohiro Kusumi (4):
  man: sync "JOB PARAMETERS" section with HOWTO
  man: sync "OUTPUT" section and after with HOWTO
  man: minor fixes for sections before "JOB PARAMETERS" for consistency
  HOWTO: minor fixes and backports from man page

 HOWTO |  193 ++-
 fio.1 | 4240 +++++++++++++++++++++++++++++++++++++----------------------------
 2 files changed, 2530 insertions(+), 1903 deletions(-)

-- 
2.9.4


