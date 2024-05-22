Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE997E567
	for <fio@vger.kernel.org>; Wed, 22 May 2024 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716379343; cv=none; b=Tf1N6v565B/9a/p8nI/JyqT/g36U5l1zQwbEf5zV8RipTxFzy2k0/8M3CIgGJ2zZyWHc9PQxn+fh930p3+BE87l01aYwfh30Nt7JsHuyF52zdiDrbeR+cGTKQ1dFT1nsCrAGhuCqmiTngpRviVt1bluep0AK2KZOJoXGvbl0YvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716379343; c=relaxed/simple;
	bh=hB6m8j6BD5jdpUr6j492SzMgKx3bGV7G4s/jpSJaCQ4=;
	h=Subject:From:To:Message-Id:Date; b=h+8nbslMNyoEi+MqBFVjtR8YoU/EpHGE47ycUd4U/Ft2B298jKAlQIV/uk7OKzXpToB/pwCU0gCCLd37MM+qyjczemgdFlKL1tvgrmMp9F3IfnNmbmbIBD9t/CTeIBQMVpdzkjUmDtKRI8etmnchyEUilxGu531B0cn1IVm1Nxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XjGak1ok; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XjGak1ok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5w5TKU3nZBiZNmXn0rvJ1oGLdKiNUAg7iC+A0y50L9U=; b=XjGak1oka7OM4HZLsLJixl94KY
	AuaafLmR1FsZzHJ+RDkjUXAXcXG2+42Y3iSZAzfv1ZgA3r2XmPEyNIJaWVr2LH9vhe7mzQZBIx3uK
	q7kcGMEYpun2LwVpr2gVD484VEWLZAw2ryuA1duS3OFWbJBZUQHFKe2F8ARicRBjIvPnwbJGpKZGV
	n/ZTmtWza5A3ddkSbhhqI3EmKUtlwd5hs6kdraQnRY9skFBubKPzwQjVgnepXufBT35u1gNT/DsJX
	hW7mFP8IYJa+cWTwjmJDxwHzv33REe32XSbWS/a/x4nrNo8Wt+c9ykGdgDg59K+ixFhdEJZeLZ/hd
	ZFaMtLeg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9kdY-00000008jpM-2M2X
	for fio@vger.kernel.org;
	Wed, 22 May 2024 12:02:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9E13F1BC013F; Wed, 22 May 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240522120001.9E13F1BC013F@kernel.dk>
