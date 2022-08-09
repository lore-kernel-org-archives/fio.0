Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988CCC19F2D
	for <fio@archiver.kernel.org>; Tue,  9 Aug 2022 16:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiHIQUI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244870AbiHIQUG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Aug 2022 12:20:06 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478AF1F2DB
        for <fio@vger.kernel.org>; Tue,  9 Aug 2022 09:20:03 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220809161958usoutp022999e8fd815999f05ad058c8b4d49413~JuZeQ3wPJ0184701847usoutp02D;
        Tue,  9 Aug 2022 16:19:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220809161958usoutp022999e8fd815999f05ad058c8b4d49413~JuZeQ3wPJ0184701847usoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660061998;
        bh=sB/kOUYjb/Le0nCNZXdp+oJgK/Lg5wZTCRiX3qYp0bQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tg+ucJzPSSDYbjbm6Y0yhmTBfWkZxTQH/BFfvYFMvuxh1chmb618lXG3pRWTp3rXM
         A79jKKpYoRuCQh2oGHckSazmMWHmyg7BqQkr9XsSpaT81slE9m+I571aH1iVutGEmO
         JXIHlOsaX4uPMgM2Lzn7sSNaB8fVNmx+3IZMBm7s=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220809161957uscas1p2b4433604c4790c358205fc1a09159594~JuZduZLxX0224602246uscas1p2v;
        Tue,  9 Aug 2022 16:19:57 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 4E.D8.08540.D2982F26; Tue, 
        9 Aug 2022 12:19:57 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220809161957uscas1p2a7ceb9d221b11477dee7d9d2b2917542~JuZdX79OM0221802218uscas1p2y;
        Tue,  9 Aug 2022 16:19:57 +0000 (GMT)
X-AuditID: cbfec370-f2bff7000001215c-b4-62f2892d9aca
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id C9.A3.52945.D2982F26; Tue, 
        9 Aug 2022 12:19:57 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 9 Aug 2022 09:19:56 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        9 Aug 2022 09:19:56 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Vincent Fu <vincent.fu@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Thread-Topic: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
        releases
Thread-Index: AQHYq0+ITAtLrBI/PEym6RyZ0BRk8q2nAWIA//+PogCAAC2G8A==
Date:   Tue, 9 Aug 2022 16:19:56 +0000
Message-ID: <cd6d66f0183a4849956a009fab36cfb0@samsung.com>
In-Reply-To: <f77991f3144a45b9a3542769738cea3f@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7q6nZ+SDPZc1rBYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CV0bpoB1vBLp6KV6ePMTUwTuDpYuTkkBAwkZjY
        u5i5i5GLQ0hgJaPE50lTWCGcViaJbec+MsJUfX+2lAUisZZRYsHJT0wQzkdGib4j39kgnKWM
        EveOPQRyODjYBDQl3u4vAOkWESiReL6xhQnEFhYIlmi+c5cVIh4icWX9FhYI20li/tzVTCCt
        LAIqEsuuBYCEeQWsJDbMbmYHsTkFrCUebtoENoZRQEzi+6k1YDazgLjErSfzmSAOFZRYNHsP
        M4QtJvFvF8g1ILaixP3vL9lBxjMDXbZ+lz5Eq6LElO6H7BCrBCVOznzCAlEuKXFwxQ2wfyUE
        Gjkkur70skIkXCQ6X0yCKpKWmL7mMlRRO6PE3I1foBITGCWuP5GCsK0l/nVeY4fYxifx99cj
        RpAjJAR4JTrahCYwKs1C8sIshPNmITlvFpLzFjCyrGIULy0uzk1PLTbOSy3XK07MLS7NS9dL
        zs/dxAhMGKf/HS7YwXjr1ke9Q4xMHIyHGCU4mJVEeI+sfZ8kxJuSWFmVWpQfX1Sak1p8iFGa
        g0VJnHdZ5oZEIYH0xJLU7NTUgtQimCwTB6dUA5OH6xOzD6lvZxxTstBeLFL2YZeh+kcjw2m7
        H+v28bvkq27qqfUWmet/4PlK9dWqgu+O1njVti34K/p5wQ/L07Zv7s53/fUjwG2x/3qHqkma
        YvZCyd2G6S/vN2+YJ1C39TL3B4udbVb/5jKurtx6s0OC3Tvn2E5DxpdHzxU7z2/6cCB+1fXo
        0BVSe702VT+7divOInvHWpdzFpd2fZhw/5jDtSs6m1f7lPRcOxIkkaonW30+ddWWc/fET22y
        O2Potl3j/BYlzkmtnfv2zvnHkWLm1+DRpd0l88n3yufgnXm/EyqKHi1xl4n9uuKMgzLfkeQ/
        a/iTPQvszbIuJ6/zPGgV5lKpbpDjeWPqmTUrFBqUWIozEg21mIuKEwF01bI4hwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWS2cA0SVe381OSwaMbghar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyWhftYCvYxVPx6vQxpgbGCTxdjJwcEgImEt+f
        LWUBsYUEVjNKNDzS6WLkArI/Mkrs//SCEcJZyijxtfE5kMPBwSagKfF2fwFIg4hAicTzjS1M
        ILawQLBE8527rCAlIgIhEuvu+0CUOEnMn7uaCSTMIqAisexaAEiYV8BKYsPsZnaI6Z8ZJR5/
        uMoMkuAUsJZ4uGkT2EhGATGJ76fWgNnMAuISt57MZ4K4WUBiyZ7zzBC2qMTLx/9YIWxFifvf
        X7KD7GIGunL9Ln2IVkWJKd0P2SH2CkqcnPmEBaJcUuLgihssExjFZiHZMAuhexaS7llIuhcw
        sqxiFC8tLs5Nryg2zkst1ytOzC0uzUvXS87P3cQIjJzT/w7H7GC8d+uj3iFGJg7GQ4wSHMxK
        IrxH1r5PEuJNSaysSi3Kjy8qzUktPsQozcGiJM7rETsxXkggPbEkNTs1tSC1CCbLxMEp1cB0
        rnK2+/fltz8fSRHft217bkd767pmn3v/xFgKitLbT8TyTH2eOatorc7fHheD6DcvF1g9fZB3
        6dP6YIEbr98tX3dr2ekzaYJf3ni5tUdf56h8kX5CRmnzaiZpXxu+mSds22J77F5MZJZzDYyc
        /X7nFP7um+c37nvw+t67x7+2Cxp+X7xPbNWWmKO+/feXi5k/+sfE3aJ5IHLi6jSGlJ3WicuY
        TddOU/lya5PLw/szTrHtvKT39IPulMTjnXpbbxYvfZ2z20LsjaNGioew3avjfx239amLJKep
        tttWX91035H32T6PST/+dZfJrJKeNctmcmTu/E+a87fw7RLJCuxaVq8iX3w30DWMexrDxndG
        HEosxRmJhlrMRcWJAAu8HAkLAwAA
