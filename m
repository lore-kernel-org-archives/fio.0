Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5BCC636D6
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 17:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBIRMt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 12:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBIRMt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 12:12:49 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EC3AD2F
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 09:12:46 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319H1WWJ032705
        for <fio@vger.kernel.org>; Thu, 9 Feb 2023 09:12:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=Aos2zmo30hQ7ZLAJW9IrYiem1iK1uyapTUYkvlLw8GY=;
 b=K69c+NbBE3AVgR9P/Vtw84HQeRW/XBd79WFX1Tmp9FdOwfAjWTx+aRZOIv2mQIpdASob
 Wp5/n8BoWn1N4nUIE5G024d1vBx4vq12lYCFHtI6NSIDArmtx1dngIvuCiuThnvs81Ro
 CNCuqPQS+gfVERXQT3pmCAytmmKiiIAuPOsDI+ym7ucoRgC9eVSZmcdz/r8FBXQwMnq2
 mJ/spBmPgnilGcssmWBc44rSzh+522tXXl9De1m+MdfUiomb0+zSBa8kFfmfd7huBBiQ
 wNyJbqFNR+PkuMu3cRJAPNzDRJYYxDZxwXCqpQJU+uW/97z7Ovbax626xZ2O1zM/x8MA Pw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nmc0et3k2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 09 Feb 2023 09:12:46 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 9 Feb 2023 09:12:44 -0800
Received: from twshared24004.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 9 Feb 2023 09:12:43 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 034FE10F46E73; Thu,  9 Feb 2023 09:12:36 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <fio@vger.kernel.org>, <axboe@kernel.dk>
CC:     <its@irrelevant.dk>, <damien.lemoal@opensource.wdc.com>,
        <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Date:   Thu, 9 Feb 2023 09:12:36 -0800
Message-ID: <20230209171236.1113887-1-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fOLcJ5JewdDZ2XT05d1ELNplsVd9XRKD
X-Proofpoint-ORIG-GUID: fOLcJ5JewdDZ2XT05d1ELNplsVd9XRKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_13,2023-02-09_03,2023-02-09_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
identifiers in write commands. The user can enabled this with the new
"fdp=3D1" parameter for fio's io_uring_cmd ioengine. By default, the fio
jobs will cycle through all the namespace's available placement
identifiers for write commands. The user can limit which placement
identifiers can be used with additional parameter, "fdp_plis=3D<list,>",
which can be used to separate write intensive jobs from less intensive
ones.

Setting up your namespace for FDP is outside the scope of 'fio', so this
assumes the namespace is already properly configured for the mode.

Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
v1->v2:

Actually 'git add' the new source files (Vincent, Ankit)

Added HOWTO and fio.1 documentation on new options (Jens)

Fix whitespace (Jens)

Bump FIO_IOOPS_VERSION (Damien)

Dropped the unnecessary fdp checks and infrastructure for it, relying
only on the iomgmt to provide fdp state.

 HOWTO.rst                  |  10 +++
 Makefile                   |   2 +-
 engines/io_uring.c         |  23 +++++++
 engines/nvme.c             |  39 +++++++++++-
 engines/nvme.h             |  20 ++++++
 examples/uring-cmd-fdp.fio |  37 ++++++++++++
 fdp.c                      | 121 +++++++++++++++++++++++++++++++++++++
 fdp.h                      |  16 +++++
 file.h                     |   3 +
 filesetup.c                |   7 +++
 fio.1                      |   8 +++
 io_u.c                     |   3 +
 io_u.h                     |   3 +
 ioengines.h                |   5 +-
 options.c                  |  49 +++++++++++++++
 thread_options.h           |   7 +++
 16 files changed, 350 insertions(+), 3 deletions(-)
 create mode 100644 examples/uring-cmd-fdp.fio
 create mode 100644 fdp.c
 create mode 100644 fdp.h

diff --git a/HOWTO.rst b/HOWTO.rst
index 17caaf5d..1e4dd25e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2431,6 +2431,16 @@ with the caveat that when used on the command line=
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
+.. option:: fdp_pli=3Dint[,int][,int] : [io_uring_cmd]
+
+	Select which Placement ID Index/Indicies this job is allowed to use for
+	writes. By default, the job will cycle through all available Placement
+	IDs, so use this to isolate these identifiers to specific jobs..
+
 .. option:: cpuload=3Dint : [cpuio]
=20
 	Attempt to use the specified percentage of CPU cycles. This is a mandat=
