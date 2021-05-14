Return-Path: <prvs=761aa9a9b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 3/4] ioengines: add get_max_open_zones zoned block device
 operation
Date: Fri, 14 May 2021 12:53:14 +0000
Message-ID: <20210514125233.10508-4-Niklas.Cassel@wdc.com>
References: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Define a new IO engine operation to get the maximum number of open zones.
Like the existing IO engine operations: .get_zoned_model, .report_zones,
and .reset_wp, this new IO engine operation is only valid for zoned block
devices.

Similarly to the other zbd IO engine operations, also provide a default
implementation inside oslib/linux-blkzoned.c that will be used if the
ioengine does not override it.

The default Linux oslib implementation is implemented similarly to
blkzoned_get_zoned_model(), i.e. it will return a successful error code
even when the sysfs attribute does not exist.
This is because the sysfs max_open_zones attribute was introduced first
in Linux v5.9.
All error handling is still there, so an ioengine that provides its own
implementation will still have its error code respected properly.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/skeleton_external.c | 13 ++++++
 ioengines.h                 |  4 +-
 oslib/blkzoned.h            |  7 +++
 oslib/linux-blkzoned.c      | 21 +++++++++
 zbd.c                       | 90 ++++++++++++++++++++++++++++++++++---
 5 files changed, 129 insertions(+), 6 deletions(-)

diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 7f3e4cb3..c79b6f11 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -193,6 +193,18 @@ static int fio_skeleton_reset_wp(struct thread_data *t=
d, struct fio_file *f,
 	return 0;
 }