Date: Wed, 22 May 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3ed8eea0ee9b5d7de603e9b128e6c05941b99938:

  t/zbd: avoid test case 31 failure with small devices (2024-04-30 11:11:58 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d3bcdd30da4ad2d6f845e65d6a358c080e120b5e:

  Merge branch 'enable-dataplacement-scheme' of https://github.com/parkvibes/fio (2024-05-21 14:06:32 -0400)

----------------------------------------------------------------
Hyunwoo Park (2):
      fdp: support scheme placement id (index) selection
      t/nvmept_fdp: add tests(302,303,400,401) for fdp scheme

Vincent Fu (1):
      Merge branch 'enable-dataplacement-scheme' of https://github.com/parkvibes/fio

 HOWTO.rst        |  28 +++++++++++-
 cconv.c          |   2 +
 dataplacement.c  |  78 +++++++++++++++++++++++++++++++++
 dataplacement.h  |  14 +++++-
 file.h           |   1 +
 fio.1            |  32 +++++++++++++-
 options.c        |  52 ++++++++++++++++++++++
 server.h         |   2 +-
 t/nvmept_fdp.py  | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 thread_options.h |   2 +
 10 files changed, 329 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2f8ef6d4..3b262fae 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2529,8 +2529,12 @@ with the caveat that when used on the command line, they must come after the
 			Round robin over available placement IDs. This is the
 			default.
 
-	The available placement ID (indices) are defined by the option
-	:option:`plids`.
+		**scheme**
+			Choose a placement ID (index) based on the scheme file defined by
+			the option :option:`dp_scheme`.
+
+	The available placement ID (indices) are defined by the option :option:`fdp_pli`
+	or :option:`plids` except for the case of **scheme**.
 
 .. option:: plids=str, fdp_pli=str : [io_uring_cmd] [xnvme]
 
@@ -2541,6 +2545,26 @@ with the caveat that when used on the command line, they must come after the
         identifiers only at indices 0, 2 and 5 specify ``plids=0,2,5``. For
         streams this should be a comma-separated list of Stream IDs.
 
+.. option:: dp_scheme=str : [io_uring_cmd] [xnvme]
+
+	Defines which placement ID (index) to be selected based on offset(LBA) range.
+	The file should contains one or more scheme entries in the following format:
+
+		0, 10737418240, 0
+		10737418240, 21474836480, 1
+		21474836480, 32212254720, 2
+		...
+
+	Each line, a scheme entry, contains start offset, end offset, and placement ID
+	(index) separated by comma(,). If the write offset is within the range of a certain
+	scheme entry(start offset ≤ offset < end offset), the corresponding placement ID
+	(index) will be selected. If the write offset belongs to multiple scheme entries,
+	the first matched scheme entry will be applied. If the offset is not within any range
+	of scheme entry, dspec field will be set to 0, default RUH. (Caution: In case of
+	multiple devices in a job, all devices of the job will be affected by the scheme. If
+	this option is specified, the option :option:`plids` or :option:`fdp_pli` will be
+	ignored.)
+
 .. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
 	Size in bytes for separate metadata buffer per IO. Default: 0.
diff --git a/cconv.c b/cconv.c
index 16112248..9b344940 100644
--- a/cconv.c
+++ b/cconv.c
@@ -94,6 +94,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->ioscheduler, top->ioscheduler);
 	string_to_cpu(&o->profile, top->profile);
 	string_to_cpu(&o->cgroup, top->cgroup);
+	string_to_cpu(&o->dp_scheme_file, top->dp_scheme_file);
 
 	o->allow_create = le32_to_cpu(top->allow_create);
 	o->allow_mounted_write = le32_to_cpu(top->allow_mounted_write);
@@ -398,6 +399,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->ioscheduler, o->ioscheduler);
 	string_to_net(top->profile, o->profile);
 	string_to_net(top->cgroup, o->cgroup);
+	string_to_net(top->dp_scheme_file, o->dp_scheme_file);
 
 	top->allow_create = cpu_to_le32(o->allow_create);
 	top->allow_mounted_write = cpu_to_le32(o->allow_mounted_write);
diff --git a/dataplacement.c b/dataplacement.c
index 1d5b21ed..8a4c8e64 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -100,6 +100,56 @@ out:
 	return ret;
 }
 
+static int init_ruh_scheme(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_ruhs_scheme *ruh_scheme;
+	FILE *scheme_fp;
+	unsigned long long start, end;
+	uint16_t pli;
+	int ret = 0;
+
+	if (td->o.dp_id_select != FIO_DP_SCHEME)
+		return 0;
+
+	/* Get the scheme from the file */
+	scheme_fp = fopen(td->o.dp_scheme_file, "r");
+
+	if (!scheme_fp) {
+		log_err("fio: ruh scheme failed to open scheme file %s\n",
+			 td->o.dp_scheme_file);
+		ret = -errno;
+		goto out;
+	}
+
+	ruh_scheme = scalloc(1, sizeof(*ruh_scheme));
+	if (!ruh_scheme) {
+		ret = -ENOMEM;
+		goto out_with_close_fp;
+	}
+
+	for (int i = 0;
+		i < DP_MAX_SCHEME_ENTRIES && fscanf(scheme_fp, "%llu,%llu,%hu\n", &start, &end, &pli) == 3;
+		i++) {
+
+		ruh_scheme->scheme_entries[i].start_offset = start;
+		ruh_scheme->scheme_entries[i].end_offset = end;
+		ruh_scheme->scheme_entries[i].pli = pli;
+		ruh_scheme->nr_schemes++;
+	}
+
+	if (fscanf(scheme_fp, "%llu,%llu,%hu\n", &start, &end, &pli) == 3)
+		log_info("fio: too many scheme entries in %s. Only the first %d scheme entries are applied\n",
+			 td->o.dp_scheme_file,
+			 DP_MAX_SCHEME_ENTRIES);
+
+	f->ruhs_scheme = ruh_scheme;
+
+out_with_close_fp:
+	fclose(scheme_fp);
+out:
+	return ret;
+}
+
 int dp_init(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -109,6 +159,10 @@ int dp_init(struct thread_data *td)
 		ret = init_ruh_info(td, f);
 		if (ret)
 			break;
+
+		ret = init_ruh_scheme(td, f);
+		if (ret)
+			break;
 	}
 	return ret;
 }
