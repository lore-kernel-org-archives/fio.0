Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D216C69C
	for <fio@vger.kernel.org>; Fri, 12 Jul 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720785612; cv=none; b=WPB58Eh4VaCqod9FsH8z8KkCgGTzfwGr0y+QebvGZW6jti0y6ANB79V+1yPPnQit3oCa5mHT5zDJU3kGhhJjtK9B4Czk2+yOf4rGsziNTT4GcY+XHxOu5S+AXUKI8otYfP8YntW5JflpV9CStT3IwZVUZxT5YzpIYiHEbPqU1Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720785612; c=relaxed/simple;
	bh=txGvDspqlyyvYxvh0EwhYcuVPRZuMY0lvz7TlgWEtqk=;
	h=Subject:From:To:Message-Id:Date; b=QZzSn8EGKSSvjCHa5/fQTFaUFghoaFaHvh2SoHm3JOp+hsbV2N0BeEpJauDxpFRpCgv5XMLqPqhqFHMRdKADy3PMx1O15RKVzIu4oSd0PaoKOgsaGwUFiLzydIQOUUslWNGXD4Ad+B8iv9SdH6k5FZrttchsrQGLoLWAhWzBzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a270J0oD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a270J0oD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gpBzPDwjxyAc2JrA/ORfNI4BD/S02DtlqPeMq1/N6Sg=; b=a270J0oDz/J084bV1hitF1L5VV
	pspUimMxhmPuJTv4pIqdnHukYr2bRaJtN3j9yX8dNEMSW63owqZ7tE+88UMrFWYmLsiroH/lWkyvc
	H6bViJhzGSRh9xAZveKDTxTUCj6svvHlYwZkaJsWyuIGiQaZECa9dwHPDbbzYcGrJgNnCQuzIKeaU
	t6rHZLp9WLSRmHhel06oBc/cm5nAPimBuNOa4RH1+7DgO8dKudr6nqZRdI3jKjPwrLIVu6cMvVHLS
	oK1NKm2cT4lM6rxHj3/sjUtB1OcRsODHTnp8DWqhqkrhpyJe23FUJzygHtx0GVLc9yo4rK+5hL1Wq
	tIBDKaRA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sSEwW-00000001ICd-2dBS
	for fio@vger.kernel.org;
	Fri, 12 Jul 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9721C1BC012D; Fri, 12 Jul 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240712120001.9721C1BC012D@kernel.dk>
Date: Fri, 12 Jul 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6eaa6422fccf857e6b1a88492db805dafca8ee85:

  windows: don't define strtoll for 32-bit builds (2024-06-28 18:48:43 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 89fc4019e2a5ecb23be181a6a1dcda1902cdcfcc:

  Merge branch 'io-uring-cmd/nvme/add-flush' of https://github.com/minwooim/fio (2024-07-11 09:59:48 -0400)

----------------------------------------------------------------
Minwoo Im (6):
      io_uring: Add support FLUSH command
      td: Rename last_ddir to last_ddir_completed
      td: Replace last_was_sync with last_ddir_issued
      io_u: Ensure fsync only after write(s)
      io_u: Support fsync for --rw=trimwrite
      t/nvmept.py: Add test cases for FLUSH

Vincent Fu (1):
      Merge branch 'io-uring-cmd/nvme/add-flush' of https://github.com/minwooim/fio

 engines/nvme.c |  5 ++++
 engines/nvme.h |  1 +
 fio.h          |  7 +++--
 io_u.c         | 10 +++----
 ioengines.c    |  4 +--
 libfio.c       |  1 -
 t/nvmept.py    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 108 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/engines/nvme.c b/engines/nvme.c
index 72934c8b..33d87477 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -381,6 +381,11 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	case DDIR_TRIM:
 		fio_nvme_uring_cmd_trim_prep(cmd, io_u, dsm);
 		return 0;
+	case DDIR_SYNC:
+	case DDIR_DATASYNC:
+		cmd->opcode = nvme_cmd_flush;
+		cmd->nsid = data->nsid;
+		return 0;
 	default:
 		return -ENOTSUP;
 	}
