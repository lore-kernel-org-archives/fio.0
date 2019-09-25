Return-Path: <prvs=1646af0c7=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] Extend file size for 'null' and 'filecreate' ioengines
Date: Wed, 25 Sep 2019 17:29:22 +0900
Message-Id: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <Vincent.Fu@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The commit ad46c5715ffc "filesetup: honor the offset option" intended to fix
a failure observed with null ioengine, but it affected all other ioengines. It
changed io_size and caused t/zbd/test-zbd-support test script failures for
zoned block devices.

This patch series suggests to replace the commit with the better fix which
affects only null ioengine and filecreate ioengine. The cause of the failure was
that fio does not extend file size even when it is smaller than io_size + offset
if null ioengine is set. This failure is observed also for filecreate ioengine.
The first patch reverts the fix affecting all ioengines. The second patch
extends file size for null ioengine and filecreate ioengine when file size is
smaller than io_size + offset.

Shin'ichiro Kawasaki (2):
  Revert "filesetup: honor the offset option"
  filesetup: Extend file size for 'null' and 'filecreate' ioengines

 filesetup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.21.0


