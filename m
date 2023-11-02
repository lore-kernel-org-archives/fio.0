Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE1011C91
	for <fio@vger.kernel.org>; Thu,  2 Nov 2023 08:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pr6NTYHK"
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1768312C
	for <fio@vger.kernel.org>; Thu,  2 Nov 2023 01:48:11 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231102084808epoutp01801a29d02dcb60773dc3fdb88a0fcd80~TwhbmY0lI1060010600epoutp01U
	for <fio@vger.kernel.org>; Thu,  2 Nov 2023 08:48:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231102084808epoutp01801a29d02dcb60773dc3fdb88a0fcd80~TwhbmY0lI1060010600epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1698914888;
	bh=rjX3v6n/Bwql7h5keHEuV7pT9fzvu8OXonbmctR7rKs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=pr6NTYHKXZ1O23ZdX/ZWIqX2r1D23gnmrC1gz/lOvyisSisZVntnLfWjxX/jb1rin
	 qi0L2HUGICz/pC3RMMK9VSHOImRWeazW+ImUwOg7CQm1eM+dvM6HZJvIx37rNLDHIy
	 NKWsZk6MHIARwvO61u7YgtKa1OWmUONRR4Uh/3p0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231102084807epcas5p1f2cbef90e80fe0bab6a043a049f54edb~TwhbUCmMT2776527765epcas5p1i;
	Thu,  2 Nov 2023 08:48:07 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4SLcw630LMz4x9Q4; Thu,  2 Nov
	2023 08:48:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	68.64.08567.64263456; Thu,  2 Nov 2023 17:48:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231102084106epcas5p21fea8b9fb34faef6c9783d020e57a2f5~TwbTayC2S1532415324epcas5p2Z;
	Thu,  2 Nov 2023 08:41:06 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231102084106epsmtrp1d4230e5ce120f9b0fff945476d1a2471~TwbTaIMD31572615726epsmtrp1P;
	Thu,  2 Nov 2023 08:41:06 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-16-654362468b1d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.94.18939.2A063456; Thu,  2 Nov 2023 17:41:06 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231102084106epsmtip2c154177a4c1fb265104f033cc57bb0b1~TwbSq2RgU0915709157epsmtip2j;
	Thu,  2 Nov 2023 08:41:06 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, vincentfu@gmail.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH] engines/xnvme: fix fdp support for userspace drivers
