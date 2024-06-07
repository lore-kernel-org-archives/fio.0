Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF6176036
	for <fio@vger.kernel.org>; Fri,  7 Jun 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761611; cv=none; b=KtgYDrA0YbpHsHgKy8KFVzythHXiZm84/x5mMPosItfZUKhDTjAyqtyfP+vmTyT9gD2g0eB22oDaqoZ80GCNCbB7BRs4O6yTPuPwG5SsP0LLQ3GTcGud8+GvqIZczSLSzqDNWwbizA1IGEQEfeFNOwBvmoXp/jN5qe1zxToHiMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761611; c=relaxed/simple;
	bh=QurLHGgTMR2yQC5rvoN5YvcyqBPJL4MzaSJYPqC76uE=;
	h=Subject:From:To:Message-Id:Date; b=b5DxfDQs8OZ/mak39+EwtEtzspqOk0oITBZQ5GrNtaV0Tf6XgKMo4U1zKxDJxCIhsiVjwzZpFel7rfc3/SbheutEZHdGxSyhYFEyk7z84C9TEpv4CJPafRld7A6ocwTEjCmHG7oEmPFYY9yLrrwmW4S8o3gSuLhYWDeeKbzq7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aU89fJMR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aU89fJMR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+/5CKCaGruXcnBYntyCpfZwHxU4lUoK6+NwbQNbRJIo=; b=aU89fJMRQwXwowV8+y9mX54C2Z
	bDVWwa+C2WQbrq0IAw5v9naTpQXiWujIVawJ808alamXGDGcJYAcHvbWJJamSambH9Vg6bXEN7niO
	OH+rsb2k91h5iZDQM2cP3kvP0etGEcpY6ZoCWsly/ZF3VDAmtNsw+np0+t0UDE0VSV/Nifyc4kgiF
	tSuolqoDJ7dmo7gn4HC0CjO+0QLV3i+mx6yMvPd4J8otpJ5/S0Nb1sO4ZF6jsibCVXnLsCu/Uaz9U
	xC/Vy6Af2P4mTUsnDNJJmPK9vqBzZpT+FFNEhnZ2n86Ru9mOuygAHuRRMCUZQ/uLwDA5jfJM1rfC3
	q3u3xWOA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFYGL-00000006EHL-0MFk
	for fio@vger.kernel.org;
	Fri, 07 Jun 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 135B21BC016C; Fri,  7 Jun 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240607120002.135B21BC016C@kernel.dk>
