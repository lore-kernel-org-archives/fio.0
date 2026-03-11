Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D263DE445
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773230411; cv=none; b=UBc1MvmV06xn7F4hkSjrIKoV8bxT8C29d0ZuRX2qi/W1jcEEPXJPccc8U6wxa4MSik4lRHlvsHrh7FnwelXGpWUGes7N3inlWUv+xbIhEFobpYnU3ETFPXzM/01IBxwBlfUx1fPFN4Eqx+ylMbyiMKeuGkHuAgppF0qewMFgDEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773230411; c=relaxed/simple;
	bh=hYcGykziWYrb/Ospz+52OL6m2h0znY/yyQFtAco5lRQ=;
	h=Subject:From:To:Date:Message-Id; b=kp8cG01NDmPOfSu8mVzm/BBVq9YWvPCiiCaqrW/qANMm0ac/1FoHQLxRY0E+NjaIdNNzo+KrltAYu08n6bQO5bRx2kV9IounFgsG0o81pdE7Xuj6mAqWZXOxwVfLd1XEHhXiIei0PJFYynk4rKLnt54CsWiLrSO/3LDSjxhTFdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bQZeHxTF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bQZeHxTF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=jiXxYQy/uFMldMDFXXv+Z9IvaAtRoPqTv6vdWZjZE/I=; b=bQZeHxTFfabaiWPioSAk4botFw
	N4QA2xuj3GuPTWRdJ30IIaZCLk2GgohvPVj5ZDmkZusENUKr5/HYM2Jgrnzb8F4bJ7ER0FAaK4VSN
	tHrTH+yK9pg059Ld7+BaYSWDKpbBok5UNwts1dsd+h4wUiuYWQ/S+PYYNeAVCazFaaceecXgy73+p
	Ge5ilhVqbgK3u01NPcIzvoHBsRnRcc9axM8IZsDRqNDr22tgD6PZJQlLUulvLoRV20/khg4zdg+Wc
	U4TWa2QlVlzj9zw6o9NG/Axg8clJ9lLR2Q2KK3kXRBUgribJtXdVWjSvaPflx7ld5IZLp5tsl8/qT
	aNk0uzKw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0IEO-0000000Gr8t-3SQH
	for fio@vger.kernel.org;
	Wed, 11 Mar 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id EF1B21BC017F; Wed, 11 Mar 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 11 Mar 2026 06:00:01 -0600
Message-Id: <20260311120001.EF1B21BC017F@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fa23c09bfefb2b9c960d179ad67d356fbc29179f:

  Merge branch 'push-lnvrzuqpnylp' of https://github.com/msuozzo/fio (2026-03-09 20:02:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a0e8ddf28ad32785ea3130ce0ee42524d835d60:

  backend: correctly handle rate_iops combined with bssplit (2026-03-11 05:37:00 -0600)

----------------------------------------------------------------
Dmitry Fomichev (1):
      backend: correctly handle rate_iops combined with bssplit

Vincent Fu (3):
      fio: specify filename for --bandwidth-log option
      ci: switch to actions/checkout@v6
      ci: switch to upload-artifact@v6

 .github/workflows/ci.yml     |  6 +++---
 .github/workflows/cifuzz.yml |  2 +-
 .github/workflows/qemu.yml   |  2 +-
 HOWTO.rst                    |  7 +++++--
 backend.c                    | 35 +++++++++++++++++++++++++++++------
 fio.1                        |  5 ++++-
 init.c                       |  7 ++++++-
 7 files changed, 49 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index a162ad18..2210f971 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -33,7 +33,7 @@ jobs:
 
     steps:
     - name: Checkout repo
-      uses: actions/checkout@v4
+      uses: actions/checkout@v6
     - name: Install dependencies
       run:  ./ci/actions-install.sh
     - name: Build
@@ -102,7 +102,7 @@ jobs:
       if: ${{ contains( matrix.build, 'windows' ) }}
       run: git config --global core.autocrlf input
     - name: Checkout repo
-      uses: actions/checkout@v4
+      uses: actions/checkout@v6
     - name: Install Cygwin toolchain (Windows)
       if: ${{ startsWith(matrix.build, 'windows-cygwin') }}
       uses: cygwin/cygwin-install-action@master
@@ -151,7 +151,7 @@ jobs:
 
     - name: Upload installer as artifact (Windows)
       if: ${{ contains( matrix.build, 'windows' ) }}
-      uses: actions/upload-artifact@v4
+      uses: actions/upload-artifact@v6
       with:
         name: ${{ matrix.build }}-installer
         path: os\windows\*.msi
diff --git a/.github/workflows/cifuzz.yml b/.github/workflows/cifuzz.yml
index d12388f1..121109a8 100644
--- a/.github/workflows/cifuzz.yml
+++ b/.github/workflows/cifuzz.yml
@@ -17,7 +17,7 @@ jobs:
         fuzz-seconds: 600
         dry-run: false
     - name: Upload Crash
-      uses: actions/upload-artifact@v4
+      uses: actions/upload-artifact@v6
       if: failure() && steps.build.outcome == 'success'
       with:
         name: artifacts
diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index 16787018..8160d43e 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -67,7 +67,7 @@ jobs:
 
     steps:
     - name: Check out repository
