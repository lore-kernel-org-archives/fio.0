Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D3C22069E
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639860; cv=none; b=EUyFscOkv/741VOTGm9bdKYTuXpOUdUdi8xgA6ybdOSgVchRmxfOz9oJ+MDeguBvJlycYNPX+rDcCzVZ+pO28JnMEIgtbY1ANm8CI9tgkTmau+qJmGZMrecSz0TooMhpdRkgfUEvCNQkAfw7FD4xUNALa9ENyZtZouQLtjikbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639860; c=relaxed/simple;
	bh=pDKofpAS2txqQO+n/zFjuyku38JSi1+5birSkYhK/UA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=r5DjB9Ii02/c5BSeV66CbQdOiQIzEKtCpEGTBcScEp4x/x2Yrj5623yiEXh40w436KpIiNwNEIkkcGZ/NVcV/PRdcr9jIK9aUhCsRo3XQMzeR5kDcLhdppNkqwm3gNLS6wCq7cNohN3vnIYM83PIHb8vPwC+zjKK4L8Zo/3X/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G8h4JXAK; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G8h4JXAK"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070416epoutp01708000849e1ca39b8111bb46fdd71f8f~n-roooCUZ2779427794epoutp01d
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070416epoutp01708000849e1ca39b8111bb46fdd71f8f~n-roooCUZ2779427794epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639856;
	bh=BMRjL9XQkeNc15NmGoiJwOWQHTv7mtZyfUeDeN3DtIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8h4JXAKKOyZQbpQzMWM7cOG1L1rhDkQDvEfIBUURiuPq2nozTRY7Y9IlqAk202U/
	 ZQuX51RhOCNJFWQJw1iuEviTJ1UiCICRmFZ6AeE/UxklERuyDNc1ySJnJSE6enl+86
	 acD2ivTp7yh72riYh/EEbVGGqvQXi0MmVT1Xutr0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250227070416epcas5p2870a1ddddb068e92adbd96e895e87cfc~n-roXg00F0816808168epcas5p2T;
	Thu, 27 Feb 2025 07:04:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3MlL35Mvz4x9QC; Thu, 27 Feb
	2025 07:04:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FD.99.19933.C6E00C76; Thu, 27 Feb 2025 16:04:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053403epcas5p3f7137d9bad2e501bfa6098ce53360937~n_c29buWv0147701477epcas5p3g;
	Thu, 27 Feb 2025 05:34:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053403epsmtrp19dbd5f81a8056d158391a56a9c25588a~n_c280iTD1040410404epsmtrp1p;
	Thu, 27 Feb 2025 05:34:03 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-53-67c00e6c709c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AF.4A.18949.A49FFB76; Thu, 27 Feb 2025 14:34:02 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053402epsmtip29afecffd88c37bdac5c73e92be7e3d0f~n_c2D63pD1588515885epsmtip2h;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Vincent Fu
	<vincent.fu@samsung.com>
Subject: [PATCH 14/21] verify: adjust fio_offset_overlap_risk to include
 randommap
