Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:56598 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2JTDTz (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Oct 2012 23:19:55 -0400
Received: by mail-qc0-f198.google.com with SMTP id e13so1902208qcs.1
        for <fio@vger.kernel.org>; Fri, 19 Oct 2012 20:19:54 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH 4/4] Fine-grained job level numa control
Date: Fri, 19 Oct 2012 23:11:52 -0400
Message-Id: <1350702712-5168-5-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

Two new options, numa_cpu_nodes and numa_mem_policy, are created
for a fine-grained job level numa control. Please refer HOWTO and
README for detailed description.
A example job, examples/numa, is added as well.

---
 HOWTO         |   18 +++++++
 README        |   14 ++++--
 backend.c     |   43 ++++++++++++++++++
 examples/numa |   21 +++++++++
 fio.1         |   22 +++++++++
 fio.h         |   18 +++++++
 options.c     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 270 insertions(+), 4 deletions(-)
 create mode 100644 examples/numa

diff --git a/HOWTO b/HOWTO
index ee9680a..8eda99d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -799,6 +799,24 @@ cpus_allowed=str Controls the same options as cpumask, but it allows a text
 		allows a range of CPUs. Say you wanted a binding to CPUs
 		1, 5, and 8-15, you would set cpus_allowed=1,5,8-15.
 
+numa_cpu_nodes=str Set this job running on spcified NUMA nodes' CPUs. The
+		arguments allow comma delimited list of cpu numbers,
+		A-B ranges, or 'all'. Note, to enable numa options support,
+		export the following environment variables,
+			export EXTFLAGS+=" -DFIO_HAVE_LIBNUMA "
+			export EXTLIBS+=" -lnuma "
+
+numa_mem_policy=str Set this job's memory policy and corresponding NUMA
+		nodes. Format of the argements:
+			<mode>[:<nodelist>]
+		`mode' is one of the following memory policy:
+			default, prefer, bind, interleave, local
+		For `default' and `local' memory policy, no node is
+		needed to be specified.
+		For `prefer', only one node is allowed.
+		For `bind' and `interleave', it allow comma delimited
+		list of numbers, A-B ranges, or 'all'.
+
 startdelay=time	Start this job the specified number of seconds after fio
 		has started. Only useful if the job file contains several
 		jobs, and you want to delay starting some jobs to a certain
diff --git a/README b/README
index 535b077..ceac385 100644
--- a/README
+++ b/README
@@ -233,10 +233,11 @@ The job file parameters are:
 			readv/writev (with queuing emulation) mmap for mmap'ed
 			io, syslet-rw for syslet driven read/write, splice for
 			using splice/vmsplice, sg for direct SG_IO io, net
-			for network io, or cpuio for a cycler burner load. sg
-			only works on Linux on SCSI (or SCSI-like devices, such
-			as usb-storage or sata/libata driven) devices. Fio also
-			has a null io engine, which is mainly used for testing
+			for network io, rdma for RDMA io, or cpuio for a
+			cycler burner load. sg only works on Linux on
+			SCSI (or SCSI-like devices, such as usb-storage or
+			sata/libata driven) devices. Fio also has a null
+			io engine, which is mainly used for testing
 			fio itself.
 
 	iodepth=x	For async io, allow 'x' ios in flight
@@ -255,6 +256,11 @@ The job file parameters are:
 	ratecycle=x	ratemin averaged over x msecs
 	cpumask=x	Only allow job to run on CPUs defined by mask.
 	cpus_allowed=x	Like 'cpumask', but allow text setting of CPU affinity.
+	numa_cpu_nodes=x,y-z  Allow job to run on specified NUMA nodes' CPU.
+	numa_mem_policy=m:x,y-z  Setup numa memory allocation policy.
+			'm' stands for policy, such as local, interleave,
+			bind, prefer, local. 'x, y-z' are numa node(s) for
+			memory allocation according to policy.
 	fsync=x		If writing with buffered IO, fsync after every
 			'x' blocks have been written.
 	end_fsync=x	If 'x', run fsync() after end-of-job.
diff --git a/backend.c b/backend.c
index 85ec196..157fd52 100644
--- a/backend.c
+++ b/backend.c
@@ -1052,6 +1052,49 @@ static void *thread_main(void *data)
 		goto err;
 	}
 
