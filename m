Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300BC12882C
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995367; cv=none; b=k/V526cnWK8VZKyDDAOgGq8HJzWvPJRqsQZ4N6jDSIcYQFqcfdq5qLMWT/Q3kBdn0SgsDmY+S8l2M/4ACPnUIs7oNB/FQSCvEKU3pmDWgCpZt9GsvmlJJp+vhHxi3cIxLfsK5VyIs0VcPWUy20X8G0jtElMAjAgDZ7A2LUg56M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995367; c=relaxed/simple;
	bh=dwL34Zm92uWMwrwPWiGzG+YuQtBYevqd+YDX+oW6V58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IYB2tubsBjL1Sdwb92NgRRS3ZIJX5GH45HnPpKTLJmulUCOWmV2IZtWAQIzefQupcQLXN9b6+frKo65RuLEkzuMW9FiEJCx+HkIC63/1EC4SS3oZC1wNNCOfGpTXtYnqKWjSRqTpiOB2UY7mi/wAXTPYQCJPJ+UCTKaVn4InVrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Kw1G4UNQ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Kw1G4UNQ"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240215110922epoutp03db785b5fd3da64f27cbbb093d5afe1d2~0BLuBMIhs2484724847epoutp03G
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240215110922epoutp03db785b5fd3da64f27cbbb093d5afe1d2~0BLuBMIhs2484724847epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707995362;
	bh=yo/DRHocjiDXmVYik0qA5QdGtNFCRNop09sOd4suRWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kw1G4UNQf7xnKcncgGBbRZHh6r2eACMLoPmIy0HP9zylWaWj6wddicAk05HkcOHS4
	 bNUbqn1gPEL++IXPLj/HqBKFkDeQY8EBL4mmzPGBHBDLy3vT7LoWAHz5sCiD4qh8lF
	 et/2cXT2kH8gULLCuU1UfCWThZNHidk7OH6C5Ih4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240215110921epcas5p432d383b5a534d0c6efb0d9010f65e3a4~0BLtzlKVb2634026340epcas5p45;
	Thu, 15 Feb 2024 11:09:21 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TbC4b4SzYz4x9Pq; Thu, 15 Feb
	2024 11:09:19 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CE.C7.19369.9D0FDC56; Thu, 15 Feb 2024 20:09:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240215100104epcas5p111b3faaa2981ffea3e137adfae2e4a35~0AQF708cd1502115021epcas5p1Q;
	Thu, 15 Feb 2024 10:01:04 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240215100104epsmtrp2707fc89f99ed88d5b16b326b9ed7735c~0AQF7OxsW1268912689epsmtrp2W;
	Thu, 15 Feb 2024 10:01:04 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-97-65cdf0d9a868
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A9.A0.07368.0E0EDC56; Thu, 15 Feb 2024 19:01:04 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240215100103epsmtip28f67c1ab72900d4adac3ece5c60ca7ff~0AQFDWWVg2363023630epsmtip2p;
	Thu, 15 Feb 2024 10:01:03 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH v2 1/3] trim: add support for multiple ranges
