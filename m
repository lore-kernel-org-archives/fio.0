Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB83C433EF
	for <fio@archiver.kernel.org>; Thu, 19 May 2022 13:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbiESNfM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 19 May 2022 09:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiESNfK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 May 2022 09:35:10 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D05326CD
        for <fio@vger.kernel.org>; Thu, 19 May 2022 06:35:07 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220519133503usoutp02af29989ce295d36ea49a690f8d661d4d~whQFIlr5E1273512735usoutp02P;
        Thu, 19 May 2022 13:35:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220519133503usoutp02af29989ce295d36ea49a690f8d661d4d~whQFIlr5E1273512735usoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652967303;
        bh=qiR4o8z5vPe/3UZ5xfi/pF7UieCQJTFJiWF8pEB458A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aRxjvHjTwZpGOHuCfnO90EcDaxlT+TXwqmyavL7uYbiA257pKziTGZZzf1czzY0Gz
         c7zXD0izcp+A6a1bd0uDEL9H4hd6G5BNYmr1VrvcmEy3OZdHp2IXMeGAXgGU2mXQzv
         FqXcxLOToISsfIAL/ovuCHQpxdIlWl9nXF0wh4vo=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220519133503uscas1p2462938dbf1f5d11a34ffa68b3d841fe5~whQE66AL61325013250uscas1p2x;
        Thu, 19 May 2022 13:35:03 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id F9.C5.09760.78746826; Thu,
        19 May 2022 09:35:03 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220519133503uscas1p2087dc468add4b1f882e8c5e5ef53eab9~whQEqEhN80933509335uscas1p2C;
        Thu, 19 May 2022 13:35:03 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-4f-628647879211
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 15.73.57470.78746826; Thu,
        19 May 2022 09:35:03 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Thu, 19 May 2022 06:35:02 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Thu,
        19 May 2022 06:35:02 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     =?utf-8?B?QW50b2luZSBCZWF1cHLDqQ==?= <anarcat@torproject.org>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: running jobs serially
