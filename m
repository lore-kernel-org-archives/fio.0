Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44715C433EF
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 21:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304C061131
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 21:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhIUVfD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 17:35:03 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:24975 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbhIUVfA (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 17:35:00 -0400
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20210921212510usoutp015e5206927203f7f2bc669d5eb26692d8~m82Bf7P0e0550105501usoutp01Q;
        Tue, 21 Sep 2021 21:25:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20210921212510usoutp015e5206927203f7f2bc669d5eb26692d8~m82Bf7P0e0550105501usoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632259510;
        bh=8yfLzhS/HcJHmaZaA+g0E3nweRjnLysklCn8yRhmvHY=;
        h=From:To:CC:Subject:Date:References:From;
        b=SJ132XG6LxQmABA20JXq9p36noft3vVVAluqozwQIysl7T4CsalUsAenpY+zWCOnN
         s4kB8xlPk3T45OTtj7WlLxkAPieoc52rUC9R02srf7TuWKP0ZChgyGRXdoogxtrzGp
         KnDeqlWtqb4xkpjVUOT2fgT+RS6oOgZt8fzYPMoc=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210921212510uscas1p2e93c95d36d4fb8774e4724f81273d8c5~m82BWTysb1581615816uscas1p2b;
        Tue, 21 Sep 2021 21:25:10 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id E7.4B.32368.5BD4A416; Tue,
        21 Sep 2021 17:25:09 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210921212509uscas1p2cb672c3c98ba460d5c859f29961ca6cf~m82BB3cY30748607486uscas1p2N;
        Tue, 21 Sep 2021 21:25:09 +0000 (GMT)
X-AuditID: cbfec36d-bebff70000017e70-9f-614a4db5bfe5
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 9E.BF.26904.5BD4A416; Tue,
        21 Sep 2021 17:25:09 -0400 (EDT)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Tue, 21 Sep 2021 14:25:08 -0700
Received: from SSI-EX1.ssi.samsung.com ([fe80::bc40:3104:26cd:107e]) by
        SSI-EX1.ssi.samsung.com ([fe80::bc40:3104:26cd:107e%7]) with mapi id
        15.01.2242.008; Tue, 21 Sep 2021 14:25:08 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] run-fio-tests: make test runs more resilient
