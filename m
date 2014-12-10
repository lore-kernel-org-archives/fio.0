Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaLJNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Dec 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XygsA-0007N6-3M
	for fio@vger.kernel.org; Wed, 10 Dec 2014 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141210130003.71180400D0@lyth.info>
Date: Wed, 10 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f8b8f7da1f64353ebc1dfa47de3b7ff1e8cca303:

  Update date and email in man page (2014-12-06 18:47:43 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3b577774803435109e070cc8f4313fc485c9160f:

  Fix server/client set_options conversion (2014-12-09 14:12:47 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      options: add support for checking if an option has been set
      Get rid of _set variables
      Always scramble buffers, if scramble_buffers is set
      Use fio_option_is_set() for ioprio setting
      Fix server/client set_options conversion

 backend.c        |   15 +++++-----
 cconv.c          |   10 ++++---
 init.c           |    8 +++++-
 options.c        |   83 +++++++++++++++++++++++++++++++++++++++++-------------
 options.h        |    7 +++++
 parse.c          |    2 --
 server.h         |    2 +-
 thread_options.h |   13 ++++-----
 verify.c         |    2 +-
 9 files changed, 100 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 6816362..f027cf0 100644
--- a/backend.c
+++ b/backend.c
@@ -1345,7 +1345,7 @@ static void *thread_main(void *data)
 	 * Set affinity first, in case it has an impact on the memory
 	 * allocations.
 	 */
-	if (o->cpumask_set) {
+	if (fio_option_is_set(o, cpumask)) {
 		if (o->cpus_allowed_policy == FIO_CPUS_SPLIT) {
 			ret = fio_cpus_split(&o->cpumask, td->thread_number - 1);
 			if (!ret) {
@@ -1364,7 +1364,8 @@ static void *thread_main(void *data)
 
 #ifdef CONFIG_LIBNUMA
 	/* numa node setup */
-	if (o->numa_cpumask_set || o->numa_memmask_set) {
+	if (fio_option_is_set(o, numa_cpunodes) ||
+	    fio_option_is_set(o, numa_memnodes)) {
 		struct bitmask *mask;
 
 		if (numa_available() < 0) {
@@ -1372,7 +1373,7 @@ static void *thread_main(void *data)
 			goto err;
 		}
 
-		if (o->numa_cpumask_set) {
+		if (fio_option_is_set(o, numa_cpunodes)) {
 			mask = numa_parse_nodestring(o->numa_cpunodes);
 			ret = numa_run_on_node_mask(mask);
 			numa_free_nodemask(mask);
@@ -1383,8 +1384,7 @@ static void *thread_main(void *data)
 			}
 		}
 
-		if (o->numa_memmask_set) {
-
+		if (fio_option_is_set(o, numa_memnodes)) {
 			mask = NULL;
 			if (o->numa_memnodes)
 				mask = numa_parse_nodestring(o->numa_memnodes);
@@ -1430,7 +1430,8 @@ static void *thread_main(void *data)
 	if (o->verify_async && verify_async_init(td))
 		goto err;
 
-	if (o->ioprio) {
+	if (fio_option_is_set(o, ioprio) ||
+	    fio_option_is_set(o, ioprio_class)) {
 		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
 		if (ret == -1) {
 			td_verror(td, errno, "ioprio_set");
@@ -1589,7 +1590,7 @@ err:
 	cgroup_shutdown(td, &cgroup_mnt);
 	verify_free_state(td);
 
-	if (o->cpumask_set) {
+	if (fio_option_is_set(o, cpumask)) {
 		ret = fio_cpuset_exit(&o->cpumask);
 		if (ret)
 			td_verror(td, ret, "fio_cpuset_exit");
diff --git a/cconv.c b/cconv.c
index d0a124e..0de2f5c 100644
--- a/cconv.c
+++ b/cconv.c
@@ -49,6 +49,9 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 {
 	int i, j;
 
+	for (i = 0; i < NR_OPTS_SZ; i++)
+		o->set_options[i] = le64_to_cpu(top->set_options[i]);
+
 	string_to_cpu(&o->description, top->description);
 	string_to_cpu(&o->name, top->name);
 	string_to_cpu(&o->directory, top->directory);
@@ -194,8 +197,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->stonewall = le32_to_cpu(top->stonewall);
 	o->new_group = le32_to_cpu(top->new_group);
 	o->numjobs = le32_to_cpu(top->numjobs);
-	o->cpumask_set = le32_to_cpu(top->cpumask_set);
-	o->verify_cpumask_set = le32_to_cpu(top->verify_cpumask_set);
 	o->cpus_allowed_policy = le32_to_cpu(top->cpus_allowed_policy);
 	o->iolog = le32_to_cpu(top->iolog);
 	o->rwmixcycle = le32_to_cpu(top->rwmixcycle);
@@ -258,6 +259,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 {
 	int i, j;
 
+	for (i = 0; i < NR_OPTS_SZ; i++)
+		top->set_options[i] = cpu_to_le64(o->set_options[i]);
+
 	string_to_net(top->description, o->description);
 	string_to_net(top->name, o->name);
 	string_to_net(top->directory, o->directory);
@@ -355,8 +359,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->stonewall = cpu_to_le32(o->stonewall);
 	top->new_group = cpu_to_le32(o->new_group);
 	top->numjobs = cpu_to_le32(o->numjobs);
-	top->cpumask_set = cpu_to_le32(o->cpumask_set);
-	top->verify_cpumask_set = cpu_to_le32(o->verify_cpumask_set);
 	top->cpus_allowed_policy = cpu_to_le32(o->cpus_allowed_policy);
 	top->iolog = cpu_to_le32(o->iolog);
 	top->rwmixcycle = cpu_to_le32(o->rwmixcycle);
diff --git a/init.c b/init.c
index 9fbc477..f606087 100644
--- a/init.c
+++ b/init.c
@@ -926,7 +926,13 @@ static void init_flags(struct thread_data *td)
 		td->flags |= TD_F_READ_IOLOG;
 	if (o->refill_buffers)
 		td->flags |= TD_F_REFILL_BUFFERS;
-	if (o->scramble_buffers)
+	/*
+	 * Scramble by default, but not if zero_buffer is true and has been
+	 * set. But if scramble_buffers has been set, always scramble.
+	 */
+	if (o->scramble_buffers && ((!o->zero_buffers &&
+	    fio_option_is_set(o, zero_buffers)) ||
+	    fio_option_is_set(o, scramble_buffers)))
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
diff --git a/options.c b/options.c
index 2c703fd..afca727 100644
--- a/options.c
+++ b/options.c
@@ -453,7 +453,6 @@ static int str_cpumask_cb(void *data, unsigned long long *val)
 		}
 	}
 
-	td->o.cpumask_set = 1;
 	return 0;
 }
 
@@ -520,36 +519,24 @@ static int set_cpus_allowed(struct thread_data *td, os_cpu_mask_t *mask,
 	}
 
 	free(p);
-	if (!ret)
-		td->o.cpumask_set = 1;
 	return ret;
 }
 
 static int str_cpus_allowed_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
-	int ret;
 
 	if (parse_dryrun())
 		return 0;
 
-	ret = set_cpus_allowed(td, &td->o.cpumask, input);
-	if (!ret)
-		td->o.cpumask_set = 1;
-
-	return ret;
+	return set_cpus_allowed(td, &td->o.cpumask, input);
 }
 
 static int str_verify_cpus_allowed_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
-	int ret;
 
-	ret = set_cpus_allowed(td, &td->o.verify_cpumask, input);
-	if (!ret)
-		td->o.verify_cpumask_set = 1;
-
-	return ret;
+	return set_cpus_allowed(td, &td->o.verify_cpumask, input);
 }
 #endif
 
@@ -576,7 +563,6 @@ static int str_numa_cpunodes_cb(void *data, char *input)
 	numa_free_nodemask(verify_bitmask);
 
 	td->o.numa_cpunodes = strdup(input);
-	td->o.numa_cpumask_set = 1;
 	return 0;
 }
 
@@ -683,9 +669,7 @@ static int str_numa_mpol_cb(void *data, char *input)
 		break;
 	}
 
-	td->o.numa_memmask_set = 1;
 	return 0;
-
 out:
 	return 1;
 }
@@ -1650,6 +1634,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Size",
 		.type	= FIO_OPT_STR_VAL,
 		.cb	= str_size_cb,
+		.off1	= td_var_offset(size),
 		.help	= "Total size of device or files",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
@@ -1789,6 +1774,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size split",
 		.type	= FIO_OPT_STR,
 		.cb	= str_bssplit_cb,
+		.off1	= td_var_offset(bssplit),
 		.help	= "Set a specific mix of block sizes",
 		.parent	= "rw",
 		.hide	= 1,
@@ -2443,6 +2429,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Verify pattern",
 		.type	= FIO_OPT_STR,
 		.cb	= str_verify_pattern_cb,
+		.off1	= td_var_offset(verify_pattern),
 		.help	= "Fill pattern for IO buffers",
 		.parent	= "verify",
 		.hide	= 1,
@@ -2513,6 +2500,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Async verify CPUs",
 		.type	= FIO_OPT_STR,
 		.cb	= str_verify_cpus_allowed_cb,
+		.off1	= td_var_offset(verify_cpumask),
 		.help	= "Set CPUs allowed for async verify threads",
 		.parent	= "verify_async",
 		.hide	= 1,
@@ -2722,6 +2710,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Read/write mix read",
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_read_cb,
+		.off1	= td_var_offset(rwmix[DDIR_READ]),
 		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is reads",
 		.def	= "50",
@@ -2735,6 +2724,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Read/write mix write",
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_write_cb,
+		.off1	= td_var_offset(rwmix[DDIR_WRITE]),
 		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is writes",
 		.def	= "50",
@@ -3004,6 +2994,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "CPU mask",
 		.type	= FIO_OPT_INT,
 		.cb	= str_cpumask_cb,
+		.off1	= td_var_offset(cpumask),
 		.help	= "CPU affinity mask",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -3013,6 +3004,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "CPUs allowed",
 		.type	= FIO_OPT_STR,
 		.cb	= str_cpus_allowed_cb,
+		.off1	= td_var_offset(cpumask),
 		.help	= "Set CPUs allowed",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -3044,6 +3036,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "numa_cpu_nodes",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_cpunodes_cb,
+		.off1	= td_var_offset(numa_cpunodes),
 		.help	= "NUMA CPU nodes bind",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -3052,6 +3045,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "numa_mem_policy",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_mpol_cb,
+		.off1	= td_var_offset(numa_memnodes),
 		.help	= "NUMA memory policy setup",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
@@ -3266,6 +3260,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Buffer pattern",
 		.type	= FIO_OPT_STR,
 		.cb	= str_buffer_pattern_cb,
+		.off1	= td_var_offset(buffer_pattern),
 		.help	= "Fill pattern for IO buffers",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_BUF,
@@ -3275,6 +3270,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Buffer compression percentage",
 		.type	= FIO_OPT_INT,
 		.cb	= str_buffer_compress_cb,
+		.off1	= td_var_offset(compress_percentage),
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "How compressible the buffer is (approximately)",
@@ -3299,6 +3295,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Dedupe percentage",
 		.type	= FIO_OPT_INT,
 		.cb	= str_dedupe_cb,
+		.off1	= td_var_offset(dedupe_percentage),
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "Percentage of buffers that are dedupable",
@@ -3469,6 +3466,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "ignore_error",
 		.type	= FIO_OPT_STR,
 		.cb	= str_ignore_error_cb,
+		.off1	= td_var_offset(ignore_error_nr),
 		.help	= "Set a specific list of errors to ignore",
 		.parent	= "rw",
 		.category = FIO_OPT_C_GENERAL,
@@ -3980,6 +3978,9 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 		int newret = parse_option(opts_copy[i], opts[i], fio_options,
 						&o, td, dump_cmdline);
 
+		if (!newret && o)
+			fio_option_mark_set(&td->o, o);
+
 		if (opts_copy[i]) {
 			if (newret && !o) {
 				unknown++;
@@ -4026,7 +4027,18 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 
 int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 {
-	return parse_cmd_option(opt, val, fio_options, td);
+	int ret;
+
+	ret = parse_cmd_option(opt, val, fio_options, td);
+	if (!ret) {
+		struct fio_option *o;
+
+		o = find_option(fio_options, opt);
+		if (o)
+			fio_option_mark_set(&td->o, o);
+	}
+
+	return ret;
 }
 
 int fio_cmd_ioengine_option_parse(struct thread_data *td, const char *opt,
@@ -4188,3 +4200,36 @@ struct fio_option *fio_option_find(const char *name)
 	return find_option(fio_options, name);
 }
 
+int __fio_option_is_set(struct thread_options *o, unsigned int off1)
+{
+	unsigned int opt_off, index, offset;
+	struct fio_option *opt = NULL;
+	int i;
+
+	for (i = 0; fio_options[i].name; i++) {
+		if (off1 == fio_options[i].off1) {
+			opt = &fio_options[i];
+			break;
+		}
+	}
+
+	if (!opt) {
+		log_err("fio: no option found at offset %u\n", off1);
+		return 0;
+	}
+
+	opt_off = opt - &fio_options[0];
+	index = opt_off / (8 * sizeof(uint64_t));
+	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
+	return (o->set_options[index] & (1UL << offset)) != 0;
+}
+
+void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
+{
+	unsigned int opt_off, index, offset;
+
+	opt_off = opt - &fio_options[0];
+	index = opt_off / (8 * sizeof(uint64_t));
+	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
+	o->set_options[index] |= 1UL << offset;
+}
diff --git a/options.h b/options.h
index b2e2c0c..fa015c3 100644
--- a/options.h
+++ b/options.h
@@ -22,6 +22,13 @@ int set_name_idx(char *, char *, int);
 
 extern struct fio_option fio_options[FIO_MAX_OPTS];
 
+extern int __fio_option_is_set(struct thread_options *, unsigned int off);
+
+#define fio_option_is_set(__td, name)	\
+	__fio_option_is_set((__td), td_var_offset(name))
+
+extern void fio_option_mark_set(struct thread_options *, struct fio_option *);
+
 static inline int o_match(struct fio_option *o, const char *opt)
 {
 	if (!strcmp(o->name, opt))
diff --git a/parse.c b/parse.c
index 141f4b2..ae87b1e 100644
--- a/parse.c
+++ b/parse.c
@@ -1279,8 +1279,6 @@ void option_init(struct fio_option *o)
 	if (o->type == FIO_OPT_STR || o->type == FIO_OPT_STR_STORE ||
 	    o->type == FIO_OPT_STR_MULTI)
 		return;
-	if (o->cb && (o->off1 || o->off2 || o->off3 || o->off4))
-		log_err("Option %s: both cb and offset given\n", o->name);
 }
 
 /*
diff --git a/server.h b/server.h
index 0a98bf5..cd3f999 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 40,
+	FIO_SERVER_VER			= 41,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index f311e2c..530dd9a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -3,6 +3,7 @@
 
 #include "arch/arch.h"
 #include "os/os.h"
+#include "options.h"
 #include "stat.h"
 #include "gettime.h"
 #include "lib/ieee754.h"
@@ -28,10 +29,13 @@ struct bssplit {
 	uint32_t perc;
 };
 
+#define NR_OPTS_SZ	(FIO_MAX_OPTS / (8 * sizeof(uint64_t)))
+
 #define OPT_MAGIC	0x4f50544e
 
 struct thread_options {
 	int magic;
+	uint64_t set_options[NR_OPTS_SZ];
 	char *description;
 	char *name;
 	char *directory;
@@ -159,16 +163,12 @@ struct thread_options {
 	unsigned int new_group;
 	unsigned int numjobs;
 	os_cpu_mask_t cpumask;
-	unsigned int cpumask_set;
 	os_cpu_mask_t verify_cpumask;
-	unsigned int verify_cpumask_set;
 	unsigned int cpus_allowed_policy;
 	char *numa_cpunodes;
-	unsigned int numa_cpumask_set;
 	unsigned short numa_mem_mode;
 	unsigned int numa_mem_prefer_node;
 	char *numa_memnodes;
-	unsigned int numa_memmask_set;
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
@@ -265,6 +265,7 @@ struct thread_options {
 #define FIO_TOP_STR_MAX		256
 
 struct thread_options_pack {
+	uint64_t set_options[NR_OPTS_SZ];
 	uint8_t description[FIO_TOP_STR_MAX];
 	uint8_t name[FIO_TOP_STR_MAX];
 	uint8_t directory[FIO_TOP_STR_MAX];
@@ -334,7 +335,6 @@ struct thread_options_pack {
 	uint32_t experimental_verify;
 	uint32_t verify_state;
 	uint32_t verify_state_save;
-	uint32_t pad;
 	uint32_t use_thread;
 	uint32_t unlink;
 	uint32_t do_disk_util;
@@ -354,6 +354,7 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
+	uint32_t pad;
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 
@@ -390,9 +391,7 @@ struct thread_options_pack {
 	uint32_t new_group;
 	uint32_t numjobs;
 	uint8_t cpumask[FIO_TOP_STR_MAX];
-	uint32_t cpumask_set;
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
-	uint32_t verify_cpumask_set;
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
diff --git a/verify.c b/verify.c
index d1a1266..2ae03f8 100644
--- a/verify.c
+++ b/verify.c
@@ -1151,7 +1151,7 @@ static void *verify_async_thread(void *data)
 	struct io_u *io_u;
 	int ret = 0;
 
-	if (td->o.verify_cpumask_set &&
+	if (fio_option_is_set(&td->o, verify_cpumask) &&
 	    fio_setaffinity(td->pid, td->o.verify_cpumask)) {
 		log_err("fio: failed setting verify thread affinity\n");
 		goto done;