+#ifdef FIO_HAVE_LIBNUMA
+	/* numa node setup */
+	if (td->o.numa_cpumask_set || td->o.numa_memmask_set) {
+		int ret;
+
+		if (numa_available() < 0) {
+			td_verror(td, errno, "Does not support NUMA API\n");
+			goto err;
+		}
+
+		if (td->o.numa_cpumask_set) {
+			ret = numa_run_on_node_mask(td->o.numa_cpunodesmask);
+			if (ret == -1) {
+				td_verror(td, errno, \
+					"numa_run_on_node_mask failed\n");
+				goto err;
+			}
+		}
+
+		if (td->o.numa_memmask_set) {
+
+			switch (td->o.numa_mem_mode) {
+			case MPOL_INTERLEAVE:
+				numa_set_interleave_mask(td->o.numa_memnodesmask);
+				break;
+			case MPOL_BIND:
+				numa_set_membind(td->o.numa_memnodesmask);
+				break;
+			case MPOL_LOCAL:
+				numa_set_localalloc();
+				break;
+			case MPOL_PREFERRED:
+				numa_set_preferred(td->o.numa_mem_prefer_node);
+				break;
+			case MPOL_DEFAULT:
+			default:
+				break;
+			}
+
+		}
+	}
+#endif
+
 	/*
 	 * May alter parameters that init_io_u() will use, so we need to
 	 * do this first.
diff --git a/examples/numa b/examples/numa
new file mode 100644
index 0000000..b81964f
--- /dev/null
+++ b/examples/numa
@@ -0,0 +1,21 @@
+; setup numa policy for each thread
+; 'numactl --show' to determine the maximum numa nodes
+[global]
+ioengine=libaio
+buffered=0
+rw=randread
+bs=512K
+iodepth=16
+size=512m
+filename=/dev/sdb1
+
+; Fix memory blocks (512K * 16) in numa node 0
+[job1]
+numa_cpu_nodes=0
+numa_mem_policy=bind:0
+
+; Interleave memory blocks (512K * 16) in numa node 0 and 1
+[job2]
+numa_cpu_nodes=0-1
+numa_mem_policy=interleave:0-1
+
diff --git a/fio.1 b/fio.1
index fad0ae4..bf65551 100644
--- a/fio.1
+++ b/fio.1
@@ -646,6 +646,28 @@ may run on.  See \fBsched_setaffinity\fR\|(2).
 .BI cpus_allowed \fR=\fPstr
 Same as \fBcpumask\fR, but allows a comma-delimited list of CPU numbers.
 .TP
+.BI numa_cpu_nodes \fR=\fPstr
+Set this job running on spcified NUMA nodes' CPUs. The arguments allow
+comma delimited list of cpu numbers, A-B ranges, or 'all'.
+.TP
+.BI numa_mem_policy \fR=\fPstr
+Set this job's memory policy and corresponding NUMA nodes. Format of
+the argements:
+.RS
+.TP
+.B <mode>[:<nodelist>]
+.TP
+.B mode
+is one of the following memory policy:
+.TP
+.B default, prefer, bind, interleave, local
+.TP
+.RE
+For \fBdefault\fR and \fBlocal\fR memory policy, no \fBnodelist\fR is
+needed to be specified. For \fBprefer\fR, only one node is
+allowed. For \fBbind\fR and \fBinterleave\fR, \fBnodelist\fR allows
+comma delimited list of numbers, A-B ranges, or 'all'.
+.TP
 .BI startdelay \fR=\fPint
 Delay start of job for the specified number of seconds.
 .TP
diff --git a/fio.h b/fio.h
index 8bb5b03..03e4da1 100644
--- a/fio.h
+++ b/fio.h
@@ -48,6 +48,16 @@ struct thread_data;
 #include <sys/asynch.h>
 #endif
 
+#ifdef FIO_HAVE_LIBNUMA
+#include <linux/mempolicy.h>
+#include <numa.h>
+
+/*
+ * "local" is pseudo-policy
+ */
+#define MPOL_LOCAL MPOL_MAX
+#endif
+
 /*
  * What type of allocation to use for io buffers
  */
@@ -195,6 +205,14 @@ struct thread_options {
 	unsigned int cpumask_set;
 	os_cpu_mask_t verify_cpumask;
 	unsigned int verify_cpumask_set;
+#ifdef FIO_HAVE_LIBNUMA
+	struct bitmask *numa_cpunodesmask;
+	unsigned int numa_cpumask_set;
+	unsigned short numa_mem_mode;
+	unsigned int numa_mem_prefer_node;
+	struct bitmask *numa_memnodesmask;
+	unsigned int numa_memmask_set;
+#endif
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[2];
diff --git a/options.c b/options.c
index 84101d1..e0b7fec 100644
--- a/options.c
+++ b/options.c
@@ -564,6 +564,130 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 }
 #endif
 
