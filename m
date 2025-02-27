Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529EA21B9CB
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639835; cv=none; b=V6Agz9xI4LuhBoBzHDR3+zCnMrhkiqq8HreuJ+8WBrMaAyjV5OXj/WYXOU7U3jd0yzoBzNachxBFvo3RKf9vhpXNmzGhDIn0a+A2kmmC2Y7UY/F/WWR299NlykqJoCRWGxtbQgZpDp0+mz/hw3IJkRMsKY6tweHvP/IHR5NC+2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639835; c=relaxed/simple;
	bh=y+rif2pQHaG+WYweXIvVEZLUXXbKa1Ah/JT0ft8//mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nbqav7CdoEGcyACVylvYhfysplp3k2X1YMofrM4R5lxiHHS1POZ3Pkx3B8CZpXrzpAj/6ZkzMjDoGsQZjxAbM5wQRlRAJEU3uKiNCB/YAHOKJRM+3ei8a7v/tXE34UrYYNmxyLXRmsWRz+S2+p//ZJy5LXjtMTj8U9Qaux3QjFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZusSg2HQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZusSg2HQ"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250227070346epoutp02d71c45d47a6aab54b64bed60455b6ddc~n-rMVbJKx1554815548epoutp02m
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250227070346epoutp02d71c45d47a6aab54b64bed60455b6ddc~n-rMVbJKx1554815548epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639826;
	bh=VbB/tl0I2Ajl4GHx/RRfAJTUaR/dgG5i66RnOWMp5Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZusSg2HQSnHFzZ0IUW2dScC5zX/VPfmb4At4Q/JDH6iqGOPnG18WspTSaKYeUJWJx
	 ttg/RbZRNbqIdhdO2Zq7v7SeEVaafkSJ6ERb359W2MAJmVR0vQL7EiEp8XYJZA/yER
	 Z1ozY/h9NJ/QHSr7YB5nugJaOqgoMZwnmg7gU5vw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070345epcas5p3f689ea38b50e29d2ed02dab9d0522e6b~n-rMEoho_1598915989epcas5p31;
	Thu, 27 Feb 2025 07:03:45 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Mkl3sVrz4x9Pw; Thu, 27 Feb
	2025 07:03:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	47.A2.19710.D4E00C76; Thu, 27 Feb 2025 16:03:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250227053353epcas5p4a2895c2563fce082f626977e7d6f0914~n_cuXJRNL0510105101epcas5p44;
	Thu, 27 Feb 2025 05:33:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053353epsmtrp2f2e6c0efa58283d427d7380593e9ec82~n_cuWgwQg2879728797epsmtrp2k;
	Thu, 27 Feb 2025 05:33:53 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-06-67c00e4dcd5c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	23.A3.18729.149FFB76; Thu, 27 Feb 2025 14:33:53 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053353epsmtip2563adb53a3bdf5215c038035ef9edae5~n_ctpBg9w1682416824epsmtip26;
	Thu, 27 Feb 2025 05:33:52 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 04/21] fio: add verify_header_seed option