=20
+/*
+ * Hook called for getting the maximum number of open zones for a
+ * ZBD_HOST_MANAGED zoned block device.
+ * A @max_open_zones value set to zero means no limit.
+ */
+static int fio_skeleton_get_max_open_zones(struct thread_data *td,
+					   struct fio_file *f,
+					   unsigned int *max_open_zones)
+{
+	return 0;
+}
+
 /*
  * Note that the structure is exported, so that fio can get it via
  * dlsym(..., "ioengine"); for (and only for) external engines.
@@ -212,6 +224,7 @@ struct ioengine_ops ioengine =3D {
 	.get_zoned_model =3D fio_skeleton_get_zoned_model,
 	.report_zones	=3D fio_skeleton_report_zones,
 	.reset_wp	=3D fio_skeleton_reset_wp,
+	.get_max_open_zones =3D fio_skeleton_get_max_open_zones,
 	.options	=3D options,
 	.option_struct_size	=3D sizeof(struct fio_skeleton_options),
 };
diff --git a/ioengines.h b/ioengines.h
index 1d01ab0a..b3f755b4 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
=20
-#define FIO_IOOPS_VERSION	29
+#define FIO_IOOPS_VERSION	30
=20
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -59,6 +59,8 @@ struct ioengine_ops {
 			    uint64_t, struct zbd_zone *, unsigned int);
 	int (*reset_wp)(struct thread_data *, struct fio_file *,
 			uint64_t, uint64_t);
+	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
+				  unsigned int *);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 4cc071dc..719b041d 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -16,6 +16,8 @@ extern int blkzoned_report_zones(struct thread_data *td,
 				struct zbd_zone *zones, unsigned int nr_zones);
 extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
+extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_=
file *f,
+				       unsigned int *max_open_zones);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -44,6 +46,11 @@ static inline int blkzoned_reset_wp(struct thread_data *=
td, struct fio_file *f,
 {
 	return -EIO;
 }
+static inline int blkzoned_get_max_open_zones(struct thread_data *td, stru=
ct fio_file *f,
+					      unsigned int *max_open_zones)
+{
+	return -EIO;
+}
 #endif
=20
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 84a64ed3..6f89ec6f 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -162,6 +162,27 @@ int blkzoned_get_zoned_model(struct thread_data *td, s=
truct fio_file *f,
 	return 0;
 }
=20
+int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f=
,
+				unsigned int *max_open_zones)
+{
+	char *max_open_str;
+
+	if (f->filetype !=3D FIO_TYPE_BLOCK)
+		return -EIO;
+
+	max_open_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_zo=
nes");
+	if (!max_open_str)
+		return 0;
+
+	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",
+	       f->file_name, max_open_str);
+	*max_open_zones =3D atoll(max_open_str);
+
+	free(max_open_str);
+
+	return 0;
+}
+
 static uint64_t zone_capacity(struct blk_zone_report *hdr,
 			      struct blk_zone *blkz)
 {
diff --git a/zbd.c b/zbd.c
index 46ff9aeb..68cd58e1 100644
--- a/zbd.c
+++ b/zbd.c
@@ -113,6 +113,34 @@ int zbd_reset_wp(struct thread_data *td, struct fio_fi=
le *f,
 	return ret;
 }
=20
+/**
+ * zbd_get_max_open_zones - Get the maximum number of open zones
+ * @td: FIO thread data
+ * @f: FIO file for which to get max open zones
+ * @max_open_zones: Upon success, result will be stored here.
+ *
+ * A @max_open_zones value set to zero means no limit.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+			   unsigned int *max_open_zones)
+{
+	int ret;
+
+	if (td->io_ops && td->io_ops->get_max_open_zones)
+		ret =3D td->io_ops->get_max_open_zones(td, f, max_open_zones);
+	else
+		ret =3D blkzoned_get_max_open_zones(td, f, max_open_zones);
+	if (ret < 0) {
+		td_verror(td, errno, "get max open zones failed");
+		log_err("%s: get max open zones failed (%d).\n",
+			f->file_name, errno);
+	}
+
+	return ret;
+}
+
 /**
  * zbd_zone_idx - convert an offset into a zone number
  * @f: file pointer.
@@ -554,6 +582,51 @@ out:
 	return ret;
 }
=20
+static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file =
*f)
+{
+	struct zoned_block_device_info *zbd =3D f->zbd_info;
+	unsigned int max_open_zones;
+	int ret;
+
+	if (zbd->model !=3D ZBD_HOST_MANAGED) {
+		/* Only host-managed devices have a max open limit */
+		zbd->max_open_zones =3D td->o.max_open_zones;
+		goto out;
+	}
+
+	/* If host-managed, get the max open limit */
+	ret =3D zbd_get_max_open_zones(td, f, &max_open_zones);
+	if (ret)
+		return ret;
+
+	if (!max_open_zones) {
+		/* No device limit */
+		zbd->max_open_zones =3D td->o.max_open_zones;
+	} else if (!td->o.max_open_zones) {
+		/* No user limit. Set limit to device limit */
+		zbd->max_open_zones =3D max_open_zones;
+	} else if (td->o.max_open_zones <=3D max_open_zones) {
+		/* Both user limit and dev limit. User limit not too large */
+		zbd->max_open_zones =3D td->o.max_open_zones;
+	} else {
+		/* Both user limit and dev limit. User limit too large */
+		td_verror(td, EINVAL,
+			  "Specified --max_open_zones is too large");
+		log_err("Specified --max_open_zones (%d) is larger than max (%u)\n",
+			td->o.max_open_zones, max_open_zones);
+		return -EINVAL;
+	}
+
+out:
+	/* Ensure that the limit is not larger than FIO's internal limit */
+	zbd->max_open_zones =3D min_not_zero(zbd->max_open_zones,
+					   (uint32_t) ZBD_MAX_OPEN_ZONES);
+	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
+	       f->file_name, zbd->max_open_zones);
+
+	return 0;
+}
+
 /*
  * Allocate zone information and store it into f->zbd_info if zonemode=3Dz=
bd.
  *
@@ -576,9 +649,13 @@ static int zbd_create_zone_info(struct thread_data *td=
, struct fio_file *f)
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
 		ret =3D parse_zone_info(td, f);
+		if (ret)
+			return ret;
 		break;
 	case ZBD_NONE:
 		ret =3D init_zone_info(td, f);
+		if (ret)
+			return ret;
 		break;
 	default:
 		td_verror(td, EINVAL, "Unsupported zoned model");
@@ -586,12 +663,15 @@ static int zbd_create_zone_info(struct thread_data *t=
d, struct fio_file *f)
 		return -EINVAL;
 	}
=20
-	if (ret =3D=3D 0) {
-		f->zbd_info->model =3D zbd_model;
-		f->zbd_info->max_open_zones =3D
-			min_not_zero(td->o.max_open_zones, ZBD_MAX_OPEN_ZONES);
+	f->zbd_info->model =3D zbd_model;
+
+	ret =3D zbd_set_max_open_zones(td, f);
+	if (ret) {
+		zbd_free_zone_info(f);
+		return ret;
 	}
-	return ret;
+
+	return 0;
 }
=20
 void zbd_free_zone_info(struct fio_file *f)
--=20
2.25.1

