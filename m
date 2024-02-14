Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD4125A4
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707893968; cv=none; b=WO38RVjIAUAQdKPhPqbyDZWZgfm6BGsNNT7AMB+z1DkUZ3a9E3Ab0EwIUx3FNwEb9BET9XM11QJb/S7NEJjlY2XMlztK7VRZuJ7kuPF1nIkaX01VfQfFpq/1q3TaSl9SSOQ6u//MGk2bmo9KNk3JqhXQLb60npkNPBCs/oUdGZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707893968; c=relaxed/simple;
	bh=5yR3eykTEgv6KZgo02KzGhTPDaUYTULCRElfJYDNC3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=c/WOUmqjbHVs2KMe1qmCJ1E2vIgDOT0P+r5raHVV38KFiTJo7WkiykPIQlo5qiPHb40gOWBXlRObkDrWxZxkrsL0m+LdKuBJrlvzte5VVr1dfvTTUu5b19YyJmGXtnJG9fJzXq7zEP6eHyYIZo27MYLCTLRpIYq6uK5Uqc5SNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IIcme/SX; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IIcme/SX"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240214065923epoutp032010201fb921d82b26d50eec6e0a197b~zqILDyTEm1097510975epoutp03C
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240214065923epoutp032010201fb921d82b26d50eec6e0a197b~zqILDyTEm1097510975epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707893963;
	bh=zTqJzURGyLjfeZAgwAKVcJBR9YqwtiF1Pr/Eynwg16Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIcme/SXrFP1L1sppHniRHkiqcT+jjyizVHWU6W8KT1vskWOYKLSSjW27K+hkCerG
	 ze0Vlj6mq/0oH6MZ2wzWcq4Uhccbuu2YBh5WHU9RpxNySllIlwb0h6GzpJb0KmLOhp
	 I/F8jEtCpaZRXMMmwH9aEUNBfDJMlbTBtqaokfGM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240214065922epcas5p40ddbfc8be331a6284986070e9de50fab~zqIKyTiqV2166921669epcas5p4K;
	Wed, 14 Feb 2024 06:59:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TZTZd0fWvz4x9Q4; Wed, 14 Feb
	2024 06:59:21 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EF.D9.09672.4C46CC56; Wed, 14 Feb 2024 15:59:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685~zp-eCoMOP2886428864epcas5p49;
	Wed, 14 Feb 2024 06:49:25 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240214064925epsmtrp224f60c023f19c0e1e5294f945d35ece0~zp-eB9st42841428414epsmtrp2g;
	Wed, 14 Feb 2024 06:49:25 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-c7-65cc64c4366f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7C.90.07368.4726CC56; Wed, 14 Feb 2024 15:49:25 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240214064924epsmtip1a87929cd44a768a9d0ed3c2c1d5ac3c9~zp-dFnT230632506325epsmtip1G;
	Wed, 14 Feb 2024 06:49:24 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH 1/3] trim: add support for multiple ranges
