Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C00180A67
	for <fio@vger.kernel.org>; Wed, 29 May 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984011; cv=none; b=rN9FknluGtToPSEppuhBuWXfSbB4tIwzSiPABcwp2a8hjmdKrjCaLyJwGTQN0wM5P6BD2RRhnWUxcGWnNrRAAWWJziUXOgX1KYcr8rSjlixhSrdxhVE/8LpV6W04rFCpTt4cMC5QxLmG0T2oUs3eCnKjbc/BwQAYDatq97EZ/nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984011; c=relaxed/simple;
	bh=tjUzkKo+KUuOGCOy8bBDo5ic3DqxPTwwKeHGxOAO4lE=;
	h=Subject:From:To:Message-Id:Date; b=uBlNa+2aJwCPNnTVeCKDzUdvgT8SVQYY/OyN//uuwr9z0qvIctx5lVZQDVOQiFCa4kaoRgdHcjwOA9/Q0CE63jrQIISOB7rY2yrxDLx/NtzPhLgLiRjGO4ar8QcYuuQPrUR07xXM3sMBjXL6SmKShoNkaIEexXiLw6T+sUdH0b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M2sU8dom; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M2sU8dom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=H9BKYyoEWOoeoVDxe8wDYqykh+wTuJg+We+oI5oUeg4=; b=M2sU8domwvJHpNq1U/z/vsmF1A
	beeZ21643kKOnhPl1Caba+p+ZNN/HPPhCSD2icqBCYWHirHqs4hRRgcAy2aADKzz+ppq9f7zmia71
	z64IE3tPnmKn5HC3F337EMfS391qyLh1efCWYv4L8ZMJyi9E72um//8QkUiUADj6mL+18iV0AvW30
	/5mCr9c3rdrxeAUKWXH9qddEF3Amh2JVS3LC4VOanxhUmmudntnuJIGGGHAxDGrE9jZs9bNPNyZo7
	wcQVNOCHer0QagJ1pLdngRtG6JVxU0KjLYC+tgn2lLecFNf/8j0+N34QTnM1X5PPhcP7XEtAhPtCo
	eEAt+H3A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCHyN-0000000DfcQ-3hvb
	for fio@vger.kernel.org;
	Wed, 29 May 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B77761BC0147; Wed, 29 May 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240529120001.B77761BC0147@kernel.dk>
Date: Wed, 29 May 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 85b5eb32dba009e82d8c1b368ce7d8170d59eb8a:

  Merge branch 'nvme/support-sync-fua-for-iouring-v2' of https://github.com/minwooim/fio (2024-05-24 12:44:44 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5fbe84b83999d862838f36ea0d4a499e31f0653:

  Merge branch 'enable-dataplacement-while-replaying-io' of https://github.com/parkvibes/fio (2024-05-28 14:19:19 -0400)

----------------------------------------------------------------
Hyunwoo Park (2):
      fio: enable dataplacement(fdp) while replaying I/Os
      t/nvmept_fdp: add a test(402)

Jens Axboe (1):
      Merge branch 'io_uring/fix-negative-cqe-status' of https://github.com/minwooim/fio

Minwoo Im (2):
      io_uring: Fix the flip to negative of CQE status
      options: Add support hex value to ignore_error

Vincent Fu (1):
      Merge branch 'enable-dataplacement-while-replaying-io' of https://github.com/parkvibes/fio

 engines/io_uring.c |  2 +-
 iolog.c            | 14 +++++++++++++-
 options.c          |  6 +++++-
 t/nvmept_fdp.py    | 30 +++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 3a03ae35..05ce27eb 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -499,7 +499,7 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
 	if (cqe->res != 0) {
-		io_u->error = -cqe->res;
+		io_u->error = abs(cqe->res);
 		return io_u;
 	} else {
 		io_u->error = 0;
diff --git a/iolog.c b/iolog.c
index 96af4f33..37ad0d2a 100644
--- a/iolog.c
+++ b/iolog.c
@@ -140,8 +140,17 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 			break;
 		}
 		ret = td_io_open_file(td, f);
