Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F4BC433FE
	for <fio@archiver.kernel.org>; Fri,  7 Oct 2022 12:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiJGMFo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 7 Oct 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJGMFn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Oct 2022 08:05:43 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E975558161
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 05:05:36 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221007120531euoutp01a804128ee835dbfd406723f90ca59168~bx-JzAy0I2441724417euoutp01r
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 12:05:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221007120531euoutp01a804128ee835dbfd406723f90ca59168~bx-JzAy0I2441724417euoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665144331;
        bh=08TCUp4E3509Ok+nElHz10U+beWC284eTQ/m7KZ1Di8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UvPmdGVds/swY6Nk/NUolTBUU7VVL+tTKYz4nX9POBZZ0Locv539mreJwunsY2Oeg
         aw9zVJ9DPnGtAJv5hLoO8rbkLznPhx/8EVyQH+xNFh8mPYQe3aXu5YAGFeMaGR2Qrg
         YKcxmUuHa4qx5QP/yJmN7EXlPXDgz+9KiB4Y/iZA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221007120530eucas1p25eab628dcd9c5d73cd836e7bfbc1e278~bx-I7eAJz0054700547eucas1p2q;
        Fri,  7 Oct 2022 12:05:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 78.48.07817.A0610436; Fri,  7
        Oct 2022 13:05:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221007120530eucas1p16e2b45344e7148a39789645352a5aba8~bx-Iod1Q_2983629836eucas1p1T;
        Fri,  7 Oct 2022 12:05:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221007120530eusmtrp1db8eeb1838ac2b374fb6c82a098c013c~bx-InpOWK2739927399eusmtrp1I;
        Fri,  7 Oct 2022 12:05:30 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-5e-6340160aeec1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 16.3A.07473.A0610436; Fri,  7
        Oct 2022 13:05:30 +0100 (BST)
