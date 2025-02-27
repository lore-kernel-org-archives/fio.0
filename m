Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B90C21B9CB
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639842; cv=none; b=O9vDjcggH5qlz8CvHUL7K8Wm91GvpbiylYIsJrvn6cYiYMT5rTZPpFXwe0XM0wBoRKBci8GrGr6Y8hfmlv3+wHl8Kp4rKDJoy0Anfk74Js1Rfa9CC4pv6aS8pL/owV/30RCeXqrlbf9y4ncUxRLslvlUtajJcF9XP5z3roKI9OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639842; c=relaxed/simple;
	bh=IIzApGCWNVAEPnUPFr44prvYbENOl06YoYFfb9C+V/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=D8hdZCCU7ZbMHmaaQBxEq+vlr0TLo5jrjn9H6iCQt4Mk2oZiHJhnts4dgWdRvf78XZVsm3TItGlfCtY+u/47wWMeKN2nA5wTa5U7O8847pktq12scbs4R6WXYL/ahKgWME2G+yXreT594hNreJbDesK9ISmBta3JxbrwEGefIDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CBHdmyI5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CBHdmyI5"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070358epoutp0147cab2b9b2c4c9b09ee9c92ee42a9edc~n-rXpg39s2773427734epoutp01O
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070358epoutp0147cab2b9b2c4c9b09ee9c92ee42a9edc~n-rXpg39s2773427734epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639838;
	bh=ymu95aGpYPQyzBNNNzsuhlj1f28YrApXaqU+lzD/lZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBHdmyI5p4hc7h34JH5yZmRMHzN7JVkeHSuU/vBEj3v2N9qGg5ZS+y0ku0MYr+Up6
	 3YY3xRqcZyQ3QVRUc+RcLBLIDp9rAMSsRZ8SVfVZNgoYOmktNN7A1Ky+0UsTSXKdFg
	 nj4r1RDarMnZjVgNNm8ztfKhoN1IVClZzVc5795Q=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070357epcas5p4f46f28bc6f4ef48084f30c2696f52a10~n-rXWxfGY1979319793epcas5p4O;
	Thu, 27 Feb 2025 07:03:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3Ml00ltGz4x9Pv; Thu, 27 Feb
	2025 07:03:56 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A6.6B.19956.B5E00C76; Thu, 27 Feb 2025 16:03:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053357epcas5p3e7bee74e043628bb402a624eda6840be~n_cxsz-ip0099900999epcas5p3Z;
	Thu, 27 Feb 2025 05:33:57 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053357epsmtrp117bc1081660e4199402c6ebf2e60a82a~n_cxsSydJ1011210112epsmtrp1b;
	Thu, 27 Feb 2025 05:33:57 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-7f-67c00e5b9015
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	10.EA.33707.549FFB76; Thu, 27 Feb 2025 14:33:57 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053356epsmtip2d98ea5b7f39fc517fc4b65748eafe640~n_cw-sDC71588515885epsmtip2P;
	Thu, 27 Feb 2025 05:33:56 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 08/21] verify: header seed check for read only workloads
Date: Thu, 27 Feb 2025 16:17:14 +0530
Message-Id: <20250227104727.1794982-9-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmum4034F0g44/QhZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnvJq3hKlghmrFswvfWBoYX8h2MXJy
	SAiYSDzqms7cxcjFISSwm1HiwccONpCEkMAnRomWf0kQCSB72/37bDAdnSeeskAkdjJK7Hq1
	nhWi4wejxIt5qSA2m4C2xKu3N4DGcnCICGhIrLkLFmYWsJO4evgl2BxhAQ+JfW/vMoLYLAKq
	Eocnv2UBsXmBam42zWeC2CUvMfPSd3YQm1PAXuJNZyNUjaDEyZlPWCBmyks0b50N9oGEwDF2
	ieWt76GaXSRmzellhbCFJV4d38IOYUtJvOxvg7KzJTY9/AlVXyBx5EUvM4RtL9F6qh/sfmYB
	TYn1u/QhwrISU0+tY4LYyyfR+/sJVCuvxI55MLaqxN97t1kgbGmJm++uQtkeEv+39UHDbRKj
	xJorW5knMCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arFpgXFeajk8jpPzczcxgpOglvcOxkcP
	PugdYmTiYDzEKMHBrCTCy5m5J12INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wPTcF5JvKGJ
	pYGJmZmZiaWxmaGSOG/zzpZ0IYH0xJLU7NTUgtQimD4mDk6pBqYMAfHdB+87PN+616Fo0Voh
	vd++qltuuKyynS21yuznvZ6fs5LZGFqXPRN7dezGd4NaeyP9jr1fggLUZ8Spa/uwsexqvbjz
	3OmWZAPb5z/UilOY+Kaarwu8kRD0uqR8j0rQBZ/Q97KLt3P8F/5TLZEk66U7I03qoIFRpXbl
	RIEHi1OKLx2dPK+lbBKj4uTM1X/jtovVXArc3Oai7zlR52ugRuyT31EXWI6E6Nv8YNh8Y1nd
	qdM5csE7d/R/nm3xXfnjUqY1cf+X5GnUVlaFsco+VTUXbSoUK7g8J1YmytJIYfqxd776Z20n
	fapzuTHTKePjfWPp1a8tgiLO9X4ymdhT1eQhZNxRtodZs/XeMyWW4oxEQy3mouJEAAotwlAL
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvK7rz/3pBhsei1isufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxat4SpoIZ
	qhXPLnxjaWB8IdvFyMkhIWAi0XniKUsXIxeHkMB2RolNb76xdzFyACWkJRauT4SoEZZY+e85
	O0TNN0aJD3f3MIIk2AS0JV69vcEMYosIaEkcW9fEBmIzCzhI/Nu1BcwWFvCQ2Pf2Llg9i4Cq
	xOHJb1lAbF4BO4mbTfOZIBbIS8y89J0dxOYUsJd409kIViMEVLNg4jcmiHpBiZMzn7BAzJeX
	aN46m3kCo8AsJKlZSFILGJlWMYqmFhTnpucmFxjqFSfmFpfmpesl5+duYgQHqFbQDsZl6//q
	HWJk4mA8xCjBwawkwsuZuSddiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9yTmeKkEB6Yklqdmpq
	QWoRTJaJg1OqgWlOR//6fRF18S9y4zO213LGaV3+/jPz7C737b8+Po+3bFyrednq66FLWhsf
	24r4LJyy/OCXHfcbpt9oXzHlfWNPhvDqkAUNrc+U41bN3jJfUkit8qvn5EUteuqBxlKXlTJi
	Fn0P8FB5nyzB9UW+jCffUyDFrfnT2pzHd+TTT0tZuucmn9h2VsT8b3HYJPFftXt/2H3R/HV3
	edmpU0eWXF1V/MnK+EJr2xfnrZdCD36ctOP2ec0D5VK2fDwLDn9c/dUyI9RttsHCqFcm0WwT
	+2s+uaqvNjmVdrTvf/kbd80tsy04kuepzjsuNePqJgePfc2zYg/p5a19NXHxY7UEF4VOt7jT
	L67vnxi+1+XdHstcJZbijERDLeai4kQA5gTXaL8CAAA=