Date: Thu, 15 Feb 2024 20:48:10 +0530
Message-Id: <20240215151812.138370-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240215151812.138370-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmuu7ND2dTDZ585LNYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
	JakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ828IFdxNqfg8J6CB8Yh/
	FyMHh4SAicSUdoMuRi4OIYE9jBIrT9xnh3A+MUp8Of2ApYuRE8j5xihx94E9TMPKI7IQNXsZ
	Jb7+2M0E4XQySXzu/AvWwCagLfHq7Q1mkAYRAQ2JNXdTQcLMAqES/S0dYCXCArYSMzffYgKx
	WQRUJQ79X8QOYvMCxd/vmssKYksIyEvMvPSdHWQMp4CdxNf/ORAlghInZz5hgRgpL9G8dTYz
	yAkSAufYJdb0tbJB9LpILLr0igXCFpZ4dXwLO4QtJfH53V6ommyJTQ9/MkHYBRJHXvQyQ9j2
	Eq2n+sHOZxbQlFi/Sx8iLCsx9dQ6Joi9fBK9v59AtfJK7JgHY6tK/L13G2qttMTNd1ehbA+J
	jVcnskKCaiKjxLq+58wTGBVmIflnFpJ/ZiGsXsDIvIpRKrWgODc9Ndm0wFA3L7UcHsHJ+bmb
	GMGJUCtgB+PqDX/1DjEycTAeYpTgYFYS4Z3UeyZViDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJ
	JucDU3FeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1McwVOlhhL
	BbDb11Qven3aXvJKHsOsmLlfiz+f8Fh4VHV37+t5WosniZa075qzfP+Mt+GMaxum8WhfWu2U
	yjehtNYjzf2GH/PZl78X3rv4aGW4yapHlca13V7MnNrpU/5vvPhlrcERrt+r98s+lIp7F2cb
	+bntxguGw8bWteV7bKxLjPaUPdeqvNCaIc/+4/vF2uMPe9/8S63Vfs28hSNPOkQkR/+XogHb
	8ZdB833/rzFuVZr+33VtCae2583TT02V9D5lGT2cc0LxrNWMrRreqrKsoZM6NmTYZ+9+/8Ns
	XldeRKbzZZE585my9i+/1pzi8FPc1TNOgePDltZ3wj0fORcuf8fZ2PLchyNg0/PDSizFGYmG
	WsxFxYkA0hXK1g0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSvO6DB2dTDRackLFYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnz
	bwgV3E2p+DwnoIHxiH8XIweHhICJxMojsl2MXBxCArsZJZ6vP8gIEZeWWLg+sYuRE8gUllj5
	7zk7RE07k0TbnO/sIAk2AW2JV29vMIPYIgJaEsfWNbGB2MwC4RKNs5+D1QgL2ErM3HyLCcRm
	EVCVOPR/EVicFyj+ftdcVogF8hIzL4HM5ODgFLCT+Po/ByQsBFTy7fsMVohyQYmTM5+wQIyX
	l2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnJhsWGOallusVJ+YWl+al6yXn525iBIeqlsYO
	xnvz/+kdYmTiYDzEKMHBrCTCO6n3TKoQb0piZVVqUX58UWlOavEhRmkOFiVxXsMZs1OEBNIT
	S1KzU1MLUotgskwcnFINTIvqZ89WidA2MZGXPPDlCtsdBcfypXGnj9z7Km3ItdP6xOSFT3WU
	vd9d2F1ddqyBVe7GrNN7ZMVjvF6uebzzt+nZKvl/re5/nnS2hl63nGF9587cNwwHtzh8ynuy
	bfGZg4IdPVNXZCWwJM6JzviSlbN9Qi1HSir3JaX+uP9rWzlrXy5t6Qhqv8Lgp8HyRfmdBvd0
	yRteTu/r/RaG265NEdZQLJm93mh/x/GfhZbpZzj8vjKLzowX4dVKdcjLVj1lOK8r4Yba2XV7
	v0TMfbv0qI7SJEfH9XKWG05fdVzEoc61rtf909T/XxmOfAxUEVj7822P6jUjh7SDr5p2Cqff
	eH2mTbtjboriqbeegcu69imxFGckGmoxFxUnAgASHgdVxAIAAA==
X-CMS-MailID: 20240215100104epcas5p111b3faaa2981ffea3e137adfae2e4a35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240215100104epcas5p111b3faaa2981ffea3e137adfae2e4a35
References: <20240215151812.138370-1-ankit.kumar@samsung.com>
	<CGME20240215100104epcas5p111b3faaa2981ffea3e137adfae2e4a35@epcas5p1.samsung.com>

NVMe specification allow multiple ranges for the dataset management
commands. Currently the block ioctl only allows a single range for
trim, however multiple ranges can be specified using nvme character
device.

