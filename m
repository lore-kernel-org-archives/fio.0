Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B562EC4332F
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbiEWSmY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244556AbiEWSlq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:41:46 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0B7188E77
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:22:37 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175713usoutp02cfaf161bc56aeef2758484afeb9b2ed0~xzaH_pV092760727607usoutp028;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523175713usoutp02cfaf161bc56aeef2758484afeb9b2ed0~xzaH_pV092760727607usoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328633;
        bh=Z9O0Q6kDYvont8y1hOs/1sZQfQUc6HK6cwqYZbYnZIk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Tr8mLGsdwKjUP6TiNP1GVW9ObsxHJZQwKJn0PToqwlaCezfvo71j9q9eF132cZseL
         5HuUYN6H0MJ3f+CYaDtRGp3YlzkLoxZEVZxcZ1InYyxLkkZ2z4/s2OQwLVD6gyGKKc
         cRtsge08iI8Org19t2rQcuOpti+p1FFwKdzScw6A=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p177023f4d01bf62d34a30166096eb0a46~xzaH2iNtz0098600986uscas1p1y;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 13.D1.09749.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p2554fb9f5a5cc7b150f3fdc08bfb4a113~xzaHkwqlE0404104041uscas1p2x;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-b7-628bcaf9f9eb
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 8F.4C.52349.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:12 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:12 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 4/6] t/run-fio-tests: improve json data decoding
Thread-Topic: [PATCH 4/6] t/run-fio-tests: improve json data decoding
Thread-Index: AQHYbs6HwU2OaEfsdkGCWWdJJ0oqBA==
Date:   Mon, 23 May 2022 17:57:12 +0000
Message-ID: <20220523175650.130895-5-vincent.fu@samsung.com>
In-Reply-To: <20220523175650.130895-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87o/T3UnGcz8q2Gx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY/7rKSwFC3kr+o9eZWlgPMjZxcjJISFgIrH0
        /RS2LkYuDiGBlYwS668fYYJwWpkkNp2bCJThAKs6sSMVpEFIYC2jxJ67khA1nxglnp54wgjh
        LGOU+Hn5AzNIA5uApsTb/QUgDSICYRI/H21nBbGZBdQljm3cwAZiCws4SKy5e4ENosZVov/t
        YShbT2LX77mMIDaLgKrEon9XGUFG8grYSCx+agcS5hSwldi56DM7iM0oICbx/dQaJojx4hK3
        nsxngnhMUGLR7D3MELaYxL9dD9kgbEWJ+99fskPU60ncmDqFDcLWlli28DVYPS9Q78mZT1gg
        6iUlDq64wQLyooRAJ4fE3L6frJAwcZGY0mIPUSMtcfX6VGaImnZGibkbv0A1T2CUuP5ECsK2
        lvjXeQ1qMZ/E31+PGCcwKs9CcvcsJDfNQnLTLCQ3LWBkWcUoXlpcnJueWmycl1quV5yYW1ya
        l66XnJ+7iRGYME7/O1ywg/HWrY96hxiZOBgPMUpwMCuJ8G5P7EgS4k1JrKxKLcqPLyrNSS0+
        xCjNwaIkzrssc0OikEB6YklqdmpqQWoRTJaJg1Oqgam7ZVubd0CN/mVOP6azf2X0i9OcPhVM
        qjqUf8Ri9koplxWNvpKrV1rqSDVx3Gt4Hq1fumX64ymObKfX7thtUMz/XE99YQBPWfCs078s
        pR0zH+/2Yt/nEiIg7bu4gPvq6nlbb876sO2FqVq4YL1sHc9Tj5udyb53GLdYXuw9erkpU8dq
        itC0/ZUrX0T2bdz1lnfFGWdGZg+BwNNzmVo0xZ0/h3GXPannUwj+GN/b+/+GAvuOjw9uRwdy
        3D586K3ElbgzNoEddhfU1R/e7nZ94bpht96arp51Nk/expp+1zygXeX1Rd/wzE2XIyo/b9aG
        n+P5vkH7d+C6oy+XPXRUNv0md/TKX/WPm+emKpz9WajEUpyRaKjFXFScCAA77dBThwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCaqPvzVHeSwdnLQhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgy5r+ewlKwkLei/+hVlgbGg5xdjBwcEgImEid2
        pHYxcnEICaxmlDi4cTorhPOJUeL5xy3sEM4yRolfl98xgXSwCWhKvN1f0MXIySEiECbx89F2
        VhCbWUBd4tjGDWwgtrCAg8SauxfYIGpcJfrfHoay9SR2/Z7LCGKzCKhKLPp3lRFkJK+AjcTi
        p3YgYSEg8+uXDhYQm1PAVmLnos/sIDajgJjE91NrmCBWiUvcejIfzJYQEJBYsuc8M4QtKvHy
        8T9WCFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXwNVs8rIChxcuYTFoh6SYmDK26wTGAUn4VkxSwk
        7bOQtM9C0r6AkWUVo3hpcXFuekWxYV5quV5xYm5xaV66XnJ+7iZGYFSd/nc4cgfj0Vsf9Q4x
        MnEwHmKU4GBWEuHdntiRJMSbklhZlVqUH19UmpNafIhRmoNFSZxXyHVivJBAemJJanZqakFq
        EUyWiYNTqoFpbVKMXkWnl7iDQbFFcVBjBGvQ/5+3r38R6k4MYUgpF1guVPr6icACTiFV7pSW
        3BOnLomYd7yPq660V2nyDqps1DNLP/7/i2vird7Q6J8BfF0zXm8Iq2LVbO7b+m77MxftYxUd
        bet88jxtH8n+2PEvg5mrVWPBo+q1k+5zrnPbM/Vo/gzW1j3tgi8ZWPl3cj37IOmd3BYiuGgr
        m8/skN2SnEIXLxm0/jjBJ2jTlvr+ytaDP5c+k3xftCL4hE1AuNLtv9lWvOXH0n4UeUi1Ma5y
        FLAy7fg93d7jo3/OLM6COzOtxSR/Lv+wyJ19rvz2SenGx94d4Qyu+5XzKe+qGb/xTIn55ssU
        t11UXsUTosRSnJFoqMVcVJwIAE/uTxMZAwAA
