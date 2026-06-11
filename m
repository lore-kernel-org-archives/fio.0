Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA413CB2D4
	for <fio@vger.kernel.org>; Thu, 11 Jun 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179210; cv=none; b=YGZe0p5FLJsgXSgEDHS1A0Ui/zaHXudwOrQHTEQsZOWV2IGg4s+AIFY8zA0dunkCitOGCv1XnSd9Gd+O1gguOXP7/8Xyr0ks+H/bvpx9Vc4SZ1ERso1W2t+jm2suNIGwn90r1CCKFiK9PZyZPOBpQe3gxpVpmzAX/6pluMt6L54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179210; c=relaxed/simple;
	bh=PYWs0U+JT1awooIPYXiMlRG3kl377BgmFIaurgV/4Ek=;
	h=Subject:From:To:Date:Message-Id; b=X1JWlkUW3F2N/RDyVlILA5SudnuclCalakg06otJ8uC2wIYPnF/YNWr+fljnmCowJ9ujfUOIB4j2uGqalLiIpx8VR9xo9LSIZuwyVgyDS0lUKg5lMAxEtwW23/NFVWFWEuUwdgrjDWRmr4klN+UaZgcr/NhIDjlAd9lhQPuOusA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E4SsIyfl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E4SsIyfl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=jjqkIEPfv9jiLoGoaraq2k8fLTwzVu7MKXEDJYLSw38=; b=E4SsIyflY7jjYvm64l1vX0cuDI
	ocS6PjAVagZeTxCw/xMNlKgtenpHVxV0Z9fhCnljP36DYqdkn3Yd8kXLt5vzd4v7K2QXbkv7lqWhO
	q1hwQRE10D2H2XyV2DysQJdplJ2tuS5ABFA89Bj6HNcjHy/SpXk23Fy3voJ2DNGu6OJzZLw2V1Ctk
	sah91LwyBxu1DDA0O/KMMJXSZ+cWJ/TwHu8FzDFI8hxFLWpW6MPIe9Mj8wCuNqDjEmBjfbbQneLUf
	dCapziDbfCD2q211M9PJO0kWOZDf4G9UDmdHux33KOSNx2oD8I6tOTUK8SAzxS482tnPYqLZNHDF3
	ADuWxVXg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXe4q-00000001qLL-0Z8u
	for fio@vger.kernel.org;
	Thu, 11 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 848241BC0156; Thu, 11 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 11 Jun 2026 06:00:01 -0600