Thread-Topic: running jobs serially
Thread-Index: AQHYavFE6X8uxry3QUucBYSLHsol8a0lOslwgACg6ACAAFXkoA==
Date:   Thu, 19 May 2022 13:35:02 +0000
Message-ID: <f4da48b19d4f4d36aa238ca582a351d6@samsung.com>
In-Reply-To: <87tu9mqq2l.fsf@angela.anarc.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7rt7m1JBpc2KFjcfrqT1eLjrBfM
        Dkwem9dfZvP4vEkugCmKyyYlNSezLLVI3y6BK2N3q3vBLqGKz/efMTUw/hHsYuTkkBAwkdiw
        7DdbFyMXh5DASkaJtglrmCGcViaJ3bNeMMFU/Z18FCqxllHi9/7PUC2fGCW+9T1kAakSEljG
        KPHzYHkXIwcHm4CmxNv9BSBhEYECif+T57GC2MICShIzJ+5jgYgrSzw6v4gJwnaS2PbrLyOI
        zSKgKtHy/y4biM0rYCWxvr8ZrIZTQFdi6byjYDajgJjE91NrwGxmAXGJW0/mQx0qKLFo9h5m
        CFtM4t+uh2wQtqLE/e8v2UFOYwY6bf0ufYhWRYkp3Q/ZIVYJSpyc+YQFolxS4uCKGywgL0oI
        NHJIXF3wGGqmi8T5rhdQtrTE37vLmCCK2hkl5m78AtU9gVHi+hMpCNta4l/nNXaIbXwSf389
        YgQ5QkKAV6KjTWgCo9IsJC/MQjhvFpLzZiE5bwEjyypG8dLi4tz01GLDvNRyveLE3OLSvHS9
        5PzcTYzAhHH63+HcHYw7bn3UO8TIxMF4iFGCg1lJhJcxtyVJiDclsbIqtSg/vqg0J7X4EKM0
        B4uSOO+yzA2JQgLpiSWp2ampBalFMFkmDk6pBiah2W5VR+1mrZ/qcl3G0p3riLYs+1fLbX7H
        25gUJN9UXMt3F3F1tns1aRmr6MM9GufvTNL+rX3h9uTwjvIQjmNr1Jb1Pn+vuqA58rHz+12z
        dyvXuBZxTpv+dt+Tjmo2PdasOr/lv4613A767Kyy/ElZxn/rBTqzfna6C9cLb3IS+jM/LGp1
        zoS6cNa0wOk1QlN5TnCsvj9V3peh8s/7lBOvki2FmwXOBX6VMfr3T3GNY6ZcY/8q4S88Mpvc
        f7adMTa4v+uLsOw09oguGbu2rCU3l890vGd5YjFj8eK39X2pz1u2vLjen6HP8qWpe/Lt/N+K
        HeJ966dvXDOBzStyd1D0EoXqg+sevHS76m5+00OJpTgj0VCLuag4EQAmtSoVhwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWS2cA0SbfdvS3J4PAuXovbT3eyWnyc9YLZ
        gclj8/rLbB6fN8kFMEVx2aSk5mSWpRbp2yVwZexudS/YJVTx+f4zpgbGP4JdjJwcEgImEn8n
        H2XuYuTiEBJYzSjxbetORgjnE6PEwx2LoZxljBKvrkwCKuPgYBPQlHi7vwCkW0SgQOL/5Hms
        ILawgJLEzIn7WCDiyhKPzi9igrCdJLb9+ssIYrMIqEq0/L/LBmLzClhJrO9vZoKYf5lR4tGd
        newgCU4BXYml846CNTMKiEl8P7UGzGYWEJe49WQ+E8TZAhJL9pxnhrBFJV4+/scKYStK3P/+
        kh3kTmagO9fv0odoVZSY0v2QHWKvoMTJmU9YIMolJQ6uuMEygVFsFpINsxC6ZyHpnoWkewEj
        yypG8dLi4tz0imKjvNRyveLE3OLSvHS95PzcTYzA+Dn973D0Dsbbtz7qHWJk4mA8xCjBwawk
        wsuY25IkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdl1MR4IYH0xJLU7NTUgtQimCwTB6dUA5PI
        i+YHHquaTi1ZsegDB/chfd8g55U1NY8XaK7jMZp+V7fX442/E/uEstj8p1MlTs+f1JEUtMK1
        /Yj5zXuhuw3yHOqsy64xcu7mfj5Hbd86Bp9rz4rqtKZnNZQsa2We/urR1JJMUYmb8yy2CPgv
        55l5fl4ud9QLoXM9r41ct1wQ294xOfKCHter6yXm3eXv+cK55zRMnblc0eRx3tGHv6fxG/ce
        zvd9dmyOVIY8l9ce223Cn85zGPa9vbQ1v9Lh80G+b3K+Jvv/TtduKQ4sXaptHe/ItbdC/OMT
        t9YnW/+fnN4WlFprNPtmV0KqR67w3Amqb35frm6e68uyK9Czdz3XdpbN02fHqEw+rTP132ol
        luKMREMt5qLiRADvR3kJDgMAAA==
X-CMS-MailID: 20220519133503uscas1p2087dc468add4b1f882e8c5e5ef53eab9
CMS-TYPE: 301P
X-CMS-RootMailID: 20220518195544uscas1p2df5012297be87e1151c9b1f2ea33ff01
References: <CGME20220518195544uscas1p2df5012297be87e1151c9b1f2ea33ff01@uscas1p2.samsung.com>
        <87pmkaeicg.fsf@curie.anarc.at>
        <ab0612e1ab8a40aaa8d6eaed69c5985b@samsung.com>
        <87tu9mqq2l.fsf@angela.anarc.at>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbnRvaW5lIEJlYXVwcsOpIFtt