Add an option num_range to send multiple range per trim request, which
only works if the data direction is solely trim i.e. trim or randtrim.
Add FIO_MULTI_RANGE_TRIM as the ioengine flag, to restrict the usage of
this new option.
For multi range trim request this modifies the way IO buffers are used.
The buffer length will depend on number of trim ranges and the actual
buffer will contains start and length of each range entry.

This increases fio server version (FIO_SERVER_VER) to 103.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst        |  9 +++++
 backend.c        | 20 ++++++++--
 cconv.c          |  2 +
 fio.1            |  7 ++++
 fio.h            | 18 +++++++++
 init.c           | 13 +++++++
 io_u.c           | 97 ++++++++++++++++++++++++++++++++++++++++--------
 io_u.h           |  4 ++
 ioengines.h      |  2 +
 options.c        | 11 ++++++
 server.h         |  2 +-
 thread_options.h |  3 ++
 12 files changed, 168 insertions(+), 20 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 5bc1713c..4b02100c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2534,6 +2534,15 @@ with the caveat that when used on the command line, they must come after the
 	Specifies logical block application tag mask value, if namespace is
 	formatted to use end to end protection information. Default: 0xffff.
 
+.. option:: num_range=int : [io_uring_cmd]
+
+	For trim command this will be the number of ranges to trim per I/O
+	request. The number of logical blocks per range is determined by the
+	:option:`bs` option which should be a multiple of logical block size.
+	This cannot be used with read or write. Note that setting this
+	option > 1, :option:`log_offset` will not be able to log all the
+	offsets. Default: 1.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/backend.c b/backend.c
index 1fab467a..2f2221bf 100644
--- a/backend.c
+++ b/backend.c
@@ -1333,7 +1333,7 @@ static int init_io_u(struct thread_data *td)
 int init_io_u_buffers(struct thread_data *td)
 {
 	struct io_u *io_u;
-	unsigned long long max_bs, min_write;
+	unsigned long long max_bs, min_write, trim_bs = 0;
 	int i, max_units;
 	int data_xfer = 1;
 	char *p;
@@ -1344,7 +1344,18 @@ int init_io_u_buffers(struct thread_data *td)
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
 
-	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
+	if (td_trim(td) && td->o.num_range > 1) {
+		trim_bs = td->o.num_range * sizeof(struct trim_range);
+		td->orig_buffer_size = trim_bs
+					* (unsigned long long) max_units;
+	}
+
+	/*
+	 * For reads, writes, and multi-range trim operations we need a
+	 * data buffer
+	 */
+	if (td_ioengine_flagged(td, FIO_NOIO) ||
+	    !(td_read(td) || td_write(td) || (td_trim(td) && td->o.num_range > 1)))
 		data_xfer = 0;
 
 	/*
@@ -1396,7 +1407,10 @@ int init_io_u_buffers(struct thread_data *td)
 				fill_verify_pattern(td, io_u->buf, max_bs, io_u, 0, 0);
 			}
 		}
-		p += max_bs;
+		if (td_trim(td) && td->o.num_range > 1)
+			p += trim_bs;
+		else
+			p += max_bs;
 	}
 
 	return 0;
diff --git a/cconv.c b/cconv.c
index c9298408..ead47248 100644
--- a/cconv.c
+++ b/cconv.c
@@ -111,6 +111,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->serialize_overlap = le32_to_cpu(top->serialize_overlap);
 	o->size = le64_to_cpu(top->size);
 	o->io_size = le64_to_cpu(top->io_size);
+	o->num_range = le32_to_cpu(top->num_range);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->io_size_percent = le32_to_cpu(top->io_size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
@@ -609,6 +610,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	top->size = __cpu_to_le64(o->size);
 	top->io_size = __cpu_to_le64(o->io_size);
+	top->num_range = __cpu_to_le32(o->num_range);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/fio.1 b/fio.1
index 7ec5c745..e6b291a7 100644
--- a/fio.1
+++ b/fio.1
@@ -2293,6 +2293,13 @@ end to end protection information. Default: 0x1234.
 Specifies logical block application tag mask value, if namespace is formatted
 to use end to end protection information. Default: 0xffff.
 .TP
+.BI (io_uring_cmd)num_range \fR=\fPint
+For trim command this will be the number of ranges to trim per I/O request.
+The number of logical blocks per range is determined by the \fBbs\fR option
+which should be a multiple of logical block size. This cannot be used with
+read or write. Note that setting this option > 1, \fBlog_offset\fR will not be
+able to log all the offsets. Default: 1.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/fio.h b/fio.h
index 1322656f..fc3e3ece 100644
--- a/fio.h
+++ b/fio.h
@@ -71,6 +71,16 @@
 
 struct fio_sem;
 
+#define MAX_TRIM_RANGE	256
+
+/*
+ * Range for trim command
+ */
+struct trim_range {
+	unsigned long long start;
+	unsigned long long len;
+};
+
 /*
  * offset generator types
  */
@@ -609,6 +619,14 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
 }
 
