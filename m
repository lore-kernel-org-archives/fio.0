Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4B2C433EF
	for <fio@archiver.kernel.org>; Fri,  6 May 2022 15:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbiEFQBD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 May 2022 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443236AbiEFQBC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 May 2022 12:01:02 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F12A6D1BE
        for <fio@vger.kernel.org>; Fri,  6 May 2022 08:57:18 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220506155715usoutp02337240530345815558475a310d415175~sjzhLanCk3178531785usoutp02Z;
        Fri,  6 May 2022 15:57:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220506155715usoutp02337240530345815558475a310d415175~sjzhLanCk3178531785usoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651852635;
        bh=G3LIxBj48P84pNDSkjas/RgfUKnhfxQRUFqdxfsBg5o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=llzMZlKHd/dviprUsZJUuMHd4y+gXeSUDrHc2OsA7nW09m564ahd0/9cNUCJZUtNX
         Q0Lm6mSui63b1DvCx9EFX9VSzUJ6WurnrwuIDiOZxQ9FpG3OpzzB9olaaB9Ms0SU1f
         3l3IDB014nQETk6a3nQyeo5IyhB9FfGWgsAww3qo=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220506155715uscas1p1e0ed257259b7cfc33a36856f1520fa52~sjzhBZK7P2845428454uscas1p19;
        Fri,  6 May 2022 15:57:15 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 3C.27.09642.A5545726; Fri, 
        6 May 2022 11:57:15 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220506155714uscas1p1aad4344825d59a5ffe8c5be6bdaf16c7~sjzgw_8RZ2857928579uscas1p10;
        Fri,  6 May 2022 15:57:14 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-bd-6275455a4735
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 9A.FC.52349.A5545726; Fri, 
        6 May 2022 11:57:14 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.7; Fri, 6 May 2022 08:57:13 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
        6 May 2022 08:57:13 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "simon.lund@samsung.com" <simon.lund@samsung.com>