YWlsdG86YW5hcmNhdEB0b3Jwcm9qZWN0Lm9yZ10NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTgs
IDIwMjIgOToxNyBQTQ0KPiBUbzogVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT47
IGZpb0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IHJ1bm5pbmcgam9icyBzZXJpYWxs
eQ0KPiANCj4gT24gMjAyMi0wNS0xOCAyMjo0MToyNCwgVmluY2VudCBGdSB3cm90ZToNCj4gPiBU
aGUgam9icyB5b3UgYXJlIHJ1bm5pbmcgaGF2ZSB0aGUgKnN0b25ld2FsbCogb3B0aW9uIHdoaWNo
IHNob3VsZA0KPiBtYWtlIHRoZW0gcnVuDQo+ID4gc2VyaWFsbHkgdW5sZXNzIHNvbWV0aGluZyBp
cyB2ZXJ5IGJyb2tlbi4NCj4gDQo+IFllYWgsIHNvIHRoYXQncyBzb21ldGhpbmcgSSBhZGRlZCBk
ZWxpYmVyYXRlbHkgZm9yIHRoYXQgcHVycG9zZSwgYnV0IHR3bw0KPiB0aGluZ3MgbWFrZSBtZSB0
aGluayBpdCdzIG5vdCB3b3JraW5nIHByb3Blcmx5Lg0KPiANCj4gIDEuIHRoZSB0aW1lc3RhbXBz
IGFyZSBpZGVudGljYWwgZm9yIHRoZSB0d28gam9icw0KPiANCj4gICAgICAgICByYW5kd3JpdGUt
NGstNGctMXg6IChncm91cGlkPTEsIGpvYnM9MSk6IGVycj0gMDogcGlkPTEwMzM0Nzc6IFdlZA0K
PiBNYXkgMTggMTU6NDE6MDQgMjAyMg0KPiAgICAgICAgICByYW5kcmVhZC00ay00Zy0xeDogKGdy
b3VwaWQ9MCwgam9icz0xKTogZXJyPSAwOiBwaWQ9MTAzMzQ3MDogV2VkDQo+IE1heSAxOCAxNTo0
MTowNCAyMDIyDQo+IA0KPiAgMi4gd2hlbiBmaW8gc3RhcnRzLCBpdCBzYXlzOg0KPiANCj4gICAg
ICAgICAgU3RhcnRpbmcgMiBwcm9jZXNzZXMNCj4gDQo+ICAgICBpIHdvdWxkIGhhdmUgZXhwZWN0
ZWQgaXQgdG8gc3RhcnQgb25lIHByb2Nlc3MgYXQgYSB0aW1lDQo+IA0KDQo8c25pcD4NCg0KPiAN
Cj4gU3BlYWtpbmcgb2Ygd2hpY2gsIGl0J3Mgbm90IGNsZWFyIHRvIG1lIGlmIEkgbmVlZCB0byBh
ZGQgc3RvbmV3YWxsIHRvDQo+IGVhY2ggam9iIG9yIGlmIEkgY2FuIGp1c3QgYWRkIGl0IHRvIHRo
ZSB0b3AtbGV2ZWwgZ2xvYmFsIG9wdGlvbnMgYW5kIGJlDQo+IGRvbmUgd2l0aCBpdC4uLg0KPiAN
Cg0KVGhlIHN0b25ld2FsbCBvcHRpb24gaXMgbmVlZGVkIG9ubHkgaW4gdGhlIGdsb2JhbCBzZWN0
aW9uIGFuZCB3aWxsIGFwcGx5DQp0byBhbGwgb2YgdGhlIGpvYnMuDQoNCjxzbmlwPg0KDQo+IA0K
PiBTbyBtYXliZSB0aGUgYnVnIGlzICpqdXN0KiAxIGFuZCAyOiAoMSkgdGhlIHRpbWVzdGFtcHMg
aW4gdGhlIGZpbmFsDQo+IHJlcG9ydCBhcmUgaW5jb3JyZWN0LCBhbmQgKDIpIHByb2Nlc3NlcyBh
cmUgYWxsIHN0YXJ0ZWQgYXQgb25jZSAoYW5kIDENCj4gbWF5IGJlIHJlbGF0ZWQgdG8gMiEpDQo+
IA0KDQpUaGUgdGltZXN0YW1wIGlzIGFjdHVhbGx5IHRoZSB0aW1lIGF0IHdoaWNoIHRoZSBzdW1t
YXJ5IG91dHB1dCB3YXMgZ2VuZXJhdGVkLA0Kbm90IHRoZSB0aW1lIHRoZSBqb2Igc3RhcnRlZCBv
ciBzdG9wcGVkLg0KDQpodHRwczovL2dpdGh1Yi5jb20vYXhib2UvZmlvL2Jsb2IvZmlvLTMuMzAv
c3RhdC5jI0wxMTYxDQoNCkFsbCBvZiB0aGUgcHJvY2Vzc2VzIGFyZSBjcmVhdGVkIHdoZW4gZmlv
IHN0YXJ0cyB1cCBidXQgdGhleSBkbyBub3Qgc3RhcnQgaXNzdWluZyBJTw0KdW50aWwgaXQgaXMg
dGhlaXIgdHVybi4NCg==
