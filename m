Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C97C64ED6
	for <fio@archiver.kernel.org>; Mon, 27 Feb 2023 15:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjB0Pyo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjB0Pyn (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Feb 2023 10:54:43 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C841ADE0
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 07:54:41 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RAwkjw009052
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 07:54:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=O3SrO9qzCAMLfMjmUbwrdMoiHiRb2CQHeyYXin0xles=;
 b=mfL7SSMhaID6OQhJQNdCjjxsnNXR1VS8XKcTKwLel2bEbXQLMI7NWHyqYx1tK0R5pzGt
 /JziksXcXl3EalhkFqMtPUwGOioatTKNQ//U/Vrl+aBIIiTlg63jQI/AXEADcsQH7wNi
 jZ7wx02Omvdu+9iDy2HX3D5H1b+2PXrQUY3Nrnu8CM5QxkloIR9Qp/OCbNTfakmEjTNh
 f+QLqmS/McwJ5dm3GuTx8owBaC5sRItEbQ570LkhAUp+9uZtw/pnsPmotOXRrQRIHojj
 iUvPjd/jtUTXbKvlX91hbnrmY8/9one+YC63iak2V26lZkQlomKJ+/AyOc9ftD0Aa1uU 7Q== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nygy5m81s-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 07:54:40 -0800
Received: from twshared4298.02.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Feb 2023 07:54:36 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 5CA29125750F6; Mon, 27 Feb 2023 07:51:35 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <fio@vger.kernel.org>, <axboe@kernel.dk>
CC:     <its@irrelevant.dk>, <vincentfu@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCHv4] fio: add fdp support for io_uring_cmd nvme engine
Date:   Mon, 27 Feb 2023 07:51:34 -0800
Message-ID: <20230227155134.819147-1-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: idikpg9lhhB6WreInFFJZMrXgp_r_4ee
X-Proofpoint-ORIG-GUID: idikpg9lhhB6WreInFFJZMrXgp_r_4ee
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_12,2023-02-27_01,2023-02-09_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
identifiers in write commands. The user can enabled this with the new
"fdp=3D1" parameter for fio's io_uring_cmd ioengine. By default, the fio
jobs will cycle through all the namespace's available placement
identifiers for write commands. The user can limit which placement
identifiers can be used with additional parameter, "fdp_pli=3D<list,>",
which can be used to separate write intensive jobs from less intensive
ones.

Setting up your namespace for FDP is outside the scope of 'fio', so this
assumes the namespace is already properly configured for the mode.

Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
v3->v4:

  Used scalloc instead of calloc (Ankit)

  Check for NULL alloc (Damien)

  Don't log the same ioengine error (Damien)

  Fixed reclaim unit handles memory leak on file free

 HOWTO.rst                  |  12 ++++
 Makefile                   |   2 +-
 cconv.c                    |  10 ++++
 engines/io_uring.c         |  24 ++++++++
 engines/nvme.c             |  40 ++++++++++++-
 engines/nvme.h             |  18 ++++++
 examples/uring-cmd-fdp.fio |  37 ++++++++++++
 fdp.c                      | 119 +++++++++++++++++++++++++++++++++++++
 fdp.h                      |  16 +++++
 file.h                     |   3 +
 filesetup.c                |   9 +++
 fio.1                      |   9 +++
 io_u.c                     |   3 +
 io_u.h                     |   3 +
 ioengines.h                |   5 +-
 options.c                  |  49 +++++++++++++++
 server.h                   |   2 +-
 thread_options.h           |   9 +++
 18 files changed, 366 insertions(+), 4 deletions(-)
 create mode 100644 examples/uring-cmd-fdp.fio
 create mode 100644 fdp.c
 create mode 100644 fdp.h

diff --git a/HOWTO.rst b/HOWTO.rst
index 7a0535af..4ac9ffe2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2423,6 +2423,18 @@ with the caveat that when used on the command line=
, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't =
required,
 	file blocks are fully allocated and the disk request could be issued im=
