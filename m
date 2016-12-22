Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t5009.houston.hpe.com ([15.241.48.73]:53263 "EHLO
        g9t5009.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935636AbcLVUrr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:47 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id 6968475
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 20:47:46 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 01/12] Avoid using units in option defaults
Date: Thu, 22 Dec 2016 14:50:40 -0600
Message-Id: <20161222205051.4677-1-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Change option defaults and some generated option strings to specify
the number of bytes without units, so they are immune to the
interpretation of the units (e.g. is 1M interpreted as
1048576 or 1000000).
---
 options.c                       | 2 +-
 profiles/act.c                  | 6 +++---
 profiles/tiobench.c             | 2 +-
 unit_tests/steadystate_tests.py | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/options.c b/options.c
index b81db23..45c85a2 100644
--- a/options.c
+++ b/options.c
@@ -1965,7 +1965,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off3	= offsetof(struct thread_options, bs[DDIR_TRIM]),
 		.minval = 1,
 		.help	= "Block size unit",
-		.def	= "4k",
+		.def	= "4096",
 		.parent = "rw",
 		.hide	= 1,
 		.interval = 512,
diff --git a/profiles/act.c b/profiles/act.c
index 3e9238b..58ae7af 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -144,7 +144,7 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct act_options, write_size),
 		.help	= "Size of large block ops (writes)",
-		.def	= "128k",
+		.def	= "131072",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
 	},
@@ -220,7 +220,7 @@ static int act_add_dev_prep(const char *dev)
 		return 1;
 	if (act_add_opt("filename=%s", dev))
 		return 1;
-	if (act_add_opt("bs=1M"))
+	if (act_add_opt("bs=1048576"))
 		return 1;
 	if (act_add_opt("zero_buffers"))
 		return 1;
@@ -234,7 +234,7 @@ static int act_add_dev_prep(const char *dev)
 		return 1;
 	if (act_add_opt("filename=%s", dev))
 		return 1;
-	if (act_add_opt("bs=4k"))
+	if (act_add_opt("bs=4096"))
 		return 1;
 	if (act_add_opt("ioengine=libaio"))
 		return 1;
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 8af6f4e..17229b9 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -49,7 +49,7 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct tiobench_options, bs),
 		.help	= "Block size in bytes",
-		.def	= "4k",
+		.def	= "4096",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
 	},
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
index a8e4e39..91c79a4 100755
--- a/unit_tests/steadystate_tests.py
+++ b/unit_tests/steadystate_tests.py
@@ -115,7 +115,7 @@ if __name__ == '__main__':
     if args.read == None:
         if os.name == 'posix':
             args.read = '/dev/zero'
-            extra = [ "--size=128M" ]
+            extra = [ "--size=134217728" ]  # 128 MiB
         else:
             print "ERROR: file for read testing must be specified on non-posix systems"
             sys.exit(1)
-- 
2.9.3