-		if (!ret)
+		if (!ret) {
+			if (td->o.dp_type != FIO_DP_NONE) {
+				int dp_init_ret = dp_init(td);
+
+				if (dp_init_ret != 0) {
+					td_verror(td, dp_init_ret, "dp_init");
+					return -1;
+				}
+			}
 			break;
+		}
 		td_verror(td, ret, "iolog open file");
 		return -1;
 	case FIO_LOG_CLOSE_FILE:
@@ -233,6 +242,9 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 				usec_sleep(td, (ipo->delay - elapsed) * 1000);
 		}
 
+		if (td->o.dp_type != FIO_DP_NONE)
+			dp_fill_dspec_data(td, io_u);
+
 		free(ipo);
 
 		if (io_u->ddir != DDIR_WAIT)
diff --git a/options.c b/options.c
index f5d221c7..1dd60e8b 100644
--- a/options.c
+++ b/options.c
@@ -532,7 +532,11 @@ static int ignore_error_type(struct thread_data *td, enum error_type_bit etype,
 		if (fname[0] == 'E') {
 			error[i] = str2error(fname);
 		} else {
-			error[i] = atoi(fname);
+			int base = 10;
+			if (!strncmp(fname, "0x", 2) ||
+					!strncmp(fname, "0X", 2))
+				base = 16;
+			error[i] = strtol(fname, NULL, base);
 			if (error[i] < 0)
 				error[i] = -error[i];
 		}
diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
index d6a543f2..c50c14e4 100755
--- a/t/nvmept_fdp.py
+++ b/t/nvmept_fdp.py
@@ -64,7 +64,7 @@ class FDPTest(FioJobCmdTest):
                     'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
                     'buffer_pattern', 'verify_pattern', 'offset', 'fdp',
                     'fdp_pli', 'fdp_pli_select', 'dataplacement', 'plid_select',
-                    'plids', 'dp_scheme', 'number_ios']:
+                    'plids', 'dp_scheme', 'number_ios', 'read_iolog']:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
@@ -148,6 +148,18 @@ class FDPMultiplePLIDTest(FDPTest):
             with open(scheme_path, mode='w') as f:
                 for i in range(mapping['nios_for_scheme']):
                     f.write(f'{mapping["hole_size"] * 2 * i}, {mapping["hole_size"] * 2 * (i+1)}, {i}\n')
+
+        if 'read_iolog' in self.fio_opts:
+            read_iolog_path = os.path.join(self.paths['test_dir'], self.fio_opts['read_iolog'])
+            with open(read_iolog_path, mode='w') as f:
+                f.write('fio version 2 iolog\n')
+                f.write(f'{self.fio_opts["filename"]} add\n')
+                f.write(f'{self.fio_opts["filename"]} open\n')
+
+                for i in range(mapping['nios_for_scheme']):
+                    f.write(f'{self.fio_opts["filename"]} write {mapping["hole_size"] * 2 * i} {mapping["hole_size"]}\n')
+
+                f.write(f'{self.fio_opts["filename"]} close')
  
     def _check_result(self):
         if 'fdp_pli' in self.fio_opts:
@@ -789,6 +801,22 @@ TEST_LIST = [
             },
         "test_class": FDPMultiplePLIDTest,
     },
+    # check whether dataplacement works while replaying iologs
+    {
+        "test_id": 402,
+        "fio_opts": {
+            "rw": "write:{hole_size}",
+            "bs": "{hole_size}",
+            "number_ios": "{nios_for_scheme}",
+            "verify": "crc32c",
+            "read_iolog": "iolog",
+            "dataplacement": "fdp",
+            "plid_select": "scheme",
+            "dp_scheme": "lba.scheme",
+            "output-format": "json",
+        },
+        "test_class": FDPMultiplePLIDTest,
+    },
 ]
 
 def parse_args():
