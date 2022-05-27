Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A63AC433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 15:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349402AbiE0PTW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiE0PTT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 11:19:19 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F97534661
        for <fio@vger.kernel.org>; Fri, 27 May 2022 08:19:15 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220527151910usoutp01587d4fda69a6296adcbe0400896a8017~y-1RIBlff3207732077usoutp01M;
        Fri, 27 May 2022 15:19:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220527151910usoutp01587d4fda69a6296adcbe0400896a8017~y-1RIBlff3207732077usoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653664750;
        bh=9RzPzgQkZkJ+Mx7E5LYW7ft/VKw3tJuo1AqGYioDVuI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=DqaPhYfc0GE2g63RrO+WxLybXqqIYfyk1uKlcIk3MXT3HgK0kEVn/QWJg0bRkXlN1
         /nQxvP9QHIo/Ciergc9vnRxh5xiqIFWa4tnSMOB7PiV9yUdw+mzjJ14hbeNchCINUf
         Eq1E81Y1oe9qcFhsYvAWYc4ndfG8n0BVWKxK6uUw=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527151910uscas1p27dffdf04fe6b616a0c69059bc80e57f9~y-1Q-KYui1663716637uscas1p2T;
        Fri, 27 May 2022 15:19:10 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id D0.58.09760.EEBE0926; Fri,
        27 May 2022 11:19:10 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220527151910uscas1p1a91c9f68c1295d56828626857e27ef3b~y-1QuhJsA1125811258uscas1p1-;
        Fri, 27 May 2022 15:19:10 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-3f-6290ebee7213
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id F9.B2.52945.DEBE0926; Fri,
        27 May 2022 11:19:10 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 08:19:09 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 08:19:09 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v2 5/8] docs: document options for io_uring_cmd I/O
 engine
Thread-Topic: [PATCH v2 5/8] docs: document options for io_uring_cmd I/O
        engine
Thread-Index: AQHYcSBxx1uZ/eaR8kSYODeU2JZNF60y1kSw
Date:   Fri, 27 May 2022 15:19:09 +0000
Message-ID: <391ced1e01384f87afb9e41f79f6b4cf@samsung.com>
In-Reply-To: <20220526144809.14877-6-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7rvXk9IMrjwRdJi9d1+NouPs14w
        OzB5XD5b6vF5k1wAUxSXTUpqTmZZapG+XQJXxtKve5gLzvFWfJnxjb2BcQFvFyMnh4SAicT1
        hruMILaQwEpGiZ8vJLoYuYDsViaJ/qOL2GGKVvQuYYZIrGWUOLOyC8r5xChxdfFrFghnGaPE
        /N7jQA4HB5uApsTb/QUg3SICARKP23cwgdQwCxxhlPjUdpcNJCEMlHh96iQbRFGgxM+Tu6Fs
        I4k9vbvBbmIRUJXo3H2ICcTmFbCS+H54OlicU8BW4tSW8ywgNqOAmMT3U2vAapgFxCVuPZnP
        BHG2oMSi2XuYIWwxiX+7HrJB2IoS97+/ZAe5kxnozvW79CFaFSWmdD9kh1glKHFy5hMWiHJJ
        iYMrboD9KCEwkUPizpoNUHNcJPqnf2eEsKUlpq+5DFXUzigxd+MXqO4JjBLXn0hB2NYS/zqv
        sUNs45P4++sR4wRG5VlI7p6FcNMsJDfNQnLTAkaWVYzipcXFuempxYZ5qeV6xYm5xaV56XrJ
        +bmbGIFJ4/S/w7k7GHfc+qh3iJGJg/EQowQHs5II74WnvUlCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeZdlbkgUEkhPLEnNTk0tSC2CyTJxcEo1MCWF1nZMbNb4UTNP8EsfW8FUL33rmU21sw49
        unhnleZrfZ3UgxHT5+g+NZwWcnOy66wMsXC9dFOtjx+4VvRemj0tvnuK++R8t3OmaiFsVqf+
        BMzl26FS2qnqvuXIy2BJ+wchyaoPjiZ09q37wSR55nLaPNtDfZPZHFbvmn19/4p2C/V+0Ry1
        sJKf82/pRPM9knkvFhDAVV37dk3o5L0XxQvjHksfaIqxOFG4W7TpRqj4h0+lfRMe/bAtDnbN
        s+Vds7gsp8nGavYzg+3bZEU+/lpb98HIfPovu8Kmc3Oao9jbe5gmfFu9o0H37kKf1J1/6t59
        Uz9/wiPuuPTzsmzWeZHs6jO1jzD8yPOdlP1+hhJLcUaioRZzUXEiAFmNPUqJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCaqPvu9YQkg5997Bar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyln7dw1xwjrfiy4xv7A2MC3i7GDk5JARMJFb0
        LmHuYuTiEBJYzSjR/mszG4TziVHi0YN5UJlljBIfjsxh6WLk4GAT0JR4u78ApFtEwE/i/JOt
        LCA1zAJHGCU+td1lA0kIAyUebJzFDFEUKPFvei8LhG0ksad3NyOIzSKgKtG5+xATiM0rYCXx
        /fB0Rohlhxkldlzfyg6S4BSwlTi15TxYM6OAmMT3U2vAGpgFxCVuPZnPBPGDgMSSPeeZIWxR
        iZeP/7FC2IoS97+/ZAc5mhno6PW79CFaFSWmdD9kh9grKHFy5hMWiHJJiYMrbrBMYBSfhWTD
        LITuWUi6ZyHpXsDIsopRvLS4ODe9otg4L7Vcrzgxt7g0L10vOT93EyMwsk7/Oxyzg/HerY96
        hxiZOBgPMUpwMCuJ8F542pskxJuSWFmVWpQfX1Sak1p8iFGag0VJnNcjdmK8kEB6Yklqdmpq
        QWoRTJaJg1OqgWnqjBWbdctk//L/3dOrtvGYkc5NvWQBXYPID9kPd21SnbSbiW/W56q56ZIm
        D3h0398OjQv2abA8OEdU5AnDB129efaPs/4EPH4sP8XWWf3lp5L4Rsu3ZqURJ1KzT3nofLJ3
        NFxmwXgi5sgGMyWxq2ZXG3zW6xTG/zTUzaq27rRce+P328//01cudNrsWmwqLfPWmf202p9n
        KYrq4llageunyT7fUXM/MkPoS+icDc+rWhU/rL/K+l73QoVYmsQbz/ID7WcK7m44GJll8m3d
        ub06b/1SznzY+1hI/Obix43eUXJRmV9fzdnCtcT57R+XL4+ma1+JO7dN1PIzJ8+U1ITpWcVf
        WPPTlohGzNvjW6DEUpyRaKjFXFScCADvK3hOGwMAAA==
