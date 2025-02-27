Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E69D21D595
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639850; cv=none; b=mHik/mGaJGNbqqaFcsXFD+CK+e9GQz8CCc2Q6rI1JbV7Gc8OS/tF5GZCsODqrhdAouI4Fs6/OvWAKqf52Wk8CMHQLXkk3BM0tkeverXDJMo55o64wqDDWTmQz7T0+BTnP45ah8TYxhM+3NoxB86HGk6Hc5zJyHHsVU+YiHDf07w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639850; c=relaxed/simple;
	bh=84oTgN3mVJdJ13unGlYHXTeX+9LcKuNig6Vnqn809so=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rXMaa8DmfFavlEBSG+REPCqJX8kI2LIGfwhoX8gXJNpheEG0etLSqOkT62ec7W3x4y014362ArT4/Th1ZZ++Pdz+3qWI/0zVZP7+m5wqzZnpyYZ2+VM9x2ivdY9qcQHx4N5Iv7iqFmZVqeONuX/O8iZa9MwL5XTKYD88ApFKSuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oGYd32U+; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oGYd32U+"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070406epoutp01fc80e60ea508cc4b2417c13edcf37d75~n-rfBMmCg2749927499epoutp01U
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070406epoutp01fc80e60ea508cc4b2417c13edcf37d75~n-rfBMmCg2749927499epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639846;
	bh=OLVAo26MgNTs4IpQCFC+8756cUGYgV7v2HyrMbf3XiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGYd32U+5a/aL8lxZt2R3qFHs+gsPV5dCx17VvLWAyRpXSUhClealdOsMz5AULe+l
	 sn08lRwzZo/2dAkNgSZZT6N9fgAtY6ir1w8whw3nLtYjkXBHAmnfp4B2FvpjgcMvLN
	 VvcSjn2PEETIGs8TDkdAMMTU+V4VdqHlxjC3LWUs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250227070405epcas5p2c68826068ed5272ac2b68f8edc49e986~n-rewgF_40061900619epcas5p2q;
	Thu, 27 Feb 2025 07:04:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3Ml73RCbz4x9Q8; Thu, 27 Feb
	2025 07:04:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.C1.20052.06E00C76; Thu, 27 Feb 2025 16:04:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053359epcas5p2acd2b6ab8ae47db5e7e8ccbe41579910~n_czc0GhL1906519065epcas5p2c;
	Thu, 27 Feb 2025 05:33:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053359epsmtrp204e5a658e72be7129d0b7658879eaa46~n_czcLvPk2933029330epsmtrp2J;
	Thu, 27 Feb 2025 05:33:59 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-e1-67c00e60deb7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.A2.23488.749FFB76; Thu, 27 Feb 2025 14:33:59 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053358epsmtip2b760b3f7bdb47159b1317dfff9f2101a~n_cys_tmj1751717517epsmtip2b;
	Thu, 27 Feb 2025 05:33:58 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 10/21] verify: disable write sequence checks with
 norandommap and iodepth > 1
Date: Thu, 27 Feb 2025 16:17:16 +0530
Message-Id: <20250227104727.1794982-11-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmum4i34F0gy9vGC3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOaD5ZVjBfvuLfzwfsDYx3JLsYOTkk
	BEwkpky4xdjFyMUhJLCbUeLL9SVsEM4nRonGxafZIZxvjBLTv79gh2n5+mcXM0RiL6NEc+9m
	FgjnB6PEnCN7GEGq2AS0JV69vQFUxcEhIqAhseZuKkiYWcBO4urhl2wgtrBAvMT0zhYWEJtF
	QFXi5s4GsFZeAXuJ/o+PWSGWyUvMvPQdbDEnUPxNZyMLRI2gxMmZT1ggZspLNG+dDXaQhMAx
	don+GVugLnWRmHBqPhuELSzx6jhMXEri87u9UPFsiU0PfzJB2AUSR170MkPY9hKtp/rB7mcW
	0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyYB2OrSvy9d5sFwpaWuPnuKpTtIfG56Tc0rCYx
	Shw995N1AqPCLCT/zELyzyyE1QsYmVcxSqYWFOempxabFhjmpZbDIzk5P3cTIzgNannuYLz7
	4IPeIUYmDsZDjBIczEoivJyZe9KFeFMSK6tSi/Lji0pzUosPMZoCA3wis5Rocj4wEeeVxBua
	WBqYmJmZmVgamxkqifM272xJFxJITyxJzU5NLUgtgulj4uCUamDqm3px4uIj1+Uf3Z2xb9dO
	le9OO9Pn/c2aUTep2FDijXm/3fo4b8P7618dV35rdNbrWeYft0maXTvzjTjWZzcdU27T1g5/
	KGtlu3VVeG4Fc6+EZZp7gihr0pvbbk0frdafSIs8Kds8geEZl1KQqvOHhAfV+85PuHfZsvtj
	Juvvhvv/l/LKH+mfXMbAUKb3enbDRn3dmyF/ZoQXyDWtvz2Fd9mLReyWr+b1LZScNilGXSlt
	d5GIHcsfA5U14e6c4l8OMy5dceHUe3ZeTQfeiGa++Y83y996kuazyH47S98sNl7GuiOGq7bK
	z0i1/XRHXf95rr0lv+CWY9rtbb7yGyOslfgPtFgzJz6qZpuXdliJpTgj0VCLuag4EQCgGQBU
	DAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK77z/3pBm/auSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MpoPllWMF++
	4t/PB+wNjHckuxg5OSQETCS+/tnF3MXIxSEksJtRonndPMYuRg6ghLTEwvWJEDXCEiv/PWeH
	qPnGKHH04FpWkASbgLbEq7c3mEFsEQEtiWPrmthAbGYBB4l/u7aA2cICsRLN8w6A1bAIqErc
	3NnACGLzCthL9H98zAqxQF5i5qXv7CA2J1D8TWcjC4gtJGAnsWDiNyaIekGJkzOfsEDMl5do
	3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgSHqZbGDsZ3
	35r0DzEycTAeYpTgYFYS4eXM3JMuxJuSWFmVWpQfX1Sak1p8iFGag0VJnHelYUS6kEB6Yklq
	dmpqQWoRTJaJg1OqgUmi0/C+2NFL7y65JzpeFG9a9/jg43sxWbX3tFW4H6QrC5xwnvs2ulfD
	9Ox6w91d97+4MH9gv8OnrHEjp94q7qC0oeJFdaMFy9L0kpYJGPyW6noucjisKs7186xLK2vO
	ugt2md5+Znkw8yX//prmG/w5t5TN3wtfbhCXj436Nn9qXEiyv9eHteedt19jYTZ7/aiYRy54
	9R+v0gsrZdbsD7XX+LG9SeagR7fYZH3N58GvsgUKn+6fuE60xyS9/b5I4hMZ8+Cvx8vYIzb8
	Vj/cZh5ll8rowvxE89kZnXqn2f2uEjN+yJVNP3umVbaZ//2qlu0MS2JNlj30vXHJxyhSf+bc
	3oeSGebbD93K2/hCTYmlOCPRUIu5qDgRAIhZZfDCAgAA