Subject: RE: [PATCH 2/3] docs: documentation for xnvme ioengine
Thread-Topic: [PATCH 2/3] docs: documentation for xnvme ioengine
Thread-Index: AQHYYIgSecidRwFXWUSBPMzUykqrla0SAmmA
Date:   Fri, 6 May 2022 15:57:13 +0000
Message-ID: <9a244e2c12e742618de59e408761f9c2@samsung.com>
In-Reply-To: <20220505131935.32076-3-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7rRrqVJBocOMFmsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DK2NArUfCCteL97hvsDYxXWLsYOTkkBEwkZrzY
        wtLFyMUhJLCSUeLJknWMEE4rk0TrvWlwVVdvXWeHSKxllGi//I4ZwvnAKDH3xhUmCGcpo8SU
        k7eBhnFwsAloSrzdXwDSLSIQIPG4fQdYDbPATEaJC9fawMYKC9hL/NiwmBWiyEFi4YMeFgjb
        SOL7yzmMIDaLgIpE3/c7YDW8AlYSe6/PYAKxOQVsJea3fGcGsRkFxCS+n1oDFmcWEJe49WQ+
        E8TZghKLZu9hhrDFJP7tesgGYStK3P/+kh3kTmagO9fv0odoVZSY0v2QHWKVoMTJmU9YIMol
        JQ6uuAEOIwmBXg6JL+1HoOa7SDTOnAcNImmJq9enMkMUtQNDZeMXqO4JjBLXn0hB2NYS/zqv
        sUNs45P4++sR4wRG5VlI7p6FcNMsJDfNQnLTAkaWVYzipcXFuempxUZ5qeV6xYm5xaV56XrJ
        +bmbGIFJ4/S/w/k7GK/f+qh3iJGJg/EQowQHs5IIr/CskiQh3pTEyqrUovz4otKc1OJDjNIc
        LErivMsyNyQKCaQnlqRmp6YWpBbBZJk4OKUamMr2Cnwym81kf8X/R6eM4KRL/MobUtJOmqyf
        8GrLqccX1u+7V5EfXWSvuP/ijou/fO7+/lDAH/qY65OlGYtx2lv1zl/Z7fvXSNux71F/tNy/
        ZMbZtDP3V7lrXl6W8W6jqMUK9ROfNPhqJob5XG2p/Fm/+c7hXS3rWkUsj6i1BjqpTXbav7/3
        wR7PydaL/8hlmzg8WvZV+sNZr6SH5hcX1tv0PNS7OKvijKZhuzX7wpsPjd1XLJhwYv7GkC0b
        Oy1XGxQ9+32xmunBGd55l1f+yD7fvkvpos/R9ZxrpRY+fPtwpkWI+UYjr+6Q3m+H2552/zOq
        sPu47LP8AyHhFxf5X8w9335g1cbJXUrV/UUT29JklFiKMxINtZiLihMBcqqCg4kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqBvlWppk8OuStsXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6MDb0SBS9YK97vvsHewHiFtYuRk0NCwETi6q3r
        7F2MXBxCAqsZJU7cvMsK4XxglPh79jGUs5RR4urVqYxdjBwcbAKaEm/3F4B0iwj4SZx/spUF
        pIZZYCajxIVrbWBjhQXsJX5sWMwKUeQgsfBBDwuEbSTx/eUcRhCbRUBFou/7HbAaXgErib3X
        ZzBBLDvMKHHq/Ts2kASngK3E/JbvzCA2o4CYxPdTa5hAbGYBcYlbT+YzQfwgILFkz3lmCFtU
        4uXjf1C/KUrc//6SHeRoZqCj1+/Sh2hVlJjS/ZAdYq+gxMmZT1ggyiUlDq64wTKBUXwWkg2z
        ELpnIemehaR7ASPLKkbx0uLi3PSKYsO81HK94sTc4tK8dL3k/NxNjMC4Ov3vcOQOxqO3Puod
        YmTiYDzEKMHBrCTCKzyrJEmINyWxsiq1KD++qDQntfgQozQHi5I4r5DrxHghgfTEktTs1NSC
        1CKYLBMHp1QDk6NnxJuvC8XuWzB0GhqtPx2r83G99ZnGpkah9woBGp9yJn3iOCPxftK8YqUi
        VZ82gxgPy0aX/LWNL5yKckv4lU5Y839ilnzz843hMfbgm09Vdq49lXXUxMMn0JJj2pXFmh2s
        Yu8LpatmXazcG9eWGrRz7aqD1qIzwzZM2aRp5ldaJ+ww53zv3VU889Sbz2g//tya7T3JrfpE
        l+5FhnN2H25vlK5s/bOJIWIr867u6at33+S1ZXi9PtB2+8NWp6aPVeLtNqf2ZdgUORlueP7z
        heukmU/2B1allu/gmi7ml28heijlz/lnZx3umtxawqxQmOXcKN70vyuicdYlzxCJAn+3c+es
        hOrsfpjm13oqsRRnJBpqMRcVJwIAp6vLXxoDAAA=
X-CMS-MailID: 20220506155714uscas1p1aad4344825d59a5ffe8c5be6bdaf16c7
CMS-TYPE: 301P
X-CMS-RootMailID: 20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d@epcas5p2.samsung.com>
        <20220505131935.32076-3-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDUsIDIwMjIg
OToyMCBBTQ0KPiBUbzogYXhib2VAa2VybmVsLmRrDQo+IENjOiBmaW9Admdlci5rZXJuZWwub3Jn
OyBrcmlzaC5yZWRkeUBzYW1zdW5nLmNvbTsNCj4gc2ltb24ubHVuZEBzYW1zdW5nLmNvbTsgQW5r
aXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMi8z
XSBkb2NzOiBkb2N1bWVudGF0aW9uIGZvciB4bnZtZSBpb2VuZ2luZQ0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQW5raXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29tPg0KPiAtLS0NCg0KSSBi
dWlsdCB0aGUgaHRtbCBkb2N1bWVudGF0aW9uIGFuZCBsb29rIHRocm91Z2ggdGhlIHVwZGF0ZWQg
bWFuIHBhZ2UuIEV2ZXJ5dGhpbmcgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IFZpbmNlbnQg
RnUgPHZpbmNlbnQuZnVAc2Ftc3VuZy5jb20+DQo=
