Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6262C433EF
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 15:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbiDGPhM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 11:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbiDGPhK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 11:37:10 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB302E4C
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 08:35:08 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220407153459usoutp01095d51fed5d19857351656c3fae64487~jpyy5qtg82311723117usoutp01a;
        Thu,  7 Apr 2022 15:34:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220407153459usoutp01095d51fed5d19857351656c3fae64487~jpyy5qtg82311723117usoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649345699;
        bh=EIPQ8I/YSYGahMi/eRoaVSGz3zwU2H/BFTEomnn1Aic=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=u6R+1JibYueL3WzV2OjiPC7LWMEjNXq436e5pvozBVnRM1s2p/1/TR5+DTzi8Ou3K
         l6Fm5XTgu5pIrBStOR7tGi1lacQOgej0QyXjQFvDd7SLzqO9g+R+rBRXMRb64PtDuw
         wi//QBq/ZezAA4oOD+/uSvabyK9pUDytyupfGKcA=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220407153458uscas1p1ce8284eece565bbb8843ada786f55a3c~jpyyx-pCK2700327003uscas1p1C;
        Thu,  7 Apr 2022 15:34:58 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id A2.7A.09760.2A40F426; Thu, 
        7 Apr 2022 11:34:58 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220407153458uscas1p2c03bb0149e903026a00713c5649eb77e~jpyya7v7M2713127131uscas1p2X;
        Thu,  7 Apr 2022 15:34:58 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-5e-624f04a2732d
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id FF.D3.09702.2A40F426; Thu, 
        7 Apr 2022 11:34:58 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Thu, 7 Apr 2022 08:34:57 -0700
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::4031:294d:7626:e900%4]) with mapi id
        15.01.2242.008; Thu, 7 Apr 2022 08:34:57 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Mohamad Gebai <mogeb@fb.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] iolog: update man page for version 3