Date: Thu, 27 Feb 2025 16:17:10 +0530
Message-Id: <20250227104727.1794982-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmuq4v34F0g2XrlS3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmPvtClvBYtOKt+03GRsYb2l3MXJw
	SAiYSExdYtHFyMUhJLCbUWLv734WCOcTo8SdFadYIZxvjBIfv/1k7GLkBOuYsng5VNVeRomt
	k19BVf0Aqpp4hgmkik1AW+LV2xvMIDtEBDQk1txNBQkzC9hJXD38kg0kLCxgKXGmOwskzCKg
	KtH3opEZxOYFKjm4biMbxC55iZmXvrOD2JwC9hJvOhtZIGoEJU7OfMICMVJeonnrbGaQEyQE
	jrFLXO3oZYZodpGYeWgyC4QtLPHq+BZ2CFtK4vO7vVALsiU2PfzJBGEXSBx5AdNrL9F6qh/s
	fGYBTYn1u/QhwrISU0+tY4LYyyfR+/sJVCuvxI55MLaqxN97t6HWSkvcfHcVyvaQ2PV/K1iN
	kMAkYLjt853AqDALyTuzkLwzC2HzAkbmVYySqQXFuempyaYFhnmp5fAoTs7P3cQIToFaLjsY
	b8z/p3eIkYmD8RCjBAezkggvZ+aedCHelMTKqtSi/Pii0pzU4kOMpsDwnsgsJZqcD0zCeSXx
	hiaWBiZmZmYmlsZmhkrivM07W9KFBNITS1KzU1MLUotg+pg4OKUamEyjQsoXW26uKN3yaHnp
	5e/cnH9ZprvavGGLeuL94HFej03JubzzvMVGpw5P2ymhsH2JPFfpDz8dxUuVhuvXvT2mMetF
	Zt097p08ceEe65MXx17lWsO9dIKnlVjpheAFGrrmh09w/dC/2Gdyz3vyuckxxRNnTPdSdAh7
	E/A8ZJeiXJPGmnq/EzfYDbvUm9defuNlcLp4ilHGKX+7F3X7gt7uv+R47UvUIsHTH6ZM58yv
	WGnqMOPw3P8TX93P+nLwvtyN9RfMGa22tO+at1Jux3s3qZWsOhcvKDFuXMyjHvh001XHvSd2
	H3/z3vr4XWPvhFNVrC4C07du+7kze58+H3t+U2qUmohWUaXt3M3zX/sqsRRnJBpqMRcVJwIA
	sKjFjAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSvK7jz/3pBmf/6VisufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx99sVtoLF
	phVv228yNjDe0u5i5OSQEDCRmLJ4OQuILSSwm1HifZdtFyMHUFxaYuH6RIgSYYmV/56zdzFy
	AZV8Y5Q4umwTM0iCTUBb4tXbG2C2iICWxLF1TWwgNrOAg8S/XVvYQOYIC1hKnOnOAgmzCKhK
	9L1oBCvnFbCTOLhuIxvEfHmJmZe+s4PYnAL2Em86G6HOsZNYMPEbE0S9oMTJmU9YIMbLSzRv
	nc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgoNUS3MH4/ZV
	H/QOMTJxMB5ilOBgVhLh5czcky7Em5JYWZValB9fVJqTWnyIUZqDRUmcV/xFb4qQQHpiSWp2
	ampBahFMlomDU6qBKer2t9A1NgYzpkt0z5TpNpq5NWjppFt/D20PNiwO3HPETopP+1JC7XGu
	RP5fUzJvB6VnFNyUCVsgP/HIQscmO/Pjqy2r/r/Yr7X47PMje3yLH8YGcwQ0lmuUvLz1Ifiy
	d0rPzj+h3zyfzI5eZeV+99hJ38CWd/IM187fquFYYrhj/6d50tFvzm//8GiOT9h+bQGD9tI3
	Vcs+JXNl5zp+EmGM6Lh88egiYfVkf5f/BRIXdiRMa5W/vcnXn/e/2bJw8dzjhc+O7vUMOqja
	/v6Bdn3hZrGSk7N/cEXp29tL6pzM0fimo66r+mVvcLlzmupxOcaywJVHTwro6k38IN5wS+1P
	38UkOc7fjQ6n/2ZfUGIpzkg01GIuKk4EAHnFdk7BAgAA
X-CMS-MailID: 20250227053353epcas5p4a2895c2563fce082f626977e7d6f0914
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053353epcas5p4a2895c2563fce082f626977e7d6f0914
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053353epcas5p4a2895c2563fce082f626977e7d6f0914@epcas5p4.samsung.com>

Add a new option to disable the verify header seed check. The header
seed check is enabled by default.
There have been numerous issues observed with header seed mismatch. Hence
this allows end user to disable this check, and proceed with the checksum
verification. This is similar to option verify_write_sequence, which
allows the capability to disable write sequence number check.

Update the documentation accordingly.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst        | 14 ++++++++++++--
 cconv.c          |  2 ++
 fio.1            | 12 ++++++++++--
 options.c        | 11 +++++++++++
 server.h         |  2 +-
 thread_options.h |  3 ++-
 verify.c         |  2 +-
 7 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index c7c131e7..a221b9d8 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3830,8 +3830,9 @@ Verification
 	of the job. Each verification method also implies verification of special
 	header, which is written to the beginning of each block. This header also
 	includes meta information, like offset of the block, block number, timestamp
-	when block was written, etc.  :option:`verify` can be combined with
-	:option:`verify_pattern` option.  The allowed values are:
+	when block was written, initial seed value used to generate the buffer
+	contents etc. :option:`verify` can be combined with :option:`verify_pattern`
+	option.  The allowed values are:
 
 		**md5**
 			Use an md5 sum of the data area and store it in the header of
@@ -4029,6 +4030,15 @@ Verification
         fail).
         Defaults to true.
 