+#ifdef FIO_HAVE_LIBNUMA
+static int str_numa_cpunodes_cb(void *data, char *input)
+{
+	struct thread_data *td = data;
+
+	/* numa_parse_nodestring() parses a character string list
+	 * of nodes into a bit mask. The bit mask is allocated by
+	 * numa_allocate_nodemask(), so it should be freed by
+	 * numa_free_nodemask().
+	 */
+	td->o.numa_cpunodesmask = numa_parse_nodestring(input);
+	if (td->o.numa_cpunodesmask == NULL) {
+		log_err("fio: numa_parse_nodestring failed\n");
+		td_verror(td, 1, "str_numa_cpunodes_cb");
+		return 1;
+	}
+
+	td->o.numa_cpumask_set = 1;
+	return 0;
+}
+
+static int str_numa_mpol_cb(void *data, char *input)
+{
+	struct thread_data *td = data;
+	const char * const policy_types[] =
+		{ "default", "prefer", "bind", "interleave", "local" };
+	int i;
+
+	char *nodelist = strchr(input, ':');
+	if (nodelist) {
+		/* NUL-terminate mode */
+		*nodelist++ = '\0';
+	}
+
+	for (i = 0; i <= MPOL_LOCAL; i++) {
+		if (!strcmp(input, policy_types[i])) {
+			td->o.numa_mem_mode = i;
+			break;
+		}
+	}
+	if (i > MPOL_LOCAL) {
+		log_err("fio: memory policy should be: default, prefer, bind, interleave, local\n");
+		goto out;
+	}
+
+	switch (td->o.numa_mem_mode) {
+	case MPOL_PREFERRED:
+		/*
+		 * Insist on a nodelist of one node only
+		 */
+		if (nodelist) {
+			char *rest = nodelist;
+			while (isdigit(*rest))
+				rest++;
+			if (*rest) {
+				log_err("fio: one node only for \'prefer\'\n");
+				goto out;
+			}
+		} else {
+			log_err("fio: one node is needed for \'prefer\'\n");
+			goto out;
+		}
+		break;
+	case MPOL_INTERLEAVE:
+		/*
+		 * Default to online nodes with memory if no nodelist
+		 */
+		if (!nodelist)
+			nodelist = strdup("all");
+		break;
+	case MPOL_LOCAL:
+	case MPOL_DEFAULT:
+		/*
+		 * Don't allow a nodelist
+		 */
+		if (nodelist) {
+			log_err("fio: NO nodelist for \'local\'\n");
+			goto out;
+		}
+		break;
+	case MPOL_BIND:
+		/*
+		 * Insist on a nodelist
+		 */
+		if (!nodelist) {
+			log_err("fio: a nodelist is needed for \'bind\'\n");
+			goto out;
+		}
+		break;
+	}
+
+
+	/* numa_parse_nodestring() parses a character string list
+	 * of nodes into a bit mask. The bit mask is allocated by
+	 * numa_allocate_nodemask(), so it should be freed by
+	 * numa_free_nodemask().
+	 */
+	switch (td->o.numa_mem_mode) {
+	case MPOL_PREFERRED:
+		td->o.numa_mem_prefer_node = atoi(nodelist);
+		break;
+	case MPOL_INTERLEAVE:
+	case MPOL_BIND:
+		td->o.numa_memnodesmask = numa_parse_nodestring(nodelist);
+		if (td->o.numa_memnodesmask == NULL) {
+			log_err("fio: numa_parse_nodestring failed\n");
+			td_verror(td, 1, "str_numa_memnodes_cb");
+			return 1;
+		}
+		break;
+	case MPOL_LOCAL:
+	case MPOL_DEFAULT:
+	default:
+		break;
+	}
+
+	td->o.numa_memmask_set = 1;
+	return 0;
+
+out:
+	return 1;
+}
+#endif
+
 #ifdef FIO_HAVE_TRIM
 static int str_verify_trim_cb(void *data, unsigned long long *val)
 {
@@ -2069,6 +2193,20 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Set CPUs allowed",
 	},
 #endif
+#ifdef FIO_HAVE_LIBNUMA
+	{
+		.name	= "numa_cpu_nodes",
+		.type	= FIO_OPT_STR,
+		.cb	= str_numa_cpunodes_cb,
+		.help	= "NUMA CPU nodes bind",
+	},
+	{
+		.name	= "numa_mem_policy",
+		.type	= FIO_OPT_STR,
+		.cb	= str_numa_mpol_cb,
+		.help	= "NUMA memory policy setup",
+	},
+#endif
 	{
 		.name	= "end_fsync",
 		.type	= FIO_OPT_BOOL,
-- 
1.7.2.3

