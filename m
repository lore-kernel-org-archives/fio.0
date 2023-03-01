Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF78AC64ED6
	for <fio@archiver.kernel.org>; Wed,  1 Mar 2023 13:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCANA3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Mar 2023 08:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCANAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Mar 2023 08:00:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBD93E617
        for <fio@vger.kernel.org>; Wed,  1 Mar 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=A3A5gULM3SVW1/RCdJ41UM7Vznl5Qmm8vpYlsn4/tdY=; b=i1GPbd1eQvIIdrcOZUTwijQOLd
        4aOM59x+HX5rkWK89CslA6QTRpPRIaf6hNlTEY7DJyKVxDxwsgiZ1xafYyIuvicMKUg05K57JDSM4
        nxfN29EB3yAlOIKQ34DH5tTQWxfR42/onBYTpcOt08eHF0WV/cBwK9z3uAQVUzPbR0juDb2wuyEwN
        B1bn0GEcJlvO+C4/C/7yBcXf2rJKQY0QvoGXLutkuPA8TB3iVabkd+sQQ69v+oEFQhYxJlTPYmu67
        dGfagdIchOJoemF6sXDoYtKmmaqJsft9v3xQjV4mxPk/orz0yxIxtsVIp0EMkntab1og9q4RHNZ2d
        dJYOS/Kw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXM3w-001ddk-Ev
        for fio@vger.kernel.org; Wed, 01 Mar 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8E0C41BC0170; Wed,  1 Mar 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230301130001.8E0C41BC0170@kernel.dk>
Date:   Wed,  1 Mar 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 8d94106730d11047f313caadda87e450f242f53c:

  Merge branch 'master' of https://github.com/Cuelive/fio (2023-02-28 05:55:55 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5a37211238f995657c50e5d0ea6e5e22ff3ca69e:

  examples: add fiograph diagram for uring-cmd-fdp.fio (2023-02-28 13:58:58 -0500)

----------------------------------------------------------------
Horshack (3):
      ioengines.c:346: td_io_queue: Assertion `res == 0' failed
      Fix "verify bad_hdr rand_seed" for requeued I/Os
      Clarify documentation for runtime parameter

Jens Axboe (5):
      Merge branch 'Fix_Bad_Hdr_Rand_Seed_For_Requeued_IO' of https://github.com/horshack-dpreview/fio
      Merge branch 'Fix_Assert_TdIoQueue_Serialize_Overlap_Offload' of https://github.com/horshack-dpreview/fio
      fdp: cleanup init
      Revert "ioengines.c:346: td_io_queue: Assertion `res == 0' failed"
      Merge branch 'doc-Clarify_Runtime_Param' of https://github.com/horshack-dpreview/fio

Keith Busch (1):
      fio: add fdp support for io_uring_cmd nvme engine

Vincent Fu (2):
      fdp: change the order of includes to fix Windows build error
      examples: add fiograph diagram for uring-cmd-fdp.fio

 HOWTO.rst                  |  22 ++++++--
 Makefile                   |   2 +-
 backend.c                  |   7 ++-
 cconv.c                    |  10 ++++
 engines/io_uring.c         |  24 +++++++++
 engines/nvme.c             |  40 ++++++++++++++-
 engines/nvme.h             |  18 +++++++
 examples/uring-cmd-fdp.fio |  37 ++++++++++++++
 examples/uring-cmd-fdp.png | Bin 0 -> 50265 bytes
 fdp.c                      | 125 +++++++++++++++++++++++++++++++++++++++++++++
 fdp.h                      |  16 ++++++
 file.h                     |   3 ++
 filesetup.c                |   9 ++++
 fio.1                      |  19 +++++--
 io_u.c                     |   5 +-
 io_u.h                     |   4 ++
 ioengines.h                |   5 +-
 options.c                  |  49 ++++++++++++++++++
 server.h                   |   2 +-
 thread_options.h           |   9 ++++
 20 files changed, 391 insertions(+), 15 deletions(-)
 create mode 100644 examples/uring-cmd-fdp.fio
 create mode 100644 examples/uring-cmd-fdp.png
 create mode 100644 fdp.c
 create mode 100644 fdp.h

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 7a0535af..bbd9496e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -686,10 +686,12 @@ Time related parameters
 
 .. option:: runtime=time
 
-	Tell fio to terminate processing after the specified period of time.  It
-	can be quite hard to determine for how long a specified job will run, so
-	this parameter is handy to cap the total runtime to a given time.  When
-	the unit is omitted, the value is interpreted in seconds.
+	Limit runtime. The test will run until it completes the configured I/O
+	workload or until it has run for this specified amount of time, whichever
+	occurs first. It can be quite hard to determine for how long a specified
+	job will run, so this parameter is handy to cap the total runtime to a
+	given time.  When the unit is omitted, the value is interpreted in
+	seconds.
 
 .. option:: time_based
 
