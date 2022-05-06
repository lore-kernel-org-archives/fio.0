Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3983C433EF
	for <fio@archiver.kernel.org>; Fri,  6 May 2022 16:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443298AbiEFQEs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 May 2022 12:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443296AbiEFQEm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 May 2022 12:04:42 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566E069734
        for <fio@vger.kernel.org>; Fri,  6 May 2022 09:00:59 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220506160058usoutp018d69204235159ec3c54e8bc2da44310a~sj2xJT6Wk0713707137usoutp01G;
        Fri,  6 May 2022 16:00:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220506160058usoutp018d69204235159ec3c54e8bc2da44310a~sj2xJT6Wk0713707137usoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651852858;
        bh=7ifJC0LiR/bNyEoJAbVcHXlK21ZwTTpV/RxyGqDJAHg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=LicG9Sn/P3c0vNXlaC9DrGpWQWLugB6vbrgv1yR6pp/jdbueQmsqzEj9DJAEfdZb9
         bfDZuHoFv0WzuiMY6dty4/kvmC2+7iZl/IkzwLTX16/+ta31FYvAWzYBKf3EqzZ85a
         os5PZs9ZG4mW19E4cL3/bhWnf1je9Fp9Ah2s+2bs=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220506160058uscas1p126b64aed325c7e0f026cdb4bef51e71d~sj2w_O8NG3166631666uscas1p1B;
        Fri,  6 May 2022 16:00:58 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 6E.54.09760.A3645726; Fri, 
        6 May 2022 12:00:58 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220506160058uscas1p2ce72259a007ed8d8978c310f3c1cda73~sj2wp1bUB3229032290uscas1p2r;
        Fri,  6 May 2022 16:00:58 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-a3-6275463a4ced
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 2E.0D.52349.93645726; Fri, 
        6 May 2022 12:00:57 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.7; Fri, 6 May 2022 09:00:56 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
        6 May 2022 09:00:56 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "simon.lund@samsung.com" <simon.lund@samsung.com>
Subject: RE: [PATCH 3/3] examples: add example job file for xnvme engine
 usage
Thread-Topic: [PATCH 3/3] examples: add example job file for xnvme engine
        usage
Thread-Index: AQHYYIgWtDoACcrnS0aHoj1IMUDLpa0SAuAQ
Date:   Fri, 6 May 2022 16:00:56 +0000
Message-ID: <44d4a4607dc449babc307b869f2d5029@samsung.com>
In-Reply-To: <20220505131935.32076-4-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87pWbqVJBn++iVqsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKaF/0gbHgFUfF5t+rWBsYz3B0MXJySAiYSKx6
        upS5i5GLQ0hgJaPErx3/2EESQgKtTBKPTzHDFP1oW80EUbSWUeJ77y5WCOcDo8T7m6/ZIJyl
        jBK7Gg8xdjFycLAJaEq83V8A0i0iECDxuH0HWDezwExGiQvX2lhBEsJAiRnzj7JCFAVK7Duw
        CMo2ktjzqJMVZA6LgIrEngdqIGFeASuJd0/Og13EKWArMfXeATYQm1FATOL7qTVMIDazgLjE
        rSfzmSCuFpRYNHsP1AdiEv92PWSDsBUl7n9/yQ4ynhnozPW79CFaFSWmdD9kh1glKHFy5hMW
        iHJJiYMrbrCAnC8hMJFD4u6mr6wQCReJG7tfQs2Ulrh6fSozRFE7o8TcjV+guicwSlx/IgVh
        W0v867zGDrGNT+Lvr0eMExiVZyG5exbCTbOQ3DQLyU0LGFlWMYqXFhfnpqcWG+allusVJ+YW
        l+al6yXn525iBKaM0/8O5+5g3HHro94hRiYOxkOMEhzMSiK8wrNKkoR4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzLsvckCgkkJ5YkpqdmlqQWgSTZeLglGpg0ud1m/5HMPjbMo67c20O6TyoD49c
        7ycmb7DF/C/7DKvlt90d29W+yUUvWfLn6P8mWdkvtcvnxLx7dM34e5jZl+cLXs8Mq2NjeBG3
        Q1Og0j54dUxvp9m5DKObWkIzd78xei1zjPUfT9TRp1c/qIRpmgteKGXnnbTBZpWiCt/KrrON
        D4Vft047u1tGbMuu17Pean5J+uMVY2C75Z4FR/+hxz/8fFUDrJk/bdxovGkRG3OrUfzUJp85
        J2cttsuaJnv37i3t0ssnDdhfbrUyLi7x781M1fj98H01gyGL5ME3M20+OqxzObjk6Jlioyz2
        ORd+3nXgZnzLMvNnMSdzxRkrrfp99lej/blXtp97PjF0qxJLcUaioRZzUXEiAP97mjGIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqGvpVppkcOCltcXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6M9kUfGAtecVRs/r2KtYHxDEcXIyeHhICJxI+2
        1UxdjFwcQgKrGSV+/e5gg3A+MEpcnnmMFcJZyijxb8Fu5i5GDg42AU2Jt/sLQLpFBPwkzj/Z
        ygJSwywwk1HiwrU2VpCEMFBi8pYuZoiiQImtLSdYIWwjiT2POllB5rAIqEjseaAGEuYVsJJ4
        9+Q8M8Suw4wSS5s7GEESnAK2ElPvHWADsRkFxCS+n1rDBGIzC4hL3HoynwniBQGJJXvOM0PY
        ohIvH/9jhbAVJe5/f8kOsosZ6Ob1u/QhWhUlpnQ/ZIfYKyhxcuYTFohySYmDK26wTGAUn4Vk
        wyyE7llIumch6V7AyLKKUby0uDg3vaLYMC+1XK84Mbe4NC9dLzk/dxMjMK5O/zscuYPx6K2P
        eocYmTgYDzFKcDArifAKzypJEuJNSaysSi3Kjy8qzUktPsQozcGiJM4r5DoxXkggPbEkNTs1
        tSC1CCbLxMEp1cBkJqfB6P26/piFWNo3+wbDsr1lghOnLJf6vHNPxmHlST9XX5W5unDW5stP
        PO/31pfLySbv2bguf9uG11++TDQNmHel4e3dyEPTYn+8WnTs9xG1RwZ22go3+rkcPyyInbl8
        md7ctglR0Vdd5p47uCTD8MIB+4qjO/17nP+cTy92YrottPLCg1QOzn3VmwsafrR3rXqSKxOv
        tvLzzyPGdirWpwqm559weqDXfzp+NtuFZ8sTy1I4U13ajuYcP+zP/XzNoYeSXX3qZhbfr5wu
        djU9JvZsVfapjxc/7tG+9533a8kqltVvLF47SEYY6yYlu/9c/+Fwko9D3d4DIRslciaeWvy3
        juVhSOcHaW2rxXXOVUosxRmJhlrMRcWJAMA1bVkaAwAA
