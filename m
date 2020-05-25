Return-Path: <prvs=407053df0=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/4] libzbc: cleanup init code
Date: Tue, 26 May 2020 06:32:53 +0900
Message-Id: <20200525213256.7476-2-dmitry.fomichev@wdc.com>
In-Reply-To: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Make sure every allocated data structure gets freed in case of
unsuccessful libzbc ioengine initialization.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/libzbc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 8c682de6..2f6b4583 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -92,15 +92,12 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=%d\n",
 			f->file_name, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = libzbc_get_dev_info(ld, f);
-	if (ret) {
-		zbc_close(ld->zdev);
-		free(ld);
-		return ret;
-	}
+	if (ret)
+		goto err_close;
 
 	td->io_ops_data = ld;
 out:
@@ -108,6 +105,12 @@ out:
 		*p_ld = ld;
 
 	return 0;
+
+err_close:
+	zbc_close(ld->zdev);
+err:
+	free(ld);
+	return ret;
 }
 
 static int libzbc_close_dev(struct thread_data *td)
-- 
2.21.0