mediately.
=20
+.. option:: fdp=3Dbool : [io_uring_cmd]
+
+	Enable Flexible Data Placement mode for write commands.
+
+.. option:: fdp_pli=3Dstr : [io_uring_cmd]
+
+	Select which Placement ID Index/Indicies this job is allowed to use for
+	writes. By default, the job will cycle through all available Placement
+        IDs, so use this to isolate these identifiers to specific jobs. =
If you
+        want fio to use placement identifier only at indices 0, 2 and 5 =
specify
+        ``fdp_pli=3D0,2,5``.
+
 .. option:: cpuload=3Dint : [cpuio]
=20
 	Attempt to use the specified percentage of CPU cycles. This is a mandat=
ory
diff --git a/Makefile b/Makefile
index e4cde4ba..6d7fd4e2 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard =
$(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c dedupe.c
+		steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
=20
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS=3D -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I =
$(FIO_LIBHDFS_INCLUDE)
diff --git a/cconv.c b/cconv.c
index d755844f..05ac75e3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -349,6 +349,11 @@ int convert_thread_options_to_cpu(struct thread_opti=
ons *o,
=20
 	for (i =3D 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->merge_blktrace_iters[i].u.f =3D fio_uint64_to_double(le64_to_cpu(to=
p->merge_blktrace_iters[i].u.i));
+
+	o->fdp =3D le32_to_cpu(top->fdp);
+	o->fdp_nrpli =3D le32_to_cpu(top->fdp_nrpli);
+	for (i =3D 0; i < o->fdp_nrpli; i++)
+		o->fdp_plis[i] =3D le32_to_cpu(top->fdp_plis[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -638,6 +643,11 @@ void convert_thread_options_to_net(struct thread_opt=
ions_pack *top,
=20
 	for (i =3D 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->merge_blktrace_iters[i].u.i =3D __cpu_to_le64(fio_double_to_uint6=
4(o->merge_blktrace_iters[i].u.f));
+
+	top->fdp =3D cpu_to_le32(o->fdp);
+	top->fdp_nrpli =3D cpu_to_le32(o->fdp_nrpli);
+	for (i =3D 0; i < o->fdp_nrpli; i++)
+		top->fdp_plis[i] =3D cpu_to_le32(o->fdp_plis[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/engines/io_uring.c b/engines/io_uring.c
index a9abd11d..5393758a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1262,6 +1262,29 @@ static int fio_ioring_cmd_get_max_open_zones(struc=
t thread_data *td,
 	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
 }
=20
+static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_=
file *f,
+				     struct fio_ruhs_info *fruhs_info)
+{
+	struct nvme_fdp_ruh_status *ruhs;
+	int bytes, ret, i;
+
+	bytes =3D sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status_desc)=
;
+	ruhs =3D scalloc(1, bytes);
+	if (!ruhs)
+		return -ENOMEM;
+
+	ret =3D fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
+	if (ret)
+		goto free;
+
+	fruhs_info->nr_ruhs =3D le16_to_cpu(ruhs->nruhsd);
+	for (i =3D 0; i < fruhs_info->nr_ruhs; i++)
+		fruhs_info->plis[i] =3D le16_to_cpu(ruhs->ruhss[i].pid);
+free:
+	sfree(ruhs);
+	return ret;
+}
+
 static struct ioengine_ops ioengine_uring =3D {
 	.name			=3D "io_uring",
 	.version		=3D FIO_IOOPS_VERSION,
@@ -1307,6 +1330,7 @@ static struct ioengine_ops ioengine_uring_cmd =3D {
 	.get_max_open_zones	=3D fio_ioring_cmd_get_max_open_zones,
 	.options		=3D options,
 	.option_struct_size	=3D sizeof(struct ioring_options),
+	.fdp_fetch_ruhs		=3D fio_ioring_cmd_fetch_ruhs,
 };
=20
 static void fio_init fio_ioring_register(void)
diff --git a/engines/nvme.c b/engines/nvme.c
index 9ffc5303..da18eba9 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -28,7 +28,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd,=
 struct io_u *io_u,
 	cmd->cdw10 =3D slba & 0xffffffff;
 	cmd->cdw11 =3D slba >> 32;
 	/* cdw12 represent number of lba's for read/write */
-	cmd->cdw12 =3D nlb;
+	cmd->cdw12 =3D nlb | (io_u->dtype << 20);
+	cmd->cdw13 =3D io_u->dspec << 16;
 	if (iov) {
 		iov->iov_base =3D io_u->xfer_buf;
 		iov->iov_len =3D io_u->xfer_buflen;
@@ -345,3 +346,40 @@ out:
 	close(fd);
 	return ret;
 }
+
+static inline int nvme_fdp_reclaim_unit_handle_status(int fd, __u32 nsid=
,
+						      __u32 data_len, void *data)
+{
+	struct nvme_passthru_cmd cmd =3D {
+		.opcode		=3D nvme_cmd_io_mgmt_recv,
+		.nsid		=3D nsid,
+		.addr		=3D (__u64)(uintptr_t)data,
+		.data_len 	=3D data_len,
+		.cdw10		=3D 1,
+		.cdw11		=3D (data_len >> 2) - 1,
+	};
+
+	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
+			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
+{
+	struct nvme_data *data =3D FILE_ENG_DATA(f);
+	int fd, ret;
+
+	fd =3D open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	ret =3D nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs=
);
+	if (ret) {
+		log_err("%s: nvme_fdp_reclaim_unit_handle_status failed, err=3D%d\n",
+			f->file_name, ret);
+		errno =3D ENOTSUP;
+	} else
+		errno =3D 0;
+
+	close(fd);
+	return -errno;
+}
diff --git a/engines/nvme.h b/engines/nvme.h
index 70a89b74..1c0e526b 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -67,6 +67,7 @@ enum nvme_admin_opcode {
 enum nvme_io_opcode {
 	nvme_cmd_write			=3D 0x01,
 	nvme_cmd_read			=3D 0x02,
+	nvme_cmd_io_mgmt_recv		=3D 0x12,
 	nvme_zns_cmd_mgmt_send		=3D 0x79,
 	nvme_zns_cmd_mgmt_recv		=3D 0x7a,
 };
@@ -192,6 +193,23 @@ struct nvme_zone_report {
 	struct nvme_zns_desc	entries[];
 };
=20
+struct nvme_fdp_ruh_status_desc {
+	__u16 pid;
+	__u16 ruhid;
+	__u32 earutr;
+	__u64 ruamw;
+	__u8  rsvd16[16];
+};
+
+struct nvme_fdp_ruh_status {
+	__u8  rsvd0[14];
+	__le16 nruhsd;
+	struct nvme_fdp_ruh_status_desc ruhss[];
+};
+
+int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
+			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
+
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		      __u64 *nlba);
=20
diff --git a/examples/uring-cmd-fdp.fio b/examples/uring-cmd-fdp.fio
new file mode 100644
index 00000000..55d741d3
--- /dev/null
+++ b/examples/uring-cmd-fdp.fio
@@ -0,0 +1,37 @@
+# io_uring_cmd I/O engine for nvme-ns generic character device with FDP =
enabled
+# This assumes the namespace is already configured with FDP support and =
has at
+# least 8 available reclaim units.
+#
+# Each job targets different ranges of LBAs with different placement
+# identifiers, and has different write intensity.
+
+[global]
+filename=3D/dev/ng0n1
+ioengine=3Dio_uring_cmd
+cmd_type=3Dnvme
+iodepth=3D32
+bs=3D4K
+fdp=3D1
+time_based=3D1
+runtime=3D1000
+
+[write-heavy]
+rw=3Drandrw
+rwmixwrite=3D90
+fdp_pli=3D0,1,2,3
+offset=3D0%
+size=3D30%
+
+[write-mid]
+rw=3Drandrw
+rwmixwrite=3D30
+fdp_pli=3D4,5
+offset=3D30%
+size=3D30%
+
+[write-light]
+rw=3Drandrw
+rwmixwrite=3D10
+fdp_pli=3D6
+offset=3D60%
+size=3D30%
diff --git a/fdp.c b/fdp.c
new file mode 100644
index 00000000..52b1c0b4
--- /dev/null
+++ b/fdp.c
@@ -0,0 +1,119 @@
+/*
+ * Note: This is similar to a very basic setup
+ * of ZBD devices
+ *
+ * Specify fdp=3D1 (With char devices /dev/ng0n1)
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "file.h"
+#include "fio.h"
+
+#include "pshared.h"
+#include "fdp.h"
+
+static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
+			struct fio_ruhs_info *ruhs)
+{
+	int ret =3D -EINVAL;
+
+	if (td->io_ops && td->io_ops->fdp_fetch_ruhs) {
+		ret =3D td->io_ops->fdp_fetch_ruhs(td, f, ruhs);
+		if (ret < 0) {
+			td_verror(td, errno, "fdp fetch ruhs failed");
+			log_err("%s: fdp fetch ruhs failed (%d)\n",
+				f->file_name, errno);
+		}
+	} else
+		log_err("%s: engine (%s) lacks fetch ruhs\n",
+			f->file_name, td->io_ops->name);
+
+	return ret;
+}
+
+static int init_ruh_info(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_ruhs_info *ruhs, *tmp;
+	int i, ret;
+
+	ruhs =3D scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
+	if (!ruhs)
+		return -ENOMEM;
+
+	ret =3D fdp_ruh_info(td, f, ruhs);
+	if (ret) {
+		log_info("fio: ruh info failed for %s (%d)\n",
+			 f->file_name, -ret);
+		goto out;
+	}
+
+	if (ruhs->nr_ruhs > 128)
+		ruhs->nr_ruhs =3D 128;
+
+	if (td->o.fdp_nrpli =3D=3D 0) {
+		f->ruhs_info =3D ruhs;
+		return 0;
+	}
+
+	for (i =3D 0; i < td->o.fdp_nrpli; i++) {
+		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
+			ret =3D -EINVAL;
+			goto out;
+		}
+	}
+
+	tmp =3D scalloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));
+	if (!tmp) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	tmp->nr_ruhs =3D td->o.fdp_nrpli;
+	for (i =3D 0; i < td->o.fdp_nrpli; i++)
+		tmp->plis[i] =3D ruhs->plis[td->o.fdp_plis[i]];
+	f->ruhs_info =3D tmp;
+out:
+	sfree(ruhs);
+	return ret;
+}
+
+int fdp_init(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i, ret =3D 0;
+
+	for_each_file(td, f, i) {
+		ret =3D init_ruh_info(td, f);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+void fdp_free_ruhs_info(struct fio_file *f)
+{
+	if (!f->ruhs_info)
+		return;
+	free(f->ruhs_info);
+	f->ruhs_info =3D NULL;
+}
+
+void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f =3D io_u->file;
+	struct fio_ruhs_info *ruhs =3D f->ruhs_info;
+	int dspec;
+
+	if (!ruhs || io_u->ddir !=3D DDIR_WRITE) {
+		io_u->dtype =3D 0;
+		io_u->dspec =3D 0;
+		return;
+	}
+
+	dspec =3D ruhs->plis[ruhs->pli_loc++ % ruhs->nr_ruhs];
+	io_u->dtype =3D 2;
+	io_u->dspec =3D dspec;
+}
diff --git a/fdp.h b/fdp.h
new file mode 100644
index 00000000..81691f62
--- /dev/null
+++ b/fdp.h
@@ -0,0 +1,16 @@
+#ifndef FIO_FDP_H
+#define FIO_FDP_H
+
+#include "io_u.h"
+
+struct fio_ruhs_info {
+	uint32_t nr_ruhs;
+	uint32_t pli_loc;
+	uint16_t plis[];
+};
+
+int fdp_init(struct thread_data *td);
+void fdp_free_ruhs_info(struct fio_file *f);
+void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
+
+#endif /* FIO_FDP_H */
diff --git a/file.h b/file.h
index da1b8947..deb36e02 100644
--- a/file.h
+++ b/file.h
@@ -12,6 +12,7 @@
=20
 /* Forward declarations */
 struct zoned_block_device_info;
+struct fdp_ruh_info;
=20
 /*
  * The type of object we are working on
@@ -101,6 +102,8 @@ struct fio_file {
 	uint64_t file_offset;
 	uint64_t io_size;
=20
+	struct fio_ruhs_info *ruhs_info;
+
 	/*
 	 * Zoned block device information. See also zonemode=3Dzbd.
 	 */
diff --git a/filesetup.c b/filesetup.c
index 648f48c6..8e505941 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1407,6 +1407,12 @@ done:
=20
 	td_restore_runstate(td, old_state);
=20
+	if (td->o.fdp) {
+		err =3D fdp_init(td);
+		if (err)
+			goto err_out;
+	}
+
 	return 0;
=20
 err_offset:
@@ -1584,6 +1590,8 @@ void fio_file_free(struct fio_file *f)
 {
 	if (fio_file_axmap(f))
 		axmap_free(f->io_axmap);
+	if (f->ruhs_info)
+		sfree(f->ruhs_info);
 	if (!fio_file_smalloc(f)) {
 		free(f->file_name);
 		free(f);
@@ -1617,6 +1625,7 @@ void close_and_free_files(struct thread_data *td)
 		}
=20
 		zbd_close_file(f);
+		fdp_free_ruhs_info(f);
 		fio_file_free(f);
 	}
=20
diff --git a/fio.1 b/fio.1
index e94fad0a..159d6d91 100644
--- a/fio.1
+++ b/fio.1
@@ -2184,6 +2184,15 @@ cached data. Currently the RWF_NOWAIT flag does no=
t supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't r=
equired,
 file blocks are fully allocated and the disk request could be issued imm=
ediately.
 .TP
+.BI (io_uring_cmd)fdp \fR=3D\fPbool
+Enable Flexible Data Placement mode for write commands.
+.TP
+.BI (io_uring_cmd)fdp_pli \fR=3D\fPstr
+Select which Placement ID Index/Indicies this job is allowed to use for =
writes.
+By default, the job will cycle through all available Placement IDs, so u=
se this
+to isolate these identifiers to specific jobs. If you want fio to use pl=
acement
+identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=3D=
0,2,5`.
+.TP
 .BI (cpuio)cpuload \fR=3D\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandato=
ry
 option when using cpuio I/O engine.
diff --git a/io_u.c b/io_u.c
index eb617e64..42e70177 100644
--- a/io_u.c
+++ b/io_u.c
@@ -988,6 +988,9 @@ static int fill_io_u(struct thread_data *td, struct i=
o_u *io_u)
 			return 1;
 	}
=20
+	if (td->o.fdp)
+		fdp_fill_dspec_data(td, io_u);
+
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=3D0x%llx + len=3D0x%llx exceeds file size=3D=
0x%llx\n",
 			io_u,
diff --git a/io_u.h b/io_u.h
index 206e24fe..13b26d37 100644
--- a/io_u.h
+++ b/io_u.h
@@ -117,6 +117,9 @@ struct io_u {
 	 */
 	int (*end_io)(struct thread_data *, struct io_u **);
=20
+	uint32_t dtype;
+	uint32_t dspec;
+
 	union {
 #ifdef CONFIG_LIBAIO
 		struct iocb iocb;
diff --git a/ioengines.h b/ioengines.h
index ea799180..9484265e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -7,8 +7,9 @@
 #include "flist.h"
 #include "io_u.h"
 #include "zbd_types.h"
+#include "fdp.h"
=20
-#define FIO_IOOPS_VERSION	31
+#define FIO_IOOPS_VERSION	32
=20
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -63,6 +64,8 @@ struct ioengine_ops {
 				  unsigned int *);
 	int (*finish_zone)(struct thread_data *, struct fio_file *,
 			   uint64_t, uint64_t);
+	int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
+			      struct fio_ruhs_info *);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/options.c b/options.c
index 536ba91c..91049af5 100644
--- a/options.c
+++ b/options.c
@@ -251,6 +251,34 @@ int str_split_parse(struct thread_data *td, char *st=
r,
 	return ret;
 }
=20
+static int fio_fdp_cmp(const void *p1, const void *p2)
+{
+	const uint16_t *t1 =3D p1;
+	const uint16_t *t2 =3D p2;
+
+	return *t1 - *t2;
+}
+
+static int str_fdp_pli_cb(void *data, const char *input)
+{
+	struct thread_data *td =3D cb_data_to_td(data);
+	char *str, *p, *v;
+	int i =3D 0;
+
+	p =3D str =3D strdup(input);
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	while ((v =3D strsep(&str, ",")) !=3D NULL && i < FIO_MAX_PLIS)
+		td->o.fdp_plis[i++] =3D strtoll(v, NULL, 0);
+	free(p);
+
+	qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
+	td->o.fdp_nrpli =3D i;
+
+	return 0;
+}
+
 static int str_bssplit_cb(void *data, const char *input)
 {
 	struct thread_data *td =3D cb_data_to_td(data);
@@ -3643,6 +3671,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 		.category =3D FIO_OPT_C_IO,
 		.group	=3D FIO_OPT_G_ZONE,
 	},
+	{
+		.name   =3D "fdp",
+		.lname  =3D "Flexible data placement",
+		.type   =3D FIO_OPT_BOOL,
+		.off1   =3D offsetof(struct thread_options, fdp),
+		.help   =3D "Use Data placement directive (FDP)",
+		.def	=3D "0",
+		.category =3D FIO_OPT_C_IO,
+		.group  =3D FIO_OPT_G_INVALID,
+	},
+	{
+		.name	=3D "fdp_pli",
+		.lname	=3D "FDP Placement ID indicies",
+		.type	=3D FIO_OPT_STR,
+		.cb	=3D str_fdp_pli_cb,
+		.off1	=3D offsetof(struct thread_options, fdp_plis),
+		.help	=3D "Sets which placement ids to use (defaults to all)",
+		.hide	=3D 1,
+		.category =3D FIO_OPT_C_IO,
+		.group	=3D FIO_OPT_G_INVALID,
+	},
 	{
 		.name	=3D "lockmem",
 		.lname	=3D "Lock memory",
diff --git a/server.h b/server.h
index 28133020..898a893d 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 98,
+	FIO_SERVER_VER			=3D 99,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/thread_options.h b/thread_options.h
index 74e7ea45..2520357c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -386,6 +386,11 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
=20
+#define FIO_MAX_PLIS 16
+	unsigned int fdp;
+	unsigned int fdp_plis[FIO_MAX_PLIS];
+	unsigned int fdp_nrpli;
+
 	unsigned int log_entries;
 	unsigned int log_prio;
 };
@@ -698,6 +703,10 @@ struct thread_options_pack {
 	uint32_t log_entries;
 	uint32_t log_prio;
=20
+	uint32_t fdp;
+	uint32_t fdp_plis[FIO_MAX_PLIS];
+	uint32_t fdp_nrpli;
+
 	/*
 	 * verify_pattern followed by buffer_pattern from the unpacked struct
 	 */
--=20
2.30.2