X-CMS-MailID: 20220506160058uscas1p2ce72259a007ed8d8978c310f3c1cda73
CMS-TYPE: 301P
X-CMS-RootMailID: 20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132546epcas5p331f666cadd5c7e788d27d09b144e0b8a@epcas5p3.samsung.com>
        <20220505131935.32076-4-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDUsIDIwMjIg
OToyMCBBTQ0KPiBUbzogYXhib2VAa2VybmVsLmRrDQo+IENjOiBmaW9Admdlci5rZXJuZWwub3Jn
OyBrcmlzaC5yZWRkeUBzYW1zdW5nLmNvbTsNCj4gc2ltb24ubHVuZEBzYW1zdW5nLmNvbTsgQW5r
aXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBleGFtcGxlczogYWRkIGV4YW1wbGUgam9iIGZpbGUgZm9yIHhudm1lIGVuZ2luZQ0KPiB1c2Fn
ZQ0KPiANCj4gQ28tQXV0aG9yZWQtQnk6IEFua2l0IEt1bWFyIDxhbmtpdC5rdW1hckBzYW1zdW5n
LmNvbT4NCj4gQ28tQXV0aG9yZWQtQnk6IFNpbW9uIEEuIEYuIEx1bmQgPHNpbW9uLmx1bmRAc2Ft
c3VuZy5jb20+DQo+IC0tLQ0KDQpJIHJhbiB4bm1lLWNvbXBhcmUuZmlvIChpb191cmluZywgeG52
bWUraW9fdXJpbmcsIGFuZCB4bnZtZStsaWJhaW8pIGFnYWluc3QgYW4gTlZNZW9GIGxvb3AgZGV2
aWNlIGJhY2tlZCBieSBudWxsX2JsayBhbmQgZXZlcnl0aGluZyB3b3JrZWQgYXMgZXhwZWN0ZWQu
DQpJIHJhbiB4bnZtZS16b25lZC5maW8gKGlvX3VyaW5nLCB4bnZtZStpb191cmluZywgYW5kIHhu
dm1lK2xpYmFpbykgYWdhaW5zdCBhbiBlbXVsYXRlZCBaTlMgZGV2aWNlIGluIFFFTVUgYW5kIGV2
ZXJ5dGhpbmcgd29ya2VkIGFzIGV4cGVjdGVkLg0KDQpSZXZpZXdlZC1ieTogVmluY2VudCBGdSA8
dmluY2VudC5mdUBzYW1zdW5nLmNvbT4NCg==
