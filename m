Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6618C433EF
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiEXOXj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiEXOXd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:33 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E765FF01
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142326usoutp01122a3f483b77b76929ef4a566b41fd00~yEIvdQ8IN1431114311usoutp01O;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220524142326usoutp01122a3f483b77b76929ef4a566b41fd00~yEIvdQ8IN1431114311usoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402206;
        bh=dFG6h543O1k+pIqYCgq0eDqwUrksxdMjdNFPl/TLdho=;
        h=From:To:CC:Subject:Date:References:From;
        b=bVbFozjj5gkxOZqYlXyYB6nbNaFsCK+jRQHBYyO/6nemVNzcwqv4NPuyUEynNYmNr
         TZcFbJxnhtVan9jt2YCVav6w1sSi+d/cB/6NbibyMxiUDkoHC7vQoi4PFCoOCjT4EE
         fu1n5VxgG6pbDcbd5sW8Vq10rTl6GfLK16kTU6rg=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220524142325uscas1p2f816dfc1b03022a8cde0a8957c5d6152~yEIvBzk6h0777507775uscas1p21;
        Tue, 24 May 2022 14:23:25 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 81.8C.09642.D5AEC826; Tue,
        24 May 2022 10:23:25 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142325uscas1p197b28727cdb38d34f866b97b0a1932e5~yEIups0420914809148uscas1p1F;
        Tue, 24 May 2022 14:23:25 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-26-628cea5da898
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 66.77.52945.C5AEC826; Tue,
        24 May 2022 10:23:25 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 24 May 2022 07:23:24 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        24 May 2022 07:23:24 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2 0/5] (now) five cleanups
Thread-Topic: [PATCH v2 0/5] (now) five cleanups
Thread-Index: AQHYb3nTMhvZZxCeTE2PxTx+OZPL+A==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87qxr3qSDBpuKVmsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKaN6ylqWgha1idmttA+MFli5GTg4JAROJ3dvv
        sHUxcnEICaxklFix9g07hNPKJHFj+W82mKqNr99DVa1llDi48yKU84lRYk/zT0YIZxmjxI3v
        H4AGc3CwCWhKvN1fANItIhAm8fPRdlYQm1lAXeLYxg1sICXCAtoSRxYLQJQYSDQeeMIOYetJ
        7Fm/Guw8FgFViR1vNzGB2LwCNhI3f28GsxkFxCS+n1rDBDFSXOLWk/lMEIcKSiyavYcZwhaT
        +LfrIdQDihL3v79kh6jXk7gxdQobhK0tsWzha2aI+YISJ2c+gQaLpMTBFTdYQN6SEHjLLtG6
        7xsjRMJF4t2LdihbWmL6mstQRe2MEnM3foHqnsAocf2JFIRtLfGv8xrUZj6Jv78eMYI8LyHA
        K9HRJjSBUWkWkh9mIblvFpL7ZiG5bwEjyypG8dLi4tz01GKjvNRyveLE3OLSvHS95PzcTYzA
        lHH63+H8HYzXb33UO8TIxMF4iFGCg1lJhDclrCdJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+y
        zA2JQgLpiSWp2ampBalFMFkmDk6pBib/it4fU293/vNvZrfov/1YOG3P4ffJnMuLJZXdBd79
        nFYY1Xf/4I5fxxK9LVWEOdKlpnPKfdyzNrQrvfdKSiRzXM/c+/bd1mvWpBZc0F8jfqPnKQvD
        meebtDcuPHhMUrLjysNny++2H300KaY6mpPruYnq2+YnGpN+LTmZvqMi7dfM20kXTONVvrx8
        8aPSJeT8cS/WW+1d9+2WZJ75oMh6f0rd8fcsD//r//w4Sylgxdcj7unMc/327QhNXNW4oFSu
        Y3mDi7tJqliR+IvkZLYTXRtri9y8xdRWTlliqt++/sS1n3O/yFa8cXuZ1Cmcz+lyYA97eG3A
        4tWvv/84WLW34VGkyrevJdrmsZ8a2EOUWIozEg21mIuKEwGLx1egiAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWS2cA0UTf2VU+SwYWTbBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgymresZSloYauY3VrbwHiBpYuRk0NCwERi4+v3
        bF2MXBxCAqsZJbq/7mWBcD4xSrx59JgdwlnGKLHk4SKgDAcHm4CmxNv9BSDdIgJhEj8fbWcF
        sZkF1CWObdzABlIiLKAtcWSxAESJgUTjgSfsELaexJ71q8EWswioSux4u4kJxOYVsJG4+Xsz
        mM0oICbx/dQaJoiR4hK3nsxngjhUQGLJnvPMELaoxMvH/1ghbEWJ+99fskPU60ncmDqFDcLW
        lli28DUzxHxBiZMzn0A9LClxcMUNlgmMorOQrJiFpH0WkvZZSNoXMLKsYhQvLS7OTa8oNs5L
        LdcrTswtLs1L10vOz93ECIyS0/8Ox+xgvHfro94hRiYOxkOMEhzMSiK8KWE9SUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5PWInxgsJpCeWpGanphakFsFkmTg4pRqYtvbvNzovXr3haK1gsNKW
        FvdPyRGVTyy+VIQ8/vpi1wwRK6loRYnPJ7f0mMR937QuWILhVfDy1JClEyp5+qRni6dtuRoq
        l/rc7przfMOXMj8asr98eqB04bbdh1gVLUtx8TbrvOKsJ9f+bFGufTH7XFrv/QXHfuunvhFP
        YOnM6W7Y3M/btm2j6METgQ//r9fmFCwPDWnprj1lt2X9oprHD+S+Ru/8PWHC4vd/3mQGvFQ6
        sKYxfk8kx80Hev/+yDZ4zdBfrbv67k6uzy/+Tl7IbmtqkH/p5qLrWuxMZnltv/ZbXluUFCB1
        bvuJCdy/ji8u/Rfs1s129ExcTq+r49HU1Yl3mfT470irL7vbvPaVrRJLcUaioRZzUXEiABAq
        MSYBAwAA
X-CMS-MailID: 20220524142325uscas1p197b28727cdb38d34f866b97b0a1932e5
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142325uscas1p197b28727cdb38d34f866b97b0a1932e5
References: <CGME20220524142325uscas1p197b28727cdb38d34f866b97b0a1932e5@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, please consider these five cleanup patches.

Changes from v1 (cleanups, parse /proc/meminfo for huge page size):
- Drop patch that parses /proc/meminfo
- Documentation patch about huge page sizes fixes default size



Vincent Fu (5):
  steadystate: delete incorrect comment
  configure: refer to zlib1g-dev package for zlib support
  HOWTO: add blank line for prettier formatting
  t/run-fio-tests: improve json data decoding
  docs: update discussion of huge page sizes

 HOWTO.rst          | 26 +++++++++++++++-----------
 configure          |  2 +-
 fio.1              | 19 ++++++++++---------
 steadystate.c      |  7 -------
 t/run-fio-tests.py | 20 +++++++-------------
 5 files changed, 33 insertions(+), 41 deletions(-)

--=20
2.25.1