Message-Id: <20260611120001.848241BC0156@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f055bacb90990b96fe9940579b3f7eda3515679f:

  t/nvmept_write_mode: fix fio path (2026-06-10 00:21:19 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bd11387aba55e9dc58c0127437c8c6982e6ac32f:

  ci: skip new write uncorrectable tests on QEMU (2026-06-10 22:28:50 +0000)

----------------------------------------------------------------
Minwoo Im (3):
      io_uring_cmd: support mixed write_mode with ratio
      io_u: add zeroed, errored flags to @io_u for verify
      t/nvmept_write_mode: add multiple write_mode tests

Vincent Fu (7):
      Merge branch 'io_uring/multiple-write-modes' of https://github.com/minwooim/fio
      engines/io_uring_cmd: debug print for write mode
      verify: debug print for verifying write zeroes
      t/nvmept_write_mode: check write mode splits
      t/nvmept_write_mode: check verify job
      t/nvmept_write_mode: improve formatting
      ci: skip new write uncorrectable tests on QEMU

 .github/workflows/qemu.yml        |   2 +-
 HOWTO.rst                         |   6 +
 engines/io_uring.c                | 261 +++++++++++++++++++++++++++-----
 examples/uring-cmd-write-mode.fio |  21 +++
 examples/uring-cmd-write-mode.png | Bin 0 -> 41207 bytes
 fio.1                             |   6 +
 fio.h                             |   1 +
 io_u.c                            |  11 +-
 io_u.h                            |   2 +
 iolog.c                           |   5 +
 iolog.h                           |   2 +
 t/nvmept_write_mode.py            | 303 ++++++++++++++++++++++++++++++++++++--
 verify.c                          |  25 +++-
 13 files changed, 590 insertions(+), 55 deletions(-)
 create mode 100644 examples/uring-cmd-write-mode.fio
 create mode 100644 examples/uring-cmd-write-mode.png

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index ba0a00ac..451ecd42 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -18,7 +18,7 @@ jobs:
               -device nvme,id=nvme0,serial=deadbeef
               -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
               -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
-            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 -p '1022:--skip 30 31 32 33 34'"
+            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 -p '1022:--skip 30 31 32 33 34 40 50 51 53 70'"
             extra_pkgs: "nvme-cli"
           - config: 16-bit Guard PI tests (long)
             device: >-
diff --git a/HOWTO.rst b/HOWTO.rst
index 63964eb9..ac570972 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3049,6 +3049,12 @@ with the caveat that when used on the command line, they must come after the
                 **verify**
                         Use Verify commands for write operations
 
+        Multiple modes with mix ratios can be specified using the format
+        ``mode/pct:mode/pct:...``.  Percentages must sum to 100.  If a
+        percentage is omitted, the remaining percentage is split evenly among
+        entries with no percentage specified.
+        Example: ``write/60:zeroes/30:uncor/10`` or ``write/50:zeroes/:uncor/``
+
 .. option:: verify_mode=str : [io_uring_cmd]
 
         Specifies the type of command to be used in the verification phase.  Defaults to 'read'.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6aedb062..b7b912b3 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -104,6 +104,14 @@ enum uring_cmd_write_mode {
 	FIO_URING_CMD_WMODE_VERIFY,
 };
 
+#define WMODE_SPLIT_MAX	4
+
+struct wmode_split_entry {
+	uint8_t		opcode;
+	uint32_t	cdw12_flag;
+	unsigned int	perc;
+};
+
 enum uring_cmd_verify_mode {
 	FIO_URING_CMD_VMODE_READ = 1,
 	FIO_URING_CMD_VMODE_COMPARE,
@@ -161,6 +169,7 @@ struct ioring_data {
 	struct nvme_dsm *dsm;
 	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 	uint8_t write_opcode;
+	struct frand_state wmode_state;
 
 	bool is_uring_cmd_eng;
 
@@ -174,6 +183,8 @@ struct ioring_options {
 	unsigned int writefua;
 	unsigned int deac;
 	unsigned int write_mode;
+	struct wmode_split_entry wmode_split[WMODE_SPLIT_MAX];
+	unsigned int wmode_split_nr;
 	unsigned int verify_mode;
 	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
@@ -206,6 +217,138 @@ static const int fixed_ddir_to_op[2] = {
 	IORING_OP_WRITE_FIXED
 };
 
+static uint8_t wmode_str_to_opcode(const char *mode)
+{
+	if (!strcmp(mode, "write"))
+		return nvme_cmd_write;
+	if (!strcmp(mode, "uncor"))
+		return nvme_cmd_write_uncor;
+	if (!strcmp(mode, "zeroes"))
+		return nvme_cmd_write_zeroes;
+	if (!strcmp(mode, "verify"))
+		return nvme_cmd_verify;
+	return 0xff;
+}
+
+static int str_write_mode_cb(void *data, const char *str)
+{
+	struct ioring_options *o = data;
+	char *s, *p, *tok;
+	unsigned int total_perc = 0, perc_missing;
+	int i = 0, j;
+
+	/* Single-value: no ':' means single mode name */
+	if (!strchr(str, ':')) {
+		uint8_t op = wmode_str_to_opcode(str);
+
+		if (op == 0xff) {
+			log_err("fio: invalid write_mode value: %s\n", str);
+			return 1;
+		}
+
+		if (op == nvme_cmd_write_uncor)
+			o->write_mode = FIO_URING_CMD_WMODE_UNCOR;
+		else if (op == nvme_cmd_write_zeroes)
+			o->write_mode = FIO_URING_CMD_WMODE_ZEROES;
+		else if (op == nvme_cmd_verify)
+			o->write_mode = FIO_URING_CMD_WMODE_VERIFY;
+		else
+			o->write_mode = FIO_URING_CMD_WMODE_WRITE;
+		o->wmode_split_nr = 0;
+		return 0;
+	}
+
+	/* Multi-value: e.g., --write_mode=write/60:zeroes/30:uncor/10 */
+	s = strdup(str);
+	p = s;
+	while ((tok = strsep(&p, ":")) != NULL) {
+		char *perc_str = strchr(tok, '/');
+		unsigned int perc;
+		uint8_t op;
+
+		if (i >= WMODE_SPLIT_MAX) {
+			log_err("fio: write_mode: too many entries (max %d)\n",
+				WMODE_SPLIT_MAX);
+			free(s);
+			return 1;
+		}
+
+		if (!perc_str) {
+			log_err("fio: write_mode: missing '/' in entry: %s\n", tok);
+			free(s);
+			return 1;
+		}
+
+		*perc_str++ = '\0';
+		op = wmode_str_to_opcode(tok);
+		if (op == 0xff) {
+			log_err("fio: invalid write_mode value: %s\n", tok);
+			free(s);
+			return 1;
+		}
+
+		if (*perc_str) {
+			int tmp = atoi(perc_str);
+
+			if (tmp < 0) {
+				log_err("fio: write_mode: percentage must not be negative: %s\n",
+					perc_str);
+				free(s);
+				return 1;
+			}
+
+			perc = (unsigned int)tmp;
+			total_perc += perc;
+		} else {
+			/* blank percentage: fill in evenly later */
+			perc = -1U;
+		}
+
+		o->wmode_split[i].opcode = op;
+		o->wmode_split[i].cdw12_flag = 0;
+		o->wmode_split[i].perc = perc;
+		i++;
+	}
+	free(s);
+
+	if (i < 2) {
+		log_err("fio: write_mode needs at least 2 entries\n");
+		return 1;
+	}
+
+	if (total_perc > 100) {
+		log_err("fio: write_mode percentages exceed 100%%\n");
+		return 1;
+	}
+
+	/*
+	 * Distribute the remaining percentage evenly among blank entries,
+	 * matching bssplit behavior (e.g. write/50:zeroes/:uncor/ gives 25%
+	 * each to zeroes and uncor).
+	 */
+	perc_missing = 0;
+	for (j = 0; j < i; j++) {
+		if (o->wmode_split[j].perc == -1U)
+			perc_missing++;
+	}
+
+	if (perc_missing) {
+		unsigned int fill = (100 - total_perc) / perc_missing;
+
+		for (j = 0; j < i; j++) {
+			if (o->wmode_split[j].perc == -1U)
+				o->wmode_split[j].perc = fill;
+		}
+	} else if (total_perc != 100) {
+		log_err("fio: write_mode percentages should add up to 100%%\n");
+		return 1;
+	}
+
+	o->wmode_split_nr = i;
+	o->write_mode = FIO_URING_CMD_WMODE_WRITE;
+	return 0;
+}
+
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -247,29 +390,13 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "write_mode",
-		.lname	= "Additional Write commands support (Write Uncorrectable, Write Zeores)",
+		.lname	= "Write command type(s) with optional mix ratios",
 		.type	= FIO_OPT_STR,
-		.off1	= offsetof(struct ioring_options, write_mode),
-		.help	= "Issue Write Uncorrectable or Zeroes command instead of Write command",
+		.cb	= str_write_mode_cb,
+		.help	= "Single: write|uncor|zeroes|verify. "
+			  "Mixed: mode/pct:mode/pct:... (e.g. write/60:zeroes/40). "
+			  "Blank pct evenly splits the remainder (e.g. write/50:zeroes/:uncor/)",
 		.def	= "write",
-		.posval = {
-			  { .ival = "write",
-			    .oval = FIO_URING_CMD_WMODE_WRITE,
-			    .help = "Issue Write commands for write operations"
-			  },
-			  { .ival = "uncor",
-			    .oval = FIO_URING_CMD_WMODE_UNCOR,
-			    .help = "Issue Write Uncorrectable commands for write operations"
-			  },
-			  { .ival = "zeroes",
-			    .oval = FIO_URING_CMD_WMODE_ZEROES,
-			    .help = "Issue Write Zeroes commands for write operations"
-			  },
-			  { .ival = "verify",
-			    .oval = FIO_URING_CMD_WMODE_VERIFY,
-			    .help = "Issue Verify commands for write operations"
-			  },
-		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
@@ -647,6 +774,35 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		io_u_set(td, io_u, IO_U_F_VER_IN_DEV);
 	}
 
+	if (o->wmode_split_nr > 1 && io_u->ddir == DDIR_WRITE) {
+		unsigned int rand = rand_between(&ld->wmode_state, 0, 99);
+		unsigned int perc = 0;
+		int i;
+
+		for (i = 0; i < (int)o->wmode_split_nr; i++) {
+			perc += o->wmode_split[i].perc;
+			if (rand < perc) {
+				uint8_t op = o->wmode_split[i].opcode;
+
+				io_u_clear(td, io_u, IO_U_F_TRIMMED | IO_U_F_ZEROED | IO_U_F_ERRORED);
+				if (op == nvme_cmd_write_zeroes) {
+					if (o->deac)
+						io_u_set(td, io_u, IO_U_F_TRIMMED);
+					else
+						io_u_set(td, io_u, IO_U_F_ZEROED);
+				} else if (op == nvme_cmd_write_uncor) {
+					io_u_set(td, io_u, IO_U_F_ERRORED);
+				}
+
+				dprint(FD_IO, "op selected %u\n", op);
+				return fio_nvme_uring_cmd_prep(cmd, io_u,
+					o->nonvectored ? NULL : &ld->iovecs[io_u->index],
+					dsm, read_opcode, op,
+					o->wmode_split[i].cdw12_flag);
+			}
+		}
+	}
+
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
 			dsm, read_opcode, ld->write_opcode,
@@ -1459,27 +1615,44 @@ static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 	struct ioring_options *o = td->eo;
 
 	if (td_write(td)) {
-		switch (o->write_mode) {
-		case FIO_URING_CMD_WMODE_UNCOR:
-			ld->write_opcode = nvme_cmd_write_uncor;
-			break;
-		case FIO_URING_CMD_WMODE_ZEROES:
-			ld->write_opcode = nvme_cmd_write_zeroes;
-			if (o->deac)
-				ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
-			break;
-		case FIO_URING_CMD_WMODE_VERIFY:
-			ld->write_opcode = nvme_cmd_verify;
-			break;
-		default:
-			ld->write_opcode = nvme_cmd_write;
-			break;
+		if (o->wmode_split_nr > 1) {
+			int i;
+
+			init_rand_seed(&ld->wmode_state,
+				       td->rand_seeds[FIO_RAND_WMODE_OFF],
+				       false);
+			for (i = 0; i < (int)o->wmode_split_nr; i++) {
+				struct wmode_split_entry *e = &o->wmode_split[i];
+
+				e->cdw12_flag = 0;
+				if (e->opcode == nvme_cmd_write_zeroes && o->deac)
+					e->cdw12_flag = 1 << 25;
+				else if (e->opcode == nvme_cmd_write && o->writefua)
+					e->cdw12_flag = 1 << 30;
+			}
+		} else {
+			switch (o->write_mode) {
+			case FIO_URING_CMD_WMODE_UNCOR:
+				ld->write_opcode = nvme_cmd_write_uncor;
+				break;
+			case FIO_URING_CMD_WMODE_ZEROES:
+				ld->write_opcode = nvme_cmd_write_zeroes;
+				if (o->deac)
+					ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
+				break;
+			case FIO_URING_CMD_WMODE_VERIFY:
+				ld->write_opcode = nvme_cmd_verify;
+				break;
+			default:
+				ld->write_opcode = nvme_cmd_write;
+				break;
+			}
 		}
 	}
 
 	if (o->readfua)
 		ld->cdw12_flags[DDIR_READ] = 1 << 30;
-	if (o->writefua)
+	if (o->writefua && o->wmode_split_nr <= 1)
 		ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
 
 	return 0;
@@ -1649,6 +1822,17 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 		io_u->engine_data = pi_data;
 	}
 
+	if (ld->is_uring_cmd_eng && o->wmode_split_nr <= 1) {
+		if (ld->write_opcode == nvme_cmd_write_zeroes) {
+			if (o->deac)
+				io_u_set(td, io_u, IO_U_F_TRIMMED);
+			else
+				io_u_set(td, io_u, IO_U_F_ZEROED);
+		} else if (ld->write_opcode == nvme_cmd_write_uncor) {
+			io_u_set(td, io_u, IO_U_F_ERRORED);
+		}
+	}
+
 	return 0;
 }
 
@@ -1840,7 +2024,8 @@ static int fio_ioring_open_nvme(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
-	if (o->write_mode != FIO_URING_CMD_WMODE_WRITE && !td_write(td)) {
+	if ((o->write_mode != FIO_URING_CMD_WMODE_WRITE || o->wmode_split_nr > 1) &&
+	    !td_write(td)) {
 		log_err("%s: 'readwrite=|rw=' has no write\n", f->file_name);
 		td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 		return 1;
diff --git a/examples/uring-cmd-write-mode.fio b/examples/uring-cmd-write-mode.fio
new file mode 100644
index 00000000..63e4c18c
--- /dev/null
+++ b/examples/uring-cmd-write-mode.fio
@@ -0,0 +1,21 @@
+# io_uring_cmd mixed write_mode example
+#
+# Issues write, zeroes, uncor, and verify commands in a single job
+# using the ratio-based write_mode syntax:
+#
+#   write_mode=write/40:zeroes/30:uncor/20:verify/10
+#
+# Replace /dev/ng0n1 with the target nvme-ns generic character device.
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=1G
+iodepth=32
+bs=4K
+thread=1
+
+[mixed-write-modes]
+rw=write
+write_mode=write/40:zeroes/30:uncor/20:verify/10
diff --git a/examples/uring-cmd-write-mode.png b/examples/uring-cmd-write-mode.png
new file mode 100644
index 00000000..8754c111
Binary files /dev/null and b/examples/uring-cmd-write-mode.png differ
diff --git a/fio.1 b/fio.1
index 71a7309a..d2933a8f 100644
--- a/fio.1
+++ b/fio.1
@@ -2835,6 +2835,12 @@ Use Write Zeroes commands for write operations
 .B verify
 Use Verify commands for write operations
 .RE
+.P
+Multiple modes with mix ratios can be specified using the format
+\fBmode/pct:mode/pct:...\fR.  Percentages must sum to 100.  If a percentage
+is omitted, the remaining percentage is split evenly among entries with no
+percentage specified.
+Example: \fBwrite/60:zeroes/30:uncor/10\fR or \fBwrite/50:zeroes/:uncor/\fR
 .RE
 .TP
 .BI (io_uring_cmd)verify_mode \fR=\fPstr
diff --git a/fio.h b/fio.h
index 8ef3523e..b05abf77 100644
--- a/fio.h
+++ b/fio.h
@@ -156,6 +156,7 @@ enum {
 	FIO_RAND_DEDUPE_WORKING_SET_IX,
 	FIO_RAND_FDP_OFF,
 	FIO_RAND_SPRANDOM_OFF,
+	FIO_RAND_WMODE_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
diff --git a/io_u.c b/io_u.c
index 8b90dd1b..c3327f16 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2232,9 +2232,16 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 				icd->error = ret;
 		}
 	} else if (io_u->error) {
+		if (!((io_u->flags & IO_U_F_ERRORED) &&
+				(io_u->flags & IO_U_F_VER_LIST))) {
 error:
-		icd->error = io_u->error;
-		io_u_log_error(td, io_u);
+			icd->error = io_u->error;
+			io_u_log_error(td, io_u);
+		} else {
+			dprint(FD_IO, "io_completed: errored io_u numberio="
+					"%"PRIu64" for verify (expected)\n",
+					io_u->numberio);
+		}
 	}
 	if (icd->error) {
 		enum error_type_bit eb = td_error_type(ddir, icd->error);
diff --git a/io_u.h b/io_u.h
index 68771eba..0f656ee0 100644
--- a/io_u.h
+++ b/io_u.h
@@ -24,6 +24,8 @@ enum {
 	IO_U_F_PATTERN_DONE	= 1 << 8,
 	IO_U_F_DEVICE_ERROR	= 1 << 9,
 	IO_U_F_VER_IN_DEV	= 1 << 10, /* Verify data in device */
+	IO_U_F_ZEROED		= 1 << 11, /* Zeroed data */
+	IO_U_F_ERRORED		= 1 << 12, /* Errored offset */
 };
 
 /*
diff --git a/iolog.c b/iolog.c
index dcf6083c..df862ea6 100644
--- a/iolog.c
+++ b/iolog.c
@@ -295,6 +295,11 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 
 	io_u->ipo = ipo;
 
+	if (io_u->flags & IO_U_F_ZEROED)
+		ipo->flags |= IP_F_ZEROED;
+	else if (io_u->flags & IO_U_F_ERRORED)
+		ipo->flags |= IP_F_ERRORED;
+
 	if (io_u_should_trim(td, io_u)) {
 		flist_add_tail(&ipo->trim_list, &td->trim_list);
 		td->trim_entries++;
diff --git a/iolog.h b/iolog.h
index b52ae87d..8730427c 100644
--- a/iolog.h
+++ b/iolog.h
@@ -244,6 +244,8 @@ enum {
 	IP_F_ONLIST	= 2,
 	IP_F_TRIMMED	= 4,
 	IP_F_IN_FLIGHT	= 8,
+	IP_F_ZEROED	= 16,
+	IP_F_ERRORED	= 32,
 };
 
 /*
diff --git a/t/nvmept_write_mode.py b/t/nvmept_write_mode.py
index 21a6ea1e..dd8cc045 100755
--- a/t/nvmept_write_mode.py
+++ b/t/nvmept_write_mode.py
@@ -46,7 +46,7 @@ class WriteModeTest(FioJobCmdTest):
             f"--filename={self.fio_opts['filename']}",
             f"--rw={self.fio_opts['rw']}",
             f"--output={self.filenames['output']}",
-            f"--output-format={self.fio_opts['output-format']}",
+            f"--output-format={self.fio_opts.get('output-format', 'normal')}",
         ]
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
@@ -54,7 +54,7 @@ class WriteModeTest(FioJobCmdTest):
                     'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
                     'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
                     'buffer_pattern', 'verify_pattern', 'verify', 'offset',
-                    'filesize', 'write_mode', ]:
+                    'filesize', 'write_mode', 'debug', ]:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
@@ -68,7 +68,7 @@ class WriteModeTest(FioJobCmdTest):
 
         if 'rw' not in self.fio_opts or \
                 not self.passed or \
-                'json' not in self.fio_opts['output-format']:
+                'json' not in self.fio_opts.get('output-format', ''):
             return
 
         job = self.json_data['jobs'][0]
@@ -90,7 +90,134 @@ class WriteModeTest(FioJobCmdTest):
             logging.error("Unhandled rw value %s", self.fio_opts['rw'])
             self.passed = False
 
-TEST_SIZE="16M"
+nvme_cmd_write = 1
+nvme_cmd_write_uncor = 4
+nvme_cmd_write_zeroes = 8
+nvme_cmd_verify = 12
+
+class WriteModeSplit(WriteModeTest):
+    """
+    Make sure that the expected fraction of write, write uncorrectable, write
+    zeroes, and verify commands are actually submitted.
+    """
+
+    def __init__(self, fio_path, success, testnum, artifact_root, fio_opts, basename=None):
+        super().__init__(fio_path, success, testnum, artifact_root, fio_opts, basename)
+        self.actual = None
+
+    def check_result(self):
+
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        split = {'write': 0, 'uncor': 0, 'verify': 0, 'zeroes': 0}
+        wm = self.fio_opts['write_mode']
+        for s in wm.split(':'):
+            sp = s.split('/')
+            split[sp[0]] = sp[1]
+
+        total = 0
+        blanks = 0
+        for v in split.values():
+            if v == '':
+                blanks += 1
+            else:
+                total += int(v)
+
+        if blanks:
+            fill = int((100 - total) / blanks)
+        for k in split.keys():
+            if split[k] == '':
+                split[k] = fill
+            else:
+                split[k] = int(split[k])
+
+        logging.debug(split)
+
+        self.actual = {'write': 0, 'uncor': 0, 'verify': 0, 'zeroes': 0}
+        with open(self.filenames['output'], 'r') as file:
+            for line in file:
+                if "op selected" in line:
+                    op = int(line.split(" op selected ")[1])
+                    if op == nvme_cmd_write:
+                        self.actual['write'] += 1
+                    elif op == nvme_cmd_write_uncor:
+                        self.actual['uncor'] += 1
+                    elif op == nvme_cmd_write_zeroes:
+                        self.actual['zeroes'] += 1
+                    elif op == nvme_cmd_verify:
+                        self.actual['verify'] += 1
+                    else:
+                        raise ValueError(f"Unknown opcode {op}")
+
+        logging.debug(self.actual)
+        total = sum(self.actual.values())
+        if total == 0:
+            self.passed = False
+            self.failure_reason += \
+                    "No write/uncor/zeroes/verify commands detected"
+            return
+
+        for key, value in self.actual.items():
+            expected = int(split[key] / 100 * total)
+            logging.debug("mode %s: expected %d, actual %d", key, expected, value)
+            if expected != 0:
+                if abs(value - expected) / expected > 0.1:
+                    self.passed = False
+                    self.failure_reason += \
+                        f"large discrepancy for write mode {key}: expected {expected}, actual {value};"
+            elif value != 0:
+                self.passed = False
+                self.failure_reason += \
+                    f"discrepancy for write mode {key}: expected {expected}, actual {value};"
+
+
+class WriteModeVerify(WriteModeSplit):
+    """
+    Make sure that offsets that are the target of write uncorrectable commands
+    and offsets that are the target of write zeroes commands are appropriately
+    verified.
+
+    This only checks that the number of write zeroes commands matches the
+    number of write zero verify debug messages and that the number of write
+    uncorrectable commands matches the number of uncorrectable verify debug
+    messages.
+
+    No checking is done to make sure that the offsets where write zeroes
+    (uncorrectables) were originally targeted are the offsets where write zero
+    (uncorrectable) verification is carried out.
+
+    No overlap checking is carried out, so write offsets cannot be repeated.
+
+    Jobs must be run with --debug=verify,io in order to detect errored IOs and
+    write zeroes verification.
+    """
+
+    def check_result(self):
+
+        super().check_result()
+        if not self.passed:
+            return
+
+        verify = {'uncor': 0, 'zeroes': 0}
+        with open(self.filenames['output'], 'r') as file:
+            for line in file:
+                if "errored io_u" in line:
+                    verify['uncor'] += 1
+                elif "verifying write zeroes" in line:
+                    verify['zeroes'] += 1
+
+        logging.debug("verify: %s", str(verify))
+        for cmd in ['zeroes', 'uncor']:
+            if verify[cmd] != self.actual[cmd]:
+                self.passed = False
+                self.failure_reason += \
+                    f"{cmd}: writes {self.actual[cmd]} and verifies {verify[cmd]} do not match; "
+
+
+TEST_SIZE = "16M"
 
 TEST_LIST = [
     {
@@ -223,6 +350,164 @@ TEST_LIST = [
         "test_class": WriteModeTest,
         "success": SUCCESS_NONZERO,
     },
+
+    #
+    # Mixed write_mode tests
+    #
+    # test_id 40-41: valid mixed modes, all percentages explicit
+    # test_id 50-53: valid mixed modes, blank percentages (evenly split)
+    # test_id 60-63: invalid mixed modes (parsing should fail)
+    #
+    {
+        # All percentages explicit, sum == 100
+        "test_id": 40,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/30:zeroes/20:uncor/50",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+    {
+        # All percentages explicit with verify; write/50 + zeroes/50
+        "test_id": 41,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/50:zeroes/50",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+
+    {
+        # Blank percentages: write/50 takes half, zeroes and uncor split the
+        # remainder evenly (25% each)
+        "test_id": 50,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/50:zeroes/:uncor/",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+    {
+        # All blanks: write, zeroes, uncor each get 33% (integer division)
+        "test_id": 51,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/:zeroes/:uncor/",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+    {
+        # Two entries, one blank: write/60 + zeroes blank gets remaining 40%
+        "test_id": 52,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/60:zeroes/",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+    {
+        # Three entries, one blank: write/30 + zeroes/40 + uncor blank gets
+        # remaining 30%
+        "test_id": 53,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/30:zeroes/40:uncor/",
+            "randrepeat": 0,
+            "debug": "io",
+            },
+        "test_class": WriteModeSplit,
+    },
+    {
+        # Invalid: percentages exceed 100
+        "test_id": 60,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/60:zeroes/60",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # Invalid: only one entry (needs at least 2)
+        "test_id": 61,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/100",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # Invalid: explicit percentages don't add up to 100, no blanks
+        "test_id": 62,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/30:zeroes/30",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # Invalid: unknown mode name
+        "test_id": 63,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/50:bogus/50",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+
+    #
+    # Make sure verify handles write zeroes and write uncorrectable opcodes
+    # correctly
+    #
+    {
+        # All percentages explicit, sum == 100
+        "test_id": 70,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/30:zeroes/20:uncor/50",
+            "verify": "crc32c",
+            "randrepeat": 0,
+            "debug": "io,verify",
+            },
+        "test_class": WriteModeVerify,
+    },
+    {
+        # All percentages explicit with verify; write/50 + zeroes/50
+        "test_id": 71,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write/50:zeroes/50",
+            "verify": "crc32c",
+            "randrepeat": 0,
+            "debug": "io,verify",
+            },
+        "test_class": WriteModeVerify,
+    },
 ]
 
 def parse_args():
@@ -268,11 +553,11 @@ def main():
         test['fio_opts']['filename'] = args.dut
 
     test_env = {
-              'fio_path': fio_path,
-              'fio_root': str(Path(__file__).absolute().parent.parent),
-              'artifact_root': artifact_root,
-              'basename': 'nvmept-write-mode',
-              }
+        'fio_path': fio_path,
+        'fio_root': str(Path(__file__).absolute().parent.parent),
+        'artifact_root': artifact_root,
+        'basename': 'nvmept-write-mode',
+        }
 
     _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
     sys.exit(failed)
diff --git a/verify.c b/verify.c
index 7237dc2c..d8312815 100644
--- a/verify.c
+++ b/verify.c
@@ -891,25 +891,30 @@ static int mem_is_zero_slow(const void *data, size_t length, size_t *offset)
 	return !length;
 }
 
-static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
+static int verify_zero(struct io_u *io_u)
 {
 	size_t offset;
 
-	if (!td->o.trim_zero)
-		return 0;
-
 	if (mem_is_zero(io_u->buf, io_u->buflen))
 		return 0;
 
 	mem_is_zero_slow(io_u->buf, io_u->buflen, &offset);
 
-	log_err("trim: verify failed at file %s offset %llu, length %llu"
+	log_err("verify failed for zeroed data at file %s offset %llu, length %llu"
 		", block offset %lu\n",
 			io_u->file->file_name, io_u->verify_offset, io_u->buflen,
 			(unsigned long) offset);
 	return EILSEQ;
 }
 
+static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
+{
+	if (!td->o.trim_zero)
+		return 0;
+
+	return verify_zero(io_u);
+}
+
 static int verify_header(struct io_u *io_u, struct thread_data *td,
 			 struct verify_header *hdr, unsigned int hdr_num,
 			 unsigned int hdr_len)
@@ -1011,6 +1016,10 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 	if (io_u->flags & IO_U_F_TRIMMED) {
 		ret = verify_trimmed_io_u(td, io_u);
 		goto done;
+	} else if (io_u->flags & IO_U_F_ZEROED) {
+		dprint(FD_VERIFY, "verifying write zeroes command\n");
+		ret = verify_zero(io_u);
+		goto done;
 	}
 
 	hdr_inc = get_hdr_inc(td, io_u);
@@ -1451,8 +1460,14 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		io_u->file = ipo->file;
 		io_u_set(td, io_u, IO_U_F_VER_LIST);
 
+		io_u_clear(td, io_u, IO_U_F_TRIMMED | IO_U_F_ZEROED | IO_U_F_ERRORED);
+
 		if (ipo->flags & IP_F_TRIMMED)
 			io_u_set(td, io_u, IO_U_F_TRIMMED);
+		else if (ipo->flags & IP_F_ZEROED)
+			io_u_set(td, io_u, IO_U_F_ZEROED);
+		else if (ipo->flags & IP_F_ERRORED)
+			io_u_set(td, io_u, IO_U_F_ERRORED);
 
 		if (!fio_file_open(io_u->file)) {
 			int r = td_io_open_file(td, io_u->file);
