Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4950C433F5
	for <fio@archiver.kernel.org>; Mon, 29 Nov 2021 15:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbhK2PZp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 29 Nov 2021 10:25:45 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:44731 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhK2PXp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 29 Nov 2021 10:23:45 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211129152026usoutp0102c1d3102825a70f081342f1a54bdcee~8DYRpteF92284822848usoutp01X;
        Mon, 29 Nov 2021 15:20:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211129152026usoutp0102c1d3102825a70f081342f1a54bdcee~8DYRpteF92284822848usoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1638199226;
        bh=GWfRFoF2NYVD5v3yqEPYU+d10A/Z00ORKnz7a/61Xc8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UXan/14F414fz+EhqcePa1I1mb7IsF+jRwBvqQnilEdLL1vRZj4wm2lqel5p3CuNn
         lF9YtbN1jCk17D2MWR4d8xnKtM/TyUV7e3Vrq78a8UgF7hr8RzLli6aLtD8W/xTUB5
         eJ4xvQPl2xSeKqIJ0KLswi75G75bJViuKC2mWLqU=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211129152026uscas1p178da34746a4f4772638ea7567d0acbda~8DYRjabmF1589715897uscas1p1r;
        Mon, 29 Nov 2021 15:20:26 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id CF.D2.10104.ABFE4A16; Mon,
        29 Nov 2021 10:20:26 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211129152026uscas1p1c9f4f5b6d00f3b0eea2d2b6d9868fcc6~8DYRMHEtD2417524175uscas1p12;
        Mon, 29 Nov 2021 15:20:26 +0000 (GMT)
X-AuditID: cbfec36f-2fdff70000002778-97-61a4efbac009
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 84.DA.10042.9DFE4A16; Mon,
        29 Nov 2021 10:20:57 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 29 Nov 2021 07:19:51 -0800
Received: from SSI-EX1.ssi.samsung.com ([::1]) by SSI-EX1.ssi.samsung.com
        ([fe80::f93d:5544:8666:3356%7]) with mapi id 15.01.2242.008; Mon, 29 Nov
        2021 07:19:51 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 0/6] additional sg ionegine commands
