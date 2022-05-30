Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D25C433EF
	for <fio@archiver.kernel.org>; Mon, 30 May 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiE3MAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 30 May 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiE3MAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 May 2022 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8448E7CB1F
        for <fio@vger.kernel.org>; Mon, 30 May 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3Pvo0fe7VOuzZaSB64CXts1MFV5KExDy58dkGA+aTs4=; b=j5jMVjWwwU5NKTrB8KBb8BjHTR
        G5eHqXg8vzyiXqPjCwCWd+4rBfRKlNufjhj27b/netidLe9y2WqdoLTspAdSYiBK8UNkkuHFgHrKi
        q+iowWHVpIZzse9QKOusWebOTDL6mYUDYe2UFH3S2hMBXJL2PJVtcVovBt894EsZAqPGq/IOBEQjt
        /MKGa/aA/gHtKN2FSq8hIwtzVLljiTpUxbF43HDfC7NFPaORki8CdfciP1VJKu4/T4IW2RnA7EXxd
        P6V9PIE+0b79eCi/HnbFKcsJ1ip7LlBKIoVc2XxRjmUVJlFFgv0n4mLVh5kRWvgNAaN0MJzst7jaO
        szROnaSg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nve44-004S4o-Gn
        for fio@vger.kernel.org; Mon, 30 May 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B00091BC0129; Mon, 30 May 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220530120001.B00091BC0129@kernel.dk>
Date:   Mon, 30 May 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a2840331c3cae5b2b0a13f99e58ae18375e2e40d:

  Merge branch 'master' of https://github.com/guoanwu/fio (2022-05-25 06:30:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e1aeff3ac96a51128b0493377f405e38bdc83500:

  Merge branch 'wip-lmy-rados' of https://github.com/liangmingyuanneo/fio (2022-05-29 09:32:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'wip-lmy-rados' of https://github.com/liangmingyuanneo/fio

Vincent Fu (5):
      steadystate: delete incorrect comment
      configure: refer to zlib1g-dev package for zlib support
      HOWTO: add blank line for prettier formatting
      t/run-fio-tests: improve json data decoding
      docs: update discussion of huge page sizes

liangmingyuan (1):
      engines/ceph: add option for setting config file path

 HOWTO.rst          | 31 ++++++++++++++++++++-----------
 configure          |  2 +-
 engines/rados.c    | 13 ++++++++++++-
 examples/rados.fio |  1 +
 fio.1              | 23 ++++++++++++++---------
 steadystate.c      |  7 -------
 t/run-fio-tests.py | 20 +++++++-------------
 7 files changed, 55 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 84bea5c5..8ab3ac4b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1064,6 +1064,7 @@ Target file/device
 	thread/process.
 
 .. option:: ignore_zone_limits=bool
+
 	If this option is used, fio will ignore the maximum number of open
 	zones limit of the zoned block device in use, thus allowing the
 	option :option:`max_open_zones` value to be larger than the device
@@ -1822,13 +1823,14 @@ Buffers and memory
 	**mmaphuge** to work, the system must have free huge pages allocated. This
 	can normally be checked and set by reading/writing
 	:file:`/proc/sys/vm/nr_hugepages` on a Linux system. Fio assumes a huge page
-	is 4MiB in size. So to calculate the number of huge pages you need for a
-	given job file, add up the I/O depth of all jobs (normally one unless
-	:option:`iodepth` is used) and multiply by the maximum bs set. Then divide
-	that number by the huge page size. You can see the size of the huge pages in
-	:file:`/proc/meminfo`. If no huge pages are allocated by having a non-zero
-	number in `nr_hugepages`, using **mmaphuge** or **shmhuge** will fail. Also
-	see :option:`hugepage-size`.
+        is 2 or 4MiB in size depending on the platform. So to calculate the
+        number of huge pages you need for a given job file, add up the I/O
+        depth of all jobs (normally one unless :option:`iodepth` is used) and
+        multiply by the maximum bs set. Then divide that number by the huge
+        page size. You can see the size of the huge pages in
+        :file:`/proc/meminfo`. If no huge pages are allocated by having a
+        non-zero number in `nr_hugepages`, using **mmaphuge** or **shmhuge**
+        will fail. Also see :option:`hugepage-size`.
 
 	**mmaphuge** also needs to have hugetlbfs mounted and the file location
 	should point there. So if it's mounted in :file:`/huge`, you would use
