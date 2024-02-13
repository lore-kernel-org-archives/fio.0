Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AE8224FD
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707820259; cv=none; b=L0xiZe8HrLiW6fPVYgBIMGMB0LNzIH9kfTHLdgfum852gs0l9oIamqAk/ADpX50gRYQ6HPsdhp7rdwhBuVORyIb/gxnxbmPf0aDCo3M3BL6QtM8NZowbbebC3DQ0IksTuVu7BEJAJwrnt0xNAohYsnIUUvaD5ORPE/7af0qREXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707820259; c=relaxed/simple;
	bh=Gb2NcTMyjLPpvMM9uROKNkNcDhKjCUxPA2zFeLQo7yY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ooi98q9i8BMP3FUhh5ANErhRlQMzoniOnWmYvnxKPl3s2s1857G+AJXfCAJhDm1h/vdo9OkNKZYW4RM21CeOx+OxjvQ2mtTtIrjKSRCxsT68vzNmgavAiOiSSvZ2kge+EnwkbUSaeO/NyZewmgEpoChQKsbXpgj/vr4dNVEE9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QqqXmKOg; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QqqXmKOg"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240213103055epoutp0443bb0455bcdee54d1a058748cc6d296e~zZXlkvg_i1813918139epoutp04b
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240213103055epoutp0443bb0455bcdee54d1a058748cc6d296e~zZXlkvg_i1813918139epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707820255;
	bh=iOZOjKlg2n435+5984EU02nLP4KTFyscBeXvus3qQOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqqXmKOglD3wJGJPpzDKDUvuUKPqXn+Qg6rtwcYHaTaUt2VBdkmoowMcR5f6WolVL
	 V5HEYGIROH5vROlSTJAWH2R2jSBHGjz4/QbPQHVEPBdeuz6fLd5rJPlB6QWZOLvZ5v
	 XsOMoVUwiTkts5t3nt46iaVPVCz5aM8Krb8X6pQs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240213103055epcas5p14553dfdbd98a58354833a1a4a0833dd3~zZXlIfTQn2511725117epcas5p1f;
	Tue, 13 Feb 2024 10:30:55 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TYyK82QnMz4x9Q8; Tue, 13 Feb
	2024 10:30:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.E0.19369.CD44BC56; Tue, 13 Feb 2024 19:30:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c~zZKpt4Gkm0062900629epcas5p3t;
	Tue, 13 Feb 2024 10:16:06 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240213101606epsmtrp123d4eee358013b9b3818580fdb11ed09~zZKptUZPa0831308313epsmtrp1-;
	Tue, 13 Feb 2024 10:16:06 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-75-65cb44dcee94
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.AE.08817.6614BC56; Tue, 13 Feb 2024 19:16:06 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101606epsmtip1b97823c4a0c21ec30e7e3025f0aca819~zZKo_Yxv00104501045epsmtip1k;
	Tue, 13 Feb 2024 10:16:05 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 4/5] engines/xnvme: add checks for verify, block size and
 metadata size
Date: Tue, 13 Feb 2024 21:03:14 +0530
Message-Id: <20240213153315.134202-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240213153315.134202-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmpu4dl9OpBtOf81msufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd8fbPBMaC96IVX/pmMTUwXhTsYuTk
	kBAwkXix8i1zFyMXh5DAHkaJc3eWs0E4nxglWta8Y4dwvjFK/N54hQ2mZeHP1SwQib2MEvf/
	LIGq6mSSaJ67kh2kik1AW+LV2xtAgzk4RAQ0JNbcTQUJMwvYSVw9/BJskLBApMS21wtZQGwW
	AVWJtVf3g7XyCthKXH8yhRVimbzEzEvfweKcQL1737WwQdQISpyc+YQFYqa8RPPW2WA/SAgc
	Y5f4fmwnE0Szi8TfcyAJEFtY4tXxLewQtpTEy/42KDtbYtPDn1D1BRJHXvRC1dtLtJ7qB7uf
	WUBTYv0ufYiwrMTUU+uYIPbySfT+fgLVyiuxYx6MrSrx995tFghbWuLmu6tQtofE3IVXwGwh
	gYmMElvWyE1gVJiF5J1ZSN6ZhbB5ASPzKkap1ILi3PTUZNMCQ9281HJ4LCfn525iBCdCrYAd
	jKs3/NU7xMjEwXiIUYKDWUmE99KME6lCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YivNK
	4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamDi3fFZ4JlbUMCuI4Gf
	5nM6t8wK5g3Z8ptDa/KZ754JHgu0Jp298E393cmci9abAt/5vH067Sir2e16gfIJG6auD1/u
	qOzhUCduv7jtcZNPZmirFlO1sVXZ3MUL9DJD7gRuvlGhWbzDwXP1t1L7yEydbbun/c0I8//v
	/iv5qsea/yL2L1S2zevfyHSwwSvIKdE9eoLRzpevJOMqOsL03GIvRV+OL94gs5f9w6eMjHXq
	vyvVBBZPXfJt8kdut3y3C080OF/Xpouy73HdvOlO9cJdGW7dMzmezbBWPdcoPUVUYfenI1vW
	P5KXmHzt+/yklBIdi9b51XGRnl94lB4GLLXbys+3RXNvqKVkvLCUvZoSS3FGoqEWc1FxIgCw
	6vuDDQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnG6a4+lUg4NndS3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mp4+2cCY8F7
	0YovfbOYGhgvCnYxcnJICJhILPy5mqWLkYtDSGA3o8TaZ31ADgdQQlpi4fpEiBphiZX/nrND
	1LQzSew+dYcNJMEmoC3x6u0NZhBbREBL4ti6JrA4s4CDxL9dW9hA5ggLhEvM+VoAEmYRUJVY
	e3U/O4jNK2Arcf3JFFaI+fISMy99B4tzCthJ7H3XAjZGCKjmypTVUPWCEidnPmGBGC8v0bx1
	NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDlMtrR2Me1Z9
	0DvEyMTBeIhRgoNZSYT30owTqUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v73uTRESSE8sSc1O
	TS1ILYLJMnFwSjUwyWlMuTm3/JKeXJc/k3N6X7HKrj9NvM/tqn+4qK7Jua0pp92Uq3d/re6J
	9inLJbe1HVGyvHd/+px1mizFmXe5V/2Tl/UJXs2sqcllP6u4gPvj9+C++SsK0g+oaqptnh2f
	flas33XJC22RkO1i703yPhiwpR9+dC/cXOzB3D0iOkGfNnN58DTfnOP7YEUQd12o856L3swf
	kxPWTlhoe7aKf5/Nki3RyascoruO5s02Sp20PDWrt//AY5PXd4y/hx8VvTVx2/3lqhdsS770
	cG2Sd67QMpxhfyDrslNk/cUXN8JmOu7/NetPkcekE3s9NqUa5Gx/ev/pY/kdkdXfznwQnexy
	5/2h1jm/JjG6fuZTUGIpzkg01GIuKk4EAPHNXhLCAgAA
