Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29579 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhE0LOG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 May 2021 07:14:06 -0400
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 2/2] zbd: add a new --ignore_zone_limits option
Date: Thu, 27 May 2021 11:12:32 +0000
Message-ID: <20210527111222.122783-2-Niklas.Cassel@wdc.com>
References: <20210527111222.122783-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210527111222.122783-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>

From: Niklas Cassel <niklas.cassel@wdc.com>

In commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned block
device operation") we added a check that verifies that the specified
--max_open_zones value is lower than the max value reported by the device.

For ZNS devices there is a max open zones and a max active zones limit.
For ZAC/ZBC devices there is only a max open zones limit.

On ZAC/ZBC, there is thus no limit on the amount of zones that can be
in zone state closed.
When doing a write to an empty or closed zone, a ZAC/ZBC drive will
close an arbitrary implicit open zone in order to handle the write.

The ZNS specification has no requirement on closing a zone in order to
handle a write to an empty or closed zone. The drive is free to return
an error.

Even on ZAC/ZBC, you do not want to exceed the max open zones limit,
since it will lead to additional implicit close zone and implicit open
zone operations, which may degrade performance.
However, it seems that this is sometimes done on purpose, in order to
measure the overhead of these additional operations. Therefore, add
an option that allows the user to ignore the reported device limits.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
Changes since V2:
- Fixed minor nits reported by Damien.
- Picked up Reviewed-by tag from Damien.

 cconv.c          |  2 ++
 fio.1            |  5 +++++
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 zbd.c            |  2 +-
 6 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/cconv.c b/cconv.c
index d4dfb81b..74c24106 100644
--- a/cconv.c
+++ b/cconv.c
@@ -232,6 +232,7 @@ void convert_thread_options_to_cpu(struct thread_option=
s *o,
 	o->zone_skip =3D le64_to_cpu(top->zone_skip);
 	o->zone_mode =3D le32_to_cpu(top->zone_mode);
 	o->max_open_zones =3D __le32_to_cpu(top->max_open_zones);
+	o->ignore_zone_limits =3D le32_to_cpu(top->ignore_zone_limits);
 	o->lockmem =3D le64_to_cpu(top->lockmem);
 	o->offset_increment_percent =3D le32_to_cpu(top->offset_increment_percent=
);
 	o->offset_increment =3D le64_to_cpu(top->offset_increment);
@@ -575,6 +576,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pack *top,
 	top->zone_skip =3D __cpu_to_le64(o->zone_skip);
 	top->zone_mode =3D __cpu_to_le32(o->zone_mode);
 	top->max_open_zones =3D __cpu_to_le32(o->max_open_zones);
+	top->ignore_zone_limits =3D cpu_to_le32(o->ignore_zone_limits);
 	top->lockmem =3D __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add =3D __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low =3D __cpu_to_le64(o->file_size_low);
diff --git a/fio.1 b/fio.1
index ab08cb01..5aa54a4d 100644
--- a/fio.1
+++ b/fio.1
@@ -835,6 +835,11 @@ threads/processes.
 .BI job_max_open_zones \fR=3D\fPint
 Limit on the number of simultaneously opened zones per single thread/proce=
ss.
 .TP
+.BI ignore_zone_limits \fR=3D\fPbool
+If this isn't set, fio will query the max open zones limit from the zoned =
block
+device, and exit if the specified \fBmax_open_zones\fR value is larger tha=
n the
+limit reported by the device. Default: false.
+.TP
 .BI zone_reset_threshold \fR=3D\fPfloat
 A number between zero and one that indicates the ratio of logical blocks w=
ith
 data to the total number of logical blocks in the test above which zones
diff --git a/options.c b/options.c
index b82a10aa..a8986d11 100644
--- a/options.c
+++ b/options.c
@@ -3492,6 +3492,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 		.category =3D FIO_OPT_C_IO,
 		.group	=3D FIO_OPT_G_INVALID,
 	},
+	{
+		.name	=3D "ignore_zone_limits",
+		.lname	=3D "Ignore zone resource limits",
+		.type	=3D FIO_OPT_BOOL,
+		.off1	=3D offsetof(struct thread_options, ignore_zone_limits),
+		.def	=3D "0",
+		.help	=3D "Ignore the zone resource limits (max open/active zones) repor=
ted by the device",
+		.category =3D FIO_OPT_C_IO,
+		.group	=3D FIO_OPT_G_INVALID,
+	},
 	{
 		.name	=3D "zone_reset_threshold",
 		.lname	=3D "Zone reset threshold",
diff --git a/server.h b/server.h
index 8cf3a60b..c128df28 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 90,
+	FIO_SERVER_VER			=3D 91,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/thread_options.h b/thread_options.h
index 4d48e462..05c2d138 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -355,6 +355,7 @@ struct thread_options {
 	unsigned int read_beyond_wp;
 	int max_open_zones;
 	unsigned int job_max_open_zones;
+	unsigned int ignore_zone_limits;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 };
@@ -657,6 +658,7 @@ struct thread_options_pack {
=20
 	uint32_t zone_mode;
 	int32_t max_open_zones;
+	uint32_t ignore_zone_limits;
 } __attribute__((packed));
=20
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct=
 thread_options_pack *top);
diff --git a/zbd.c b/zbd.c
index 68cd58e1..5d9e331a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -588,7 +588,7 @@ static int zbd_set_max_open_zones(struct thread_data *t=
d, struct fio_file *f)
 	unsigned int max_open_zones;
 	int ret;
=20
-	if (zbd->model !=3D ZBD_HOST_MANAGED) {
+	if (zbd->model !=3D ZBD_HOST_MANAGED || td->o.ignore_zone_limits) {
 		/* Only host-managed devices have a max open limit */
 		zbd->max_open_zones =3D td->o.max_open_zones;
 		goto out;
--=20
2.31.1

