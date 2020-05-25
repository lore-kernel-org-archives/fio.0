Return-Path: <prvs=407053df0=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 2/4] libzbc: fix whitespace errors
Date: Tue, 26 May 2020 06:32:54 +0900
Message-Id: <20200525213256.7476-3-dmitry.fomichev@wdc.com>
In-Reply-To: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Make checkpatch happy... no functional change.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/libzbc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2f6b4583..9e568334 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -47,7 +47,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			   struct libzbc_data **p_ld)
 {
 	struct libzbc_data *ld = td->io_ops_data;
-        int ret, flags = OS_O_DIRECT;
+	int ret, flags = OS_O_DIRECT;
 
 	if (ld) {
 		/* Already open */
@@ -61,7 +61,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -EINVAL;
 	}
 
-        if (td_write(td)) {
+	if (td_write(td)) {
 		if (!read_only)
 			flags |= O_RDWR;
 	} else if (td_read(td)) {
@@ -71,17 +71,15 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			flags |= O_RDONLY;
 	} else if (td_trim(td)) {
 		td_verror(td, EINVAL, "libzbc does not support trim");
-                log_err("%s: libzbc does not support trim\n",
-                        f->file_name);
-                return -EINVAL;
+		log_err("%s: libzbc does not support trim\n", f->file_name);
+		return -EINVAL;
 	}
 
-        if (td->o.oatomic) {
+	if (td->o.oatomic) {
 		td_verror(td, EINVAL, "libzbc does not support O_ATOMIC");
-                log_err("%s: libzbc does not support O_ATOMIC\n",
-                        f->file_name);
-                return -EINVAL;
-        }
+		log_err("%s: libzbc does not support O_ATOMIC\n", f->file_name);
+		return -EINVAL;
+	}
 
 	ld = calloc(1, sizeof(*ld));
 	if (!ld)
-- 
2.21.0