Date: Fri,  7 Jun 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6e039133f1fe30b1abf742423019836c4d1e8123:

  docs: fix operations misspellings (2024-06-04 08:53:07 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to eb7fe4550ff2a569d0d8c71de16a1ea1e1aaf0a5:

  Revert "smalloc: smalloc() already clears memory, scalloc() need not do it again" (2024-06-06 14:03:47 -0400)

----------------------------------------------------------------
Vincent Fu (5):
      options: support ranges for FDP plids option
      t/nvmept_fdp: add tests for plid ranges
      docs: update and clarify plids option
      dataplacement: increase max data placement IDs to 128
      Revert "smalloc: smalloc() already clears memory, scalloc() need not do it again"

 HOWTO.rst        |  17 +++--
 cconv.c          |   4 +-
 dataplacement.h  |   2 +-
 fio.1            |  17 +++--
 options.c        |  53 +++++++++++++---
 server.h         |   2 +-
 smalloc.c        |   8 ++-
 t/nvmept_fdp.py  | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 thread_options.h |   4 +-
 9 files changed, 266 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ec535911..9eeb203e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2538,12 +2538,17 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: plids=str, fdp_pli=str : [io_uring_cmd] [xnvme]
 
-        Select which Placement IDs (streams) or Placement ID Indices (FDP) this
-        job is allowed to use for writes. For FDP by default, the job will
-        cycle through all available Placement IDs, so use this to isolate these
-        identifiers to specific jobs. If you want fio to use FDP placement
-        identifiers only at indices 0, 2 and 5 specify ``plids=0,2,5``. For
-        streams this should be a comma-separated list of Stream IDs.
+        Select which Placement ID Indices (FDP) or Placement IDs (streams) this
+        job is allowed to use for writes. This option accepts a comma-separated
+        list of values or ranges (e.g., 1,2-4,5,6-8).
+
+        For FDP by default, the job will cycle through all available Placement
+        IDs, so use this option to be selective. The values specified here are
+        array indices for the list of placement IDs returned by the nvme-cli
+        command ``nvme fdp status``. If you want fio to use FDP placement
+        identifiers only at indices 0, 2 and 5, set ``plids=0,2,5``.
+
+        For streams this should be a list of Stream IDs.
 
 .. option:: dp_scheme=str : [io_uring_cmd] [xnvme]
 
diff --git a/cconv.c b/cconv.c
index 9b344940..1d494982 100644
--- a/cconv.c
+++ b/cconv.c
@@ -359,7 +359,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->dp_id_select = le32_to_cpu(top->dp_id_select);
 	o->dp_nr_ids = le32_to_cpu(top->dp_nr_ids);
 	for (i = 0; i < o->dp_nr_ids; i++)
-		o->dp_ids[i] = le32_to_cpu(top->dp_ids[i]);
+		o->dp_ids[i] = le16_to_cpu(top->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -659,7 +659,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->dp_id_select = cpu_to_le32(o->dp_id_select);
 	top->dp_nr_ids = cpu_to_le32(o->dp_nr_ids);
 	for (i = 0; i < o->dp_nr_ids; i++)
-		top->dp_ids[i] = cpu_to_le32(o->dp_ids[i]);
+		top->dp_ids[i] = cpu_to_le16(o->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/dataplacement.h b/dataplacement.h
index 71d19d69..3267a460 100644
--- a/dataplacement.h
+++ b/dataplacement.h
@@ -6,7 +6,7 @@
 #define STREAMS_DIR_DTYPE	1
 #define FDP_DIR_DTYPE		2
 #define FDP_MAX_RUHS		128
-#define FIO_MAX_DP_IDS 		16
+#define FIO_MAX_DP_IDS 		128
 #define DP_MAX_SCHEME_ENTRIES	32
 
 /*
diff --git a/fio.1 b/fio.1
index 1d1cdf85..15bafbf9 100644
--- a/fio.1
+++ b/fio.1
@@ -2305,12 +2305,17 @@ The available placement ID (indices) are defined by \fBplids\fR or
 .RE
 .TP
 .BI (io_uring_cmd,xnvme)plids=str, fdp_pli \fR=\fPstr
-Select which Placement IDs (streams) or Placement ID Indicies (FDP) this job is
-allowed to use for writes.  For FDP by default, the job will cycle through all
-available Placement IDs, so use this to isolate these identifiers to specific
-jobs. If you want fio to use placement identifier only at indices 0, 2 and 5
-specify, you would set `plids=0,2,5`. For streams this should be a
-comma-separated list of Stream IDs.
+Select which Placement ID Indices (FDP) or Placement IDs (streams) this job is
+allowed to use for writes. This option accepts a comma-separated list of values
+or ranges (e.g., 1,2-4,5,6-8).
+
+For FDP by default, the job will cycle through all available Placement IDs, so
+use this option to be selective. The values specified here are array indices
+for the list of placement IDs returned by the nvme-cli command `nvme fdp
+status'. If you want fio to use FDP placement identifiers only at indices 0, 2
+and 5, set `plids=0,2,5'.
+
+For streams this should be a list of Stream IDs.
 .TP
 .BI (io_uring_cmd,xnvme)\fR\fBdp_scheme\fP=str
 Defines which placement ID (index) to be selected based on offset(LBA) range.
diff --git a/options.c b/options.c
index 1dd60e8b..ab650bb7 100644
--- a/options.c
+++ b/options.c
@@ -263,28 +263,61 @@ static int fio_fdp_cmp(const void *p1, const void *p2)
 static int str_fdp_pli_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
-	char *str, *p, *v;
-	int i = 0;
+	char *str, *p, *id1;
+	int i = 0, ret = 0;
 
 	p = str = strdup(input);
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS) {
-		unsigned long long id = strtoull(v, NULL, 0);
-		if (id > 0xFFFF) {
-			log_err("Placement IDs cannot exceed 0xFFFF\n");
-			free(p);
-			return 1;
+	while ((id1 = strsep(&str, ",")) != NULL) {
+		char *str2, *id2;
+		unsigned int start, end;
+
+		if (!strlen(id1))
+			break;
+
+		str2 = id1;
+		end = -1;
+		while ((id2 = strsep(&str2, "-")) != NULL) {
+			if (!strlen(id2))
+				break;
+
+			end = strtoull(id2, NULL, 0);
+		}
+
+		start = strtoull(id1, NULL, 0);
+		if (end == -1)
+			end = start;
+		if (start > end) {
+			ret = 1;
+			break;
+		}
+
+		while (start <= end) {
+			if (i >= FIO_MAX_DP_IDS) {
+				log_err("fio: only %d IDs supported\n", FIO_MAX_DP_IDS);
+				ret = 1;
+				break;
+			}
+			if (start > 0xFFFF) {
+				log_err("Placement IDs cannot exceed 0xFFFF\n");
+				ret = 1;
+				break;
+			}
+			td->o.dp_ids[i++] = start++;
 		}
-		td->o.dp_ids[i++] = id;
+
+		if (ret)
+			break;
 	}
+
 	free(p);
 
 	qsort(td->o.dp_ids, i, sizeof(*td->o.dp_ids), fio_fdp_cmp);
 	td->o.dp_nr_ids = i;
 
-	return 0;
+	return ret;
 }
 
 /* str_dp_scheme_cb() is a callback function for parsing the fdp_scheme option
diff --git a/server.h b/server.h
index e8659f79..a8e4dbf2 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 105,
+	FIO_SERVER_VER			= 106,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/smalloc.c b/smalloc.c
index 23243054..134f3d77 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -566,7 +566,13 @@ void *smalloc(size_t size)
 
 void *scalloc(size_t nmemb, size_t size)
 {
-	return smalloc(nmemb * size);
+	void *ret;
+
+	ret = smalloc(nmemb * size);
+	if (ret)
+		memset(ret, 0, nmemb * size);
+
+	return ret;
 }
 
 char *smalloc_strdup(const char *str)
diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
index c50c14e4..1739e8fc 100755
--- a/t/nvmept_fdp.py
+++ b/t/nvmept_fdp.py
@@ -130,6 +130,7 @@ class FDPMultiplePLIDTest(FDPTest):
         mapping = {
                     'nruhsd': FIO_FDP_NUMBER_PLIDS,
                     'max_ruamw': FIO_FDP_MAX_RUAMW,
+                    'maxplid': FIO_FDP_NUMBER_PLIDS-1,
                     # parameters for 400, 401 tests
                     'hole_size': 64*1024,
                     'nios_for_scheme': FIO_FDP_NUMBER_PLIDS//2,
@@ -140,6 +141,10 @@ class FDPMultiplePLIDTest(FDPTest):
             self.fio_opts['bs'] = eval(self.fio_opts['bs'].format(**mapping))
         if 'rw' in self.fio_opts and isinstance(self.fio_opts['rw'], str):
             self.fio_opts['rw'] = self.fio_opts['rw'].format(**mapping)
+        if 'plids' in self.fio_opts and isinstance(self.fio_opts['plids'], str):
+            self.fio_opts['plids'] = self.fio_opts['plids'].format(**mapping)
+        if 'fdp_pli' in self.fio_opts and isinstance(self.fio_opts['fdp_pli'], str):
+            self.fio_opts['fdp_pli'] = self.fio_opts['fdp_pli'].format(**mapping)
 
         super().setup(parameters)
         
@@ -167,9 +172,17 @@ class FDPMultiplePLIDTest(FDPTest):
         elif 'plids' in self.fio_opts:
             plid_list = self.fio_opts['plids'].split(',')
         else:
-            plid_list = list(range(FIO_FDP_NUMBER_PLIDS))
+            plid_list = [str(i) for i in range(FIO_FDP_NUMBER_PLIDS)]
 
-        plid_list = sorted([int(i) for i in plid_list])
+        range_ids = []
+        for plid in plid_list:
+            if '-' in plid:
+                [start, end] = plid.split('-')
+                range_ids.extend(list(range(int(start), int(end)+1)))
+            else:
+                range_ids.append(int(plid))
+
+        plid_list = sorted(range_ids)
         logging.debug("plid_list: %s", str(plid_list))
 
         fdp_status = get_fdp_status(self.fio_opts['filename'])
@@ -707,6 +720,121 @@ TEST_LIST = [
             },
         "test_class": FDPMultiplePLIDTest,
     },
+    ### use 3-4 to specify plids
+    {
+        "test_id": 204,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1,3-4",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 205,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1,3-4",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ### use 1-3 to specify plids
+    {
+        "test_id": 206,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1-3",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 207,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1-3",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ### use multiple ranges to specify plids
+    {
+        "test_id": 208,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1-2,3-3",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 209,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1-2,3-3",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 210,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "0-{maxplid}",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 211,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "fdp_pli": "0-{maxplid}",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
     # Specify invalid options fdp=1 and dataplacement=none
     {
         "test_id": 300,
@@ -771,6 +899,64 @@ TEST_LIST = [
         "test_class": FDPTest,
         "success": SUCCESS_NONZERO,
     },
+    ## Specify invalid ranges with start > end
+    {
+        "test_id": 304,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "plids": "3-1",
+            "output-format": "normal",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 305,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "3-1",
+            "output-format": "normal",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    ## Specify too many plids
+    {
+        "test_id": 306,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "plids": "0-65535",
+            "output-format": "normal",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 307,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "0-65535",
+            "output-format": "normal",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
     # write to multiple PLIDs using scheme selection of PLIDs
     ## using old and new sets of options
     {
diff --git a/thread_options.h b/thread_options.h
index ccd0c064..20fc18a3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -394,7 +394,7 @@ struct thread_options {
 	unsigned int fdp;
 	unsigned int dp_type;
 	unsigned int dp_id_select;
-	unsigned int dp_ids[FIO_MAX_DP_IDS];
+	uint16_t dp_ids[FIO_MAX_DP_IDS];
 	unsigned int dp_nr_ids;
 	char *dp_scheme_file;
 
@@ -712,7 +712,7 @@ struct thread_options_pack {
 	uint32_t fdp;
 	uint32_t dp_type;
 	uint32_t dp_id_select;
-	uint32_t dp_ids[FIO_MAX_DP_IDS];
+	uint16_t dp_ids[FIO_MAX_DP_IDS];
 	uint32_t dp_nr_ids;
 	uint8_t dp_scheme_file[FIO_TOP_STR_MAX];
 
