Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECD6C433FE
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 21:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7588A61159
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 21:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhIUVfC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 17:35:02 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:24997 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhIUVe7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 17:34:59 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 17:34:59 EDT
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20210921212712usoutp0145a6d6bc48a4da6e3122b30d472029bc~m83zcLSIQ0957209572usoutp01g;
        Tue, 21 Sep 2021 21:27:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20210921212712usoutp0145a6d6bc48a4da6e3122b30d472029bc~m83zcLSIQ0957209572usoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632259632;
        bh=0Ne7ojHMDY17MQv6B8AU+8vO8LhsnMb47c8jP2H1AVI=;
        h=From:To:CC:Subject:Date:References:From;
        b=VX1W6chcCT0bR3+hTHLwIHrgXw2GZ7VhSI/FIEhFXL9QGBlotQ/qclluA6o5UhOWJ
         FG8csPDvw0587SrYZ539nErYvI7ZgbDG/twGCzQ9jl0ok69LlqWdYgpgVH8wF3ahdb
         hW2Q5lbhPEd/U8RPAzVAxTYaNJjwsFea6XHYG8g4=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210921212712uscas1p1143b51331fee30f303f584c66e5046b6~m83zOuSH41351713517uscas1p1F;
        Tue, 21 Sep 2021 21:27:12 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 52.8B.32368.03E4A416; Tue,
        21 Sep 2021 17:27:12 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210921212712uscas1p2aa572cf95c6782ee69be4dac7beb8f50~m83zBedLi1629916299uscas1p2x;
        Tue, 21 Sep 2021 21:27:12 +0000 (GMT)
X-AuditID: cbfec36d-bebff70000017e70-e1-614a4e309fa9
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 79.FE.56110.F2E4A416; Tue,
        21 Sep 2021 17:27:11 -0400 (EDT)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Tue, 21 Sep 2021 14:27:11 -0700
Received: from SSI-EX1.ssi.samsung.com ([fe80::bc40:3104:26cd:107e]) by
        SSI-EX1.ssi.samsung.com ([fe80::bc40:3104:26cd:107e%7]) with mapi id
        15.01.2242.008; Tue, 21 Sep 2021 14:27:11 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2] run-fio-tests: make test runs more resilient