Date: Thu, 27 Feb 2025 16:17:20 +0530
Message-Id: <20250227104727.1794982-15-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmhm4O34F0g3k/LC3WXPnNbrH6bj+b
	xcdZL5gtHnd3MFpsaBN0YPXYOesuu8fls6UefVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFVJoSwxpxQoFJBYXKykb2dTlF9a
	kqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ2xZ0oba8EE9YrVbdsZGxjn
	yncxcnJICJhIrJm8l72LkYtDSGA3o8T+R2sYIZxPjBKtD/6zQDjfGCU2nPnCDNNydtJOVojE
	XkaJjfvfsIMkhAR+MEo8PeULYrMJaEu8ensDqIGDQ0RAQ2LN3VSQMLNAqsSlJc2sILawQIjE
	xnXHwGayCKhKrFh/EczmFbCXmLXlJQvELnmJmZe+g43nBIq/6WxkgagRlDg58wkLxEx5ieat
	s5lB7pEQOMcu8fDzVkaIZheJn32HoY4Wlnh1fAs7hC0l8bK/DcrOltj08CcThF0gceRFL1S9
	vUTrqX6w+5kFNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3Ya6X1ri5rurULaH
	RO/+u9Bwm8QocWLjZ9YJjAqzkPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJSXWg6P5OT83E2M
	4ISo5bWD8eGDD3qHGJk4GA8xSnAwK4nwcmbuSRfiTUmsrEotyo8vKs1JLT7EaAoM8InMUqLJ
	+cCUnFcSb2hiaWBiZmZmYmlsZqgkztu8syVdSCA9sSQ1OzW1ILUIpo+Jg1OqgWnzyZx3rqe5
	km42nZI9/+yczgKZuvCZIaeOen2J6njANCWmOrll4+c9S+cXcv9rVZS9EDX7SchU5oVM877x
	H7h+mePuNLvN9zZvjJFOr8/137tR9DqTX+jJl6xulXy69ddv77h3O9yZR0fStz18xiWHnSrl
	UjErTD49XBzSsc++yUphjmjYnftyP8XSSqY4Fj/doNzCm3KuJHB3aeKcp3Gxq36vmSq3h+Wp
	0Z9NZ1od3l5WWR7dPaFQ9+axF51tKk/K5OQbmBe06fox/rt9rWrF40suIV8f75y54PXLmvpJ
	FZdCTdRfVvUd1uhutDsQX7DwwnEukW6hnoSHNfefrNnSd2nhAUaNJfzr/gjuEv+hxFKckWio
	xVxUnAgAHmG0BxEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvK7Xz/3pBu+nmVusufKb3WL13X42
	i4+zXjBbPO7uYLTY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PP
	lDbWggnqFavbtjM2MM6V72Lk5JAQMJE4O2knaxcjF4eQwG5GiY0LLzJ1MXIAJaQlFq5PhKgR
	llj57zk7RM03Ronjt86zgCTYBLQlXr29wQxiiwhoSRxb18QGYjMLpEucv9HFBGILCwRJ/Lje
	BlbDIqAqsWL9RTCbV8BeYtaWlywQC+QlZl76zg5icwLF33Q2gsWFBOwkFkz8xgRRLyhxcuYT
	Foj58hLNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCQ
	1dLawbhn1Qe9Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYfYpTmYFES5/32ujdF
	SCA9sSQ1OzW1ILUIJsvEwSnVwCTJ2fR+69TrW59/uzyp7mPa7LwcI+13mjeLXhX8dnxwQWrz
	VNeNubqfIxruhStono+qLLTZprJa3eXYDFnJz3equw7bT2tLjrOL2LxlxS65LtH/LuvcP+3p
	zK0VqZ3V6SkUlpooMXfz7VOm6yq+etb90911d/mWHOZDyQ8ltgfyhu25EushtGVB4kJf16Ct
	F1ektN9cGRrluEw6SKYj/Lxrbewxw50pN0Xub4x5Ftz5dZnhvChh7wNpy7vfNV4XY3vyR3ct
	w/Hu6FMHXs11uJlV1e+g5q+Uc+biyQk96fNkJfiroo44ndjL+896Esv/1/ZN2/VnS9Ry9/OG
	K5g4f8g245wSPKHmx97Q0gfK/5VYijMSDbWYi4oTAZCXNNPIAgAA
X-CMS-MailID: 20250227053403epcas5p3f7137d9bad2e501bfa6098ce53360937
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053403epcas5p3f7137d9bad2e501bfa6098ce53360937
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053403epcas5p3f7137d9bad2e501bfa6098ce53360937@epcas5p3.samsung.com>

Currently we are using a list to log I/O history if:
 * randommap is enabled and fio manages to allocate memory for it.
 * there are no offset modfiers with any jobs.
For any different scenario we use an RB tree to handle offset overlaps,
which disables header seed checks for them.

This commit expands fio_offset_overlap_risk() such that it covers
file_randommap() cases.
For random workload with this change these are the possible scenarios

 -----------------------------------------------------------------------
