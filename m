Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639C9C43334
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 20:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiFAUqS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiFAUpY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 16:45:24 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5881CF140
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 13:32:59 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220601203257usoutp01a49c342f77daf86bc244b40625b39e69~0mVqxNWTA2206622066usoutp01F;
        Wed,  1 Jun 2022 20:32:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220601203257usoutp01a49c342f77daf86bc244b40625b39e69~0mVqxNWTA2206622066usoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654115577;
        bh=9mH4FEvVoWXKv8cwUd38wQSpLrggHxstE6nKtpyY7gk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=IPAezoSAYylWOqqmiO6zZEnZAh9nPvP27AjJQ+ehkyajSo0/4z9vMtbMKCNMQez4T
         agxWbTg990s7NrKXHEgAIQJ1GFPsSbm8eL4FeTFOGKGnwCRUOBPWBKI8jBC57hvh8o
         UgRNiM4L+hEPzb2hxaIo6kX/FiqWNIJ8qSAhZhzw=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220601203257uscas1p2030dd8462fa314f3aa46364341c0a4d2~0mVqoqTOy2404224042uscas1p2K;
        Wed,  1 Jun 2022 20:32:57 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id D3.31.09760.9FCC7926; Wed, 
        1 Jun 2022 16:32:57 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220601203257uscas1p2ba1b4edd8c1ee76633e61e50df0a425e~0mVqMjqBZ0872008720uscas1p2N;
        Wed,  1 Jun 2022 20:32:57 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-f1-6297ccf929c8
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 19.F8.57470.9FCC7926; Wed, 
        1 Jun 2022 16:32:57 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Wed, 1 Jun 2022 13:32:56 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Wed,
        1 Jun 2022 13:32:56 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v3 7/9] zbd: Check for direct flag only if its block
 device
Thread-Topic: [PATCH v3 7/9] zbd: Check for direct flag only if its block
        device
Thread-Index: AQHYdZvCL8100WZR3k+A+WUazHonJK06xEAg
Date:   Wed, 1 Jun 2022 20:32:56 +0000
Message-ID: <547f643d9ae54ee5a5f173115808b6da@samsung.com>
In-Reply-To: <20220531133155.17493-8-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7o/z0xPMtg3Uc9i9d1+NouPs14w
        OzB5XD5b6vF5k1wAUxSXTUpqTmZZapG+XQJXxt9vG5gK9vFU7N5+hLGBcQpPFyMnh4SAicTK
        P5fZuhi5OIQEVjJKHPo3gwkkISTQyiTx8EoZTNHriSvZIeJrGSUW3/SAaPjIKPH74EYWCGcp
        o8SSh5OARnFwsAloSrzdXwDSICIQIPG4fQcTSA2zwBFGiU9td9lAEsICgRJvzm1lhCgKkjjY
        towJwjaSaH51ASzOIqAi0bfuGyuIzStgJfG+9SrYFZwCthLvpk5iBrEZBcQkvp9aA9bLLCAu
        cevJfCaIqwUlFs3ewwxhi0n82/WQDcJWlLj//SU7yJ3MQHeu36UP0aooMaX7ITvEKkGJkzOf
        sECUS0ocXHEDyu7lkLh/XhLCdpH49HIn1Hhpib93l4H9KCHQzigxd+MXqIYJjBLXn0hB2NYS
        /zqvsUMs45P4++sR4wRG5VlIzp6FcNIsJCfNQnLSAkaWVYzipcXFuempxYZ5qeV6xYm5xaV5
        6XrJ+bmbGIEJ4/S/w7k7GHfc+qh3iJGJg/EQowQHs5IIb8muqUlCvCmJlVWpRfnxRaU5qcWH
        GKU5WJTEeZdlbkgUEkhPLEnNTk0tSC2CyTJxcEo1MAlXRvVGmZz7m7Pr/vxpuZvzV8dWdqp+
        uMzotVaE875k0LuCQxcz1i9tsIlcK3c858iliMUTz+nNSvyslbJ2M9vrKd+4P5/YseNHsI7C
        7C81HraHrhZPde992y3he3nnnmor200d+48oPzp7IvTphvOXJoVu3ykwa7lKoNE307KkxsVO
        6UtMtjb/sTkYvGUqI3uucqvFq/T/4as7o/8lvjEWiuxf8liaJW7nh7fWe1hX3XtYdvRL97qT
        E4VuPfrMVX/roXrmXtftbM+P/S1vvyMxsUp28stc17Trl0sY7lxwdY15YH9y5nn+L6J/RDSf
        3pC8Xn1XbYOSyywroW9W84PXT/9QXyGdpMd0/MaNH1e9lViKMxINtZiLihMBCirJYocDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCapPvzzPQkg91feS1W3+1ns/g46wWz
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBl/P22galgH0/F7u1HGBsYp/B0MXJySAiYSLye
        uJK9i5GLQ0hgNaPEkX2NrBDOR0aJpVNOQWWWMkrcOLWCqYuRg4NNQFPi7f4CkG4RAT+J80+2
        soDUMAscYZT41HaXDSQhLBAo8ebcVkaIoiCJB+fWM0PYRhLNry6AxVkEVCT61n1jBbF5Bawk
        3rdehVp2mFFiW+97JpAEp4CtxLupk8CaGQXEJL6fWgMWZxYQl7j1ZD4TxA8CEkv2nGeGsEUl
        Xj7+xwphK0rc//6SHeRoZqCj1+/Sh2hVlJjS/ZAdYq+gxMmZT1ggyiUlDq64wTKBUXwWkg2z
        ELpnIemehaR7ASPLKkbx0uLi3PSKYqO81HK94sTc4tK8dL3k/NxNjMDIOv3vcPQOxtu3Puod
        YmTiYDzEKMHBrCTCW7JrapIQb0piZVVqUX58UWlOavEhRmkOFiVx3pdRE+OFBNITS1KzU1ML
        UotgskwcnFINTMaWxRn9qctZ7ob0mdQv4xXKDtvrdXJa+IvXqerBOpJLNkxcYnxHyO+B1dSz
        J6wPtH6t/h6wOz8ws7tFK8b4ruZCkRW66av9l3AIbNzaJeQm+e/vjOfCvi1p5dPnZ2l6vJ0z
        IfV9tahTavDnd0Zr/I5+Kfy1M8roj+6xPS5mYkvv/5U6JafWl9Itf8wnKajafn319d9PHm/c
        at1qOF3JMeDVlIsXYg6vEhe6vUOl0VAx1WfJ3DCGsuryee4cgYzLbtxce+UuZ57OTdvmadm7
        k6eG5Fo90IzguHB5+lodttNn05yWBG4Vz2x5ITx9cqCPhY5frJCn3Kx9EzaFnioID9Upyfr0
        8HfPyqQfYi4JSizFGYmGWsxFxYkAoo6fYBsDAAA=