Thread-Topic: [PATCH] run-fio-tests: make test runs more resilient
Thread-Index: AQHXry8nHt2CRxXeSEeMSKEF43K0Nw==
Date:   Tue, 21 Sep 2021 21:25:08 +0000
Message-ID: <20210921212450.61262-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7pbfb0SDabutrRYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcfTAZ7aCL9wVDXN3MDcwXuHoYuTkkBAwkfjX
        uZCpi5GLQ0hgJaPE1+0L2SCcViaJzhc7GWGqLkzfzAqRWMso8fLzK0YI5yOjxLtzx5ghnAOM
        EtNPdAOVcXCwCWhKvN1fANItIhAm8fPRdlYQm1lAXeLYxg1sILawgK3E5e4XbBA1ThLfXrwD
        axUR0JNoamYHCbMIqEr07P0D1sorYC3xpGkZmM0oICbx/dQaJoiR4hK3nsxngjhUUGLR7D3M
        ELaYxL9dD9kgbEWJ+99fskPU60ncmDqFDcLWlli28DUzxHxBiZMzn7BA1EtKHFxxgwXkLQmB
        j+wSh5pOQQ11kdhxbjM7hC0t8ffuMqjF5xglHvwLhmi4ziix4stiVoiEtcTCP+uhLuWT+Pvr
        ESPIkxICvBIdbUITGJVmIflhFpL7ZiG5bxaS+xYwsqxiFC8tLs5NTy02zEst1ytOzC0uzUvX
        S87P3cQITBqn/x3O3cG449ZHvUOMTByMhxglOJiVRHhTn7glCvGmJFZWpRblxxeV5qQWH2KU
        5mBREuf9ZDgxXkggPbEkNTs1tSC1CCbLxMEp1cCkKHdxT0tntLtZaSqLyqfYUwGeMZ6lex2e
        zzpgbfrV8+BX/syk3lWeHP/DDlke/anv2hp2m2Uy0/pj/7Jr+ZuWMPP+9Dk0k19qdtTJ7Ywt
        GZo2pgvK5kmvelCuv6j1Xv/7wEVbQ8vE532xsQ9l9v+jsfNnxpmN07bGrykPNijNUWq+57rG
        ZHqzmcG6yQkPXq5d8v1a9oIjcmd2WB38tFKBbeumtm0vvms3b7H6tmZGL/OG30q7Fm+cdvOg
        TPicO2anr/RyhbVPDmk32yknoXTTzWV3+fYvS58fN3lcX25g7M/yPkhW+LvGlnmsz9zvHTz4
        rNk9b/Lt9I/p52TCyipS3T8IfpBeY2W7vPjduoZEJZbijERDLeai4kQANYnJsYkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWS2cA0UXerr1eiwcPJKhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyjh74zFbwhbuiYe4O5gbGKxxdjJwcEgImEhem
        b2YFsYUEVjNKnN9rD2F/ZJRo/WHWxcgFZB9glFi5bg9zFyMHB5uApsTb/QUgNSICYRI/H20H
        62UWUJc4tnEDG4gtLGArcbn7BRtEjZPEtxfvWEFaRQT0JJqa2UHCLAKqEj17/4C18gpYSzxp
        WgZmMwqISXw/tYYJYqS4xK0n85kgzhSQWLLnPDOELSrx8vE/VghbUeL+95fsEPV6EjemTmGD
        sLUlli18zQwxX1Di5MwnLBD1khIHV9xgmcAoOgvJillI2mchaZ+FpH0BI8sqRvHS4uLc9Ipi
        o7zUcr3ixNzi0rx0veT83E2MwBg5/e9w9A7G27c+6h1iZOJgPMQowcGsJMKb+sQtUYg3JbGy
        KrUoP76oNCe1+BCjNAeLkjjvy6iJ8UIC6YklqdmpqQWpRTBZJg5OqQamsH93b24RrtU2YPPU
        WnK7h8OzaG2ZkWPcMYeriW/P/76vy/SGYXpmb5n5NdUAG7s7l+8dcE17f4anvVwj4wf/TYvO
        +ri7AoWimi/+9rCIKGU+PuUpnbaSfW+N+U/b+UxNOcvV59Ws+nl3M3e7hGa6lY+T5CqZbfwf
        mj9tY/+0JmrdA/sv/cFyB/g+LWGZk/Zhg0ziVIYZhea1pVKmSQdY1tz45u9ytNlUz9wte2rX
        0w+Vax8dXH6wp+VVa83OTv0f/gbO13foWax91jlr/TYhhT+OxwpsJNi82QV6cmaefnlnGn/b
        y5ddURafNk6Ou6ElcXaHvGikZqYY0+0cnXT9lLNlmpptKkuvM2W/CVViKc5INNRiLipOBADc
        CmKaAAMAAA==
X-CMS-MailID: 20210921212509uscas1p2cb672c3c98ba460d5c859f29961ca6cf
CMS-TYPE: 301P
X-CMS-RootMailID: 20210921212509uscas1p2cb672c3c98ba460d5c859f29961ca6cf
References: <CGME20210921212509uscas1p2cb672c3c98ba460d5c859f29961ca6cf@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Catch exceptions that occur during test setup/running/evaluation. This
makes it more likely that the entire test suite can run to completion
even if some tests fail in an unexpected fashion.

In particular I have seen failures in FioJobTest_t0014() when the test
is run on a bare metal machine. Without this patch these failures make
the entire script grind to a halt.
---
 t/run-fio-tests.py | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index a59cdfe0..612e50ca 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -49,6 +49,7 @@ import shutil
 import logging
 import argparse
 import platform
+import traceback
 import subprocess
 import multiprocessing
 from pathlib import Path
@@ -1057,9 +1058,16 @@ def main():
                 skipped =3D skipped + 1
                 continue
=20
-        test.setup(artifact_root, config['test_id'])
-        test.run()
-        test.check_result()
+        try:
+            test.setup(artifact_root, config['test_id'])
+            test.run()
+            test.check_result()
+        except KeyboardInterrupt:
+            break
+        except Exception as e:
+            test.passed =3D False
+            test.failure_reason +=3D str(e)
+            logging.debug("Test %d exception:\n%s\n", config['test_id'], t=
raceback.format_exc())
         if test.passed:
             result =3D "PASSED"
             passed =3D passed + 1
--=20
2.25.1