+static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
+{
+	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
+		return true;
+
+	return false;
+}
+
 static inline bool should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
diff --git a/init.c b/init.c
index 105339fa..7a0b14a3 100644
--- a/init.c
+++ b/init.c
@@ -618,6 +618,19 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (td_trimwrite(td) && o->num_range > 1) {
+		log_err("fio: trimwrite cannot be used with multiple"
+			" ranges.\n");
+		ret |= 1;
+	}
+
+	if (td_trim(td) && o->num_range > 1 &&
+	    !td_ioengine_flagged(td, FIO_MULTI_RANGE_TRIM)) {
+		log_err("fio: can't use multiple ranges with IO engine %s\n",
+			td->io_ops->name);
+		ret |= 1;
+	}
+
 #ifndef CONFIG_PSHARED
 	if (!o->use_thread) {
 		log_info("fio: this platform does not support process shared"
diff --git a/io_u.c b/io_u.c
index 4254675a..2b8e17f8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -940,6 +940,65 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 		fio_file_reset(td, f);
 }
 
+static int fill_multi_range_io_u(struct thread_data *td, struct io_u *io_u)
+{
+	bool is_random;
+	uint64_t buflen, i = 0;
+	struct trim_range *range;
+	struct fio_file *f = io_u->file;
+	uint8_t *buf;
+
+	buf = io_u->buf;
+	buflen = 0;
+
+	while (i < td->o.num_range) {
+		range = (struct trim_range *)buf;
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n",
+			       io_u);
+			break;
+		}
+
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			break;
+		}
+
+		if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
+			dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
+			       io_u,
+			       (unsigned long long) io_u->offset, io_u->buflen,
+			       (unsigned long long) io_u->file->real_file_size);
+			break;
+		}
+
+		range->start = io_u->offset;
+		range->len = io_u->buflen;
+		buflen += io_u->buflen;
+		f->last_start[io_u->ddir] = io_u->offset;
+		f->last_pos[io_u->ddir] = io_u->offset + range->len;
+
+		buf += sizeof(struct trim_range);
+		i++;
+
+		if (td_random(td) && file_randommap(td, io_u->file))
+			mark_random_map(td, io_u, io_u->offset, io_u->buflen);
+		dprint_io_u(io_u, "fill");
+	}
+	if (buflen) {
+		/*
+		 * Set buffer length as overall trim length for this IO, and
+		 * tell the ioengine about the number of ranges to be trimmed.
+		 */
+		io_u->buflen = buflen;
+		io_u->number_trim = i;
+		return 0;
+	}
+
+	return 1;
+}
+
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	bool is_random;
@@ -966,22 +1025,27 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	else if (td->o.zone_mode == ZONE_MODE_ZBD)
 		setup_zbd_zone_mode(td, io_u);
 
