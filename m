Return-Path: <prvs=548cbc8ae=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] zbd: Avoid excessive zone resets
Date: Tue, 13 Oct 2020 15:49:25 +0900
Message-Id: <20201013064926.901831-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
References: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When zbd_reset_zone() is called for a zone repeatedly, reset zone command
is issued multiple times to a single zone even though its status is
empty. This is excessive and meaningless. Especially when zones are reset
at file set up with multiple jobs, zone reset is repeated for each job
and delays fio work load start.

To avoid the repeated zone resets, check the write pointer of the zone
before issuing zone reset command. If the write pointer is at the zone
start, do not reset the zone and just return.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/zbd.c b/zbd.c
index 905c0c2b..9327816a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -718,6 +718,9 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	uint64_t length = (z+1)->start - offset;
 	int ret = 0;
 
+	if (z->wp == z->start)
+		return 0;
+
 	assert(is_valid_offset(f, offset + length - 1));
 
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-- 
2.26.2