@@ -1847,10 +1849,12 @@ Buffers and memory
 
 .. option:: hugepage-size=int
 
-	Defines the size of a huge page. Must at least be equal to the system
-	setting, see :file:`/proc/meminfo`. Defaults to 4MiB.  Should probably
-	always be a multiple of megabytes, so using ``hugepage-size=Xm`` is the
-	preferred way to set this to avoid setting a non-pow-2 bad value.
+        Defines the size of a huge page. Must at least be equal to the system
+        setting, see :file:`/proc/meminfo` and
+        :file:`/sys/kernel/mm/hugepages/`. Defaults to 2 or 4MiB depending on
+        the platform.  Should probably always be a multiple of megabytes, so
+        using ``hugepage-size=Xm`` is the preferred way to set this to avoid
+        setting a non-pow-2 bad value.
 
 .. option:: lockmem=int
 
@@ -2491,6 +2495,11 @@ with the caveat that when used on the command line, they must come after the
 	the full *type.id* string. If no type. prefix is given, fio will add
 	'client.' by default.
 
+.. option:: conf=str : [rados]
+
+    Specifies the configuration path of ceph cluster, so conf file does not
+    have to be /etc/ceph/ceph.conf.
+
 .. option:: busy_poll=bool : [rbd,rados]
 
         Poll store instead of waiting for completion. Usually this provides better
diff --git a/configure b/configure
index 95b60bb7..4ee536a0 100755
--- a/configure
+++ b/configure
@@ -3142,7 +3142,7 @@ if test "$libzbc" = "yes" ; then
   output_sym "CONFIG_LIBZBC"
 fi
 if test "$zlib" = "no" ; then
-  echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
+  echo "Consider installing zlib1g-dev (zlib-devel) as some fio features depend on it."
   if test "$build_static" = "yes"; then
     echo "Note that some distros have separate packages for static libraries."
   fi
diff --git a/engines/rados.c b/engines/rados.c
index 976f9229..d0d15c5b 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -37,6 +37,7 @@ struct rados_options {
 	char *cluster_name;
 	char *pool_name;
 	char *client_name;
+	char *conf;
 	int busy_poll;
 	int touch_objects;
 };
@@ -69,6 +70,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_RBD,
 	},