Date: Wed, 14 Feb 2024 17:36:22 +0530
Message-Id: <20240214120624.135416-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240214120624.135416-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmuu6RlDOpBlOOm1isufKb3WL13X42
	i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
	vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
	klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMjY8vsBd8iam4On8GcwPj
	Ms8uRk4OCQETiSsT3zKC2EICuxklZm6z6GLkArI/MUrcmrKQCcL5xijx8s0RVpiOxu872SAS
	exklNn2dzgLhdDJJbJz5iw2kik1AW+LV2xvMXYwcHCICGhJr7qaChJkFQiX6WzpYQGxhASuJ
	hpnLmUFsFgFVib9z5jGB2LwCthJzls1nglgmLzHz0nd2EJtTwE7iys7/7BA1ghInZz5hgZgp
	L9G8dTYzyA0SApfYJRbPn88KsldCwEVixWZtiDnCEq+Ob2GHsKUkPr/bywZhZ0tsevgTaleB
	xJEXvcwQtr1E66l+sPOZBTQl1u/ShwjLSkw9tY4JYi2fRO/vJ1CtvBI75sHYQK/cu80CYUtL
	3Hx3Fcr2kJi2aSU0QCcySsx6tYp1AqPCLCTvzELyziyE1QsYmVcxSqYWFOempxabFhjnpZbD
	4zg5P3cTIzgdannvYHz04IPeIUYmDsZDjBIczEoivJdmnEgV4k1JrKxKLcqPLyrNSS0+xGgK
	DO+JzFKiyfnAhJxXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAPT
	KYE+pdYjdaX/98aoSqaGykytca7Krnfl1ZrE8ejRT/mbH/TW7H8pGRi56LyZPJP4UqbIvMzr
	p35Ehkb2TDvwRpPF/0Zig3Sy/dGWY8tN/S5u8t/J9KpR/VCNWDVT1vYvZrlChtvT/xw6y/rR
	OfrzCylz4curG33fc2SvYpZv/6mQ4ef18MaTtQods16dbs0Qur2H4e7VdkY/1UbDAyIu61p8
	VRt1biZum32i86DeWqHjj968XPv7IPOWI+xVNw79neWqz8lv8qNx6ePjB6KL9JUiTb0vy7Tv
	qvIwtpl05+PnuWK5j1y62PI3Trv+uu7vn7OFtoHBd3N3bytudDKZpTA5+jGrgPLjxmunNkYp
	sRRnJBpqMRcVJwIActD+IBAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnG5p0plUg8Y5zBZrrvxmt1h9t5/N
	4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2Pj
	4wvsBV9iKq7On8HcwLjMs4uRk0NCwESi8ftOti5GLg4hgd2MEqvenAVyOIAS0hIL1ydC1AhL
	rPz3nB2ipp1JYuHOfYwgCTYBbYlXb28wg9giAloSx9Y1sYHYzALhEo2zQRo4OYQFrCQaZi4H
	q2ERUJX4O2ceE4jNK2ArMWfZfCaIBfISMy99B6vnFLCTuLLzP5gtBFTz6+91Roh6QYmTM5+w
	QMyXl2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnJhsWGOallusVJ+YWl+al6yXn525iBIes
	lsYOxnvz/+kdYmTiYDzEKMHBrCTCe2nGiVQh3pTEyqrUovz4otKc1OJDjNIcLErivIYzZqcI
	CaQnlqRmp6YWpBbBZJk4OKUamObub77Nu8szhOX1gce3lhfk29pf+TW7tj9GTvrz0g+vVvxZ
	EZNztFUg5n+CQWHRo54ZIma/2eY6fLz4+NaP+VUVNYsknFizKqd94thbcKzpzclQV+Xjpn3b
	OZbVTbTbdfUN/1rL7m9+t08dXC2dtnxR1g77LL71ExVexSc4im3/ePiNTOlEh2qVjCn7ZrDG
	f/p7U7NlW6VyS91ODifnw5+4NXZxH2TmurpkSffLy85HpkvP73+9tSzhpo76smWF25Xl7/Mt
	logw5g/OWLyP6bCv0azUyBfnn5t1/aq5z2t4axWvXEPfyaTA70FCZ+s73F1yVIrvJwe//rdZ
	5cDH4CAv7ie7dwj6M/N3Hd/L3KfEUpyRaKjFXFScCACwkCZnyAIAAA==
X-CMS-MailID: 20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
	<CGME20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685@epcas5p4.samsung.com>

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

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst        |  7 +++++
 backend.c        | 20 ++++++++++--
 cconv.c          |  2 ++
 fio.1            |  6 ++++
 fio.h            | 18 +++++++++++
 init.c           | 13 ++++++++
 io_u.c           | 81 ++++++++++++++++++++++++++++++++++++++----------
 io_u.h           |  4 +++
 ioengines.h      |  2 ++
 options.c        | 11 +++++++
 thread_options.h |  3 ++
 11 files changed, 148 insertions(+), 19 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 5bc1713c..c798613b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2534,6 +2534,13 @@ with the caveat that when used on the command line, they must come after the
 	Specifies logical block application tag mask value, if namespace is
 	formatted to use end to end protection information. Default: 0xffff.
 