diff --git a/engines/nvme.h b/engines/nvme.h
index bc2370b8..b5fef2fb 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -73,6 +73,7 @@ enum nvme_admin_opcode {
 };
 
 enum nvme_io_opcode {
+	nvme_cmd_flush			= 0x00,
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
 	nvme_cmd_write_uncor		= 0x04,
diff --git a/fio.h b/fio.h
index 7d9927a0..4bb6cfa7 100644
--- a/fio.h
+++ b/fio.h
@@ -258,8 +258,9 @@ struct thread_data {
 	size_t orig_buffer_size;
 	volatile int runstate;
 	volatile bool terminate;
-	bool last_was_sync;
-	enum fio_ddir last_ddir;
+
+	enum fio_ddir last_ddir_completed;
+	enum fio_ddir last_ddir_issued;
 
 	int mmapfd;
 
@@ -629,7 +630,7 @@ static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
 
 static inline bool should_fsync(struct thread_data *td)
 {
-	if (td->last_was_sync)
+	if (ddir_sync(td->last_ddir_issued))
 		return false;
 	if (td_write(td) || td->o.override_sync)
 		return true;
diff --git a/io_u.c b/io_u.c
index a090e121..f81086b6 100644
--- a/io_u.c
+++ b/io_u.c
@@ -755,7 +755,7 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 	 * See if it's time to fsync/fdatasync/sync_file_range first,
 	 * and if not then move on to check regular I/Os.
 	 */
-	if (should_fsync(td)) {
+	if (should_fsync(td) && td->last_ddir_issued == DDIR_WRITE) {
 		if (td->o.fsync_blocks && td->io_issues[DDIR_WRITE] &&
 		    !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks))
 			return DDIR_SYNC;
@@ -815,7 +815,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 	if (td->o.zone_mode == ZONE_MODE_ZBD)
 		ddir = zbd_adjust_ddir(td, io_u, ddir);
 
-	if (td_trimwrite(td)) {
+	if (td_trimwrite(td) && !ddir_sync(ddir)) {
 		struct fio_file *f = io_u->file;
 		if (f->last_start[DDIR_WRITE] == f->last_start[DDIR_TRIM])
 			ddir = DDIR_TRIM;
@@ -1757,7 +1757,7 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 		if (get_next_trim(td, io_u))
 			return true;
 	} else if (!(td->io_hist_len % td->o.trim_backlog) &&
-		     td->last_ddir != DDIR_READ) {
+		     td->last_ddir_completed != DDIR_READ) {
 		td->trim_batch = td->o.trim_batch;
 		if (!td->trim_batch)
 			td->trim_batch = td->o.trim_backlog;
@@ -1779,7 +1779,7 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
 		if (td->verify_batch)
 			get_verify = 1;
 		else if (!(td->io_hist_len % td->o.verify_backlog) &&
-			 td->last_ddir != DDIR_READ) {
+			 td->last_ddir_completed != DDIR_READ) {
 			td->verify_batch = td->o.verify_batch;
 			if (!td->verify_batch)
 				td->verify_batch = td->o.verify_backlog;
@@ -2122,7 +2122,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		return;
 	}
 
-	td->last_ddir = ddir;
+	td->last_ddir_completed = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
 		unsigned long long bytes = io_u->xfer_buflen - io_u->resid;
diff --git a/ioengines.c b/ioengines.c
index 6b81dc77..dcd4164d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -437,7 +437,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 			td->ts.total_io_u[io_u->ddir]++;
 		}
 
-		td->last_was_sync = ddir_sync(io_u->ddir);
+		td->last_ddir_issued = ddir;
 	} else if (ret == FIO_Q_QUEUED) {
 		td->io_u_queued++;
 
@@ -448,7 +448,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 		if (td->io_u_queued >= td->o.iodepth_batch)
 			td_io_commit(td);
 
-		td->last_was_sync = ddir_sync(io_u->ddir);
+		td->last_ddir_issued = ddir;
 	}
 
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
diff --git a/libfio.c b/libfio.c
index d0c6bf8f..2596ae5a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -101,7 +101,6 @@ static void reset_io_counters(struct thread_data *td, int all)
 
 	td->zone_bytes = 0;
 
-	td->last_was_sync = false;
 	td->rwmix_issues = 0;
 
 	/*
diff --git a/t/nvmept.py b/t/nvmept.py
index 1ade64dc..3d90f4bf 100755
--- a/t/nvmept.py
+++ b/t/nvmept.py
@@ -87,6 +87,53 @@ class PassThruTest(FioJobCmdTest):
             self.passed = False
 
 
+class FlushTest(FioJobCmdTest):
+    def setup(self, parameters):
+        fio_args = [
+            "--name=nvmept-flush",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            "--randrepeat=0",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'offset', 'fdp',
+                    'fdp_pli', 'fdp_pli_select', 'dataplacement', 'plid_select',
+                    'plids', 'dp_scheme', 'number_ios', 'read_iolog', 'fsync']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        job = self.json_data['jobs'][0]
+
+        rw = self.fio_opts['rw']
+        fsync = self.fio_opts['fsync']
+
+        nr_write = job['write']['total_ios']
+        nr_sync = job['sync']['total_ios']
+
+        nr_sync_exp = nr_write // fsync
+
+        # The actual number of DDIR_SYNC issued might miss one DDIR_SYNC command
+        # when the last command issued was DDIR_WRITE command.
+        if not ((nr_sync == nr_sync_exp) or (nr_sync + 1 == nr_sync_exp)):
+            logging.error(f"nr_write={nr_write}, nr_sync={nr_sync}, fsync={fsync}")
+            self.passed = False
+
+
 TEST_LIST = [
     {
         "test_id": 1,
@@ -255,6 +302,50 @@ TEST_LIST = [
             },
         "test_class": PassThruTest,
     },
+    {
+        "test_id": 16,
+        "fio_opts": {
+            "rw": 'read',
+            "bs": 4096,
+            "number_ios": 10,
+            "fsync": 1,
+            "output-format": "json",
+            },
+        "test_class": FlushTest,
+    },
+    {
+        "test_id": 17,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 10,
+            "fsync": 1,
+            "output-format": "json",
+            },
+        "test_class": FlushTest,
+    },
+    {
+        "test_id": 18,
+        "fio_opts": {
+            "rw": 'readwrite',
+            "bs": 4096,
+            "number_ios": 10,
+            "fsync": 1,
+            "output-format": "json",
+            },
+        "test_class": FlushTest,
+    },
+    {
+        "test_id": 19,
+        "fio_opts": {
+            "rw": 'trimwrite',
+            "bs": 4096,
+            "number_ios": 10,
+            "fsync": 1,
+            "output-format": "json",
+            },
+        "test_class": FlushTest,
+    },
 ]
 
 def parse_args():
