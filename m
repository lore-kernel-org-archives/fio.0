Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lp9+vAcJ"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2A295
	for <fio@vger.kernel.org>; Tue, 12 Dec 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=T5sqqfAyBlG06tGPa8cMWWcu92HpjiKq1xhvSp87ctY=; b=Lp9+vAcJl+WRJUsNFqy+kBraiy
	HrI28HXVHokWtaxO12N6dUsYhuH1LReIhH2s17mCDR0Rf9lDxW5fCwoG5OTvFnWDwp20m5fFIdltj
	dbT+BmhQGcavRd5psS4xim/DqOPyTpMut5AEoEJrXmOUzZP/vbCoXxFhOhCmc5pD43HKKIes0VhhH
	ng9H9VN+Pyktdlt3I8EcRP1s/WK/BFpL8JReJ7FQiTiBXvyMdtzS4M0MJpqJZ8kbSCe2daK3PL7Vf
	HnoEFoxqZWtqwnx1jRjEby/Gt6GAcJ5HoVD9lE9ZDpPf6icaxG9JxVjkmYuqmBoTEFf6WZUnh1YQE
	q2xchl4Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rD2Mm-00AEMK-Sm
	for fio@vger.kernel.org; Tue, 12 Dec 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5566B1BC016A; Tue, 12 Dec 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231212130001.5566B1BC016A@kernel.dk>
Date: Tue, 12 Dec 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit bdf99b6836d75683cba5968c40f321748482ae86:

  Merge branch 'xnvme_includes' of https://github.com/safl/fio (2023-11-20 07:43:16 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63e6f55a9147cf9f76376c2e7e38a623c8832f23:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-12-11 16:27:21 -0500)

----------------------------------------------------------------
Bart Van Assche (1):
      Fall back to F_SET_RW_HINT if F_SET_FILE_RW_HINT is not supported

Vincent Fu (2):
      engines/io_uring_cmd: friendlier bad bs error msg
      Merge branch 'master' of https://github.com/bvanassche/fio

 engines/io_uring.c | 19 +++++++++++++------
 ioengines.c        | 22 ++++++++++++----------
 2 files changed, 25 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 38c36fdc..5ae3135b 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1279,14 +1279,21 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 		lba_size = data->lba_ext ? data->lba_ext : data->lba_size;
 
 		for_each_rw_ddir(ddir) {
-			if (td->o.min_bs[ddir] % lba_size ||
-				td->o.max_bs[ddir] % lba_size) {
-				if (data->lba_ext)
-					log_err("%s: block size must be a multiple of (LBA data size + Metadata size)\n",
-						f->file_name);
-				else
+			if (td->o.min_bs[ddir] % lba_size || td->o.max_bs[ddir] % lba_size) {
+				if (data->lba_ext) {
+					log_err("%s: block size must be a multiple of %u "
+						"(LBA data size + Metadata size)\n", f->file_name, lba_size);
+					if (td->o.min_bs[ddir] == td->o.max_bs[ddir] &&
+					    !(td->o.min_bs[ddir] % data->lba_size)) {
+						/* fixed block size is actually a multiple of LBA data size */
+						unsigned long long suggestion = lba_size *
+							(td->o.min_bs[ddir] / data->lba_size);
+						log_err("Did you mean to use a block size of %llu?\n", suggestion);
+					}
+				} else {
 					log_err("%s: block size must be a multiple of LBA data size\n",
 						f->file_name);
+				}
 				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
diff --git a/ioengines.c b/ioengines.c
index 36172725..87cc2286 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -590,19 +590,21 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	if (fio_option_is_set(&td->o, write_hint) &&
 	    (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_FILE)) {
 		uint64_t hint = td->o.write_hint;
-		int cmd;
+		int res;
 
 		/*
-		 * For direct IO, we just need/want to set the hint on
-		 * the file descriptor. For buffered IO, we need to set
-		 * it on the inode.
+		 * For direct IO, set the hint on the file descriptor if that is
+		 * supported. Otherwise set it on the inode. For buffered IO, we
+		 * need to set it on the inode.
 		 */
-		if (td->o.odirect)
-			cmd = F_SET_FILE_RW_HINT;
-		else
-			cmd = F_SET_RW_HINT;
-
-		if (fcntl(f->fd, cmd, &hint) < 0) {
+		if (td->o.odirect) {
+			res = fcntl(f->fd, F_SET_FILE_RW_HINT, &hint);
+			if (res < 0)
+				res = fcntl(f->fd, F_SET_RW_HINT, &hint);
+		} else {
+			res = fcntl(f->fd, F_SET_RW_HINT, &hint);
+		}
+		if (res < 0) {
 			td_verror(td, errno, "fcntl write hint");
 			goto err;
 		}