-	/*
-	 * No log, let the seq/rand engine retrieve the next buflen and
-	 * position.
-	 */
-	if (get_next_offset(td, io_u, &is_random)) {
-		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
-		return 1;
-	}
+	if (multi_range_trim(td, io_u)) {
+		if (fill_multi_range_io_u(td, io_u))
+			return 1;
+	} else {
+		/*
+		 * No log, let the seq/rand engine retrieve the next buflen and
+		 * position.
+		 */
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
+			return 1;
+		}
 
-	io_u->buflen = get_next_buflen(td, io_u, is_random);
-	if (!io_u->buflen) {
-		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
-		return 1;
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			return 1;
+		}
 	}
-
 	offset = io_u->offset;
+
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		ret = zbd_adjust_block(td, io_u);
 		if (ret == io_u_eof) {
@@ -1004,11 +1068,12 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * mark entry before potentially trimming io_u
 	 */
-	if (td_random(td) && file_randommap(td, io_u->file))
+	if (!multi_range_trim(td, io_u) && td_random(td) && file_randommap(td, io_u->file))
 		io_u->buflen = mark_random_map(td, io_u, offset, io_u->buflen);
 
 out:
-	dprint_io_u(io_u, "fill");
+	if (!multi_range_trim(td, io_u))
+		dprint_io_u(io_u, "fill");
 	io_u->verify_offset = io_u->offset;
 	td->zone_bytes += io_u->buflen;
 	return 0;
@@ -1814,7 +1879,7 @@ struct io_u *get_io_u(struct thread_data *td)
 
 	assert(fio_file_open(f));
 
-	if (ddir_rw(io_u->ddir)) {
+	if (ddir_rw(io_u->ddir) && !multi_range_trim(td, io_u)) {
 		if (!io_u->buflen && !td_ioengine_flagged(td, FIO_NOIO)) {
 			dprint(FD_IO, "get_io_u: zero buflen on %p\n", io_u);
 			goto err_put;
diff --git a/io_u.h b/io_u.h
index 786251d5..cfacf310 100644
--- a/io_u.h
+++ b/io_u.h
@@ -80,6 +80,10 @@ struct io_u {
 
 	struct io_piece *ipo;
 
+	/*
+	 * number of trim ranges for this IO.
+	 */
+	unsigned int number_trim;
 	unsigned long long resid;
 	unsigned int error;
 
diff --git a/ioengines.h b/ioengines.h
index 4391b31e..2fd7f52c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -97,6 +97,8 @@ enum fio_ioengine_flags {
 	FIO_RO_NEEDS_RW_OPEN
 			= 1 << 18,	/* open files in rw mode even if we have a read job; only
 					   affects ioengines using generic_open_file */
+	FIO_MULTI_RANGE_TRIM
+			= 1 << 19,	/* ioengine supports trim with more than one range */
 };
 
 /*
diff --git a/options.c b/options.c
index 1da4de78..25e042d0 100644
--- a/options.c
+++ b/options.c
@@ -2395,6 +2395,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "num_range",
+		.lname	= "Number of ranges",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, num_range),
+		.maxval	= MAX_TRIM_RANGE,
+		.help	= "Number of ranges for trim command",
+		.def	= "1",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "bs",
 		.lname	= "Block size",
diff --git a/server.h b/server.h
index 0eb594ce..6d2659b0 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 102,
+	FIO_SERVER_VER			= 103,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 24f695fe..c2e71518 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -353,6 +353,8 @@ struct thread_options {
 	unsigned long long offset_increment;
 	unsigned long long number_ios;
 
+	unsigned int num_range;
+
 	unsigned int sync_file_range;
 
 	unsigned long long latency_target;
@@ -711,6 +713,7 @@ struct thread_options_pack {
 	uint32_t fdp_plis[FIO_MAX_PLIS];
 	uint32_t fdp_nrpli;
 
+	uint32_t num_range;
 	/*
 	 * verify_pattern followed by buffer_pattern from the unpacked struct
 	 */
-- 
2.25.1

