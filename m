Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A62206B3
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639860; cv=none; b=GBreygGahO2NGw+UEZR5JP5jvh+tK0JfTunYem/GeJSBkpeGzwphKyEavt3rwp0YLYo5pUUspdz+klUQpBPrHiYbIkZbEtU0tYrMbRUn4pbcvZmzZe0vvDLURDhlV0iqcsx3BKb0AQASd5Aujo85aV8ZEOSdqbjmuWmZSMRE3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639860; c=relaxed/simple;
	bh=kkY3P8G7Qs93ZTRBFE9kVD14lRhkQjfHm2094dp5QUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BkBFZrgMMGe2Qu3YS8hn9t6cpoznGw9Tz17m6wnQpPRDaZ09Ht2rUByPrfF8/MWfvJObaZespchrinRmCiC1Tq+drDypxvNYCNSC8fms5UIptVjxnSTS49kKV8aDWobhzzjjl8Y/Q9vufKxRk6njSjZxctHZSEbRLb9NzEn/GQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Q1T7HAYP; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q1T7HAYP"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070413epoutp01bdd3495ed88891c20a7eed74c964e7ed~n-rlwZhN22813328133epoutp01D
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070413epoutp01bdd3495ed88891c20a7eed74c964e7ed~n-rlwZhN22813328133epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639853;
	bh=si8BqhraZvGWZpgSEt+J0vexSux4uEZfeAvZbCgaRF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1T7HAYPPfjqUP0DYNhh4XGKtz1LcVeVQNUiEYEJrl3t1nXO6D1jQQzz/3hauxEH7
	 W9hUPWM1CFkbq1ujDRaOCQVmeE9ri0AUDJKApYNMYYLDzY7L2fKl15w3HhoasiJOOY
	 pjAa89K+qBIb4Z1cXloBuSMdMr/bgjyncH6/MUHM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070413epcas5p3bef85df775b8745501d1533b29127fed~n-rlcullm0230602306epcas5p3y;
	Thu, 27 Feb 2025 07:04:13 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3MlG6MgNz4x9Pq; Thu, 27 Feb
	2025 07:04:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.C2.19710.96E00C76; Thu, 27 Feb 2025 16:04:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053401epcas5p267957df588887e9d28ba20c8bd0ab13b~n_c16n5Jv2346023460epcas5p2E;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053401epsmtrp1e4e564070153362087b9b6cf566a0e96~n_c159pa01040410404epsmtrp1d;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-6b-67c00e69f49b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.A3.18729.949FFB76; Thu, 27 Feb 2025 14:34:01 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053401epsmtip23cf491c38979a63f68f0ad0aa843a24b~n_c1OLgHh1751717517epsmtip2p;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 13/21] verify: fix verify issue with offest modifiers
Date: Thu, 27 Feb 2025 16:17:19 +0530
Message-Id: <20250227104727.1794982-14-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmlm4m34F0g7et/BZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRntG5az14wTb5i61rWBsbXEl2MnBwS
	AiYS/+43M3cxcnEICexmlFg7vZcJwvnEKHHj9RdGCOcbo8TlN23MMC09dxZDJfYySvT9nscO
	4fxglOje84EdpIpNQFvi1dsbQB0cHCICGhJr7qaChJkF7CSuHn7JBmILC7hKXLo/CcxmEVCV
	+P75PAuIzStgLzFz4mkmiGXyEjMvfQcbyQkUf9PZCFUjKHFy5hMWiJnyEs1bZ4P9ICFwjF3i
	3YStjBDNLhIf+1axQ9jCEq+Ob4GypSRe9rdB2dkSmx7+hFpWIHHkRS/Ul/YSraf6we5nFtCU
	WL9LHyIsKzH11DomiL18Er2/n0C18krsmAdjq0r8vXebBcKWlrj57iqU7SGx5ssHVkhYTWKU
	WHFiK8sERoVZSP6ZheSfWQirFzAyr2KUTC0ozk1PTTYtMMxLLYdHcnJ+7iZGcBrUctnBeGP+
	P71DjEwcjIcYJTiYlUR4OTP3pAvxpiRWVqUW5ccXleakFh9iNAUG+ERmKdHkfGAiziuJNzSx
	NDAxMzMzsTQ2M1QS523e2ZIuJJCeWJKanZpakFoE08fEwSnVwNSv5rF0XoTZuQzZ7FdcTgKX
	dsjsdnjm3Pyz25LBYJv3Id7gawpF3pWlOXWdM9Z/XaFq56DT3Kt+xGhNxrRs3++JGwNSuZo+
	+25rljuQ2moR98/1GP/i1AqnrcWnNd7wnft+N1wmc1HWAU3DysqbhXobjadvVp/b4xF4vrbD
	pmKu/12L8Kvmzq1FUY7iZSsNBDZoxJqnXJzX7b/hyCTnGV/mC8uzn8y4IW1ReCmDR3UG88a5
	y+8HhBSYiseUXGbrjera7vNkwZeML0vPxoYd4vt9XX9mRcyNyrSHncXqaTeagk2VpYzU+b/O
	s2oM432hIRG8zfVGr/H0xwe+xa67dLlTNJFt/VyvXxFnbvIqsRRnJBpqMRcVJwIAAvB7wQwE
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK7nz/3pBq39phZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGW0blrPXjBN
	vmLrWtYGxtcSXYycHBICJhI9dxYzdjFycQgJ7GaUuP5kH1sXIwdQQlpi4fpEiBphiZX/nrND
	1HxjlFi6+jw7SIJNQFvi1dsbzCC2iICWxLF1TWwgNrOAg8S/XVvAbGEBV4lL9yeB2SwCqhLf
	P59nAbF5BewlZk48zQSxQF5i5qXvYDM5geJvOhvBaoQE7CQWTPzGBFEvKHFy5hMWiPnyEs1b
	ZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4DDV0tzBuH3V
	B71DjEwcjIcYJTiYlUR4OTP3pAvxpiRWVqUW5ccXleakFh9ilOZgURLnFX/RmyIkkJ5Ykpqd
	mlqQWgSTZeLglGpgKmL9m1igum1ZWrzwlevO1v9X6IkuPPrFT+D1zgSmBYKLNoudcUjY/aZe
	Qol38onDGp/39Wp2uqk57OKs9Lz20/fez3VKcxSD+KYXMi2bu+unnFex595PVpfO8Eimn9LX
	K02Q4VJO/qF4qHey+5pXrdebvc80n1OVPPkvuIcvLldU7B5vEMu6yZvO3ps6Q15PW+7D4gsC
	/RXnxOcadzk3LN7WkhJ4WOdv5Enrhz8cs5f2X7s7+deu3MjXj9oVfRbY1GfNcw87/evI7Oxn
	PyOMUja/tj/r6patfIRPQ6rFd1mA/TGrO0/zgw2msUp+O3Dr9/K61S45y75OUnuxLrHhk3xj
	iCVn8Vz+ctZNiXyJSizFGYmGWsxFxYkA0yd0HsICAAA=
