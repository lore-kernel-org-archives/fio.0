Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F431C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbiFNP7G (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354232AbiFNP6j (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:39 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9112B2611C
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:35 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155830usoutp02fb3cfca36f1da5bb1b5e1176403b14d1~4h_wO8FuK1404714047usoutp02e;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220614155830usoutp02fb3cfca36f1da5bb1b5e1176403b14d1~4h_wO8FuK1404714047usoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222311;
        bh=pfl8QCUSyn6Yrwupi40BA/wqv/VVSij/iqogtZnzKyk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=KJeoAuwjg5xnuDF92dLpslVw0esnG3t409lEBHHWskeia7WtXM3OA8UZ/nlwklEik
         JM3YvjiOpZNjCBfkqRg58IpR9wanfWDiv9hg83HrM026nU+KPlvYLBGmZMDRonXObQ
         BXaKN97y8J53/qmv6gmv78qI5YT0qsjM5jodQclU=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p1914640ba084ed70bfbafb05a854b5dc4~4h_wIVPMX0463404634uscas1p1C;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 81.54.09642.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p2586c5e612430bdd2ce455a1081ce08e4~4h_v6Ei7Y1401314013uscas1p2i;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-c4-62a8b0261594
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 66.FB.52349.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 14 Jun 2022 08:58:29 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        14 Jun 2022 08:58:29 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/5] ioengines: add helper for trims with async ioengines
Thread-Topic: [PATCH 1/5] ioengines: add helper for trims with async
        ioengines
Thread-Index: AQHYgAeXkqt5AZPvGkWaf6TIN7WBpw==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-2-vincent.fu@samsung.com>
In-Reply-To: <20220614155822.307771-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djX87pqG1YkGTTfM7BYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVsevoJcaC3bwVZ5ddZmlgnMTdxcjJISFgInFl
        zlumLkYuDiGBlYwSf7/1sIEkhARamSR6TybBFD3tbGCGKFrLKPFn5WJWCOcTo8SMliVQ7csY
        JfpWbQHKcHCwCWhKvN1fANItIhAm8fPRdlYQm1lAXeLYxg1gG4QFPCUW9a1mh6gJkLg+qQnK
        1pN4vWEtE8gYFgFViT2dliBhXgEbiVfXt4GVcArYSszZOo8JxGYUEJP4fmoNE8R4cYlbT+Yz
        QRwtKLFo9h5mCFtM4t+uh2wQtqLE/e8v2SHq9SRuTJ3CBmFrSyxb+JoZYpegxMmZT1gg6iUl
        Dq64wQLyooRAL4fErY0/oIa6SPxa0A41VFri6vWpzBBF7YwSczd+geqewChx/YkUhG0t8a/z
        GtRmPom/vx4xTmBUnoXk8FlIjpqF5KhZSI5awMiyilG8tLg4Nz212CgvtVyvODG3uDQvXS85
        P3cTIzBpnP53OH8H4/VbH/UOMTJxMB5ilOBgVhLhnXxxWZIQb0piZVVqUX58UWlOavEhRmkO
        FiVx3mWZGxKFBNITS1KzU1MLUotgskwcnFINTHpMf2fe0mmYlCSovG1O232pu0qqJYv2VAUl
        nniv/OhU4aalS/dqN61q7Zx+5+qnWwdmntz2UyD/hdEslo1ifdzKJ24djXsd0b77nZHwqnPL
        Tkev1ta7IPCjNJz1i8/eGXdSfx/bf7Sg3CksvOqej9r1ha1WPZxek41tvjxzvRXNy3hXeYth
        T+aZUPHPaadyDh273eii/0Jude+W4O9d0a0smpnXLZ+c3L+56bXoGp7U05bP9h2eIfgndVLb
        F/XPK+bFHn9VFrCfu07F4F650qJUbafdv83PXM3n0+SY9p7JrXdey/+cY8sm6dsw7/XvEJp4
        lXub1ce9WyWrbnv2nGJScGx+wdsXsCNTavmBvxlKLMUZiYZazEXFiQA5JTgViQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapKu2YUWSwa5+RYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZu45eYizYzVtxdtlllgbGSdxdjJwcEgImEk87
        G5i7GLk4hARWM0q8ezGHDcL5xChx/+QGJghnGaPEjadXWboYOTjYBDQl3u4vAOkWEQiT+Plo
        OyuIzSygLnFs4wY2EFtYwFNiUd9qdogaP4mvc25D2XoSrzesZQIZwyKgKrGn0xIkzCtgI/Hq
        +jawEiEge9eWI8wgNqeArcScrfOYQGxGATGJ76fWMEGsEpe49WQ+E8QDAhJL9pxnhrBFJV4+
        /scKYStK3P/+kh2iXk/ixtQpbBC2tsSyha+ZIfYKSpyc+YQFol5S4uCKGywTGMVnIVkxC0n7
        LCTts5C0L2BkWcUoXlpcnJteUWyYl1quV5yYW1yal66XnJ+7iREYV6f/HY7cwXj01ke9Q4xM
        HIyHGCU4mJVEeCdfXJYkxJuSWFmVWpQfX1Sak1p8iFGag0VJnFfIdWK8kEB6YklqdmpqQWoR
        TJaJg1OqgUl/ZmPmQ/nVS87F5pZfTs4791m8Rv/wvjvsD5qKP06YKfLMZ+uflc6O57ZWZke9
        /2qqoaD77X9GA0OhH+eMzpg+t6QvH6Yah5VysO5ZfdLReZ574YMDNo2LTz1hu/Xn49vQXzsM
        he4ypn+es23iVvcN6ntKeW8dPdptHbFhwq3zfm9iw1Ji+sxmvHj0yi/64+TufwvrXrx7Nu9e
        tehPvxnLFfnfJm69+SrjWME806jLP+PezQp8INZ3q4EzbLrrXW0Fp9bP8iz60ecrNNWz857o
        xhulO27IMw/1uP7xmbnN/bdTWQzemXbW+rRwiF36Wn5g0Seb/b1u/86lyQYryq9NEXv1nOPe
        7s7/xwuYMm8rsRRnJBpqMRcVJwIAJ5vfLxoDAAA=
X-CMS-MailID: 20220614155830uscas1p2586c5e612430bdd2ce455a1081ce08e4
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155830uscas1p2586c5e612430bdd2ce455a1081ce08e4
References: <20220614155822.307771-1-vincent.fu@samsung.com>
        <CGME20220614155830uscas1p2586c5e612430bdd2ce455a1081ce08e4@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Async ioengines support trim commands but trims are synchronous
operations. We need to provide special handling when measuring latency
for these commands. Create a helper function to help us identify when an
async ioengine is issuing a sync trim command. This makes the code more
readable.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 ioengines.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index 68f307e5..280da3c8 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -24,6 +24,13 @@
=20
 static FLIST_HEAD(engine_list);
=20
+static inline bool async_ioengine_sync_trim(struct thread_data *td,
+					    struct io_u	*io_u)
+{
+	return td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) &&
+		io_u->ddir =3D=3D DDIR_TRIM;
+}
+
 static bool check_engine_ops(struct thread_data *td, struct ioengine_ops *=
ops)
 {
 	if (ops->version !=3D FIO_IOOPS_VERSION) {
@@ -350,8 +357,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, s=
truct io_u *io_u)
 	io_u->resid =3D 0;
=20
 	if (td_ioengine_flagged(td, FIO_SYNCIO) ||
-		(td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) &&=20
-		io_u->ddir =3D=3D DDIR_TRIM)) {
+		async_ioengine_sync_trim(td, io_u)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
=20
@@ -435,8 +441,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, s=
truct io_u *io_u)
 	}
=20
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
-		(!td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) ||
-		 io_u->ddir !=3D DDIR_TRIM)) {
+		!async_ioengine_sync_trim(td, io_u)) {
 		if (fio_fill_issue_time(td))
 			fio_gettime(&io_u->issue_time, NULL);
=20
--=20
2.25.1
