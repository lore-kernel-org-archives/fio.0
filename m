Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD434C433F5
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 20:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJCUe5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJCUey (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 16:34:54 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52EC5FAB
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 13:34:49 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20221003203444usoutp0261287ea4bfa0f4aae2cfddb989daa1a3~aqWnoNew60750707507usoutp02L;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20221003203444usoutp0261287ea4bfa0f4aae2cfddb989daa1a3~aqWnoNew60750707507usoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664829284;
        bh=HxSBvKwuU1cR5wAEKdXEaAanJyJBKPyxk+GK+YZ86cg=;
        h=From:To:CC:Subject:Date:References:From;
        b=NpHA67JdS5AW2k6ALYASTU7SfjEmke/uU/092upG83Kh6Bc0xsixEbJsYqPt8Ya28
         nMXd+2BGb5Puzjy3BRe/NH2ovNMO7alN1SdNrduFfWiDPbYJV21w41JCZpo8o58PNw
         fuDqrLZjTtvCXFGLFOOJy5KMkZe6JmYnK9Q6fJuU=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p25bc1fb5a6fa6030eb92802142a4a451f~aqWnfhT2s0313203132uscas1p28;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 0A.F9.18126.4674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003203444uscas1p2d6d912aaf5e34efc126cef5338bc0a18~aqWnQvCCt0313203132uscas1p27;
        Mon,  3 Oct 2022 20:34:44 +0000 (GMT)
X-AuditID: cbfec36f-fe1ff700000146ce-e7-633b47649992
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 73.A5.19363.3674B336; Mon, 
        3 Oct 2022 16:34:44 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 13:34:43 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 13:34:43 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/4] randtrimwrite
Thread-Topic: [PATCH 0/4] randtrimwrite
Thread-Index: AQHY12eRsl91sRTyp0yln5bRatHTIg==
Date:   Mon, 3 Oct 2022 20:34:43 +0000
Message-ID: <20221003203427.123969-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87op7tbJBjPnSlisvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DK2HLCtmAma8XcpvdMDYw9LF2MnBwSAiYSlxbv
        Zexi5OIQEljJKNF96gE7hNPKJPHmexczTNWFRzBVaxklGmb+ZYVwPjJKHHj6lwnCWcoosWbT
        HqDBHBxsApoSb/cXgHSLCIRJ/Hy0nRXEZhZQlzi2cQMbiC0soCRx499rJogadYlp13cyQth6
        Eg8O/ge7j0VARWLy0U9gvbwCNhK/j+wEu4hRQEzi+6k1TBAzxSVuPZnPBHGpoMSi2XugrhaT
        +LfrIRuErShx//tLdoh6PYkbU6ewQdjaEssWvmaGmC8ocXLmE2i4SEocXHGDBeQvCYGP7BKn
        V25iBflLQsBF4nWzLkSNtMTV61OZIWraGSXmbvwC1TyBUeL6EykI21riX+c1qMV8En9/PWKE
        mMMr0dEmNIFRaRaSF2YhOW8WkvNmITlvASPLKkbx0uLi3PTUYqO81HK94sTc4tK8dL3k/NxN
        jMCUcfrf4fwdjNdvfdQ7xMjEwXiIUYKDWUmEd84jq2Qh3pTEyqrUovz4otKc1OJDjNIcLEri
        vFEztJKFBNITS1KzU1MLUotgskwcnFINTDqKhp9kO7hY/xTYbm4W5p76+WSU6vNV5SpO836G
        J0Ufzv5QImK1jOGNuNGFzkuv7t7bVSz3aOuyFbHluZYSx34zWUx6kvd+0f7KU11K6jM7Y5X9
        /r/edyMh5xinQL1mZaDn+pIXx2dMnFP9RflC5r33xxli2F1XTJBuUlOP2J53a5eXZtj+n8HC
        u59o70nbFZ6SG7Azrc4k210h+r+wWnnEkrcz/5zqZ+Y7H7yyqDJkvp11p8FF7i+rej4xpybs
        EUl58rdBdPMaQylv/rSzsiKTzpfu5VokMsvf5ca14os217dtZ2n5n/RESTpvTYzbv+21O3UN
        whNqJ8xhnNjYte2P72XBy0c+Jp462jZBVImlOCPRUIu5qDgRAA+lQ3CIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWS2cA0STfF3TrZYM03FovVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZW07YFsxkrZjb9J6pgbGHpYuRk0NCwETiwqO9
        jF2MXBxCAqsZJdobl7JAOB8ZJU49uMQG4SxllNi7+g97FyMHB5uApsTb/QUg3SICYRI/H21n
        BbGZBdQljm3cwAZiCwsoSdz495oJokZdYtr1nYwQtp7Eg4P/wTazCKhITD76CayXV8BG4veR
        ncwgNqOAmMT3U2uYIGaKS9x6Mp8J4lIBiSV7zjND2KISLx//Y4WwFSXuf3/JDlGvJ3Fj6hQ2
        CFtbYtnC18wQ8wUlTs58AvWxpMTBFTdYJjCKzkKyYhaS9llI2mchaV/AyLKKUby0uDg3vaLY
        MC+1XK84Mbe4NC9dLzk/dxMjME5O/zscuYPx6K2PeocYmTgYDzFKcDArifDOeWSVLMSbklhZ
        lVqUH19UmpNafIhRmoNFSZxXyHVivJBAemJJanZqakFqEUyWiYNTqoGJR+BwzIYP3Tsy46Uu
        lOTN6e0VZa//nizoaszpKPPp16l1Z7QmTdmbLHdqn3fTp9A3i1Tbfvo9WLAtoTyJ57/VU/t9
        bSZtXlE6+tWXDr9QeN4Xdv+f3EPFRPM7lSoLNkR+vbn7Urvqp1nmLrKf3doPX9KzW71/wa26
        OU+Ya8KYsvK+Tu02kDhyn2ePZuMy5uySnNUHFu6079bedNbdjzGjKmzDJ/lZ110/BLbdrej8
        GnLiT7TxkpDsL3vkdnxiZ529w/20krReQfv2k4+vx/ZLdXhnxkQs/GOxK1fn5a/mr9dN934z
        yu++wBhrkPmtnr3pWGZnTL1ZM2ft6YdfRauui0e3l93aXLPRmuNjq7kSS3FGoqEWc1FxIgB8
        TfySAgMAAA==
X-CMS-MailID: 20221003203444uscas1p2d6d912aaf5e34efc126cef5338bc0a18
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203444uscas1p2d6d912aaf5e34efc126cef5338bc0a18
References: <CGME20221003203444uscas1p2d6d912aaf5e34efc126cef5338bc0a18@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, I've spent some time on the new randtrimwrite data direction.
Please take a look and let me know if you have any thoughts.

Vincent Fu (4):
  randtrimwrite: write at same offset as trim
  test: test job for randtrimwrite
  randtrimwrite: fix offsets for corner case
  randtrimwrite: fix corner case with variable block sizes

 io_ddir.h          |  2 ++
 io_u.c             | 34 +++++++++++++++++++--
 t/jobs/t0023.fio   | 75 ++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py | 64 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 173 insertions(+), 2 deletions(-)
 create mode 100644 t/jobs/t0023.fio

--=20
2.25.1