|                 |         norandommap=0              |  norandommap=1 |
|-----------------------------------------------------------------------|
| softrandommap=0 |        list (No change)            |    RB tree     |
|                 | (fio was able to allocate memory)  |  (No change)   |
|-----------------|------------------------------------|----------------|
|                 |      RB tree (Now always)          |    RB tree     |
| softrandommap=1 |Even if fio was able to allocate mem|  (No Change)   |
 -----------------------------------------------------------------------

With randommap enabled and softrandommap=1 we now always use an RB tree,
even when fio is able to allocate memory for random map. In this case
verify header seed check will be disabled. If users want to check header
seed they can either disable softrandommap or explicilty enable
verify_header_seed.

Effectively this changes randommap from being a per-file property to
per-job property.

This also fixes rand seed mismatch isues, that have been observed when
multiple files are used, such as for the below mentioned configuration.

[global]
do_verify=1
verify=md5
direct=1
[multi_file]
rw=readwrite
directory=.
nrfiles=2
size=32K

Here is the truncated log with debug=verify flag, and an extra log when
the seed gets generated as well as the mismatch.

verify   368109 file ./multi_file.0.1 seed 46386204153304124 offset=0, length=4096
verify   368109 file ./multi_file.0.0 seed 9852480210356360750 offset=0, length=4096
verify   368109 file ./multi_file.0.1 seed 4726550845720924880 offset=4096, length=4096
verify: bad header rand_seed 9852480210356360750, wanted 46386204153304124 at file ./multi_file.0.0 offset 0, length 4096 (requested block: offset=0, length=4096)

Earlier the I/O entries were getting logged in an RB tree, as we were
relying on file_randommap(), which was false for sequential workloads.
In RB tree, files are prioritized first and then the offset. Thus during
the verify phase the I/O entries are removed from tree in order of file
and then offset which is not how it was originally written. With the new
checks, for sequential workload we now store the entries in the list
instead of RB tree.
Even for sequential workload if the user fortuitously specified
norandommap or softrandommap, then I/Os will be stored in an RB tree.
However in this case header seed checks will be disabled.

fixes #740
fixes #746
fixes #844
fixes #1538

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 fio.h   | 3 ++-
 init.c  | 7 +++----
 iolog.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fio.h b/fio.h
index c7c0d147..d6423258 100644
--- a/fio.h
+++ b/fio.h
@@ -802,7 +802,8 @@ extern void lat_target_reset(struct thread_data *);
 
 static inline bool fio_offset_overlap_risk(struct thread_data *td)
 {
-	if (td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1))
+	if (td->o.norandommap || td->o.softrandommap ||
+	    td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1))
 		return true;
 
 	return false;
diff --git a/init.c b/init.c
index feaa3f28..95f2179d 100644
--- a/init.c
+++ b/init.c
@@ -886,13 +886,12 @@ static int fixup_options(struct thread_data *td)
 
 		/*
 		 * Disable rand_seed check when we have verify_backlog,
-		 * zone reset frequency for zonemode=zbd, norandommap, or
-		 * offset modifiers.
+		 * zone reset frequency for zonemode=zbd, or if we are using
+		 * an RB tree for IO history logs.
 		 * Unless we were explicitly asked to enable it.
 		 */
 		if (!td_write(td) || (td->flags & TD_F_VER_BACKLOG) ||
-		    o->zrf.u.f || o->norandommap ||
-		    fio_offset_overlap_risk(td)) {
+		    o->zrf.u.f || fio_offset_overlap_risk(td)) {
 			if (!fio_option_is_set(o, verify_header_seed))
 				o->verify_header_seed = 0;
 		}
diff --git a/iolog.c b/iolog.c
index 6b5dc9ab..dcf6083c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -306,7 +306,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	 * the rb insert/lookup for handling. Sort writes if we have offset
 	 * modifier which can also create duplicate blocks.
 	 */
-	if (file_randommap(td, ipo->file) && !fio_offset_overlap_risk(td)) {
+	if (!fio_offset_overlap_risk(td)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
-- 
2.25.1

