Return-Path: <aherrmann@suse.com>
Date: Fri, 28 Aug 2020 12:04:35 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 1/2] thread_options: Add cgroup_use_bfq
Message-ID: <20200828100435.GH6041@suselix>
References: <20200828100230.GG6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200828100230.GG6041@suselix>
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 HOWTO            |  6 ++++++
 cconv.c          |  2 ++
 fio.1            |  5 +++++
 options.c        | 11 +++++++++++
 thread_options.h |  7 +++++--
 5 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index e0403b08..4a16534f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2846,6 +2846,12 @@ Threads, processes and job synchronization
 	job completion, set ``cgroup_nodelete=1``.  This can be useful if one wants
 	to inspect various cgroup files after job completion. Default: false.
 
+.. option:: cgroup_use_bfq=bool
+
+	Normally fio will use generic sysfs attributes to set cgroup_weight.
+	To use attributes specific to BFQ IO scheduler set ``cgroup_use_bfq=1``.
+	Default: false.
+
 .. option:: flow_id=int
 
 	The ID of the flow. If not specified, it defaults to being a global
diff --git a/cconv.c b/cconv.c
index 4b0c3490..3f99e8d7 100644
--- a/cconv.c
+++ b/cconv.c
@@ -278,6 +278,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->continue_on_error = le32_to_cpu(top->continue_on_error);
 	o->cgroup_weight = le32_to_cpu(top->cgroup_weight);
 	o->cgroup_nodelete = le32_to_cpu(top->cgroup_nodelete);
+	o->cgroup_use_bfq = le32_to_cpu(top->cgroup_use_bfq);
 	o->uid = le32_to_cpu(top->uid);
 	o->gid = le32_to_cpu(top->gid);
 	o->flow_id = __le32_to_cpu(top->flow_id);
@@ -478,6 +479,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->continue_on_error = cpu_to_le32(o->continue_on_error);
 	top->cgroup_weight = cpu_to_le32(o->cgroup_weight);
 	top->cgroup_nodelete = cpu_to_le32(o->cgroup_nodelete);
+	top->cgroup_use_bfq = cpu_to_le32(o->cgroup_use_bfq);
 	top->uid = cpu_to_le32(o->uid);
 	top->gid = cpu_to_le32(o->gid);
 	top->flow_id = __cpu_to_le32(o->flow_id);
diff --git a/fio.1 b/fio.1
index 1c90e4a5..a0896235 100644
--- a/fio.1
+++ b/fio.1
@@ -2544,6 +2544,11 @@ completion. To override this behavior and to leave cgroups around after the
 job completion, set `cgroup_nodelete=1'. This can be useful if one wants
 to inspect various cgroup files after job completion. Default: false.
 .TP
+.BI cgroup_use_bfq \fR=\fPbool
+Normally fio will use generic sysfs attributes to set cgroup_weight.
+To use attributes specific to BFQ IO scheduler set ``cgroup_use_bfq=1``.
+Default: false.
+.TP
 .BI flow_id \fR=\fPint
 The ID of the flow. If not specified, it defaults to being a global
 flow. See \fBflow\fR.
diff --git a/options.c b/options.c
index 251ad2c1..c84e911a 100644
--- a/options.c
+++ b/options.c
@@ -4609,6 +4609,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CGROUP,
 	},
+	{
+		.name	= "cgroup_use_bfq",
+		.lname	= "Cgroup use-bfq",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, cgroup_use_bfq),
+		.help	= "Use cgroup sysfs attributes specific to BFQ",
+		.def	= "0",
+		.parent	= "cgroup",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_CGROUP,
+	},
 	{
 		.name	= "uid",
 		.lname	= "User ID",
diff --git a/thread_options.h b/thread_options.h
index 14f1cbe9..0331e881 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -302,11 +302,12 @@ struct thread_options {
 	char *profile;
 
 	/*
-	 * blkio cgroup support
+	 * (blk)io cgroup support
 	 */
 	char *cgroup;
 	unsigned int cgroup_weight;
 	unsigned int cgroup_nodelete;
+	unsigned int cgroup_use_bfq;
 
 	unsigned int uid;
 	unsigned int gid;
@@ -593,11 +594,13 @@ struct thread_options_pack {
 	uint8_t profile[FIO_TOP_STR_MAX];
 
 	/*
-	 * blkio cgroup support
+	 * (blk)io cgroup support
 	 */
 	uint8_t cgroup[FIO_TOP_STR_MAX];
 	uint32_t cgroup_weight;
 	uint32_t cgroup_nodelete;
+	uint32_t cgroup_use_bfq;
+	uint32_t padding;       /* remove when possible to maintain alignment */
 
 	uint32_t uid;
 	uint32_t gid;
-- 
2.28.0