Thread-Topic: [PATCH v2 3/3] iolog: update man page for version 3
Thread-Index: AQHYSo7ntUEkblSiYE6BIqrEuvp9kqzklM9Q
Date:   Thu, 7 Apr 2022 15:34:57 +0000
Message-ID: <494869666f17475da2e6a840d45abd5d@samsung.com>
In-Reply-To: <20220407144958.3975622-4-mogeb@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djXc7qLWPyTDO49N7b4OOsFs8XSFVMZ
        HZg8Jja/Y/f4vEkugCmKyyYlNSezLLVI3y6BK+Pd3NmMBbNZKlp+6jQw7mDuYuTkkBAwkbi2
        /gFjFyMXh5DASkaJv3fXQjmtTBLnTx1gg6na8+EpE0RiLaPEysfr2SCcD4wSDx5tYYVw9jNK
        rPjyhb2LkYODTUBT4u3+ApBuEQF/iccrG1lAbGEBB4kLPe9YIeKOEmv2PmWBsI0krr1+BLaN
        RUBFYtPEn4wgNq+AlcSv8+vA4pxAV7StuskEYjMKiEl8P7UGzGYWEJe49WQ+E8SlghKLZu+B
        +k1M4t+uh1AfKErc//6SHaJeR2LB7k9sELa2xLKFr5khdglKnJz5hAWiXlLi4IobLCB/SQg0
        ckgc2byJHSLhInFqJ0yRtMTV61OZIYraGSXmbvwClZjAKHH9iRSEbS3xr/Ma1GY+ib+/HjGC
        AkhCgFeio01oAqPSLCQ/zEJy3ywk981Cct8CRpZVjOKlxcW56anFhnmp5XrFibnFpXnpesn5
        uZsYgWnj9L/DuTsYd9z6qHeIkYmD8RCjBAezkghvVa5PkhBvSmJlVWpRfnxRaU5q8SFGaQ4W
        JXHeZZkbEoUE0hNLUrNTUwtSi2CyTBycUg1M6068qtMotd/NfDR34ufUlPXTbpf8Sfq7fX44
        L4fQ0r3ScbXlH5ItnjovLGl8l8a6IEDy/boZJa/Y9n4UfySWpmTIsC+3VHKp4B3xt6tbX4lw
        8HzR0H499Y3JGhZ+v5UqJSt2HlLT4XFx+K4Qx7Bia+yKaSFmibtqNnN0ZAZ9Y2y93e/Aubrl
        9HXGXRuPXEuZ9jTFbqXJ2oJYD477SvXT93mpy9g/igvwfd3LWqH3+4tH/Kr0vBmX4xs2JLBt
        iLXaV3tS4+vl+R2OxcseMJ2ySXHOiUt1LZ1QY3DZU33zO+vC/VL5R1mP+RhE3ReYtrtgzRch
        +fQ16e9XvtLfcY4pdE7SX+ZZM2OlSo5enbVciaU4I9FQi7moOBEABqfcHIoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWS2cA0UXcRi3+Swe1F0hYfZ71gtli6Yiqj
        A5PHxOZ37B6fN8kFMEVx2aSk5mSWpRbp2yVwZbybO5uxYDZLRctPnQbGHcxdjJwcEgImEns+
        PGXqYuTiEBJYzSix5sILFgjnA6PEhKlzoJz9jBK7d75g7WLk4GAT0JR4u78ApFtEwFfieNcx
        dhBbWMBB4kLPO1aIuKPEmr1PWSBsI4lrrx+xgdgsAioSmyb+ZASxeQWsJH6dXwcWFxLYyCjx
        9Tg3iM0JdFHbqptMIDajgJjE91NrwGxmAXGJW0/mM0FcLSCxZM95qA9EJV4+/scKYStK3P/+
        kh2iXkdiwe5PbBC2tsSyha+ZIfYKSpyc+YQFol5S4uCKGywTGMVmIVkxC0n7LCTts5C0L2Bk
        WcUoXlpcnJteUWyYl1quV5yYW1yal66XnJ+7iREYQaf/HY7cwXj01ke9Q4xMHIyHGCU4mJVE
        eKtyfZKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8wq5TowXEkhPLEnNTk0tSC2CyTJxcEo1MHG/
        kvB5oOugv1crynHjXvemSRNcW15K3rVh9LWO+6dk/1vz0TrGhvmbHH68V61Yc0zOZ2fq1dKr
        E1pZ7/M3H3hZyV3+46xL94Lp8ZvM1u3+N+PVieo1veevrZgrumH5DLkFFqycm6cY7TQ+nS15
        cELa/IN9NkX7eycwdt96cj899Xnm9mNBW19dy3Mx3Sp5ICb6ieGky8FGzDP03klwnMlyZmYx
        NVz26kXGs+kMLCkJAps0lq2/fVykQSk1SqHy5eX0ewseq7mn6u9rUPO88CFn3oN6w21cpb+n
        TXhZuZVTLKlKdU2jt8GeNzu9w7NYXs828E5qqb5y/Ivf6oiH7czH+yOfbH/0/e2Mz6UJXvOV
        WIozEg21mIuKEwGlyo1mDwMAAA==
X-CMS-MailID: 20220407153458uscas1p2c03bb0149e903026a00713c5649eb77e
CMS-TYPE: 301P
X-CMS-RootMailID: 20220407145101uscas1p290fea2d9e25b5fd3a167b88d973417dc
References: <20220407144958.3975622-1-mogeb@fb.com>
        <CGME20220407145101uscas1p290fea2d9e25b5fd3a167b88d973417dc@uscas1p2.samsung.com>
        <20220407144958.3975622-4-mogeb@fb.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> -----Original Message-----
> From: Mohamad Gebai [mailto:mogeb@fb.com]
> Sent: Thursday, April 7, 2022 10:50 AM
> To: fio@vger.kernel.org
> Cc: Mohamad Gebai <mogeb@fb.com>
> Subject: [PATCH v2 3/3] iolog: update man page for version 3
>=20
> Add documentation for iolog version 3, mainly the differences between
> versions 2 and 3.
>=20
> Signed-off-by: Mohamad Gebai <mogeb@fb.com>
> ---
>  HOWTO.rst | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>=20

Please also update fio.1