@@ -2423,6 +2425,18 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
+.. option:: fdp=bool : [io_uring_cmd]
+
+	Enable Flexible Data Placement mode for write commands.
+
+.. option:: fdp_pli=str : [io_uring_cmd]
+
+	Select which Placement ID Index/Indicies this job is allowed to use for
+	writes. By default, the job will cycle through all available Placement
+        IDs, so use this to isolate these identifiers to specific jobs. If you
+        want fio to use placement identifier only at indices 0, 2 and 5 specify
+        ``fdp_pli=0,2,5``.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/Makefile b/Makefile
index e4cde4ba..6d7fd4e2 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c zbd.c dedupe.c
+		steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/backend.c b/backend.c
index f494c831..975ef489 100644
--- a/backend.c
+++ b/backend.c
@@ -1040,8 +1040,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		}
 
 		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY) {
-			io_u->numberio = td->io_issues[io_u->ddir];
-			populate_verify_io_u(td, io_u);
+			if (!(io_u->flags & IO_U_F_PATTERN_DONE)) {
+				io_u_set(td, io_u, IO_U_F_PATTERN_DONE);
+				io_u->numberio = td->io_issues[io_u->ddir];
+				populate_verify_io_u(td, io_u);
+			}
 		}
 
 		ddir = io_u->ddir;
diff --git a/cconv.c b/cconv.c
index d755844f..05ac75e3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -349,6 +349,11 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
+
+	o->fdp = le32_to_cpu(top->fdp);
+	o->fdp_nrpli = le32_to_cpu(top->fdp_nrpli);
+	for (i = 0; i < o->fdp_nrpli; i++)
+		o->fdp_plis[i] = le32_to_cpu(top->fdp_plis[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -638,6 +643,11 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
+
+	top->fdp = cpu_to_le32(o->fdp);
+	top->fdp_nrpli = cpu_to_le32(o->fdp_nrpli);
+	for (i = 0; i < o->fdp_nrpli; i++)
+		top->fdp_plis[i] = cpu_to_le32(o->fdp_plis[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/engines/io_uring.c b/engines/io_uring.c
index a9abd11d..5393758a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1262,6 +1262,29 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
 	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
 }
 
+static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
+				     struct fio_ruhs_info *fruhs_info)
+{
+	struct nvme_fdp_ruh_status *ruhs;
+	int bytes, ret, i;
+
+	bytes = sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status_desc);
+	ruhs = scalloc(1, bytes);
+	if (!ruhs)
+		return -ENOMEM;
+
+	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
+	if (ret)
+		goto free;
+
+	fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
+	for (i = 0; i < fruhs_info->nr_ruhs; i++)
+		fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
+free:
+	sfree(ruhs);
+	return ret;
+}
+
 static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
@@ -1307,6 +1330,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
+	.fdp_fetch_ruhs		= fio_ioring_cmd_fetch_ruhs,
 };
 
 static void fio_init fio_ioring_register(void)
diff --git a/engines/nvme.c b/engines/nvme.c
index 9ffc5303..da18eba9 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -28,7 +28,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	cmd->cdw10 = slba & 0xffffffff;
 	cmd->cdw11 = slba >> 32;
 	/* cdw12 represent number of lba's for read/write */
-	cmd->cdw12 = nlb;
+	cmd->cdw12 = nlb | (io_u->dtype << 20);
+	cmd->cdw13 = io_u->dspec << 16;
 	if (iov) {
 		iov->iov_base = io_u->xfer_buf;
 		iov->iov_len = io_u->xfer_buflen;
@@ -345,3 +346,40 @@ out:
 	close(fd);
 	return ret;
 }
+
+static inline int nvme_fdp_reclaim_unit_handle_status(int fd, __u32 nsid,
+						      __u32 data_len, void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode		= nvme_cmd_io_mgmt_recv,
+		.nsid		= nsid,
+		.addr		= (__u64)(uintptr_t)data,
+		.data_len 	= data_len,
+		.cdw10		= 1,
+		.cdw11		= (data_len >> 2) - 1,
+	};
+
+	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
+			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	int fd, ret;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	ret = nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs);
+	if (ret) {
+		log_err("%s: nvme_fdp_reclaim_unit_handle_status failed, err=%d\n",
+			f->file_name, ret);
+		errno = ENOTSUP;
+	} else
+		errno = 0;
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
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
+	nvme_cmd_io_mgmt_recv		= 0x12,
 	nvme_zns_cmd_mgmt_send		= 0x79,
 	nvme_zns_cmd_mgmt_recv		= 0x7a,
 };