Date: Thu,  2 Nov 2023 19:29:28 +0530
Message-Id: <20231102135928.195372-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7bCmuq5bknOqway3vBZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnrGk5yVawhq/i7d6tbA2MD7i7GDk5
	JARMJO5N2cPWxcjFISSwm1HizIbVrBDOJ0aJ+Q2nEJx3j/+xwLT8P/cWKrGTUaLh/UN2CKeT
	SaKxdRYrSBWbgLbEq7c3mEFsEQFhif0drWDdzAKhEievfWEHsYUFXCVOXzwJVsMioCrR93Ma
	WJxXwFbicvcyJoht8hIzL32HigtKnJz5BGqOvETz1tnMIIslBJaxS+zuWcwK0eAisebsF2YI
	W1ji1fEt7BC2lMTL/jYoO1ti08OfUAsKJI686IWqt5doPdUPZHMALdCUWL9LHyIsKzH11Dom
	iL18Er2/n0C18krsmAdjq0r8vXcbGkLSEjffXYWyPSQ+3TnGCGILCcRKXH90iHECo/wsJO/M
	QvLOLITNCxiZVzFKphYU56anJpsWGOallsNjNjk/dxMjOOFpuexgvDH/n94hRiYOxkOMEhzM
	SiK8h00dUoV4UxIrq1KL8uOLSnNSiw8xmgLDeCKzlGhyPjDl5pXEG5pYGpiYmZmZWBqbGSqJ
	875unZsiJJCeWJKanZpakFoE08fEwSnVwJRTmjKN4+j3j2qX/JxN4lf3J7iaXY4PLDPz3+4e
	9e7+xGvZMlsbLb5znepyqniy8pbTW6d5Miuj8zUl5Z1EnyUc816jeXGJ1V1X2/fVd5aqiX3v
	E0jjXFkRH2gZ8Pm71sbS8Ncbf4We7SvYt1mmLs33+gf3LStzb389qLowIOO68NSHzjPZosxC
	2/fnL0ud32zpXcQbWWuZmdslaaf/zrXrSwHDXYPQLayMr5mn6IX9+2d/99KETn5/JcdpYi+X
	pB9le6p8ufkgf4ydxWIeJ7W4Mxz/fxmutJp1Q/b+qzOMB7rlFY+baIRs8Tz/UOHznn0syys9
	mI0mFKxLXrD8X+Bmjw7PY2kM82raTlXOUGIpzkg01GIuKk4EADBuD0YBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsWy7bCSvO6iBOdUg2UzTSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MpY03KSrWAN
	X8XbvVvZGhgfcHcxcnJICJhI/D/3lrWLkYtDSGA7o8TWNdOAHA6ghLTEwvWJEDXCEiv/PWeH
	qGlnkti7ZDETSIJNQFvi1dsbzCC2CFDR/o5WFhCbWSBcYvqByYwgtrCAq8TpiyfBalgEVCX6
	fk5jB7F5BWwlLncvY4JYIC8x89J3qLigxMmZT6DmyEs0b53NPIGRbxaS1CwkqQWMTKsYRVML
	inPTc5MLDPWKE3OLS/PS9ZLzczcxggNOK2gH47L1f/UOMTJxMB5ilOBgVhLhPWzqkCrEm5JY
	WZValB9fVJqTWnyIUZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXApCP7W9c9yIVvcdUF
	ibtJgSf3KwlYBH06+ebbhpA1vUflG9Y4+vtLqm1dHqEgwbGSY86djSyxLuumCIi7mGmdfm29
	Umupq2z1s/O9urVrbTo15O982fm+ou7IlOP7HleVMF8xFcrNVqjlupqzoehKhsnvRZFbDjff
	SkpJceGatcjTRvVISJ1c5UZtr669+tY/125JFyssedVhuNqR5c6n1C+rnfbHV2dt/aNjeP+C
	tOnsi+55rD91v/6vF7b9f/NR32rrU/HT90WL7jJu5ZxmzcEWtLDaec+PO3v3+ezr+PjG1lr0
	jKcy253LapO5mnxf+FTtm6a88cWpXfES0yqm/y002yewvO5cw92sM22CSizFGYmGWsxFxYkA
	/890yqcCAAA=
X-CMS-MailID: 20231102084106epcas5p21fea8b9fb34faef6c9783d020e57a2f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231102084106epcas5p21fea8b9fb34faef6c9783d020e57a2f5
References: <CGME20231102084106epcas5p21fea8b9fb34faef6c9783d020e57a2f5@epcas5p2.samsung.com>

The xNVMe backend supports FDP commands for userspace drivers
such as SPDK. Enable support in the xnvme ioengine.
Update the xnvme fdp example file accordingly.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/xnvme.c        |  2 +-
 examples/xnvme-fdp.fio | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/engines/xnvme.c b/engines/xnvme.c
index ce7b2bdd..b7824013 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -964,7 +964,7 @@ static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	uint32_t nsid;
 	int err = 0, err_lock;
 
-	if (f->filetype != FIO_TYPE_CHAR) {
+	if (f->filetype != FIO_TYPE_CHAR && f->filetype != FIO_TYPE_FILE) {
 		log_err("ioeng->fdp_ruhs(): ignoring filetype: %d\n", f->filetype);
 		return -EINVAL;
 	}
diff --git a/examples/xnvme-fdp.fio b/examples/xnvme-fdp.fio
index 86fbe0d3..c50959f1 100644
--- a/examples/xnvme-fdp.fio
+++ b/examples/xnvme-fdp.fio
@@ -16,6 +16,26 @@
 ;   --xnvme_sync=nvme \
 ;   --filename=/dev/ng0n1
 ;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
 ; FIO_BS="512" FIO_RW="read" FIO_IODEPTH=16 fio examples/xnvme-fdp.fio \
 ;   --section=override --ioengine=xnvme --xnvme_sync=nvme --filename=/dev/ng0n1
 ;
-- 
2.25.1

