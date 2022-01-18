Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30074C433F5
	for <fio@archiver.kernel.org>; Tue, 18 Jan 2022 13:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiARNI4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jan 2022 08:08:56 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:10111 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiARNI4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jan 2022 08:08:56 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 08:08:56 EST
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220118130353usoutp0106907717d1810e7e57e8b2f694e29941~LXxUHcCAx0263502635usoutp01Z;
        Tue, 18 Jan 2022 13:03:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220118130353usoutp0106907717d1810e7e57e8b2f694e29941~LXxUHcCAx0263502635usoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1642511033;
        bh=WXHumSkO6ll05x8YWbdqInmfo5vpYN3dJBClNnn+UwA=;
        h=From:To:Subject:Date:References:From;
        b=GnJR6ilS+AZKJ+hbzxOVUa/f3XEAF77/xAD/aVs/RK9drwgOFKrrpgmzaRpgflSIH
         gCKM4DMDxLamBxPTODtdJA205P3guPg+GuSGYLRq4insfq5hD7csbmbjNIjqwYee2B
         w6n4vh95PzM2EIG/sDlertEYh/TAd+DbLPJX+OgE=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220118130352uscas1p14990ea8739fbe9e0323c67adddbb110e~LXxTrDe9t1842618426uscas1p1p;
        Tue, 18 Jan 2022 13:03:52 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 20.31.09687.8BAB6E16; Tue,
        18 Jan 2022 08:03:52 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220118130352uscas1p1a51e58ff20951777a16d2d201d63cbdb~LXxTatLvR1857818578uscas1p1k;
        Tue, 18 Jan 2022 13:03:52 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-83-61e6bab888dd
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 39.F9.09657.7BAB6E16; Tue,
        18 Jan 2022 08:03:52 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Tue, 18 Jan 2022 05:02:49 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::d97c:6fde:c243:46bb]) by
        SSI-EX1.ssi.samsung.com ([fe80::d97c:6fde:c243:46bb%7]) with mapi id
        15.01.2242.008; Tue, 18 Jan 2022 05:02:49 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 0/6] additional sg ionegine commands
Thread-Topic: [PATCH 0/6] additional sg ionegine commands
Thread-Index: AQHX2lxjUrDOD8EjW0ioWasKJ4gq36was/eAgE5ugJA=
Date:   Tue, 18 Jan 2022 13:02:49 +0000
Message-ID: <edae2223f97d4abeae2c38bc3c0ecd6f@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87o7dj1LNHj2Q9pi9d1+NouPs14w
        OzB5XD5b6vF5k1wAUxSXTUpqTmZZapG+XQJXxr6d91gKfvBWnFtS3cB4kKuLkZNDQsBEounU
        NbYuRi4OIYGVjBL3ps5jh3BamSQ2vHvHAlP1YO56ZojEWkaJo38OskA4HxklerddZ4VwDjBK
        7OieAdTPwcEmoCnxdn8BSLeIQJjEz0fbWUFsYQELicXbrzBBxC0lWlp3sEPYVhLnnu0Ci7MI
        qEqsvvkPLM4LFL/4ZQJYL6OAmMT3U2vAapgFxCVuPZnPBHGdoMSi2XuYIWwxiX+7HrJB2IoS
        97+/ZIewRSTWfX/LBtGrI7Fg9ycoW1ti2cLXzBC7BCVOznwC9bGkxMEVN6Dsn+wSiz96g7wl
        IeAicflqEURYWmL6msvgcJAQ6GaUOLNmBdQNUxgl+vfnQtjWEgv/rIe6mU/i769HjBBzeCU6
        2oQmMCrNQvLNLCTXzUJy3Swk1y1gZFnFKF5aXJybnlpsnJdarlecmFtcmpeul5yfu4kRmDBO
        /ztcsIPx1q2PeocYmTgYDzFKcDArifBK1T9LFOJNSaysSi3Kjy8qzUktPsQozcGiJM67LHND
        opBAemJJanZqakFqEUyWiYNTqoFJ5bXDuljFL99jth1na376YMPRmAN2Oj0yrM+TnM1qQya6
        HLrfUi/8Mmhpm9vfvBoGDVOuZxsubbPdX7PLt0pLTmCF2CGdEMU9X58LXOxaffSQs17MNZ3Q
        pFTzM863Nc8//Od/dPLDw6naTX+Z1TLy3MNOCleZLy9VUMxd/sNrWZgYc6y92k4b93snVUVX
        Gp5oPv5FWPj/xTVcD6J/ndtU+GLPlY1Ti+4ePR6hc6Z660Zjl7evDL6ftjZLPT7vwe2F5z7E
        WDy4Ef/56q7k0vo1D32XBu8+7hDeuvZRyadZCnXpq/aEPlyS9/KwlsK6jwtuHWQt40/mWqUS
        vn9ebtp7g3eeRsuf9T1p2PXhr7xWrxJLcUaioRZzUXEiANgN6OiHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWS2cA0SXfHrmeJBgvus1usvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DK2LfzHkvBD96Kc0uqGxgPcnUxcnJICJhIPJi7
        nrmLkYtDSGA1o8S6jseMEM5HRonNTyYyQTgHGCV+XrnF1sXIwcEmoCnxdn8BSLeIQJjEz0fb
        WUFsYQELicXbrzBBxC0lWlp3sEPYVhLnnu0Ci7MIqEqsvvkPLM4LFL/4ZQJYr5CArcTmB0sZ
        QWxGATGJ76fWgNUzC4hL3HoynwniUgGJJXvOM0PYohIvH/9jhbAVJe5/f8kOYYtIrPv+lg2i
        V0diwe5PULa2xLKFr5kh9gpKnJz5hAWiXlLi4IobLBMYxWYhWTcLSfssJO2zkLQvYGRZxShe
        Wlycm15RbJyXWq5XnJhbXJqXrpecn7uJERg/p/8djtnBeO/WR71DjEwcjIcYJTiYlUR4peqf
        JQrxpiRWVqUW5ccXleakFh9ilOZgURLn9YidGC8kkJ5YkpqdmlqQWgSTZeLglGpgYhQ40Nri
        E7BuuYH4ujtryjtOq19sU3lnfSbHcN6MYFWFml+zZne8U/WJn73hoOeWsjXZU/tL99YHCDNX
        mM1+wT0xeq67WjznHY0X1/aH3oy8ueFUYOIEBZO5hfsljebU2gm/keFQPxvy3WbfneyIEMWy
        75ruU5/FctX1PHMXXPG6ZcGEtYk/PSwlP1yvmvJ3n+/R8w+8Rad3T+Q+8MX30tatP2tnLL6R
        V3Q95ei/1iCGO2tEnx9cUSFV5s3ZJRkzTytyVf2/9+e9Zm7YYVA8aWKL9cQ55dOF9oa+8Pf/
        yqJ6hZVdk3H6agNft2pr6/6wem3WbsvgHZWHHu5M+evU7Hn0wURl/WXTS/xX3wyJUGIpzkg0
        1GIuKk4EAGk8UgkOAwAA