X-CMS-MailID: 20250227053357epcas5p3e7bee74e043628bb402a624eda6840be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053357epcas5p3e7bee74e043628bb402a624eda6840be
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053357epcas5p3e7bee74e043628bb402a624eda6840be@epcas5p3.samsung.com>

For read jobs, users should have the option to verify header seeds at a
later point of time. Currently for read jobs header seeds are not
generated

Consider the below mentioned write followed by read workloads. Here fio
should allow header seed verification.

fio --name=test --filesize=16k --rw=randwrite --verify=md5
fio --name=test --filesize=16k --rw=randread --verify=md5 --verify_header_seed=1

However there are other scenarios where header seed verification will
fail. These include:
 * randrepeat is set to false, leading to different seed across runs.
 * randseed is different across write and read workloads.
 * Read workload is changed from sequential to random or vice versa
   across runs.
 * Read workloads run in the same invocation as write, i.e. a write job
   followed by a stonewall read job. Header seed verification will fail
   because random seeds vary between jobs. Refer t/jobs/t0029.fio

If verify_header_seed is explicitly enabled, fio will verify header seed
for the workload.

This reverts part of commit mentioned below
Fixes: def41e55 ("verify: decouple seed generation from buffer fill")

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 16 ++++++++++++----
 backend.c | 11 +++++++++++
 fio.1     | 15 +++++++++++----
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 05bdeebb..6d462af3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3907,10 +3907,18 @@ Verification
 			:option:`ioengine`\=null, not for much else.
 
 	This option can be used for repeated burn-in tests of a system to make sure
-	that the written data is also correctly read back. If the data direction
-	given is a read or random read, fio will assume that it should verify a
-	previously written file. If the data direction includes any form of write,
-	the verify will be of the newly written data.
+	that the written data is also correctly read back.
+
+	If the data direction given is a read or random read, fio will assume that
+	it should verify a previously written file. In this scenario fio will not
+	verify the block number written in the header. The header seed won't be
+	verified, unless its explicitly requested by setting
+	:option:`verify_header_seed`. Note in this scenario the header seed check
+	will only work if the read invocation exactly matches the original write
+	invocation.
+
+	If the data direction includes any form of write, the verify will be of the
+	newly written data.
 
 	To avoid false verification errors, do not use the norandommap option when
 	verifying data with async I/O engines and I/O depths > 1.  Or use the
diff --git a/backend.c b/backend.c
index f3e5b56a..f5cfffdb 100644
--- a/backend.c
+++ b/backend.c
@@ -1069,6 +1069,17 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
 
+			/*
+			 * For read only workloads generate the seed. This way
+			 * we can still verify header seed at any later
+			 * invocation.
+			 */
+			if (!td_write(td) && !td->o.verify_pattern_bytes) {
+				io_u->rand_seed = __rand(&td->verify_state);
+				if (sizeof(int) != sizeof(long *))
+					io_u->rand_seed *= __rand(&td->verify_state);
+			}
+
 			if (verify_state_should_stop(td, io_u)) {
 				put_io_u(td, io_u);
 				break;
diff --git a/fio.1 b/fio.1
index 1342a23a..3fbc1657 100644
--- a/fio.1
+++ b/fio.1
@@ -3634,10 +3634,17 @@ Only pretend to verify. Useful for testing internals with
 .RE
 .P
 This option can be used for repeated burn\-in tests of a system to make sure
-that the written data is also correctly read back. If the data direction
-given is a read or random read, fio will assume that it should verify a
-previously written file. If the data direction includes any form of write,
-the verify will be of the newly written data.
+that the written data is also correctly read back.
+.P
+If the data direction given is a read or random read, fio will assume that it
+should verify a previously written file. In this scenario fio will not verify
+the block number written in the header. The header seed won't be verified,
+unless its explicitly requested by setting \fBverify_header_seed\fR option.
+Note in this scenario the header seed check will only work if the read
+invocation exactly matches the original write invocation.
+.P
+If the data direction includes any form of write, the verify will be of the
+newly written data.
 .P
 To avoid false verification errors, do not use the norandommap option when
 verifying data with async I/O engines and I/O depths > 1.  Or use the
-- 
2.25.1