X-CMS-MailID: 20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
	<CGME20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c@epcas5p3.samsung.com>

Add checks to ensure that the correct block size and metadata size is
passed by the user.
Disable normal verify checks when end to end data protection checks
are enabled because of CRC conflict.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/xnvme.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/engines/xnvme.c b/engines/xnvme.c
index c726b805..a8137286 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -11,6 +11,7 @@
 #include <assert.h>
 #include <libxnvme.h>
 #include "fio.h"
+#include "verify.h"
 #include "zbd_types.h"
 #include "fdp.h"
 #include "optgroup.h"
@@ -345,6 +346,49 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
 	td->io_ops_data = NULL;
 }
 
+static int _verify_options(struct thread_data *td, struct fio_file *f,
+			   struct xnvme_fioe_fwrap *fwrap)
+{
+	struct xnvme_fioe_options *o = td->eo;
+	unsigned int correct_md_size;
+
+	for_each_rw_ddir(ddir) {
+		if (td->o.min_bs[ddir] % fwrap->lba_nbytes || td->o.max_bs[ddir] % fwrap->lba_nbytes) {
+			if (!fwrap->lba_pow2) {
+				log_err("ioeng->_verify_options(%s): block size must be a multiple of %u "
+					"(LBA data size + Metadata size)\n", f->file_name, fwrap->lba_nbytes);
+			} else {
+				log_err("ioeng->_verify_options(%s): block size must be a multiple of LBA data size\n",
+					f->file_name);
+			}
+			return 1;
+		}
+		if (ddir == DDIR_TRIM)
+			continue;
+
+		correct_md_size = (td->o.max_bs[ddir] / fwrap->lba_nbytes) * fwrap->md_nbytes;
+		if (fwrap->md_nbytes && fwrap->lba_pow2 && (o->md_per_io_size < correct_md_size)) {
+			log_err("ioeng->_verify_options(%s): md_per_io_size should be at least %u bytes\n",
+				f->file_name, correct_md_size);
+			return 1;
+		}
+	}
+
+	/*
+	 * For extended logical block sizes we cannot use verify when
+	 * end to end data protection checks are enabled, as the PI
+	 * section of data buffer conflicts with verify.
+	 */
+	if (fwrap->md_nbytes && fwrap->geo->pi_type && !fwrap->lba_pow2 &&
+	    td->o.verify != VERIFY_NONE) {
+		log_err("ioeng->_verify_options(%s): for extended LBA, verify cannot be used when E2E data protection is enabled\n",
+			f->file_name);
+		return 1;
+	}
+
+	return 0;
+}
+
 /**
  * Helper function setting up device handles as addressed by the naming
  * convention of the given `fio_file` filename.
@@ -411,6 +455,11 @@ static int _dev_open(struct thread_data *td, struct fio_file *f)
 		fwrap->md_nbytes = 0;
 	}
 
+	if (_verify_options(td, f, fwrap)) {
+		td_verror(td, EINVAL, "_dev_open");
+		goto failure;
+	}
+
 	fwrap->fio_file = f;
 	fwrap->fio_file->filetype = FIO_TYPE_BLOCK;
 	fwrap->fio_file->real_file_size = fwrap->geo->tbytes;
-- 
2.25.1