X-CMS-MailID: 20220118130352uscas1p1a51e58ff20951777a16d2d201d63cbdb
CMS-TYPE: 301P
X-CMS-RootMailID: 20220118130352uscas1p1a51e58ff20951777a16d2d201d63cbdb
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20220118130352uscas1p1a51e58ff20951777a16d2d201d63cbdb@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, please let me know your feedback on this series.

Vincent

> -----Original Message-----
> From: Vincent Fu
> Sent: Monday, November 29, 2021 10:20 AM
> To: axboe@kernel.dk; fio@vger.kernel.org
> Subject: RE: [PATCH 0/6] additional sg ionegine commands
>=20
> Jens, please let me know if you have any feedback about this patch series=
.
>=20
> Vincent
>=20
> > -----Original Message-----
> > From: Vincent Fu
> > Sent: Monday, November 15, 2021 3:07 PM
> > To: axboe@kernel.dk; fio@vger.kernel.org
> > Cc: Vincent Fu <vincent.fu@samsung.com>
> > Subject: [PATCH 0/6] additional sg ionegine commands
> >
> > Jens, please consider this patch series that adds to the sg ioengine
> > support for the SCSI commands VERIFY, WRITE SAME(16), and WRITE
> STREAM(16).
> >
> > Vincent
> >
> >
> > Vincent Fu (6):
> >   sg: add support for VERIFY command using write modes
> >   sg: add support for WRITE SAME(16) commands with NDOB flag set
> >   sg: improve sg_write_mode option names
> >   sg: add support for WRITE STREAM(16) commands
> >   sg: allow fio to open and close streams for WRITE STREAM(16) commands
> >   docs: documentation for sg WRITE STREAM(16)
> >
> >  HOWTO                           |  36 ++++++-
> >  engines/sg.c                    | 181 ++++++++++++++++++++++++++++++--
> >  examples/sg_verify-fail.fio     |  48 +++++++++
> >  examples/sg_verify.fio          |  57 ++++++++++
> >  examples/sg_write_same_ndob.fio |  44 ++++++++
> >  fio.1                           |  47 ++++++++-
> >  6 files changed, 397 insertions(+), 16 deletions(-)  create mode
> > 100644 examples/sg_verify-fail.fio  create mode 100644
> > examples/sg_verify.fio create mode 100644
> > examples/sg_write_same_ndob.fio
> >
> > --
> > 2.25.1
