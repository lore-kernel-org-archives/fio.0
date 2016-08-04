Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbcHDMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Aug 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bVHJj-0007we-Hb
	for fio@vger.kernel.org; Thu, 04 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160804120002.053682C00A2@kernel.dk>
Date: Thu,  4 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 550beaad94a11beef70dfb4057797ff8800c8a72:

  engines/rbd: fix compile without blkin support (2016-08-02 15:23:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ff56a4e2e0a87e4e3b1cc1e74547d55b295967a6:

  travis: don't enable rbd (2016-08-03 10:18:42 -0600)

----------------------------------------------------------------
Jan Fajerski (2):
      fix typo in HOWTO
      fix typo in HOWTO

Jens Axboe (4):
      iolog: prevent early entry from skewing entire logging run
      filesetup: ensure that we catch a file flagged for extend
      travis: add rbd/zlib
      travis: don't enable rbd

 .travis.yml | 2 +-
 HOWTO       | 4 ++--
 filesetup.c | 7 ++++---
 stat.c      | 4 +++-
 4 files changed, 10 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index 9bef750..bf0433d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -4,4 +4,4 @@ compiler:
   - gcc
 before_install:
   - sudo apt-get -qq update
-  - sudo apt-get install -y libaio-dev libnuma-dev
+  - sudo apt-get install -qq -y libaio-dev libnuma-dev libz-dev
diff --git a/HOWTO b/HOWTO
index 2c5896d..d18d59b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1175,7 +1175,7 @@ cpus_allowed_policy=str Set the policy of how fio distributes the CPUs
 		one cpu per job. If not enough CPUs are given for the jobs
 		listed, then fio will roundrobin the CPUs in the set.
 
-numa_cpu_nodes=str Set this job running on spcified NUMA nodes' CPUs. The
+numa_cpu_nodes=str Set this job running on specified NUMA nodes' CPUs. The
 		arguments allow comma delimited list of cpu numbers,
 		A-B ranges, or 'all'. Note, to enable numa options support,
 		fio must be built on a system with libnuma-dev(el) installed.
@@ -1606,7 +1606,7 @@ write_lat_log=str Same as write_bw_log, except that this option stores io
 		The actual log names will be foo_slat.x.log, foo_clat.x.log,
 		and foo_lat.x.log, where x is the index of the job (1..N,
 		where N is the number of jobs). This helps fio_generate_plot
-		fine the logs automatically. If 'per_job_logs' is false, then
+		find the logs automatically. If 'per_job_logs' is false, then
 		the filename will not include the job index. See 'Log File
 		Formats'.
 
diff --git a/filesetup.c b/filesetup.c
index 1ecdda6..f32d874 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -900,11 +900,12 @@ int setup_files(struct thread_data *td)
 		if (f->filetype == FIO_TYPE_FILE &&
 		    (f->io_size + f->file_offset) > f->real_file_size &&
 		    !(td->io_ops->flags & FIO_DISKLESSIO)) {
-			if (!o->create_on_open) {
-				need_extend++;
+			if (!o->create_on_open)
 				extend_size += (f->io_size + f->file_offset);
-			} else
+			else
 				f->real_file_size = f->io_size + f->file_offset;
+
+			need_extend++;
 			fio_file_set_extend(f);
 		}
 	}
diff --git a/stat.c b/stat.c
index 7a35117..d6787b7 100644
--- a/stat.c
+++ b/stat.c
@@ -2139,7 +2139,9 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * need to do.
 	 */
 	this_window = elapsed - iolog->avg_last;
-	if (this_window < iolog->avg_msec) {
+	if (elapsed < iolog->avg_last)
+		return iolog->avg_last - elapsed;
+	else if (this_window < iolog->avg_msec) {
 		int diff = iolog->avg_msec - this_window;
 
 		if (inline_log(iolog) || diff > LOG_MSEC_SLACK)