Thread-Topic: [PATCH v2] run-fio-tests: make test runs more resilient
Thread-Index: AQHXry9wa3NloyjyyESED/6k1gJnUQ==
Date:   Tue, 21 Sep 2021 21:27:11 +0000
Message-ID: <20210921212639.61319-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djX87oGfl6JBh8ahSxW3+1ns/g46wWz
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBlzLz+n71gFU/Frvtr2BoYmzm7GDk5JARMJHoP
        P2fuYuTiEBJYySgxs3EbO4TTyiTR/OsNC0zVslN9rBCJtYwS09pWsUE4HxklJtw6yQjhHGCU
        6N4wBaiMg4NNQFPi7f4CkG4RgTCJn4+2s4LYzALqEsc2bmADsYUFHCSurtvNClHjKnFudgMz
        hK0n0d/wlgnEZhFQlfiybz3YFbwC1hLv93YwgtiMAmIS30+tYYKYKS5x68l8JohLBSUWzd7D
        DGGLSfzb9ZANwlaUuP/9JTtEvZ7EjalT2CBsbYllC18zQ8wXlDg58wnUx5ISB1fcYAH5S0Lg
        I7vE8zn3oYa6SEx49RuqSFpi+prLUPY5RokH/4IhGq4zSqz4spgVImEtsfDPeqhL+ST+/nrE
        CAogCQFeiY42oQmMSrOQ/DALyX2zkNw3C8l9CxhZVjGKlxYX56anFhvmpZbrFSfmFpfmpesl
        5+duYgSmjdP/DufuYNxx66PeIUYmDsZDjBIczEoivKlP3BKFeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ834ynBgvJJCeWJKanZpakFoEk2Xi4JRqYJozc+nft1UuV06vPu0pp1VZYai7qO+5/n0W
        1irr9Tt/+Rf55RxJ2bTl7BPlmXyS/4S93nl8PXVxm8niiLzYui5/C6tPpazzv0SWq9l19IQH
        Wx+ao+tzVaZYasNv+4qELdXOj39fvM1bcWCHeMjq25ysjB2TpPtLsv9FpF6+W3VbsWK+//WV
        8sIyxye/2LT0yqu38mXvPm5kW7Wjj//KsviLp1b8buW8HOpT94CRc/3irZrRLB9mfmIP2iHg
        b6Lxvv35vRQHC+eC5JvrV+Z0PUo+NGPxyrXH78jMlpPZwHvU6FDY9isadwOOTJvZlL/LNWzD
        +UZPBu5TGoysuvlqPy1nWkrkG7af2HlkY1+8So4SS3FGoqEWc1FxIgDYFoHZigMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWS2cA0UVffzyvRoI3RYvXdfjaLj7NeMDsw
        eVw+W+rxeZNcAFMUl01Kak5mWWqRvl0CV8bM6//ZC1bxVOy6v4atgbGZs4uRk0NCwERi2ak+
        1i5GLg4hgdWMEhtntjNBOB8ZJfq7bzJCOAcYJeYdfw6U4eBgE9CUeLu/AKRbRCBM4uej7awg
        NrOAusSxjRvYQGxhAQeJq+t2s0LUuEqcm93ADGHrSfQ3vGUCsVkEVCW+7FvPAmLzClhLvN/b
        wQhiMwqISXw/tYYJYqa4xK0n85kgLhWQWLLnPDOELSrx8vE/VghbUeL+95fsEPV6EjemTmGD
        sLUlli18zQwxX1Di5MwnLBD1khIHV9xgmcAoOgvJillI2mchaZ+FpH0BI8sqRvHS4uLc9Ipi
        47zUcr3ixNzi0rx0veT83E2MwDg5/e9wzA7Ge7c+6h1iZOJgPMQowcGsJMKb+sQtUYg3JbGy
        KrUoP76oNCe1+BCjNAeLkjivR+zEeCGB9MSS1OzU1ILUIpgsEwenVANT9RYnF5Wc1mVz77lf
        OJBhKRV/3zWrPIRDQizk/N+5TH7/+t9OF2iRcQl/8S50zfFzPNLRDppl1naqs1zb3m9+ef9z
        6I3pOzh8OKb3r1E9fbl0qeQOJ6Piri/s1Z+9VmyWem/ufTnn22Uz7n8NIkyCV9WD7T96vr68
        YW/fgyX5qr9Nvdd8nKNrptt90FDw6ezS1w6Ne3R4e6WOnsv6rG/yiJ/d7/K+Dx+3Tlo2+47l
        2nrvCWnGmbzP3kT8qOMo+PWnhTWwWU1hT/Jpfx0xP/8D1Vf+8noxT+xeOKduxu46nwObf01U
        fbH+tLTb2Z9f1vdyB2dnTtZWbVFptYmd/u7ywngP/yti7zu3LsvyN9VUYinOSDTUYi4qTgQA
        okqyXAIDAAA=
X-CMS-MailID: 20210921212712uscas1p2aa572cf95c6782ee69be4dac7beb8f50
CMS-TYPE: 301P
X-CMS-RootMailID: 20210921212712uscas1p2aa572cf95c6782ee69be4dac7beb8f50
References: <CGME20210921212712uscas1p2aa572cf95c6782ee69be4dac7beb8f50@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Catch exceptions that occur during test setup/running/evaluation. This
makes it more likely that the entire test suite can run to completion
even if some tests fail in an unexpected fashion.

In particular I have seen failures in FioJobTest_t0014() when the test
is run on a bare metal machine. Without this patch these failures make
the entire script grind to a halt.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
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
