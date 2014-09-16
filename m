Return-Path: <relliott@beardog.cce.hp.com>
Subject: [PATCH] fio: print io_u errors on one line
From: Robert Elliott <relliott@beardog.cce.hp.com>
Date: Tue, 16 Sep 2014 17:09:48 -0500
Message-ID: <20140916220631.32299.39978.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, elliott@hp.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

From: Robert Elliott <elliott@hp.com>

Print io_u errors on one line and with one log_err command
to keep them from being interrupted by other prints

Old:
fio: io_u error on file /dev/sdt: Input/output error5.1MB/0KB/0KB /s]
[227K/0/0 iops] [eta 02d:10h:53m:36s]
     read offset=145442430976, buflen=4096
fio: io_u error on file /dev/sdt: Input/output error
     read offset=397760724992, buflen=4096

New:
fio: io_u error on file /dev/sdr: Input/output error: write offset=1532626153472, buflen=4096
fio: io_u error on file /dev/sdt: Input/output error: write offset=102684229632, buflen=4096

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 io_u.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/io_u.c b/io_u.c
index be2f242..bf04865 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1534,15 +1534,12 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	if (td_non_fatal_error(td, eb, io_u->error) && !td->o.error_dump)
 		return;
 
-	log_err("fio: io_u error");
-
-	if (io_u->file)
-		log_err(" on file %s", io_u->file->file_name);
-
-	log_err(": %s\n", strerror(io_u->error));
-
-	log_err("     %s offset=%llu, buflen=%lu\n", msg[io_u->ddir],
-					io_u->offset, io_u->xfer_buflen);
+	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%lu\n",
+		io_u->file ? " on file " : "",
+		io_u->file ? io_u->file->file_name : "",
+		strerror(io_u->error),
+		msg[io_u->ddir],
+		io_u->offset, io_u->xfer_buflen);
 
 	if (!td->error)
 		td_verror(td, io_u->error, "io_u error");


