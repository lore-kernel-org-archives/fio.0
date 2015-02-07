Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:51807 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbbBGNA2 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 7 Feb 2015 08:00:28 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YK4zU-0007F6-71
	for fio@vger.kernel.org; Sat, 07 Feb 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150207130003.1595A40184@lyth.info>
Date: Sat,  7 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e507fa596c6923acc0160de85e7591c91df708e6:

  Update the moral license (2015-01-30 09:38:20 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e28dd2cfa734e26163532d24f1e06708cad659a6:

  Fix for verify_only (do_dry_run()) broken by 74d6277f (2015-02-06 09:11:11 -0700)

----------------------------------------------------------------
Castor Fu (1):
      configure: fix libnuma_v2 probe to work with -Werror

Jens Axboe (1):
      Moral license update

Justin Eno (1):
      Fix for verify_only (do_dry_run()) broken by 74d6277f

 MORAL-LICENSE |    6 +++---
 backend.c     |   27 ++++++++++++++++++++++++---
 configure     |    2 +-
 3 files changed, 28 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/MORAL-LICENSE b/MORAL-LICENSE
index d7c0b1b..8ef3f26 100644
--- a/MORAL-LICENSE
+++ b/MORAL-LICENSE
@@ -1,8 +1,8 @@
 As specified by the COPYING file, fio is free software published under version
-2 of the GPL license. That covers the copying part of the license. By using fio,
-you are also promising to uphold the following moral obligations:
+2 of the GPL license. That covers the copying part of the license. When using
+fio, you are encouraged to uphold the following moral obligations:
 
-- If you publish results that are done using fio, it must be clearly stated
+- If you publish results that are done using fio, it should be clearly stated
   that fio was used. The specific version should also be listed.
 
 - If you develop features or bug fixes for fio, they should be sent upstream
diff --git a/backend.c b/backend.c
index 9012140..7ec8d2a 100644
--- a/backend.c
+++ b/backend.c
@@ -662,7 +662,7 @@ static unsigned int exceeds_number_ios(struct thread_data *td)
 	return number_ios >= td->o.number_ios;
 }
 
-static int io_bytes_exceeded(struct thread_data *td)
+static int io_issue_bytes_exceeded(struct thread_data *td)
 {
 	unsigned long long bytes, limit;
 
@@ -683,6 +683,27 @@ static int io_bytes_exceeded(struct thread_data *td)
 	return bytes >= limit || exceeds_number_ios(td);
 }
 
+static int io_complete_bytes_exceeded(struct thread_data *td)
+{
+	unsigned long long bytes, limit;
+
+	if (td_rw(td))
+		bytes = td->this_io_bytes[DDIR_READ] + td->this_io_bytes[DDIR_WRITE];
+	else if (td_write(td))
+		bytes = td->this_io_bytes[DDIR_WRITE];
+	else if (td_read(td))
+		bytes = td->this_io_bytes[DDIR_READ];
+	else
+		bytes = td->this_io_bytes[DDIR_TRIM];
+
+	if (td->o.io_limit)
+		limit = td->o.io_limit;
+	else
+		limit = td->o.size;
+
+	return bytes >= limit || exceeds_number_ios(td);
+}
+
 /*
  * Main IO worker function. It retrieves io_u's to process and queues
  * and reaps them, checking for rate and errors along the way.
@@ -714,7 +735,7 @@ static uint64_t do_io(struct thread_data *td)
 		total_bytes += td->o.size;
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
+		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
 		td->o.time_based) {
 		struct timeval comp_time;
 		struct io_u *io_u;
@@ -1231,7 +1252,7 @@ static uint64_t do_dry_run(struct thread_data *td)
 	td_set_runstate(td, TD_RUNNING);
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td)) {
+		(!flist_empty(&td->trim_list)) || !io_complete_bytes_exceeded(td)) {
 		struct io_u *io_u;
 		int ret;
 
diff --git a/configure b/configure
index 6e1376f..892335b 100755
--- a/configure
+++ b/configure
@@ -887,7 +887,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   struct bitmask *mask = numa_parse_nodestring(NULL);
-  return 0;
+  return mask->size == 0;
 }
 EOF
 if compile_prog "" "" "libnuma api"; then