ory
diff --git a/Makefile b/Makefile
index 5f4e6562..89205ebf 100644
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
diff --git a/engines/io_uring.c b/engines/io_uring.c
index a9abd11d..4d1ee021 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1262,6 +1262,28 @@ static int fio_ioring_cmd_get_max_open_zones(struc=
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
+	bytes =3D sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc=
);
+	ruhs =3D malloc(bytes);
+	memset(ruhs, 0, bytes);
+
+	ret =3D fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
+	if (ret)
+		goto free;
+
+	fruhs_info->nr_ruhs =3D le16_to_cpu(ruhs->nruhsd);
+	for (i =3D 0; i < fruhs_info->nr_ruhs; i++)
+		fruhs_info->plis[i] =3D le16_to_cpu(ruhs->ruhss[i].pid);
+free:
+	free(ruhs);
+	return ret;
+}
+
 static struct ioengine_ops ioengine_uring =3D {
 	.name			=3D "io_uring",
 	.version		=3D FIO_IOOPS_VERSION,
@@ -1307,6 +1329,7 @@ static struct ioengine_ops ioengine_uring_cmd =3D {
 	.get_max_open_zones	=3D fio_ioring_cmd_get_max_open_zones,
 	.options		=3D options,
 	.option_struct_size	=3D sizeof(struct ioring_options),
+	.fdp_fetch_ruhs		=3D fio_ioring_cmd_fetch_ruhs,
 };
=20
 static void fio_init fio_ioring_register(void)
diff --git a/engines/nvme.c b/engines/nvme.c
index 9ffc5303..e23f909d 100644
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
@@ -345,3 +346,39 @@ out:
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
+	}
+
+	close(fd);
+	return -errno;
+}
diff --git a/engines/nvme.h b/engines/nvme.h
index 70a89b74..42ed30a1 100644
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
@@ -192,6 +193,25 @@ struct nvme_zone_report {
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
+int fio_nvme_is_fdp(struct thread_data *td, struct fio_file *f, bool *fd=
p);
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
index 00000000..50ffa392
--- /dev/null
+++ b/fdp.c
@@ -0,0 +1,121 @@
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
+#include <fdp.h>
+
+/*
+ * Maximum number of RUHS to fetch
+ * TODO: Revisit this so that we can work with more than 1024 RUH's
+ */
+#define FDP_FETCH_RUHS_MAX	1024U
+
+static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
+			struct fio_ruhs_info *ruhs)
+{
+	int ret =3D -EINVAL;
+
+	if (td->io_ops && td->io_ops->fdp_fetch_ruhs)
+		ret =3D td->io_ops->fdp_fetch_ruhs(td, f, ruhs);
+	else
+		log_err("%s: engine (%s) lacks fetch ruhs.\n",
+			f->file_name, td->io_ops->name);
+	if (ret < 0) {
+		td_verror(td, errno, "fdp fetch ruhs failed");
+		log_err("%s: fdp fetch ruhs failed (%d).\n",
+			f->file_name, errno);
+	}
+
+	return ret;
+}
+
+static int init_ruh_info(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_ruhs_info *ruhs, *tmp;
+	int i, ret;
+
+	ruhs =3D calloc(1, sizeof(*ruhs) +
+			   FDP_FETCH_RUHS_MAX * sizeof(*ruhs->plis));
+	if (!ruhs)
+		return -ENOMEM;
+
+	ret =3D fdp_ruh_info(td, f, ruhs);
+	if (ret) {
+		log_info("fio: ruh info failed for %s (%d).\n",
+			 f->file_name, -ret);
+		goto out;
+	}
+
+	if (ruhs->nr_ruhs > FDP_FETCH_RUHS_MAX)
+		ruhs->nr_ruhs =3D FDP_FETCH_RUHS_MAX;
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
+	tmp =3D calloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));
+	tmp->nr_ruhs =3D td->o.fdp_nrpli;
+	for (i =3D 0; i < td->o.fdp_nrpli; i++)
+		tmp->plis[i] =3D ruhs->plis[td->o.fdp_plis[i]];
+	f->ruhs_info =3D tmp;
+out:
+	free(ruhs);
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
index cb7047c5..c1f38858 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1417,6 +1417,12 @@ done:
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
@@ -1627,6 +1633,7 @@ void close_and_free_files(struct thread_data *td)
 		}
=20
 		zbd_close_file(f);
+		fdp_free_ruhs_info(f);
 		fio_file_free(f);
 	}
=20
diff --git a/fio.1 b/fio.1
index 527b3d46..b8e9ebfb 100644
--- a/fio.1
+++ b/fio.1
@@ -2192,6 +2192,14 @@ cached data. Currently the RWF_NOWAIT flag does no=
t supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't r=
equired,
 file blocks are fully allocated and the disk request could be issued imm=
ediately.
 .TP
+.BI (io_uring_cmd)fdp \fR=3D\fPbool
+Enable Flexible Data Placement mode for write commands.
+.TP
+.BI (io_uring_cmd)fdp_pli \fR=3D\fPint[,int][,int]
+Select which Placement ID Index/Indicies this job is allowed to use for =
writes.
+By default, the job will cycle through all available Placement IDs, so u=
se this
+to isolate these identifiers to specific jobs.
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
index 49612345..31d232f8 100644
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
@@ -3649,6 +3677,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
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
diff --git a/thread_options.h b/thread_options.h
index 74e7ea45..605eb259 100644
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
@@ -698,6 +703,8 @@ struct thread_options_pack {
 	uint32_t log_entries;
 	uint32_t log_prio;
=20
+	uint32_t fdp;
+
 	/*
 	 * verify_pattern followed by buffer_pattern from the unpacked struct
 	 */
--=20
2.30.2

