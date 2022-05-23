Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3806C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiEWScz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiEWSca (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:32:30 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B06006C
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:07:03 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175713usoutp0180ee42e0871a946c2d338a65b45f0957~xzaH3yIPw1112211122usoutp01e;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220523175713usoutp0180ee42e0871a946c2d338a65b45f0957~xzaH3yIPw1112211122usoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328633;
        bh=41bSFFQRs8jKVsO3vdOI3Q4WWV+4OPhxYP2D7na2goI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=sBtAFocD+djJnLiyrKj279weQk6zP7yXD3G95lcL6CHciVSlIXCHqO542vGTU6gAr
         iVK04bo4YRfD1yzzlGvRGmeY8nJvfYW032bOl/+LbK+0ZoCXpZuJDqM+jBVvgYm5ZF
         U6594sbl9WYL/0kDflhnVXJLhh1+BJTuJEGZchzg=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p286139c373885e664827d282fab00c13e~xzaHekYsB2501325013uscas1p2K;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 72.1A.09642.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175712uscas1p2c81666b4057700908d887bddb644ff89~xzaHIVhZD2033720337uscas1p2b;
        Mon, 23 May 2022 17:57:12 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-c8-628bcaf98fff
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id BA.8C.52945.8FACB826; Mon,
        23 May 2022 13:57:12 -0400 (EDT)
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
Subject: [PATCH 1/6] steadystate: delete incorrect comment
Thread-Topic: [PATCH 1/6] steadystate: delete incorrect comment
Thread-Index: AQHYbs6Hsl/57AC4oEOp20w5M209+Q==
Date:   Mon, 23 May 2022 17:57:11 +0000
Message-ID: <20220523175650.130895-2-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7o/T3UnGbRtELBYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVsevRBNaCpRwVUzYuY29gvMTWxcjBISFgIvF/
        XWEXIxeHkMBKRomeO3/YIJxWJonOxqWMMEVPrpVDxNcySuzrvscM4XxilHh64gkjhLOMUeLn
        5Q/MIB1sApoSb/cXdDFycogIhEn8fLSdFcRmFlCXOLZxAxuILSxgJTGn5RM7RI29xPONFxkh
        bD2JS3O3MYPYLAKqEm9v3Aar5xWwkeie85sFxOYUsJXYuegzWC+jgJjE91NrmCDmi0vcejIf
        zJYQEJRYNHsPM4QtJvFv10M2CFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDLFLUOLkzCcsEPWS
        EgdX3ICyOzkk1vWoQwLFReLwegGIsLTE9DWXWUDBICHQzigxd+MXqPoJjBLXn0hB2NYS/zqv
        Qe3lk/j76xHjBEblWUjOnoXkpFlITpqF5KQFjCyrGMVLi4tz01OLjfJSy/WKE3OLS/PS9ZLz
        czcxAhPG6X+H83cwXr/1Ue8QIxMH4yFGCQ5mJRHe7YkdSUK8KYmVValF+fFFpTmpxYcYpTlY
        lMR5l2VuSBQSSE8sSc1OTS1ILYLJMnFwSjUwiYjquSc7vJX/575kbbvF/ylSTqwp7F6Zf1df
        1eNyePaNhTOjSyZn+uQj8q67q3JZdjhdL1B1k730TDDU9OerSvVdm/Z+zy2/pf94lebvj/87
        g/d8cjog7rUsp/Mhww+TW6dnP7vMmvWT2y8rX7Lh9zdRj4wTcuaRiroM2R6i69Q25jR3vVlf
        odu7ZQOX9pHfTsk5huaWL88zxdcdX7qG96Z66EG5i0u1Vj9Z/cuwX7Nu32l2hq9yDFd85nEt
        37gofNLLNd+CHzyYfjxF89DZInW/i44BT8u9Vq0WXTK53D5t7yHunyU+P3yY5i154BT+fcnu
        25/WL7DZ++n8jflPp/ed04r5cGObnYydxtZLb5VYijMSDbWYi4oTAfs47SOHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapPvjVHeSQc9ZI4vVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZux5NYC1YylExZeMy9gbGS2xdjBwcEgImEk+u
        lXcxcnEICaxmlPjVdYIRwvnEKPH84xZ2CGcZUObyOyaQDjYBTYm3+wu6GDk5RATCJH4+2s4K
        YjMLqEsc27iBDcQWFrCSmNPyiR2ixl7i+caLjBC2nsSluduYQWwWAVWJtzdug9XzCthIdM/5
        zQJiCwHZX790gNmcArYSOxd9BpvDKCAm8f3UGiaIXeISt57MB7MlBAQkluw5zwxhi0q8fPyP
        FcJWlLj//SU7RL2exI2pU9ggbG2JZQtfM0PsFZQ4OfMJC0S9pMTBFTdYJjCKz0KyYhaS9llI
        2mchaV/AyLKKUby0uDg3vaLYOC+1XK84Mbe4NC9dLzk/dxMjMK5O/zscs4Px3q2PeocYmTgY
        DzFKcDArifBuT+xIEuJNSaysSi3Kjy8qzUktPsQozcGiJM7rETsxXkggPbEkNTs1tSC1CCbL
        xMEp1cC0zkivhi3aTb1Fe/GEjbz8f2Q8DGsflIrPnGBb0ivJ4u+/hdUzSut90UYHL4ujC+XP
        /bLONnDa0bTRI/pTwIMfTxyvfuqqO/fo9YHPvUJPHn68NnnbH/7Jidf6XJ9OWPh2e+DE6zw6
        8R9NjDinxG1aZCWiVfmXe/OLhR0C3TNTAyzMX3/13zFhh5EmM+MMl6c/ZlTfK5vU1L9ArjXq
        XG9tb79WrYts1EEeLaO7az9vn65sIPklSdln89EErbQDk8VUI5Y0755g+Do0Zz5r0KuT4qVb
        JfNmz1Y4KRagK7hoTrVehWRL4mw5l3WTFkn7a124HdXlOa9Ev2K9uY7CkbqZ2V/LJgWqmF5z
        2DlzmaQSS3FGoqEWc1FxIgAbR8lJGgMAAA==
X-CMS-MailID: 20220523175712uscas1p2c81666b4057700908d887bddb644ff89
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175712uscas1p2c81666b4057700908d887bddb644ff89
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175712uscas1p2c81666b4057700908d887bddb644ff89@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fio actually does not begin collecting steady state data until the
steady state ramp time has expired. Remove the comment that said steady
state data is collected from the start of the job.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 steadystate.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/steadystate.c b/steadystate.c
index 2e3da1db..ad19318c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -250,13 +250,6 @@ int steadystate_check(void)
 		rate_time =3D mtime_since(&ss->prev_time, &now);
 		memcpy(&ss->prev_time, &now, sizeof(now));
=20
-		/*
-		 * Begin monitoring when job starts but don't actually use
-		 * data in checking stopping criterion until ss->ramp_time is
-		 * over. This ensures that we will have a sane value in
-		 * prev_iops/bw the first time through after ss->ramp_time
-		 * is done.
-		 */
 		if (ss->state & FIO_SS_RAMP_OVER) {
 			group_bw +=3D 1000 * (td_bytes - ss->prev_bytes) / rate_time;
 			group_iops +=3D 1000 * (td_iops - ss->prev_iops) / rate_time;
--=20
2.25.1