@@ -119,6 +173,11 @@ void fdp_free_ruhs_info(struct fio_file *f)
 		return;
 	sfree(f->ruhs_info);
 	f->ruhs_info = NULL;
+
+	if (!f->ruhs_scheme)
+		return;
+	sfree(f->ruhs_scheme);
+	f->ruhs_scheme = NULL;
 }
 
 void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
@@ -138,6 +197,25 @@ void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 			ruhs->pli_loc = 0;
 
 		dspec = ruhs->plis[ruhs->pli_loc++];
+	} else if (td->o.dp_id_select == FIO_DP_SCHEME) {
+		struct fio_ruhs_scheme *ruhs_scheme = f->ruhs_scheme;
+		unsigned long long offset = io_u->offset;
+		int i;
+
+		for (i = 0; i < ruhs_scheme->nr_schemes; i++) {
+			if (offset >= ruhs_scheme->scheme_entries[i].start_offset &&
+			    offset < ruhs_scheme->scheme_entries[i].end_offset) {
+				dspec = ruhs_scheme->scheme_entries[i].pli;
+				break;
+			}
+		}
+
+		/*
+		 * If the write offset is not affected by any scheme entry,
+		 * 0(default RUH) will be assigned to dspec
+		 */
+		if (i == ruhs_scheme->nr_schemes)
+			dspec = 0;
 	} else {
 		ruhs->pli_loc = rand_between(&td->fdp_state, 0, ruhs->nr_ruhs - 1);
 		dspec = ruhs->plis[ruhs->pli_loc];
diff --git a/dataplacement.h b/dataplacement.h
index b5718c86..71d19d69 100644
--- a/dataplacement.h
+++ b/dataplacement.h
@@ -7,6 +7,7 @@
 #define FDP_DIR_DTYPE		2
 #define FDP_MAX_RUHS		128
 #define FIO_MAX_DP_IDS 		16
+#define DP_MAX_SCHEME_ENTRIES	32
 
 /*
  * How fio chooses what placement identifier to use next. Choice of
@@ -15,9 +16,9 @@
 enum {
 	FIO_DP_RANDOM	= 0x1,
 	FIO_DP_RR	= 0x2,
+	FIO_DP_SCHEME	= 0x3,
 };
 
-
 enum {
 	FIO_DP_NONE	= 0x0,
 	FIO_DP_FDP	= 0x1,
@@ -30,6 +31,17 @@ struct fio_ruhs_info {
 	uint16_t plis[];
 };
 
+struct fio_ruhs_scheme_entry {
+	unsigned long long start_offset;
+	unsigned long long end_offset;
+	uint16_t pli;
+};
+
+struct fio_ruhs_scheme {
+	uint16_t nr_schemes;
+	struct fio_ruhs_scheme_entry scheme_entries[DP_MAX_SCHEME_ENTRIES];
+};
+
 int dp_init(struct thread_data *td);
 void fdp_free_ruhs_info(struct fio_file *f);
 void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
diff --git a/file.h b/file.h
index deb36e02..e38ed2f1 100644
--- a/file.h
+++ b/file.h
@@ -103,6 +103,7 @@ struct fio_file {
 	uint64_t io_size;
 
 	struct fio_ruhs_info *ruhs_info;
+	struct fio_ruhs_scheme *ruhs_scheme;
 
 	/*
 	 * Zoned block device information. See also zonemode=zbd.
diff --git a/fio.1 b/fio.1
index ee812494..1c8e3a56 100644
--- a/fio.1
+++ b/fio.1
@@ -2294,9 +2294,14 @@ Choose a placement ID at random (uniform).
 .TP
 .B roundrobin
 Round robin over available placement IDs. This is the default.
+.TP
+.B scheme
+Choose a placement ID (index) based on the scheme file defined by
+the option \fBdp_scheme\fP.
 .RE
 .P
-The available placement ID (indices) are defined by the \fBplids\fR option.
+The available placement ID (indices) are defined by \fBplids\fR or
+\fBfdp_pli\fR option except for the case of \fBscheme\fP.
 .RE
 .TP
 .BI (io_uring_cmd,xnvme)plids=str, fdp_pli \fR=\fPstr
@@ -2307,6 +2312,31 @@ jobs. If you want fio to use placement identifier only at indices 0, 2 and 5
 specify, you would set `plids=0,2,5`. For streams this should be a
 comma-separated list of Stream IDs.
 .TP
+.BI (io_uring_cmd,xnvme)\fR\fBdp_scheme\fP=str
+Defines which placement ID (index) to be selected based on offset(LBA) range.
+The file should contains one or more scheme entries in the following format:
+.sp
+.RS
+.RS
+0, 10737418240, 0
+.br
+10737418240, 21474836480, 1
+.br
+21474836480, 32212254720, 2
+.br
+\&...
+.RE
+.sp
+Each line, a scheme entry, contains start offset, end offset, and placement ID
+(index) separated by comma(,). If the write offset is within the range of a certain
+scheme entry(start offset ≤ offset < end offset), the corresponding placement ID
+(index) will be selected. If the write offset belongs to multiple scheme entries,
+the first matched scheme entry will be applied. If the offset is not within any range
+of scheme entry, dspec field will be set to 0, default RUH. (Caution: In case of
+multiple devices in a job, all devices of the job will be affected by the scheme. If
+this option is specified, the option \fBplids\fP or \fBfdp_pli\fP will be ignored.)
+.RE
+.TP
 .BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
 .TP
diff --git a/options.c b/options.c
index 61ea41cc..f5d221c7 100644
--- a/options.c
+++ b/options.c
@@ -287,6 +287,43 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	return 0;
 }
 
+/* str_dp_scheme_cb() is a callback function for parsing the fdp_scheme option
+	This function validates the fdp_scheme filename. */
+static int str_dp_scheme_cb(void *data, const char *input)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	struct stat sb;
+	char *filename;
+	int ret = 0;
+
+	if (parse_dryrun())
+		return 0;
+
+	filename = strdup(td->o.dp_scheme_file);
+	strip_blank_front(&filename);
+	strip_blank_end(filename);
+
+	strcpy(td->o.dp_scheme_file, filename);
+
+	if (lstat(filename, &sb) < 0){
+		ret = errno;
+		log_err("fio: lstat() error related to %s\n", filename);
+		td_verror(td, ret, "lstat");
+		goto out;
+	}
+
+	if (!S_ISREG(sb.st_mode)) {
+		ret = errno;
+		log_err("fio: %s is not a file\n", filename);
+		td_verror(td, ret, "S_ISREG");
+		goto out;
+	}
+
+out:
+	free(filename);
+	return ret;
+}
+
 static int str_bssplit_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -3760,6 +3797,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_DP_RR,
 			    .help = "Round robin select Placement IDs",
 			  },