X-CMS-MailID: 20220601203257uscas1p2ba1b4edd8c1ee76633e61e50df0a425e
CMS-TYPE: 301P
X-CMS-RootMailID: 20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8@epcas5p1.samsung.com>
        <20220531133155.17493-8-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBNYXkgMzEsIDIwMjIg
OTozMiBBTQ0KPiBUbzogYXhib2VAa2VybmVsLmRrDQo+IENjOiBmaW9Admdlci5rZXJuZWwub3Jn
OyBrcmlzaC5yZWRkeUBzYW1zdW5nLmNvbTsNCj4gam9zaGkua0BzYW1zdW5nLmNvbTsgYW51ajIw
LmdAc2Ftc3VuZy5jb207IEFua2l0IEt1bWFyDQo+IDxhbmtpdC5rdW1hckBzYW1zdW5nLmNvbT4u
L3Rlc3QtemJkLXN1cHBvcnQgLWwgL2Rldi9zZzINCj4gU3ViamVjdDogW1BBVENIIHYzIDcvOV0g
emJkOiBDaGVjayBmb3IgZGlyZWN0IGZsYWcgb25seSBpZiBpdHMgYmxvY2sgZGV2aWNlDQo+IA0K
PiBudm1lLW5zIGdlbmVyaWMgY2hhcmFjdGVyIGRldmljZXMgY3VycmVudGx5IGRvIG5vdCBzdXBw
b3J0IE9fRElSRUNUDQo+IGZsYWcuDQo+IENoZWNrIGZvciBmaW8gb3B0aW9uIGZvciBkaXJlY3Qg
ZmxhZyBvbmx5IGlmIGZpbGV0eXBlIGlzIGEgYmxvY2sgZGV2aWNlLg0KPiANCj4gdC96YmQgc2tp
cCB0ZXN0IGNhc2UgIzEgZm9yIGNoYXJhY3RlciBkZXZpY2VzIGFzIHRoZXkgZG9uJ3QgcmVxdWly
ZQ0KPiBkaXJlY3QgSS9PLg0KPiANCj4gVGVzdGVkLWJ5OiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1
QHNhbXN1bmcuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmtpdCBLdW1hciA8YW5raXQua3VtYXJA
c2Ftc3VuZy5jb20+DQoNCkkgcmFuDQoNCnQvemJkL3J1bi10ZXN0cy1hZ2FpbnN0LW51bGxiDQoN
CmFuZCBUZXN0IDEgcmFuIGZvciBhbGwgc2VjdGlvbnMuIFRoZXJlIHdlcmUgbm8gdGVzdCBmYWls
dXJlcy4NCg0KSSBhbHNvIGNyZWF0ZWQgYSB6b25lZCBkZXZpY2Ugd2l0aDoNCg0KbW9kcHJvYmUg
c2NzaV9kZWJ1ZyB6YmM9MiB6b25lX25yX2NvbnY9MA0KDQphbmQgdGhlbiByYW46DQoNCnQvemJk
L3Rlc3QtemJkLXN1cHBvcnQgLWwgL2Rldi9zZzINCg0KYW5kIGFsbCB0ZXN0cyBleGNlcHQgVGVz
dCAxMyBwYXNzZWQuIFRoZSBmYWlsdXJlIHNlZW1zIHVucmVsYXRlZCB0byB0aGlzIHBhdGNoLiBU
aGUgZmFpbHVyZSBhcHBlYXJzIHRvIGJlIHJlbGF0ZWQgdG8gbGliemJjIHJlcG9ydGluZyBtYXgg
b3BlbiB6b25lcyBpbmNvcnJlY3RseS4NCg==