+.. option:: verify_header_seed=bool
+
+	Verify the header seed value which was used to generate the buffer contents.
+	In certain scenarios with read / verify only workloads, when
+	:option:`norandommap` is enabled, with offset modifiers
+	(refer :option:`readwrite` and :option:`rw_sequencer`) etc verification of
+	header seed may fail. Disabling this option will mean that header seed
+	checking is skipped. Defaults to true.
+
 .. option:: trim_percentage=int
 
 	Number of verify blocks to discard/trim.
diff --git a/cconv.c b/cconv.c
index ef3fbaa8..df841703 100644
--- a/cconv.c
+++ b/cconv.c
@@ -183,6 +183,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_interval = le32_to_cpu(top->verify_interval);
 	o->verify_offset = le32_to_cpu(top->verify_offset);
 	o->verify_write_sequence = le32_to_cpu(top->verify_write_sequence);
+	o->verify_header_seed = le32_to_cpu(top->verify_header_seed);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
 	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
@@ -444,6 +445,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_interval = cpu_to_le32(o->verify_interval);
 	top->verify_offset = cpu_to_le32(o->verify_offset);
 	top->verify_write_sequence = cpu_to_le32(o->verify_write_sequence);
+	top->verify_header_seed = cpu_to_le32(o->verify_header_seed);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
 	top->verify_fatal = cpu_to_le32(o->verify_fatal);
 	top->verify_dump = cpu_to_le32(o->verify_dump);
diff --git a/fio.1 b/fio.1
index 88d3be81..dd6d9546 100644
--- a/fio.1
+++ b/fio.1
@@ -3554,8 +3554,9 @@ If writing to a file, fio can verify the file contents after each iteration
 of the job. Each verification method also implies verification of special
 header, which is written to the beginning of each block. This header also
 includes meta information, like offset of the block, block number, timestamp
-when block was written, etc. \fBverify\fR can be combined with
-\fBverify_pattern\fR option. The allowed values are:
+when block was written, initial seed value used to generate the buffer
+contents, etc. \fBverify\fR can be combined with \fBverify_pattern\fR option.
+The allowed values are:
 .RS
 .RS
 .TP
@@ -3751,6 +3752,13 @@ useful for testing atomic writes, as it means that checksum verification can
 still be attempted. For when \fBatomic\fR is enabled, checksum verification
 is expected to succeed (while write sequence checking can still fail).
 .TP
+.BI verify_header_seed \fR=\fPbool
+Verify the header seed value which was used to generate the buffer contents.
+In certain scenarios with read / verify only workloads, when \fBnorandommap\fR
+is enabled, with offset modifiers (refer options \fBreadwrite\fR and
+\fBrw_sequencer\fR), etc verification of header seed may fail. Disabling this
+option will mean that header seed checking is skipped. Defaults to true.
+.TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
diff --git a/options.c b/options.c
index c35878f7..416bc91c 100644
--- a/options.c
+++ b/options.c
@@ -3408,6 +3408,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_header_seed",
+		.lname	= "Verify header seed",
+		.off1	= offsetof(struct thread_options, verify_header_seed),
+		.type	= FIO_OPT_BOOL,
+		.def	= "1",
+		.help	= "Verify the header seed used to generate the buffer contents",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 #ifdef FIO_HAVE_TRIM
 	{
 		.name	= "trim_percentage",
diff --git a/server.h b/server.h
index d31cd688..e5968112 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 108,
+	FIO_SERVER_VER			= 109,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 4d8addc4..d25ba891 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -157,6 +157,7 @@ struct thread_options {
 	unsigned int verify_state;
 	unsigned int verify_state_save;
 	unsigned int verify_write_sequence;
+	unsigned int verify_header_seed;
 	unsigned int use_thread;
 	unsigned int unlink;
 	unsigned int unlink_each_loop;
@@ -485,7 +486,7 @@ struct thread_options_pack {
 	uint32_t verify_state;
 	uint32_t verify_state_save;
 	uint32_t verify_write_sequence;
-	uint32_t pad2;
+	uint32_t verify_header_seed;
 	uint32_t use_thread;
 	uint32_t unlink;
 	uint32_t unlink_each_loop;
diff --git a/verify.c b/verify.c
index 570c888f..49d44982 100644
--- a/verify.c
+++ b/verify.c
@@ -833,7 +833,7 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 			hdr->len, hdr_len);
 		goto err;
 	}
-	if (hdr->rand_seed != io_u->rand_seed) {
+	if (td->o.verify_header_seed && (hdr->rand_seed != io_u->rand_seed)) {
 		log_err("verify: bad header rand_seed %"PRIu64
 			", wanted %"PRIu64,
 			hdr->rand_seed, io_u->rand_seed);
-- 
2.25.1