+			  { .ival = "scheme",
+			    .oval = FIO_DP_SCHEME,
+			    .help = "Use a scheme(based on LBA) to select Placement IDs",
+			  },
 		},
 	},
 	{
@@ -3774,6 +3815,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "dp_scheme",
+		.lname	= "Data Placement Scheme",
+		.type	= FIO_OPT_STR_STORE,
+		.cb	= str_dp_scheme_cb,
+		.off1	= offsetof(struct thread_options, dp_scheme_file),
+		.maxlen	= PATH_MAX,
+		.help	= "scheme file that specifies offset-RUH mapping",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "lockmem",
 		.lname	= "Lock memory",
diff --git a/server.h b/server.h
index 83ce449b..e8659f79 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 104,
+	FIO_SERVER_VER			= 105,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
index 031b439c..d6a543f2 100755
--- a/t/nvmept_fdp.py
+++ b/t/nvmept_fdp.py
@@ -56,6 +56,7 @@ class FDPTest(FioJobCmdTest):
             f"--output={self.filenames['output']}",
             f"--output-format={self.fio_opts['output-format']}",
         ]
+
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
                     'time_based', 'runtime', 'verify', 'io_size', 'num_range',
@@ -63,7 +64,7 @@ class FDPTest(FioJobCmdTest):
                     'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
                     'buffer_pattern', 'verify_pattern', 'offset', 'fdp',
                     'fdp_pli', 'fdp_pli_select', 'dataplacement', 'plid_select',
