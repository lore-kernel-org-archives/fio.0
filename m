Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v2 3/4] thread_options: Introduce cgroup_use_bfq
Date: Mon, 31 Aug 2020 11:21:07 +0200
Message-ID: <20200831092104.3892-4-aherrmann@suse.com>
In-Reply-To: <20200831092104.3892-1-aherrmann@suse.com>
References: <20200831092104.3892-1-aherrmann@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 HOWTO            |  6 ++++++
 cconv.c          |  2 ++
 fio.1            |  5 +++++
 options.c        | 11 +++++++++++
 server.h         |  2 +-
 thread_options.h |  7 +++++--
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index e0403b08..4a16534f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2846,6 +2846,12 @@ Threads, processes and job synchronization
 	job completion, set ``cgroup_nodelete=3D1``.  This can be useful if one w=
ants
 	to inspect various cgroup files after job completion. Default: false.
=20
+.. option:: cgroup_use_bfq=3Dbool
+
+	Normally fio will use generic sysfs attributes to set cgroup_weight.
+	To use attributes specific to BFQ IO scheduler set ``cgroup_use_bfq=3D1``=
.
+	Default: false.
+
 .. option:: flow_id=3Dint
=20
 	The ID of the flow. If not specified, it defaults to being a global
diff --git a/cconv.c b/cconv.c
index 4b0c3490..3f99e8d7 100644
--- a/cconv.c
+++ b/cconv.c
@@ -278,6 +278,7 @@ void convert_thread_options_to_cpu(struct thread_option=
s *o,
 	o->continue_on_error =3D le32_to_cpu(top->continue_on_error);
 	o->cgroup_weight =3D le32_to_cpu(top->cgroup_weight);
 	o->cgroup_nodelete =3D le32_to_cpu(top->cgroup_nodelete);
+	o->cgroup_use_bfq =3D le32_to_cpu(top->cgroup_use_bfq);
 	o->uid =3D le32_to_cpu(top->uid);
 	o->gid =3D le32_to_cpu(top->gid);
 	o->flow_id =3D __le32_to_cpu(top->flow_id);
@@ -478,6 +479,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pack *top,
 	top->continue_on_error =3D cpu_to_le32(o->continue_on_error);
 	top->cgroup_weight =3D cpu_to_le32(o->cgroup_weight);
 	top->cgroup_nodelete =3D cpu_to_le32(o->cgroup_nodelete);
+	top->cgroup_use_bfq =3D cpu_to_le32(o->cgroup_use_bfq);
 	top->uid =3D cpu_to_le32(o->uid);
 	top->gid =3D cpu_to_le32(o->gid);
 	top->flow_id =3D __cpu_to_le32(o->flow_id);
diff --git a/fio.1 b/fio.1
index 1c90e4a5..a0896235 100644
--- a/fio.1
+++ b/fio.1
@@ -2544,6 +2544,11 @@ completion. To override this behavior and to leave c=
groups around after the
 job completion, set `cgroup_nodelete=3D1'. This can be useful if one wants
 to inspect various cgroup files after job completion. Default: false.
 .TP
+.BI cgroup_use_bfq \fR=3D\fPbool
+Normally fio will use generic sysfs attributes to set cgroup_weight.
+To use attributes specific to BFQ IO scheduler set ``cgroup_use_bfq=3D1``.
+Default: false.
+.TP
 .BI flow_id \fR=3D\fPint
 The ID of the flow. If not specified, it defaults to being a global
 flow. See \fBflow\fR.
diff --git a/options.c b/options.c
index 251ad2c1..c84e911a 100644
--- a/options.c
+++ b/options.c
@@ -4609,6 +4609,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 		.category =3D FIO_OPT_C_GENERAL,
 		.group	=3D FIO_OPT_G_CGROUP,
 	},
+	{
+		.name	=3D "cgroup_use_bfq",
+		.lname	=3D "Cgroup use-bfq",
+		.type	=3D FIO_OPT_BOOL,
+		.off1	=3D offsetof(struct thread_options, cgroup_use_bfq),
+		.help	=3D "Use cgroup sysfs attributes specific to BFQ",
+		.def	=3D "0",
+		.parent	=3D "cgroup",
+		.category =3D FIO_OPT_C_GENERAL,
+		.group	=3D FIO_OPT_G_CGROUP,
+	},
 	{
 		.name	=3D "uid",
 		.lname	=3D "User ID",
diff --git a/server.h b/server.h
index efa70e7c..3cd60096 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 84,
+	FIO_SERVER_VER			=3D 85,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/thread_options.h b/thread_options.h
index 14f1cbe9..c48ac19e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -302,11 +302,12 @@ struct thread_options {
 	char *profile;
=20
 	/*
-	 * blkio cgroup support
+	 * (blk)io cgroup support
 	 */
 	char *cgroup;
 	unsigned int cgroup_weight;
 	unsigned int cgroup_nodelete;
+	unsigned int cgroup_use_bfq;
=20
 	unsigned int uid;
 	unsigned int gid;
@@ -593,11 +594,13 @@ struct thread_options_pack {
 	uint8_t profile[FIO_TOP_STR_MAX];
=20
 	/*
-	 * blkio cgroup support
+	 * (blk)io cgroup support
 	 */
 	uint8_t cgroup[FIO_TOP_STR_MAX];
 	uint32_t cgroup_weight;
 	uint32_t cgroup_nodelete;
+	uint32_t cgroup_use_bfq;
+	uint32_t pad3;
=20
 	uint32_t uid;
 	uint32_t gid;
--=20
2.28.0