Received: from localhost (unknown [106.210.248.47]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221007120529eusmtip1a2da0f657b5824a31b09d37642095990~bx-ITgzBF1406914069eusmtip1B;
        Fri,  7 Oct 2022 12:05:29 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     fio@vger.kernel.org
Cc:     gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] examples: uring-cmd-zoned: expand the reasoning behind QD1
Date:   Fri,  7 Oct 2022 14:05:28 +0200
Message-Id: <20221007120528.58106-1-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWy7djP87pcYg7JBpf7JCw+znrBbHHzwE4m
        i89LW9gdmD36tqxi9Pi8SS6AKYrLJiU1J7MstUjfLoEr4/avxSwFM9grVu5sZW5g/MjaxcjJ
        ISFgInHr1iS2LkYuDiGBFYwS69o/sEI4XxglJh05wwThfGaUmP9wLQtMy+1bC6FaljNK/Pn3
        nBkkISTwglFi3yH2LkYODjYBLYnGTnaQsIiAuMS1F+vAbGYBO4mj59YygdjCAt4SX/fcA2tl
        EVCVuHxoGTNIK6+ApcTNA9kQq+QlZl76DtbKKyAocXLmExaIMfISzVtnM4OcICHwkl1iz8YN
        7BANLhLP//dDvSYs8er4Fqi4jMTpyT1Q91dLPL3xG6q5hVGif+d6NpDFEgLWEn1nckBMZgFN
        ifW79CHKHSWOvf3NClHBJ3HjrSDECXwSk7ZNZ4YI80p0tAlBVCtJ7Pz5BGqphMTlpjlQSz0k
        tn+9zwYJp1iJhoNT2ScwKsxC8tgsJI/NQrhhASPzKkbx1NLi3PTUYqO81HK94sTc4tK8dL3k
        /NxNjMD0cPrf8S87GJe/+qh3iJGJg/EQowQHs5II786ddslCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEedlmaCULCaQnlqRmp6YWpBbBZJk4OKUamCQz587YOPurQfeKjvroSxetlmbJ7l0k2Op2
        TCDGafHO4Cm2HOU6rb+35FRHHmDYk6jZnBgqHvNMY0aKZbu1aPDb7YfuZTyJctDd6NNiKKb7
        KzT5pbn3V5uFKfaLXe7aL/j0+e48VT+pdoUvbyVlnLkXH/xrnPvJ5p98nO55hg+Vl/yXPzlS
        5/Dm7OXnp19cWCT/57rR9L+a1dnuWh3zfspn/XXeHeZhtd8vvvn1vB851WwZQj1ahZ+lp0pK
        tf7sn/zx+EfJp51H/9x0OuYoMttJJuoe88SzJR8Mdy9/7/kh2qdBWKnO1uX2wZYgU1ERIyMH
        l717drI83zV7QVQZ39R0qZZCy6onB96mO98KV2Ipzkg01GIuKk4EAAbQRMx+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xu7pcYg7JBhtfMVt8nPWC2eLmgZ1M
        Fp+XtrA7MHv0bVnF6PF5k1wAU5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGp
        kr6dTUpqTmZZapG+XYJexu1fi1kKZrBXrNzZytzA+JG1i5GTQ0LAROL2rYVsXYxcHEICSxkl
        9l7bwQiRkJC4vbAJyhaW+HOtC6roGaPEypc3gLo5ONgEtCQaO9lBakQExCWuvVgHZjMLOEg0
        bzgD1iss4C3xdc89ZhCbRUBV4vKhZcwgrbwClhI3D2RDjJeXmHnpO1grr4CgxMmZT1ggxshL
        NG+dzTyBkW8WktQsJKkFjEyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAkNz27Gfm3cwznv1
        Ue8QIxMH4yFGCQ5mJRHenTvtkoV4UxIrq1KL8uOLSnNSiw8xmgKdN5FZSjQ5HxgdeSXxhmYG
        poYmZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTEmJWqWeq/mKmAvduPZOLJNk
        9bVZcbBm5bp9SwUWGHOyxCcWZZxLN5RSfLLkGf+tgAVz2E9/O3H0mQ1fesXpKEZdVzcJJ82c
        2JlCLxPjeJat+HXX98mpizel8vVt5R+z2n3L6pxZWKohmxN+Oe21YZLs1Du6Wx+kZaR5JRkF
        OrAcVJD5vT217PblBzlRsgllXXeFWdxjtS68+CX0btMc/8v5N4TE02/3HX/IFTI7THTBxsXT
        fiqGuFwJ/q5Z5yTc7vHyeF0ra3TG8rD2xHPztG5vaV7A88P6+u++wn1bpL/Nr9RjLjzTfHOS
        hEs4z/LuqNW1em+Dcg52Sr09IK2vJzS/Q2aZe7HPrnrekmglluKMREMt5qLiRADQc35z1gIA
        AA==
X-CMS-MailID: 20221007120530eucas1p16e2b45344e7148a39789645352a5aba8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221007120530eucas1p16e2b45344e7148a39789645352a5aba8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221007120530eucas1p16e2b45344e7148a39789645352a5aba8
References: <CGME20221007120530eucas1p16e2b45344e7148a39789645352a5aba8@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Expand the reasoning behind using QD1 for zoned devices with io_uring_cmd
engine.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 examples/uring-cmd-zoned.fio | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
index 58e8f79e..89be61be 100644
--- a/examples/uring-cmd-zoned.fio
+++ b/examples/uring-cmd-zoned.fio
@@ -1,7 +1,11 @@
 # io_uring_cmd I/O engine for nvme-ns generic zoned character device
 #
-# NOTE: with write workload iodepth must be set to 1 as there is no IO
-# scheduler.
+# NOTE:
+# Regular writes against a zone should be limited to QD1, as the device can
+# reorder the requests.
+#
+# As the passthrough path do not use an IO scheduler (such as mq-deadline),
+# the queue depth should be limited to 1 to avoid zone invalid writes.
 
 [global]
 filename=/dev/ng0n1
-- 
2.25.1