@@ -192,6 +193,23 @@ struct nvme_zone_report {
 	struct nvme_zns_desc	entries[];
 };
 
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
 
diff --git a/examples/uring-cmd-fdp.fio b/examples/uring-cmd-fdp.fio
new file mode 100644
index 00000000..55d741d3
--- /dev/null
+++ b/examples/uring-cmd-fdp.fio
@@ -0,0 +1,37 @@
+# io_uring_cmd I/O engine for nvme-ns generic character device with FDP enabled
+# This assumes the namespace is already configured with FDP support and has at
+# least 8 available reclaim units.
+#
+# Each job targets different ranges of LBAs with different placement
+# identifiers, and has different write intensity.
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+iodepth=32
+bs=4K
+fdp=1
+time_based=1
+runtime=1000
+
+[write-heavy]
+rw=randrw
+rwmixwrite=90
+fdp_pli=0,1,2,3
+offset=0%
+size=30%
+
+[write-mid]
+rw=randrw
+rwmixwrite=30
+fdp_pli=4,5
+offset=30%
+size=30%
+
+[write-light]
+rw=randrw
+rwmixwrite=10
+fdp_pli=6
+offset=60%
+size=30%
diff --git a/examples/uring-cmd-fdp.png b/examples/uring-cmd-fdp.png
new file mode 100644
index 00000000..251f4fe3
Binary files /dev/null and b/examples/uring-cmd-fdp.png differ
diff --git a/fdp.c b/fdp.c
new file mode 100644
index 00000000..84e04fce
--- /dev/null
+++ b/fdp.c
@@ -0,0 +1,125 @@
+/*
+ * Note: This is similar to a very basic setup
+ * of ZBD devices
+ *
+ * Specify fdp=1 (With char devices /dev/ng0n1)
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "fio.h"
+#include "file.h"
+
+#include "pshared.h"
+#include "fdp.h"
+
+static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
+			struct fio_ruhs_info *ruhs)
+{
+	int ret = -EINVAL;
+
+	if (!td->io_ops) {
+		log_err("fio: no ops set in fdp init?!\n");
+		return ret;
+	}
+
+	if (td->io_ops->fdp_fetch_ruhs) {
+		ret = td->io_ops->fdp_fetch_ruhs(td, f, ruhs);
+		if (ret < 0) {
+			td_verror(td, errno, "fdp fetch ruhs failed");
+			log_err("%s: fdp fetch ruhs failed (%d)\n",
+				f->file_name, errno);
+		}
+	} else {
+		log_err("%s: engine (%s) lacks fetch ruhs\n",
+			f->file_name, td->io_ops->name);
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
+	ruhs = scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
+	if (!ruhs)
+		return -ENOMEM;
+
+	ret = fdp_ruh_info(td, f, ruhs);
+	if (ret) {
+		log_info("fio: ruh info failed for %s (%d)\n",
+			 f->file_name, -ret);
+		goto out;
+	}
+
+	if (ruhs->nr_ruhs > 128)
+		ruhs->nr_ruhs = 128;
+
+	if (td->o.fdp_nrpli == 0) {
+		f->ruhs_info = ruhs;
+		return 0;
+	}
+
+	for (i = 0; i < td->o.fdp_nrpli; i++) {
+		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	tmp = scalloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	tmp->nr_ruhs = td->o.fdp_nrpli;
+	for (i = 0; i < td->o.fdp_nrpli; i++)
+		tmp->plis[i] = ruhs->plis[td->o.fdp_plis[i]];
+	f->ruhs_info = tmp;
+out:
+	sfree(ruhs);
+	return ret;
+}
+
+int fdp_init(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i, ret = 0;
+
+	for_each_file(td, f, i) {
+		ret = init_ruh_info(td, f);
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
+	sfree(f->ruhs_info);
+	f->ruhs_info = NULL;
+}
+
+void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_ruhs_info *ruhs = f->ruhs_info;
+	int dspec;
+
+	if (!ruhs || io_u->ddir != DDIR_WRITE) {
+		io_u->dtype = 0;
+		io_u->dspec = 0;
+		return;
+	}
+
+	dspec = ruhs->plis[ruhs->pli_loc++ % ruhs->nr_ruhs];
+	io_u->dtype = 2;
+	io_u->dspec = dspec;
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
 
 /* Forward declarations */
 struct zoned_block_device_info;
+struct fdp_ruh_info;
 
 /*
  * The type of object we are working on
@@ -101,6 +102,8 @@ struct fio_file {
 	uint64_t file_offset;
 	uint64_t io_size;
 
+	struct fio_ruhs_info *ruhs_info;
+
 	/*
 	 * Zoned block device information. See also zonemode=zbd.
 	 */