X-CMS-MailID: 20250227053401epcas5p267957df588887e9d28ba20c8bd0ab13b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053401epcas5p267957df588887e9d28ba20c8bd0ab13b
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053401epcas5p267957df588887e9d28ba20c8bd0ab13b@epcas5p2.samsung.com>

Offset modifiers such as rw=readwrite:8 or rw=write:4K can create
overlaps. For these cases use RB tree instead of list to log the I/O
entries.

Add a helper function fio_offset_overlap_risk() to decide whether to log
the I/O entry in an RB tree or a list.

Disable header seed verification if there are offset modifiers, unless
its explicitly enabled.

fixes #1503

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 4 +++-
 fio.1     | 4 +++-
 fio.h     | 8 ++++++++
 init.c    | 6 ++++--
 iolog.c   | 9 +++++----
 5 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 4293c03c..bb5da1cc 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1185,7 +1185,9 @@ I/O type
 	pattern, then the *<nr>* value specified will be **added** to the generated
 	offset for each I/O turning sequential I/O into sequential I/O with holes.
 	For instance, using ``rw=write:4k`` will skip 4k for every write.  Also see
-	the :option:`rw_sequencer` option.
+	the :option:`rw_sequencer` option. If this is used with :option:`verify`
+	then :option:`verify_header_seed` will be disabled, unless its explicitly
+	enabled.
 
 .. option:: rw_sequencer=str
 
diff --git a/fio.1 b/fio.1
index a0f204c0..4755ca19 100644
--- a/fio.1
+++ b/fio.1
@@ -955,7 +955,9 @@ modifier with a value of 8. If the suffix is used with a sequential I/O
 pattern, then the `<nr>' value specified will be added to the generated
 offset for each I/O turning sequential I/O into sequential I/O with holes.
 For instance, using `rw=write:4k' will skip 4k for every write. Also see
-the \fBrw_sequencer\fR option.
+the \fBrw_sequencer\fR option. If this is used with \fBverify\fR then
+\fBverify_header_seed\fR option will be disabled, unless its explicitly
+enabled.
 .RE
 .TP
 .BI rw_sequencer \fR=\fPstr
diff --git a/fio.h b/fio.h
index b8cf3229..c7c0d147 100644
--- a/fio.h
+++ b/fio.h
@@ -800,6 +800,14 @@ extern void lat_target_reset(struct thread_data *);
 	    	 (i) < (td)->o.nr_files && ((f) = (td)->files[i]) != NULL; \
 		 (i)++)
 
+static inline bool fio_offset_overlap_risk(struct thread_data *td)
+{
+	if (td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1))
+		return true;
+
+	return false;
+}
+
 static inline bool fio_fill_issue_time(struct thread_data *td)
 {
 	if (td->o.read_iolog_file ||
diff --git a/init.c b/init.c
index bf257ea1..feaa3f28 100644
--- a/init.c
+++ b/init.c
@@ -886,11 +886,13 @@ static int fixup_options(struct thread_data *td)
 
 		/*
 		 * Disable rand_seed check when we have verify_backlog,
-		 * zone reset frequency for zonemode=zbd, or norandommap.
+		 * zone reset frequency for zonemode=zbd, norandommap, or
+		 * offset modifiers.
 		 * Unless we were explicitly asked to enable it.
 		 */
 		if (!td_write(td) || (td->flags & TD_F_VER_BACKLOG) ||
-		    o->zrf.u.f || o->norandommap) {
+		    o->zrf.u.f || o->norandommap ||
+		    fio_offset_overlap_risk(td)) {
 			if (!fio_option_is_set(o, verify_header_seed))
 				o->verify_header_seed = 0;
 		}
diff --git a/iolog.c b/iolog.c
index ef173b09..6b5dc9ab 100644
--- a/iolog.c
+++ b/iolog.c
@@ -301,11 +301,12 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	}
 
 	/*
-	 * Only sort writes if we don't have a random map in which case we need
-	 * to check for duplicate blocks and drop the old one, which we rely on
-	 * the rb insert/lookup for handling.
+	 * Sort writes if we don't have a random map in which case we need to
+	 * check for duplicate blocks and drop the old one, which we rely on
+	 * the rb insert/lookup for handling. Sort writes if we have offset
+	 * modifier which can also create duplicate blocks.
 	 */
-	if (file_randommap(td, ipo->file)) {
+	if (file_randommap(td, ipo->file) && !fio_offset_overlap_risk(td)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
-- 
2.25.1