-                    'plids', 'number_ios']:
+                    'plids', 'dp_scheme', 'number_ios']:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
@@ -91,19 +92,20 @@ class FDPTest(FioJobCmdTest):
             return
 
         job = self.json_data['jobs'][0]
+        rw_fio_opts = self.fio_opts['rw'].split(':')[0]
 
-        if self.fio_opts['rw'] in ['read', 'randread']:
+        if rw_fio_opts in ['read', 'randread']:
             self.passed = self.check_all_ddirs(['read'], job)
-        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+        elif rw_fio_opts in ['write', 'randwrite']:
             if 'verify' not in self.fio_opts:
                 self.passed = self.check_all_ddirs(['write'], job)
             else:
                 self.passed = self.check_all_ddirs(['read', 'write'], job)
-        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+        elif rw_fio_opts in ['trim', 'randtrim']:
             self.passed = self.check_all_ddirs(['trim'], job)
-        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+        elif rw_fio_opts in ['readwrite', 'randrw']:
             self.passed = self.check_all_ddirs(['read', 'write'], job)
-        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+        elif rw_fio_opts in ['trimwrite', 'randtrimwrite']:
             self.passed = self.check_all_ddirs(['trim', 'write'], job)
         else:
             logging.error("Unhandled rw value %s", self.fio_opts['rw'])
@@ -128,12 +130,25 @@ class FDPMultiplePLIDTest(FDPTest):
         mapping = {
                     'nruhsd': FIO_FDP_NUMBER_PLIDS,
                     'max_ruamw': FIO_FDP_MAX_RUAMW,
+                    # parameters for 400, 401 tests
+                    'hole_size': 64*1024,
+                    'nios_for_scheme': FIO_FDP_NUMBER_PLIDS//2,
                 }
         if 'number_ios' in self.fio_opts and isinstance(self.fio_opts['number_ios'], str):
             self.fio_opts['number_ios'] = eval(self.fio_opts['number_ios'].format(**mapping))
+        if 'bs' in self.fio_opts and isinstance(self.fio_opts['bs'], str):
+            self.fio_opts['bs'] = eval(self.fio_opts['bs'].format(**mapping))
+        if 'rw' in self.fio_opts and isinstance(self.fio_opts['rw'], str):
+            self.fio_opts['rw'] = self.fio_opts['rw'].format(**mapping)
 
         super().setup(parameters)
-
+        
+        if 'dp_scheme' in self.fio_opts:
+            scheme_path = os.path.join(self.paths['test_dir'], self.fio_opts['dp_scheme'])
+            with open(scheme_path, mode='w') as f:
+                for i in range(mapping['nios_for_scheme']):
+                    f.write(f'{mapping["hole_size"] * 2 * i}, {mapping["hole_size"] * 2 * (i+1)}, {i}\n')
+ 
     def _check_result(self):
         if 'fdp_pli' in self.fio_opts:
             plid_list = self.fio_opts['fdp_pli'].split(',')
@@ -157,10 +172,12 @@ class FDPMultiplePLIDTest(FDPTest):
             self._check_robin(plid_list, fdp_status)
         elif select == "random":
             self._check_random(plid_list, fdp_status)
+        elif select == "scheme":
+            self._check_scheme(plid_list, fdp_status)
         else:
             logging.error("Unknown plid selection strategy %s", select)
             self.passed = False