X-CMS-MailID: 20220809161957uscas1p2a7ceb9d221b11477dee7d9d2b2917542
CMS-TYPE: 301P
X-CMS-RootMailID: 20220808175150uscas1p29cea1de374da02264662429884c9eedf
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
        <20220808175133.37920-1-vincent.fu@samsung.com>
        <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
        <f77991f3144a45b9a3542769738cea3f@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWaW5jZW50IEZ1IFttYWlsdG86
dmluY2VudC5mdUBzYW1zdW5nLmNvbV0NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDksIDIwMjIg
OTozMSBBTQ0KPiBUbzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPjsgZmlvQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDAvMV0gY2k6IHVwbG9hZCB0YWdnZWQgQXBw
VmV5b3IgaW5zdGFsbGVycyBhcyBHaXRIdWINCj4gcmVsZWFzZXMNCj4gDQo+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBKZW5zIEF4Ym9lIFttYWlsdG86YXhib2VAa2Vy
bmVsLmRrXQ0KPiA+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCA5LCAyMDIyIDk6MTAgQU0NCj4gPiBU
bzogVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT47IGZpb0B2Z2VyLmtlcm5lbC5v
cmcNCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvMV0gY2k6IHVwbG9hZCB0YWdnZWQgQXBwVmV5
b3IgaW5zdGFsbGVycyBhcw0KPiBHaXRIdWINCj4gPiByZWxlYXNlcw0KPiA+DQoNCjxzbmlwPg0K
DQo+ID4NCj4gPiBJIGFwcGxpZWQgdGhlIHBhdGNoIGFuZCB1cGRhdGVkIHRoZSBrZXksIGFuZCBw
dXNoZWQgYSB0ZXN0IHRhZy4gTGV0J3MNCj4gPiBzZWUgaWYgdGhpcyB3b3JrcyENCj4gPg0KPiA+
IC0tDQo+ID4gSmVucyBBeGJvZQ0KPiANCj4gSmVucywgaWYgeW91IGRvbid0IHdhbnQgdG8gd2Fp
dCB5b3UgY2FuIGtpbGwgdGhpcyBidWlsZDoNCj4gDQo8c25pcD4NCj4gDQo+IEFuZCB0aGVuIHRo
aXMgb25lIHNob3VsZCAoZmluZ2VycyBjcm9zc2VkKSBwdXNoIGluc3RhbGxlcnMgdG8gR2l0SHVi
Og0KPiANCjxzbmlwPg0KDQpPayBJIGhhZCB0byBtYWtlIGEgc21hbGwgdHdlYWsgYnV0IEkgdGhp
bmsgaXQgaXMgYWxsIHdvcmtpbmcgbm93Og0KDQpodHRwczovL2dpdGh1Yi5jb20vYXhib2UvZmlv
L3JlbGVhc2VzDQoNCkkgcHVzaGVkIGEgdGFnIHRvIGdpdC5rZXJuZWwuZGsgd2hpY2ggZ290IGF1
dG9tYXRpY2FsbHkgcHVzaGVkIHRvIEdpdEh1Yg0Kd2hpY2ggdGhlbiB0cmlnZ2VyZWQgdGhlIEFw
cFZleW9yIGJ1aWxkIGFuZCBldmVudHVhbGx5IHdlIGVuZGVkIHVwIHdpdGgNCnRoZSByZWxlYXNl
IGFydGlmYWN0cyBvbiBHaXRIdWIuDQo=
