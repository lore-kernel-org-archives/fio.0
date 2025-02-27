Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8966621D599
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639880; cv=none; b=ivi5r7Pzaqxd8Nz0rayywIUqY/G5aXRmH3AX8cGFxunelruvQQ4RCIKlHmaOWlfKxj/enCLnQ8ibqJP1d7YTNcld3xDqc6HFFmwTG5Ct6pZBfA6JbX99owyqeBKvBY4xv5D3tgtByAU2la+/sVkNKCk5mLzQ11P2A+0F3y03J+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639880; c=relaxed/simple;
	bh=Z6nlKWhPawAjg7Qk8SGwRwphJE1CgAweSwNZ5JHcJ/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=aASL+2zookonB1nXhcZtwnWBZAynhowRufN5ufB1H1TTQ4ACWgOcDEUqyg2hz7/aGQ3M7x+o9ZmL0fhjlHFCtdoUDY/5NXgUpyxKShb2cpdAFI7e2oV8uInRG8fyun/NunbcpVG+nNpQwHiEylp+teJ0Q5SfYXlDYeCTc/GZgtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NLl/FR/q; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NLl/FR/q"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070437epoutp013fcc1f36941ef8c2086ccb7adf34c550~n-r7wVAJd2750027500epoutp01f
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070437epoutp013fcc1f36941ef8c2086ccb7adf34c550~n-r7wVAJd2750027500epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639877;
	bh=K2AR8GLi6nFH/m1Qe9fPphvhcfHZ6XGR2lTMYL5gsek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLl/FR/q+kllr//MXlGkdrwNCFB07pBMQlYplMmRmOV9ifHqL4dX1NYiABHFPI3nd
	 p7lnYJctlj+f7bF8rAonD3OmGZ1CKuvr6/OZkNksaA76ZsVRWGdFdVJRjicRuOVLeb
	 t/nrlLwgRt0sjW8R54XCZ+4Fp55EwQeUk18wynvM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070436epcas5p4c6a61cca697e1cecee8b656569fd2dc3~n-r7RIHv10059300593epcas5p4t;
	Thu, 27 Feb 2025 07:04:36 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z3Mlk1v3gz4x9Pw; Thu, 27 Feb
	2025 07:04:34 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.B9.19933.E7E00C76; Thu, 27 Feb 2025 16:04:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053409epcas5p3ca95eb997678d7fd903d2840e4d101be~n_c9DdaCr0099900999epcas5p3B;
	Thu, 27 Feb 2025 05:34:09 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053409epsmtrp2a22ddd3251732c2a2c30efc31ed5affd~n_c8_nbsS2935229352epsmtrp21;
	Thu, 27 Feb 2025 05:34:09 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-9d-67c00e7e0625
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	BA.EA.33707.159FFB76; Thu, 27 Feb 2025 14:34:09 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053408epsmtip28fbd4b8bdf02c2aaf27e1bd4a84421c8~n_c8N7XiZ1751717517epsmtip23;
	Thu, 27 Feb 2025 05:34:08 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 21/21] ci: add nightly test for verify