+.. option:: num_range=int : [io_uring_cmd]
+
+	For trim command this will be the number of ranges to trim per I/O
+	request. The number of logical blocks per range is determined by the
+	:option:`bs` option which should be a multiple of logical block size.
+	This cannot be used with read or write. Default: 1.
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
index 7ec5c745..cfa49423 100644
--- a/fio.1
+++ b/fio.1
@@ -2293,6 +2293,12 @@ end to end protection information. Default: 0x1234.
 Specifies logical block application tag mask value, if namespace is formatted
 to use end to end protection information. Default: 0xffff.
 .TP
+.BI (io_uring_cmd)num_range \fR=\fPint
+For trim command this will be the number of ranges to trim per I/O request.
+The number of logical blocks per range is determined by the \fBbs\fR option
+which should be a multiple of logical block size. This cannot be used with
+read or write. Default: 1.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/fio.h b/fio.h
index 1322656f..5d558e7b 100644
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
+	else
+		return false;
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
index 13187882..50df518c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -943,8 +943,11 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	bool is_random;
-	uint64_t offset;
+	uint64_t offset, buflen, i = 0;
 	enum io_u_action ret;
+	struct fio_file *f = io_u->file;
+	struct trim_range *range;
+	uint8_t *buf;
 
 	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
@@ -966,22 +969,68 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
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
+		buf = io_u->buf;
+		buflen = 0;
 
-	io_u->buflen = get_next_buflen(td, io_u, is_random);
-	if (!io_u->buflen) {
-		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
-		return 1;
-	}
+		while (i < td->o.num_range) {
+			range = (struct trim_range *)buf;
+			if (get_next_offset(td, io_u, &is_random)) {
+				dprint(FD_IO, "io_u %p, failed getting offset\n",
+				       io_u);
+				break;
+			}
+
+			io_u->buflen = get_next_buflen(td, io_u, is_random);
+			if (!io_u->buflen) {
+				dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+				break;
+			}
+
+			if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
+				dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
+					io_u,
+					(unsigned long long) io_u->offset, io_u->buflen,
+					(unsigned long long) io_u->file->real_file_size);
+				break;
+			}
+
+			range->start = io_u->offset;
+			range->len = io_u->buflen;
+			buflen += io_u->buflen;
+			f->last_start[io_u->ddir] = io_u->offset;
+			f->last_pos[io_u->ddir] = io_u->offset + range->len;
+
+			buf += sizeof(struct trim_range);
+			i++;
 
+			if (td_random(td) && file_randommap(td, io_u->file))
+				mark_random_map(td, io_u, io_u->offset, io_u->buflen);
+		}
+		if (buflen) {
+			io_u->buflen = buflen;
+			io_u->number_trim = i;
+		} else {
+			return 1;
+		}
+	} else {
+		/*
+		 * No log, let the seq/rand engine retrieve the next buflen and
+		 * position.
+		 */
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
+			return 1;
+		}
+
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			return 1;
+		}
+	}
 	offset = io_u->offset;
+
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		ret = zbd_adjust_block(td, io_u);
 		if (ret == io_u_eof) {
@@ -1004,7 +1053,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * mark entry before potentially trimming io_u
 	 */
-	if (td_random(td) && file_randommap(td, io_u->file))
+	if (!multi_range_trim(td, io_u) && td_random(td) && file_randommap(td, io_u->file))
 		io_u->buflen = mark_random_map(td, io_u, offset, io_u->buflen);
 
 out:
@@ -1814,7 +1863,7 @@ struct io_u *get_io_u(struct thread_data *td)
 
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