-      uses: actions/checkout@v4
+      uses: actions/checkout@v6
 
     - name: Create tarball containing repository
       run: |
diff --git a/HOWTO.rst b/HOWTO.rst
index e712ee2e..5e3266df 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -121,9 +121,12 @@ Command line options
 	format.  `json+` is like `json`, except it adds a full dump of the latency
 	buckets.
 
-.. option:: --bandwidth-log
+.. option:: --bandwidth-log=filename
 
-	Generate aggregate bandwidth logs.
+        Generate aggregate bandwidth logs. `filename` is an optional argument.
+        If not given, Fio will by default create files called
+        "agg-{read,write,trim}_bw.log". If the filename argument is given, Fio
+        will create files called "{filename}-{read,write,trim}_bw.log".
 
 .. option:: --minimal
 
diff --git a/backend.c b/backend.c
index 6dd078c4..8ce85818 100644
--- a/backend.c
+++ b/backend.c
@@ -79,6 +79,8 @@ pthread_mutex_t overlap_check = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
 pthread_mutex_t overlap_check = PTHREAD_MUTEX_INITIALIZER;
 #endif
 
+extern char *write_bw_log_name;
+
 #define JOB_START_TIMEOUT	(5 * 1000)
 
 static void sig_int(int sig)
@@ -842,15 +844,31 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 		}
 		td->last_usec[ddir] += val;
 		return td->last_usec[ddir];
-	} else if (bps) {
+	}
+
+	if (!bps)
+		return 0;
+
+	/*
+	 * For rate_iops option combined with bssplit, recover
+	 * the user provided IOPS value and calculate the I/O delay
+	 * based on this value, not on bps.
+	 */
+	if (!td->o.rate[ddir] && td->o.bssplit_nr[ddir]) {
+		uint64_t iops = bps / td->o.min_bs[ddir];
+
+		if (!iops)
+			return 0;
+
+		td->last_usec[ddir] += (int64_t)(1000000 / iops);
+		return td->last_usec[ddir];
+	} else {
 		uint64_t bytes = td->rate_io_issue_bytes[ddir];
 		uint64_t secs = bytes / bps;
 		uint64_t remainder = bytes % bps;
 
 		return remainder * 1000000 / bps + secs * 1000000;
 	}
-
-	return 0;
 }
 
 static void init_thinktime(struct thread_data *td)
@@ -2773,13 +2791,18 @@ int fio_backend(struct sk_out *sk_out)
 		return 0;
 
 	if (write_bw_log) {
+		char read[PATH_MAX], write[PATH_MAX], trim[PATH_MAX];
 		struct log_params p = {
 			.log_type = IO_LOG_TYPE_BW,
 		};
 
-		setup_log(&agg_io_log[DDIR_READ], &p, "agg-read_bw.log");
-		setup_log(&agg_io_log[DDIR_WRITE], &p, "agg-write_bw.log");
-		setup_log(&agg_io_log[DDIR_TRIM], &p, "agg-trim_bw.log");
+		snprintf(read, sizeof(read), "%s-read_bw.log", write_bw_log_name);
+		snprintf(write, sizeof(write), "%s-write_bw.log", write_bw_log_name);
+		snprintf(trim, sizeof(trim), "%s-trim_bw.log", write_bw_log_name);
+
+		setup_log(&agg_io_log[DDIR_READ], &p, read);
+		setup_log(&agg_io_log[DDIR_WRITE], &p, write);
+		setup_log(&agg_io_log[DDIR_TRIM], &p, trim);
 	}
 
 	if (init_global_dedupe_working_set_seeds()) {
diff --git a/fio.1 b/fio.1
index 4c37848b..664d7e3b 100644
--- a/fio.1
+++ b/fio.1
@@ -33,7 +33,10 @@ is a CSV based format. `json+' is like `json', except it adds a full
 dump of the latency buckets.
 .TP
 .BI \-\-bandwidth\-log
-Generate aggregate bandwidth logs.
+Generate aggregate bandwidth logs. `filename` is an optional argument.
+If not given, Fio will by default create files called
+"agg-{read,write,trim}_bw.log". If the filename argument is given, Fio
+will create files called "{filename}-{read,write,trim}_bw.log".
 .TP
 .BI \-\-minimal
 Print statistics in a terse, semicolon\-delimited format.
diff --git a/init.c b/init.c
index 623c14e6..cce79e84 100644
--- a/init.c
+++ b/init.c
@@ -70,6 +70,7 @@ int nr_clients = 0;
 bool log_syslog = false;
 
 bool write_bw_log = false;
+const char *write_bw_log_name;
 bool read_only = false;
 int status_interval = 0;
 
@@ -109,7 +110,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "bandwidth-log",
-		.has_arg	= no_argument,
+		.has_arg	= optional_argument,
 		.val		= 'b' | FIO_CLIENT_FLAG,
 	},
 	{
@@ -2737,6 +2738,10 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 'b':
 			write_bw_log = true;
+			if (optarg)
+				write_bw_log_name = optarg;
+			else
+				write_bw_log_name = "agg";
 			break;
 		case 'o': {
 			FILE *tmp;
