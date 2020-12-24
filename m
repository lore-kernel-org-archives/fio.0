Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 19/36] zbd: improve replay range validation
Date: Thu, 24 Dec 2020 11:12:02 +0900
Message-Id: <20201224021219.189727-20-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Make sure that verification read always reads valid data.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index df61dc37..2656f3ea 100644
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