X-CMS-MailID: 20250227053359epcas5p2acd2b6ab8ae47db5e7e8ccbe41579910
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053359epcas5p2acd2b6ab8ae47db5e7e8ccbe41579910
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053359epcas5p2acd2b6ab8ae47db5e7e8ccbe41579910@epcas5p2.samsung.com>

With norandommap for async I/O engines specifying I/O depth > 1, it is
possible that two or more writes with the same offset are queued at once.
When fio tries to verify the block, it may find a numberio mismatch
because the writes did not land on the media in the order that they were
queued. Avoid these spurious failures by disabling sequence number
checking. Users will still be able to enable sequence number checking
if they explicitly set the verify_header_sequence option.

fio -name=verify -ioengine=libaio -rw=randwrite -verify=sha512 -direct=1 \
-iodepth=32 -filesize=16M -bs=512 -norandommap=1 -debug=io,verify

Below is the truncated log for the above command demonstrating the issue.
This includes extra log entries when write sequence number is saved and
retrieved.

set: io_u->numberio=28489, off=0x5f2400
queue: io_u 0x5b8039e30d40: off=0x5f2400,len=0x200,ddir=1,file=verify.0.0
set: io_u->numberio=28574, off=0x5f2400
iolog: overlap 6235136/512, 6235136/512
queue: io_u 0x5b8039e75500: off=0x5f2400,len=0x200,ddir=1,file=verify.0.0
complete: io_u 0x5b8039e75500: off=0x5f2400,len=0x200,ddir=1,file=verify.0.0
complete: io_u 0x5b8039e30d40: off=0x5f2400,len=0x200,ddir=1,file=verify.0.0

retrieve: io_u->numberio=28574, off=0x5f2400
queue: io_u 0x5b8039e1db40: off=0x5f2400,len=0x200,ddir=0,file=verify.0.0

bad header numberio 28489, wanted 28574 at file verify.0.0 offset 6235136, length 512 (requested block: offset=6235136, length=512)

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst |  5 ++---
 fio.1     |  5 ++---
 init.c    | 11 +++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index fa6b44a5..ca0044ce 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1568,9 +1568,8 @@ I/O type
 	disabled. If this option is used with :option:`verify` and multiple blocksizes
 	(via :option:`bsrange`), only intact blocks are verified, i.e.,
 	partially-overwritten blocks are ignored. With an async I/O engine and an I/O
-	depth > 1, it is possible for the same block to be overwritten, which can
-	cause verification errors. Either do not use norandommap in this case, or also
-	use the lfsr random generator.
+	depth > 1, header write sequence number verification will be disabled. See
+	:option:`verify_write_sequence`.
 
 .. option:: softrandommap=bool
 
diff --git a/fio.1 b/fio.1
index 07f09f07..fd580258 100644
--- a/fio.1
+++ b/fio.1
@@ -1371,9 +1371,8 @@ and that some blocks may be read/written more than once. If this option is
 used with \fBverify\fR then \fBverify_header_seed\fR will be disabled. If this
 option is used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
 only intact blocks are verified, i.e., partially-overwritten blocks are
-ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
-the same block to be overwritten, which can cause verification errors.  Either
-do not use norandommap in this case, or also use the lfsr random generator.
+ignored. With an async I/O engine and an I/O depth > 1, header write sequence
+number verification will be disabled. See \fBverify_write_sequence\fR.
 .TP
 .BI softrandommap \fR=\fPbool
 See \fBnorandommap\fR. If fio runs with the random block map enabled and
diff --git a/init.c b/init.c
index 91f056e3..00a3a8c7 100644
--- a/init.c
+++ b/init.c
@@ -862,6 +862,17 @@ static int fixup_options(struct thread_data *td)
 				o->verify_header_seed = 0;
 		}
 
+		if (o->norandommap && !td_ioengine_flagged(td, FIO_SYNCIO) &&
+		    o->iodepth > 1) {
+			/*
+			 * Disable write sequence checks with norandommap and
+			 * iodepth > 1.
+			 * Unless we were explicitly asked to enable it.
+			 */
+			if (!fio_option_is_set(o, verify_write_sequence))
+				o->verify_write_sequence = 0;
+		}
+
 		/*
 		 * Disable rand_seed check when we have verify_backlog,
 		 * zone reset frequency for zonemode=zbd, or norandommap.
-- 
2.25.1