+	{
+		.name     = "conf",
+		.lname    = "ceph configuration file path",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Path of the ceph configuration file",
+		.off1     = offsetof(struct rados_options, conf),
+		.def      = "/etc/ceph/ceph.conf",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
 	{
 		.name     = "busy_poll",
 		.lname    = "busy poll mode",
@@ -184,7 +195,7 @@ static int _fio_rados_connect(struct thread_data *td)
 		goto failed_early;
 	}
 
-	r = rados_conf_read_file(rados->cluster, NULL);
+	r = rados_conf_read_file(rados->cluster, o->conf);
 	if (r < 0) {
 		log_err("rados_conf_read_file failed.\n");
 		goto failed_early;
diff --git a/examples/rados.fio b/examples/rados.fio
index 035cbff4..dd86f354 100644
--- a/examples/rados.fio
+++ b/examples/rados.fio
@@ -14,6 +14,7 @@
 ioengine=rados
 clientname=admin
 pool=rados
+conf=/etc/ceph/ceph.conf
 busy_poll=0
 rw=randwrite
 bs=4k
diff --git a/fio.1 b/fio.1
index ded7bbfc..bdba3142 100644
--- a/fio.1
+++ b/fio.1
@@ -1631,11 +1631,11 @@ multiplied by the I/O depth given. Note that for \fBshmhuge\fR and
 \fBmmaphuge\fR to work, the system must have free huge pages allocated. This
 can normally be checked and set by reading/writing
 `/proc/sys/vm/nr_hugepages' on a Linux system. Fio assumes a huge page
-is 4MiB in size. So to calculate the number of huge pages you need for a
-given job file, add up the I/O depth of all jobs (normally one unless
-\fBiodepth\fR is used) and multiply by the maximum bs set. Then divide
-that number by the huge page size. You can see the size of the huge pages in
-`/proc/meminfo'. If no huge pages are allocated by having a non-zero
+is 2 or 4MiB in size depending on the platform. So to calculate the number of
+huge pages you need for a given job file, add up the I/O depth of all jobs
+(normally one unless \fBiodepth\fR is used) and multiply by the maximum bs set.
+Then divide that number by the huge page size. You can see the size of the huge
+pages in `/proc/meminfo'. If no huge pages are allocated by having a non-zero
 number in `nr_hugepages', using \fBmmaphuge\fR or \fBshmhuge\fR will fail. Also
 see \fBhugepage\-size\fR.
 .P
@@ -1655,10 +1655,11 @@ of subsequent I/O memory buffers is the sum of the \fBiomem_align\fR and
 \fBbs\fR used.
 .TP
 .BI hugepage\-size \fR=\fPint
-Defines the size of a huge page. Must at least be equal to the system
-setting, see `/proc/meminfo'. Defaults to 4MiB. Should probably
-always be a multiple of megabytes, so using `hugepage\-size=Xm' is the
-preferred way to set this to avoid setting a non-pow-2 bad value.
+Defines the size of a huge page. Must at least be equal to the system setting,
+see `/proc/meminfo' and `/sys/kernel/mm/hugepages/'. Defaults to 2 or 4MiB
+depending on the platform. Should probably always be a multiple of megabytes,
+so using `hugepage\-size=Xm' is the preferred way to set this to avoid setting
+a non-pow-2 bad value.
 .TP
 .BI lockmem \fR=\fPint
 Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
@@ -2243,6 +2244,10 @@ Ceph cluster. If the \fBclustername\fR is specified, the \fBclientname\fR shall
 the full *type.id* string. If no type. prefix is given, fio will add 'client.'
 by default.
 .TP
+.BI (rados)conf \fR=\fPstr
+Specifies the configuration path of ceph cluster, so conf file does not
+have to be /etc/ceph/ceph.conf.
+.TP
 .BI (rbd,rados)busy_poll \fR=\fPbool
 Poll store instead of waiting for completion. Usually this provides better
 throughput at cost of higher(up to 100%) CPU utilization.
diff --git a/steadystate.c b/steadystate.c
index 2e3da1db..ad19318c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -250,13 +250,6 @@ int steadystate_check(void)
 		rate_time = mtime_since(&ss->prev_time, &now);
 		memcpy(&ss->prev_time, &now, sizeof(now));
 
-		/*
-		 * Begin monitoring when job starts but don't actually use
-		 * data in checking stopping criterion until ss->ramp_time is
-		 * over. This ensures that we will have a sane value in
-		 * prev_iops/bw the first time through after ss->ramp_time
-		 * is done.
-		 */
 		if (ss->state & FIO_SS_RAMP_OVER) {
 			group_bw += 1000 * (td_bytes - ss->prev_bytes) / rate_time;
 			group_iops += 1000 * (td_iops - ss->prev_iops) / rate_time;
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index ecceb67e..32cdbc19 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -311,21 +311,15 @@ class FioJobTest(FioExeTest):
         #
         # Sometimes fio informational messages are included at the top of the
         # JSON output, especially under Windows. Try to decode output as JSON
-        # data, lopping off up to the first four lines
+        # data, skipping everything until the first {
         #
         lines = file_data.splitlines()
-        for i in range(5):
-            file_data = '\n'.join(lines[i:])
-            try:
-                self.json_data = json.loads(file_data)
-            except json.JSONDecodeError:
-                continue
-            else:
-                logging.debug("Test %d: skipped %d lines decoding JSON data", self.testnum, i)
-                return
-
-        self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
-        self.passed = False
+        file_data = '\n'.join(lines[lines.index("{"):])
+        try:
+            self.json_data = json.loads(file_data)
+        except json.JSONDecodeError:
+            self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+            self.passed = False
 
 
 class FioJobTest_t0005(FioJobTest):
