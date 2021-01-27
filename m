Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 19/38] zbd: improve replay range validation
Date: Wed, 27 Jan 2021 13:19:26 +0900
Message-Id: <20210127041945.36909-20-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The function zbd_replay_write_order() is called when a read is
issued by fio verification code to compare the read data with the
previously written data. Any data mismatch is marked as a verification
failure.

Since zbd_adjust_block() may change the i/o offset and length
to comply with i/o constrains that zoned model has set,
zbd_replay_write_order() needs to replicate the same adjustment during
verify. The general flow in this function matches the write processing
done in zbd_adjust_block(), but there are some differences. For
example, z->verify_block acts as the pseudo-write pointer during replay
and it needs to be advanced by buflen every time the function called,
but it is advanced by min_bs in the existing code (the value of this
variable is measured in min_bs units).

Fix the issue with verify_block and add more error logging to simplify
troubleshooting of this tricky part of ZBD code.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 44ecb9e0..1ee238e8 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1239,10 +1239,23 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 		assert(z);
 	}
 
-	if (z->verify_block * min_bs >= z->capacity)
+	if (z->verify_block * min_bs >= z->capacity) {
 		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
 			min_bs, (unsigned long long)z->capacity);
-	io_u->offset = z->start + z->verify_block++ * min_bs;
+		/*
+		 * If the assertion below fails during a test run, adding
+		 * "--experimental_verify=1" to the command line may help.
+		 */
+		assert(false);
+	}
+	io_u->offset = z->start + z->verify_block * min_bs;
+	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
+		log_err("%s: %llu + %llu >= %lu\n", f->file_name, io_u->offset,
+			io_u->buflen, zbd_zone_capacity_end(z));
+		assert(false);
+	}
+	z->verify_block += io_u->buflen / min_bs;
+
 	return z;
 }
 
-- 
2.28.0


