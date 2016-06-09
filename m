Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbcFIMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Jun 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1bAyd1-0006iG-5N
	for fio@vger.kernel.org; Thu, 09 Jun 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160609120002.042B62C00A6@kernel.dk>
Date: Thu,  9 Jun 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6a89b401289ef823c51760c71018b43d0c17532b:

  stat: fix reversed check for ramp time (2016-06-06 21:23:53 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a275c37ab0001b62b1961e3430e58a2d42ee3dc9:

  options: mark unsupported options as such (2016-06-08 11:13:08 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      parse: add support for unsupported options
      options: mark unsupported options as such

 options.c | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 options.h |  15 +------
 parse.c   |  21 +++++++++-
 parse.h   |   1 +
 4 files changed, 156 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 7a22fe4..e8c0b7f 100644
--- a/options.c
+++ b/options.c
@@ -2161,7 +2161,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 		},
 	},
-#endif	/* CONFIG_POSIX_FALLOCATE */
+#else	/* CONFIG_POSIX_FALLOCATE */
+	{
+		.name	= "fallocate",
+		.lname	= "Fallocate",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support fallocate",
+	},
+#endif /* CONFIG_POSIX_FALLOCATE */
 	{
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
@@ -2182,6 +2189,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+		.name	= "fadvise_stream",
+		.lname	= "Fadvise stream",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support fadvise stream ID",
+	},
 #endif
 	{
 		.name	= "fsync",
@@ -2245,6 +2258,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+		.name	= "sync_file_range",
+		.lname	= "Sync file range",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support sync_file_range",
+	},
 #endif
 	{
 		.name	= "direct",
@@ -2676,6 +2695,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+#else
+	{
+		.name	= "verify_async_cpus",
+		.lname	= "Async verify CPUs",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	"Your platform does not support CPU affinities",
+	},
 #endif
 	{
 		.name	= "experimental_verify",
@@ -2760,6 +2786,31 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_TRIM,
 	},
+#else
+	{
+		.name	= "trim_percentage",
+		.lname	= "Trim percentage",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Fio does not support TRIM on your platform",
+	},
+	{
+		.name	= "trim_verify_zero",
+		.lname	= "Verify trim zero",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Fio does not support TRIM on your platform",
+	},
+	{
+		.name	= "trim_backlog",
+		.lname	= "Trim backlog",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Fio does not support TRIM on your platform",
+	},
+	{
+		.name	= "trim_backlog_batch",
+		.lname	= "Trim backlog batch",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Fio does not support TRIM on your platform",
+	},
 #endif
 	{
 		.name	= "write_iolog",
@@ -2852,6 +2903,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+	{
+		.name	= "ioscheduler",
+		.lname	= "I/O scheduler",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO scheduler switching",
+	},
 #endif
 	{
 		.name	= "zonesize",
@@ -2970,6 +3028,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+#else
+	{
+		.name	= "prio",
+		.lname	= "I/O nice priority",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO priorities",
+	},
+	{
+		.name	= "prioclass",
+		.lname	= "I/O nice priority class",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO priorities",
+	},
 #endif
 	{
 		.name	= "thinktime",
@@ -3268,6 +3339,25 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+#else
+	{
+		.name	= "cpumask",
+		.lname	= "CPU mask",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support CPU affinities",
+	},
+	{
+		.name	= "cpus_allowed",
+		.lname	= "CPUs allowed",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support CPU affinities",
+	},
+	{
+		.name	= "cpus_allowed_policy",
+		.lname	= "CPUs allowed distribution policy",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support CPU affinities",
+	},
 #endif
 #ifdef CONFIG_LIBNUMA
 	{
@@ -3290,6 +3380,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+	{
+		.name	= "numa_cpu_nodes",
+		.lname	= "NUMA CPU Nodes",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Build fio with libnuma-dev(el) to enable this option",
+	},
+	{
+		.name	= "numa_mem_policy",
+		.lname	= "NUMA Memory Policy",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Build fio with libnuma-dev(el) to enable this option",
+	},
 #endif
 	{
 		.name	= "end_fsync",
@@ -3462,6 +3565,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+	{
+		.name	= "log_compression_cpus",
+		.lname	= "Log Compression CPUs",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support CPU affinities",
+	},
 #endif
 	{
 		.name	= "log_store_compressed",
@@ -3472,6 +3582,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+	{
+		.name	= "log_compression",
+		.lname	= "Log compression",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Install libz-dev(el) to get compression support",
+	},
+	{
+		.name	= "log_store_compressed",
+		.lname	= "Log store compressed",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Install libz-dev(el) to get compression support",
+	},
 #endif
 	{
 		.name	= "block_error_percentiles",
@@ -3632,6 +3755,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#else
+	{
+		.name	= "disk_util",
+		.lname	= "Disk utilization",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support disk utilization",
+	},
 #endif
 	{
 		.name	= "gtod_reduce",
@@ -4277,7 +4407,8 @@ static void show_closest_option(const char *opt)
 		i++;
 	}
 
-	if (best_option != -1 && string_distance_ok(name, best_distance))
+	if (best_option != -1 && string_distance_ok(name, best_distance) &&
+	    fio_options[best_option].type != FIO_OPT_UNSUPPORTED)
 		log_err("Did you mean %s?\n", fio_options[best_option].name);
 
 	free(name);
diff --git a/options.h b/options.h
index 4727bac..539a636 100644
--- a/options.h
+++ b/options.h
@@ -47,19 +47,8 @@ static inline bool o_match(struct fio_option *o, const char *opt)
 	return false;
 }
 
-static inline struct fio_option *find_option(struct fio_option *options,
-					     const char *opt)
-{
-	struct fio_option *o;
-
-	for (o = &options[0]; o->name; o++)
-		if (o_match(o, opt))
-			return o;
-
-	return NULL;
-}
-
-extern struct fio_option *fio_option_find(const char *name);
+extern struct fio_option *find_option(struct fio_option *, const char *);
+extern struct fio_option *fio_option_find(const char *);
 extern unsigned int fio_get_kb_base(void *);
 
 #endif
diff --git a/parse.c b/parse.c
index 963f1f8..bb16bc1 100644
--- a/parse.c
+++ b/parse.c
@@ -906,6 +906,25 @@ static int handle_option(struct fio_option *o, const char *__ptr, void *data)
 	return ret;
 }
 
+struct fio_option *find_option(struct fio_option *options, const char *opt)
+{
+	struct fio_option *o;
+
+	for (o = &options[0]; o->name; o++) {
+		if (!o_match(o, opt))
+			continue;
+		if (o->type == FIO_OPT_UNSUPPORTED) {
+			log_err("Option <%s>: %s\n", o->name, o->help);
+			continue;
+		}
+
+		return o;
+	}
+
+	return NULL;
+}
+
+
 static struct fio_option *get_option(char *opt,
 				     struct fio_option *options, char **post)
 {
@@ -1232,7 +1251,7 @@ void fill_default_options(void *data, struct fio_option *options)
 
 void option_init(struct fio_option *o)
 {
-	if (o->type == FIO_OPT_DEPRECATED)
+	if (o->type == FIO_OPT_DEPRECATED || o->type == FIO_OPT_UNSUPPORTED)
 		return;
 	if (o->name && !o->lname)
 		log_err("Option %s: missing long option name\n", o->name);
diff --git a/parse.h b/parse.h
index 77450ef..aa00a67 100644
--- a/parse.h
+++ b/parse.h
@@ -20,6 +20,7 @@ enum fio_opt_type {
 	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
 	FIO_OPT_DEPRECATED,
+	FIO_OPT_UNSUPPORTED,
 };
 
 /*