Thread-Topic: [PATCH 0/6] additional sg ionegine commands
Thread-Index: AQHX2lxjUrDOD8EjW0ioWasKJ4gq36was/eA
Date:   Mon, 29 Nov 2021 15:19:51 +0000
Message-ID: <50bd95773b53436f95af413167143e32@samsung.com>
In-Reply-To: <20211115200807.117138-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7q73i9JNFj5Ut1i9d1+NouPs14w
        OzB5XD5b6vF5k1wAUxSXTUpqTmZZapG+XQJXxqzupawFi7krNvS9YWlgPMHRxcjJISFgIrHy
        0DG2LkYuDiGBlYwSaz5sgnJamSTeTbrNBlN19vQ7dhBbSGAto8SNOZ4Q9kdGiXOnhSAaVjFK
        PF7+HaiIg4NNQFPi7f4CkBoRgTCJn4+2s4LYwgIWEou3X2GCiFtKtLTuYIewjST+TT3LDGKz
        CKhKPAcbw8nBK2AlceDDDhYQm1PAVmLpvJNgcUYBMYnvp9aAzWEWEJe49WQ+E8SdghKLZu9h
        hrDFJP7tegh1v6LE/e8v2SHqdSQW7P7EBmFrSyxb+JoZYpegxMmZT1gg6iUlDq64wQLyl4RA
        I4fE++vroIa6SGzcfQrKlpb4e3cZ1OJzjBIP/gVDNFxnlFjxZTErRMJaYuGf9VCX8kn8/fWI
        ERRAEgK8Eh1tQhMYlWYh+WEWkvtmIblvFpL7FjCyrGIULy0uzk1PLTbKSy3XK07MLS7NS9dL
        zs/dxAhMGaf/Hc7fwXj91ke9Q4xMHIyHGCU4mJVEeL3PLE4U4k1JrKxKLcqPLyrNSS0+xCjN
        waIkznv6T0OikEB6YklqdmpqQWoRTJaJg1OqgWluZqt/49a9iprG3jJnU5/ZN23efCpU7nXI
        heMpEQtSeWW/nU97eqXdt+x93KXMCcfOxt4VDZj/YO8bRnEV9iW5Rk0GHw/VK7DcndEiJPjr
        /Zx5Sr93d+foT3788sFfj1enXs8rPCOlJrpCZMuZPMtHkifk9E7V2rYVHUn17NUTqF72vP7n
        R68/swONdl868UbR4fimz9UtuS/+3kpgyrW6dPHo5nY3lV8bRZ+9D7/Am/ZlEtf9h3mx+ot3
        vvj3aYLx/Ks6MypYInnnr17X5xq1/pdKZIaXSOUHk5jfGRVrr3HIvp62a83zuCuv3yq9tl/J
        0sJaNlFr08yr74qPHT1nxjfZYecJe+5jv584yBu1K7EUZyQaajEXFScCAEfwfaOIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWS2cA0Uffm+yWJBqt22lisvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKmNW9lLVgMXfFhr43LA2MJzi6GDk5JARMJM6e
        fsfexcjFISSwmlFi7487rBDOR0aJaw8OMEM4qxglNi+ZyNjFyMHBJqAp8XZ/AUi3iECYxM9H
        21lBbGEBC4nF268wQcQtJVpad7BD2EYS/6aeZQaxWQRUJZ4v/w4W5xWwkjjwYQcLiC0kYCOx
        aWs/WC+ngK3E0nknwWoYBcQkvp9aAxZnFhCXuPVkPhPE1QISS/acZ4awRSVePv7HCmErStz/
        /pIdol5HYsHuT2wQtrbEsoWvmSH2CkqcnPmEBaJeUuLgihssExjFZiFZMQtJ+ywk7bOQtC9g
        ZFnFKF5aXJybXlFslJdarlecmFtcmpeul5yfu4kRGEGn/x2O3sF4+9ZHvUOMTByMhxglOJiV
        RHi9zyxOFOJNSaysSi3Kjy8qzUktPsQozcGiJM77MmpivJBAemJJanZqakFqEUyWiYNTqoFJ
        x1P+UajyAoUuU7Xo0JWMfxam1E96s+BQl1Dnt4uJhaGSxdK8ix8231/XH7Co6dirIxsuysv9
        9Z47nSkrqclN6aKr1D39C1ZXt2Seru+yzj0o7OGR1ZO9eeu04vMll15K2l3cvnzJ4TLmCbrP
        Pc09CgOXfDocYsb21D180aUPy//b7/K8N6nGUccn9XH4ue31kUrHfzLde/zT/NaKHdk+aVXd
        m0tU571rtna732EaXn3xsLyveUksywWe/9LTDIzP91vHnYl7ON/yfcjtYxckL/o0bsspjHhe
        FCjV82qW1NnFCw/ZbLf4JPC87Nb8I18TDmW7nOiyjHl4a4+OjnMAQ+vWzdmNakYcYelXnF2V
        WIozEg21mIuKEwEKta6NDwMAAA==
X-CMS-MailID: 20211129152026uscas1p1c9f4f5b6d00f3b0eea2d2b6d9868fcc6
CMS-TYPE: 301P
X-CMS-RootMailID: 20211129152026uscas1p1c9f4f5b6d00f3b0eea2d2b6d9868fcc6
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211129152026uscas1p1c9f4f5b6d00f3b0eea2d2b6d9868fcc6@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, please let me know if you have any feedback about this patch series.

Vincent

> -----Original Message-----
> From: Vincent Fu
> Sent: Monday, November 15, 2021 3:07 PM
> To: axboe@kernel.dk; fio@vger.kernel.org
> Cc: Vincent Fu <vincent.fu@samsung.com>
> Subject: [PATCH 0/6] additional sg ionegine commands
>=20
> Jens, please consider this patch series that adds to the sg ioengine supp=
ort
> for the SCSI commands VERIFY, WRITE SAME(16), and WRITE STREAM(16).
>=20
> Vincent
>=20
>=20
> Vincent Fu (6):
>   sg: add support for VERIFY command using write modes
>   sg: add support for WRITE SAME(16) commands with NDOB flag set
>   sg: improve sg_write_mode option names
>   sg: add support for WRITE STREAM(16) commands
>   sg: allow fio to open and close streams for WRITE STREAM(16) commands
>   docs: documentation for sg WRITE STREAM(16)
>=20
>  HOWTO                           |  36 ++++++-
>  engines/sg.c                    | 181 ++++++++++++++++++++++++++++++--
>  examples/sg_verify-fail.fio     |  48 +++++++++
>  examples/sg_verify.fio          |  57 ++++++++++
>  examples/sg_write_same_ndob.fio |  44 ++++++++
>  fio.1                           |  47 ++++++++-
>  6 files changed, 397 insertions(+), 16 deletions(-)  create mode 100644
> examples/sg_verify-fail.fio  create mode 100644 examples/sg_verify.fio
> create mode 100644 examples/sg_write_same_ndob.fio
>=20
> --
> 2.25.1