Date: Thu, 27 Feb 2025 16:17:27 +0530
Message-Id: <20250227104727.1794982-22-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmum4d34F0g2nd5har7/azWXyc9YLZ
	4nF3B6PFhjZBBxaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QAuVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZU74sYSw4z1lxZ9cSlgbGXexdjJwc
	EgImEg23t7B1MXJxCAnsZpQ4+vo4E4TziVHiy5lNrHDO/ycnGGFaut42skMkdjJK/D73Aqr/
	B6PEg85NYIPZBLQlXr29wdzFyMEhIqAhseZuKkiYWcBGonnlPnaQsLCAmcSbz7IgYRYBVYkr
	k76xgdi8AvYSbb8fsUHskpeYeek72EROoPibzkYWiBpBiZMzn7BAjJSXaN46mxnkBAmBQ+wS
	f4+sZoVodpF4/bwHapCwxKvjW6B+lpL4/G4vVDxbYtPDn0wQdoHEkRe9zBC2vUTrqX6w85kF
	NCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67CmV7SLx7dgUaVJMY
	Jb7O+sEygVFhFpJ/ZiH5ZxbC6gWMzKsYJVMLinPTU4tNC4zyUsvhkZycn7uJEZwGtbx2MD58
	8EHvECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YiPNK4g1N
	LA1MzMzMTCyNzQyVxHmbd7akCwmkJ5akZqemFqQWwfQxcXBKNTBNPnzruKzMpnlm0zSmMR0I
	cFp7fsrOdHERNentKZIiuz1+Hm9c+6s2f8sjDT9u5UmJzDKSOmnlh7JNHX49Xty5bJPO8sDY
	7BcP83wXMGhNulSxyTz8QX6i6b0nP4P+N8UKJc+Tmm4SUrts/rYUqew5qTvijrz7P+Xuzc2z
	NoSee8eg9aD3nZFB1w+LN9fWzdSXWCSm8unozUPf5f5c81txxnHnsR/HXl/ccZjv/Tp2571P
	lj+r//DvFrP1N76MLUdeFdn9e3pe1+fAYiuXGyufzt2f/u1jDuskIfFzDlO3732ZYLMk8sr3
	W8xs59+JO+Qe21TldPyDouAk4ZTNMsy3Q8O72Ix2JDJzvL8+YWYOj5cSS3FGoqEWc1FxIgCt
	BAVhDAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSvG7gz/3pBtN+iFmsvtvPZvFx1gtm
	i8fdHYwWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVM+bKEseA8
	Z8WdXUtYGhh3sXcxcnJICJhIdL1tBLK5OIQEtjNKzHqxk7mLkQMoIS2xcH0iRI2wxMp/z6Fq
	vjFKbDp1lBUkwSagLfHq7Q1mEFtEQEvi2LomNpBeZgE7ibXvfUBMYQEziTefZUEqWARUJa5M
	+sYGYvMK2Eu0/X7EBjFeXmLmpe9g53ACxd90NrKA2EJAUxZM/MYEUS8ocXLmE7A4M1B989bZ
	zBMYBWYhSc1CklrAyLSKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzg4tYJ2MC5b/1fvECMT
	B+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZVzOlOEBNITS1KzU1MLUotg
	skwcnFINTCHyfnnVN9ctmsp34KS1vkFqWPbd0q73b/3XyIQeyU5/uUfuyo+MeR/rK/RaA5j1
	Xf8JhL5r9D//+WDdng3toUveMN99tj33rNgEaZ6LU/k2Ju1VuX7GLmSLFd9G7UA1qbhTZVYa
	Z1apdE7jkIw4fuFc8OUdv2S1eRZsne8odjvy5MeV3ifL1v0pF7x/8OWcZefWf3q/uNNU+XrL
	i2duPPKeV2TvPtfYvoeL4dOGFz7RNwqZWALtvE8HJE1k9hEuc/l67F7g2iWaS/cn/Vj2fPWe
	zvs1F/9dUfBkdG48xSsTru7honvkwtGqez333WJ3cv4N+q6e+SW1cOuMfgczNxnz3f4Kx5K4
	Hoc1TtDxfqTEUpyRaKjFXFScCAB+UB1CvQIAAA==
X-CMS-MailID: 20250227053409epcas5p3ca95eb997678d7fd903d2840e4d101be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053409epcas5p3ca95eb997678d7fd903d2840e4d101be
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053409epcas5p3ca95eb997678d7fd903d2840e4d101be@epcas5p3.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 .github/workflows/ci.yml |  2 ++
 ci/actions-full-test.sh  | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index d20a2d01..556ebb41 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -4,6 +4,8 @@ on:
   push:
   pull_request:
   workflow_dispatch:
+  schedule:
+    - cron: "35 0 * * *"  # 0:35 UTC which is 19:35 ET
 
 jobs:
   build-containers:
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 23bdd219..854788c1 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -33,6 +33,19 @@ main() {
 
     fi
 
+    # If we are running a nightly test just run the verify tests.
+    # Otherwise skip the verify test script because it takes so long.
+    if [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
+	args+=(
+	    --run-only
+	    1017
+	)
+    else
+	skip+=(
+	    1017
+	)
+    fi
+
     echo python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     make -C doc html
-- 
2.25.1