diff --git a/filesetup.c b/filesetup.c
index 648f48c6..8e505941 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1407,6 +1407,12 @@ done:
 
 	td_restore_runstate(td, old_state);
 
+	if (td->o.fdp) {
+		err = fdp_init(td);
+		if (err)
+			goto err_out;
+	}
+
 	return 0;
 
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
 
 		zbd_close_file(f);
+		fdp_free_ruhs_info(f);
 		fio_file_free(f);
 	}
 
diff --git a/fio.1 b/fio.1
index e94fad0a..a238331c 100644
--- a/fio.1
+++ b/fio.1
@@ -471,10 +471,12 @@ See \fB\-\-max\-jobs\fR. Default: 1.
 .SS "Time related parameters"
 .TP
 .BI runtime \fR=\fPtime
-Tell fio to terminate processing after the specified period of time. It
-can be quite hard to determine for how long a specified job will run, so
-this parameter is handy to cap the total runtime to a given time. When
-the unit is omitted, the value is interpreted in seconds.
+Limit runtime. The test will run until it completes the configured I/O
+workload or until it has run for this specified amount of time, whichever
+occurs first. It can be quite hard to determine for how long a specified
+job will run, so this parameter is handy to cap the total runtime to a
+given time.  When the unit is omitted, the value is interpreted in
+seconds.
 .TP
 .BI time_based
 If set, fio will run for the duration of the \fBruntime\fR specified
@@ -2184,6 +2186,15 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
+.BI (io_uring_cmd)fdp \fR=\fPbool
+Enable Flexible Data Placement mode for write commands.
+.TP
+.BI (io_uring_cmd)fdp_pli \fR=\fPstr
+Select which Placement ID Index/Indicies this job is allowed to use for writes.
+By default, the job will cycle through all available Placement IDs, so use this
+to isolate these identifiers to specific jobs. If you want fio to use placement
+identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/io_u.c b/io_u.c
index d50d8465..ca7ee68f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -990,6 +990,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
+	if (td->o.fdp)
+		fdp_fill_dspec_data(td, io_u);
+
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
 			io_u,
@@ -2006,7 +2009,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	dprint_io_u(io_u, "complete");
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
-	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
+	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK | IO_U_F_PATTERN_DONE);
 
 	/*
 	 * Mark IO ok to verify
diff --git a/io_u.h b/io_u.h
index 206e24fe..55b4d083 100644
--- a/io_u.h
+++ b/io_u.h
@@ -21,6 +21,7 @@ enum {
 	IO_U_F_TRIMMED		= 1 << 5,
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
+	IO_U_F_PATTERN_DONE	= 1 << 8,
 };
 
 /*
@@ -117,6 +118,9 @@ struct io_u {
 	 */
 	int (*end_io)(struct thread_data *, struct io_u **);
 
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
 
-#define FIO_IOOPS_VERSION	31
+#define FIO_IOOPS_VERSION	32
 
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
@@ -251,6 +251,34 @@ int str_split_parse(struct thread_data *td, char *str,
 	return ret;
 }
 
+static int fio_fdp_cmp(const void *p1, const void *p2)
+{
+	const uint16_t *t1 = p1;
+	const uint16_t *t2 = p2;
+
+	return *t1 - *t2;
+}
+
+static int str_fdp_pli_cb(void *data, const char *input)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	char *str, *p, *v;
+	int i = 0;
+
+	p = str = strdup(input);
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_PLIS)
+		td->o.fdp_plis[i++] = strtoll(v, NULL, 0);
+	free(p);
+
+	qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
+	td->o.fdp_nrpli = i;
+
+	return 0;
+}
+
 static int str_bssplit_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -3643,6 +3671,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name   = "fdp",
+		.lname  = "Flexible data placement",
+		.type   = FIO_OPT_BOOL,
+		.off1   = offsetof(struct thread_options, fdp),
+		.help   = "Use Data placement directive (FDP)",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group  = FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "fdp_pli",
+		.lname	= "FDP Placement ID indicies",
+		.type	= FIO_OPT_STR,
+		.cb	= str_fdp_pli_cb,
+		.off1	= offsetof(struct thread_options, fdp_plis),
+		.help	= "Sets which placement ids to use (defaults to all)",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "lockmem",
 		.lname	= "Lock memory",
diff --git a/server.h b/server.h
index 28133020..898a893d 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 98,
+	FIO_SERVER_VER			= 99,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 74e7ea45..2520357c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -386,6 +386,11 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
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
 
+	uint32_t fdp;
+	uint32_t fdp_plis[FIO_MAX_PLIS];
+	uint32_t fdp_nrpli;
+
 	/*
 	 * verify_pattern followed by buffer_pattern from the unpacked struct
 	 */