X-CMS-MailID: 20220527151910uscas1p1a91c9f68c1295d56828626857e27ef3b
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0@epcas5p4.samsung.com>
        <20220526144809.14877-6-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDI2LCAyMDIy
IDEwOjQ4IEFNDQo+IFRvOiBheGJvZUBrZXJuZWwuZGsNCj4gQ2M6IGZpb0B2Z2VyLmtlcm5lbC5v
cmc7IGtyaXNoLnJlZGR5QHNhbXN1bmcuY29tOw0KPiBqb3NoaS5rQHNhbXN1bmcuY29tOyBhbnVq
MjAuZ0BzYW1zdW5nLmNvbTsgQW5raXQgS3VtYXINCj4gPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29t
Pg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjIgNS84XSBkb2NzOiBkb2N1bWVudCBvcHRpb25zIGZvciBp
b191cmluZ19jbWQgSS9PDQo+IGVuZ2luZQ0KPiANCj4gVXBkYXRlIGRvY3VtZW50YXRpb24gd2l0
aCBpb191cmluZ19jbWQgSS9PIGVuZ2luZSBzcGVjaWZpYyBvcHRpb25zLg0KPiBBZGQgbWlzc2lu
ZyBpb191cmluZyBJL08gZW5naW5lIGVudHJ5IGZyb20gZmlvIG1hbiBwYWdlLg0KPiBVcGRhdGUg
ZG9jcyB3aXRoIG1pc3NpbmcgaW9fdXJpbmcgZW5naW5lIHNwZWNpZmljIG9wdGlvbnMuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBBbmtpdCBLdW1hciA8YW5raXQua3VtYXJAc2Ftc3VuZy5jb20+DQo+
IC0tLQ0KDQo+ICsuLiBvcHRpb246OiBub252ZWN0b3JlZCA6IFtpb191cmluZ10gW2lvX3VyaW5n
X2NtZF0NCj4gKw0KPiArCVdpdGggdGhpcyBvcHRpb24sIGZpbyB3aWxsIHVzZSBub24tdmVjdG9y
ZWQgcmVhZC93cml0ZSBjb21tYW5kcywNCj4gd2hlcmUNCj4gKwlhZGRyZXNzIG11c3QgY29udGFp
biB0aGUgYWRkcmVzcyBkaXJlY3RseS4NCj4gDQo+IC0uLiBvcHRpb246OiByZWdpc3RlcmZpbGVz
IDogW2lvX3VyaW5nXQ0KPiArLi4gb3B0aW9uOjogZm9yY2VfYXN5bmM9aW50IDogW2lvX3VyaW5n
XSBbaW9fdXJpbmdfY21kXQ0KPiArDQo+ICsJTm9ybWFsIG9wZXJhdGlvbiBmb3IgaW9fdXJpbmcg
aXMgdG8gdHJ5IGFuZCBpc3N1ZSBhbiBzcWUgYXMNCj4gKwlub24tYmxvY2tpbmcgZmlyc3QsIGFu
ZCBpZiB0aGF0IGZhaWxzLCBleGVjdXRlIGl0IGluIGFuIGFzeW5jIG1hbm5lci4NCj4gKwlXaXRo
IHRoaXMgb3B0aW9uIHNldCB0byBOLCB0aGVuIGV2ZXJ5IE4gcmVxdWVzdCBmaW8gd2lsbCBhc2sg
c3FlIHRvDQo+ICsJYmUgaXNzdWVkIGluIGFuIGFzeW5jIG1hbm5lci4NCj4gKw0KDQpJdCB3b3Vs
ZCBiZSBoZWxwZnVsIHRvIHN0YXRlIHRoZSBkZWZhdWx0IHZhbHVlcyBmb3Igbm9udmVjdG9yZWQg
YW5kIGZvcmNlX2FzeW5jLg0K