X-CMS-MailID: 20220523175713uscas1p2554fb9f5a5cc7b150f3fdc08bfb4a113
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p2554fb9f5a5cc7b150f3fdc08bfb4a113
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p2554fb9f5a5cc7b150f3fdc08bfb4a113@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Instead of skipping up to five lines, just skip everything until the
opening curly brace when trying to decode JSON data.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/run-fio-tests.py | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index ecceb67e..32cdbc19 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -311,21 +311,15 @@ class FioJobTest(FioExeTest):
         #
         # Sometimes fio informational messages are included at the top of =
the
         # JSON output, especially under Windows. Try to decode output as J=
SON
-        # data, lopping off up to the first four lines
+        # data, skipping everything until the first {
         #
         lines =3D file_data.splitlines()
-        for i in range(5):
-            file_data =3D '\n'.join(lines[i:])
-            try:
-                self.json_data =3D json.loads(file_data)
-            except json.JSONDecodeError:
-                continue
-            else:
-                logging.debug("Test %d: skipped %d lines decoding JSON dat=
a", self.testnum, i)
-                return
-
-        self.failure_reason =3D "{0} unable to decode JSON data,".format(s=
elf.failure_reason)
-        self.passed =3D False
+        file_data =3D '\n'.join(lines[lines.index("{"):])
+        try:
+            self.json_data =3D json.loads(file_data)
+        except json.JSONDecodeError:
+            self.failure_reason =3D "{0} unable to decode JSON data,".form=
at(self.failure_reason)
+            self.passed =3D False
=20
=20
 class FioJobTest_t0005(FioJobTest):
--=20
2.25.1
