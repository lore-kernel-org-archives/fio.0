Return-Path: <prvs=768d5e3a9=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] zbd: add a new --ignore_zone_limits option
Date: Fri, 21 May 2021 13:39:41 +0000
Message-ID: <20210521133932.269694-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

In commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned block
device operation") we added a check that verifies that the specified
--max_open_zones value is lower than the max value reported by the device.

For ZNS devices there is a max open zones and a max active zones limit.
For ZAC/ZBC devices there is only a max open zones limit.

On ZAC/ZBC, there is thus no limit on the amount of zones that can be
in zone state closed.
When doing a write to an empty or closed zone, a ZAC/ZBC drive will
close an arbitrary implicit open zone in order in order to handle the
write.

The ZNS specification has no requirement on closing a zone in order to
handle a write to an empty or closed zone. The drive is free to return
an error.

Even on ZAC/ZBC, you do not want to exceed the max open zones limit,
since it will lead to additional implicit close zone and implicit open
zone operations, which will degrade performance.
However, it seems that this is sometimes done on purpose, in order to
measure the overhead of these additional operations. Therefore, add
an option that allows the user to ignore the reported device limits.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 fio.1            |  5 +++++
 options.c        | 10 ++++++++++
 thread_options.h |  1 +
 zbd.c            |  2 +-
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index ab08cb01..3519797a 100644
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
+max value reported by the device. Default: false.
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
diff --git a/thread_options.h b/thread_options.h
index 5ecc72d7..a9975480 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -355,6 +355,7 @@ struct thread_options {
 	unsigned int read_beyond_wp;
 	int max_open_zones;
 	unsigned int job_max_open_zones;
+	bool ignore_zone_limits;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 };
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
2.25.1