-
+        
         super()._check_result()
 
     def _check_robin(self, plid_list, fdp_status):
@@ -220,6 +237,42 @@ class FDPMultiplePLIDTest(FDPTest):
                 logging.debug("Observed expected ruamw %d for idx %d, pid %d", ruhs['ruamw'], idx,
                               ruhs['pid'])
 
+    def _check_scheme(self, plid_list, fdp_status):
+        """
+        With scheme selection, a set of PLIDs touched by the scheme
+        """
+
+        PLID_IDX_POS = 2
+        plid_list_from_scheme = set()
+
+        scheme_path = os.path.join(self.paths['test_dir'], self.fio_opts['dp_scheme'])
+
+        with open(scheme_path) as f:
+            lines = f.readlines()
+            for line in lines:
+                line_elem = line.strip().replace(' ', '').split(',')
+                plid_list_from_scheme.add(int(line_elem[PLID_IDX_POS]))
+
+        logging.debug(f'plid_list_from_scheme: {plid_list_from_scheme}')
+
+        for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if ruhs['pid'] in plid_list_from_scheme:
+                if ruhs['ruamw'] == FIO_FDP_MAX_RUAMW:
+                    logging.error("pid %d should be touched by the scheme. But ruamw of it(%d) equals to %d",
+                                    ruhs['pid'], ruhs['ruamw'], FIO_FDP_MAX_RUAMW)
+                    self.passed = False
+                else:
+                    logging.debug("pid %d should be touched by the scheme. ruamw of it(%d) is under %d",
+                                    ruhs['pid'], ruhs['ruamw'], FIO_FDP_MAX_RUAMW)
+            else:
+                if ruhs['ruamw'] == FIO_FDP_MAX_RUAMW:
+                    logging.debug("pid %d should not be touched by the scheme. ruamw of it(%d) equals to %d",
+                                    ruhs['pid'], ruhs['ruamw'], FIO_FDP_MAX_RUAMW)
+                else:
+                    logging.error("pid %d should not be touched by the scheme. But ruamw of it(%d) is under %d",
+                                    ruhs['pid'], ruhs['ruamw'], FIO_FDP_MAX_RUAMW)
+                    self.passed = False
+
 
 class FDPSinglePLIDTest(FDPTest):
     """
@@ -674,6 +727,68 @@ TEST_LIST = [
         "test_class": FDPTest,
         "success": SUCCESS_NONZERO,
     },
+    # Specify invalid options related to dataplacement scheme
+    ## using old and new sets of options
+    {
+        "test_id": 302,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "fdp_pli_select": "scheme",
+            "output-format": "normal",
+        },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 303,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "plid_select": "scheme",
+            "output-format": "normal",
+        },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    # write to multiple PLIDs using scheme selection of PLIDs
+    ## using old and new sets of options
+    {
+        "test_id": 400,
+        "fio_opts": {
+            "rw": "write:{hole_size}",
+            "bs": "{hole_size}",
+            "number_ios": "{nios_for_scheme}",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli_select": "scheme",
+            "dp_scheme": "lba.scheme",            
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 401,
+        "fio_opts": {
+            "rw": "write:{hole_size}",
+            "bs": "{hole_size}",
+            "number_ios": "{nios_for_scheme}",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plid_select": "scheme",
+            "dp_scheme": "lba.scheme",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
 ]
 
 def parse_args():
diff --git a/thread_options.h b/thread_options.h
index a36b7909..ccd0c064 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -396,6 +396,7 @@ struct thread_options {
 	unsigned int dp_id_select;
 	unsigned int dp_ids[FIO_MAX_DP_IDS];
 	unsigned int dp_nr_ids;
+	char *dp_scheme_file;
 
 	unsigned int log_entries;
 	unsigned int log_prio;
@@ -713,6 +714,7 @@ struct thread_options_pack {
 	uint32_t dp_id_select;
 	uint32_t dp_ids[FIO_MAX_DP_IDS];
 	uint32_t dp_nr_ids;
+	uint8_t dp_scheme_file[FIO_TOP_STR_MAX];
 
 	uint32_t num_range;
 	/*
