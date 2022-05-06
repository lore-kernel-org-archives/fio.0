Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073BEC433F5
	for <fio@archiver.kernel.org>; Fri,  6 May 2022 16:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443977AbiEFQ70 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 May 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443981AbiEFQ7U (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 May 2022 12:59:20 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3AB19294
        for <fio@vger.kernel.org>; Fri,  6 May 2022 09:55:35 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220506165532usoutp022292ba4f7755c6cb2498730c5dac0cbd~skmaqAKoL1774817748usoutp02V;
        Fri,  6 May 2022 16:55:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220506165532usoutp022292ba4f7755c6cb2498730c5dac0cbd~skmaqAKoL1774817748usoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651856133;
        bh=FHsCp6RJGzSWUNELGeq6DolU4Aj0Abtk7aeZHTYdg0w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=tNpK4zdmweyqb2R1ybevIB1tuZ2LPp/5voDd7Ch7qlNE/v2id/r1o/mN3ilMXstxZ
         eJYu1VmrhRN94cBZyPo9TaPlXfGP4DvCK3O6Vb2cFrYcTxLL1y2Rc4jum+lxdIFKwX
         G4zJCFlyhE60EQGyZ7PCv8vfDIaUxXf90ssS5WDc=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220506165532uscas1p2bc65629006db996e00b93a8f5e6a86f9~skmaiAtBc1174111741uscas1p2B;
        Fri,  6 May 2022 16:55:32 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 4E.BA.09749.40355726; Fri, 
        6 May 2022 12:55:32 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220506165532uscas1p2ed1684f4bf344c14f6667a6e4db556ff~skmaRALVz2344123441uscas1p2H;
        Fri,  6 May 2022 16:55:32 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-11-62755304e240
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 61.5E.52349.40355726; Fri, 
        6 May 2022 12:55:32 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.7; Fri, 6 May 2022 09:55:31 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
        6 May 2022 09:55:31 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "simon.lund@samsung.com" <simon.lund@samsung.com>
Subject: RE: [PATCH 1/3] engines/xnvme: add xnvme engine
Thread-Topic: [PATCH 1/3] engines/xnvme: add xnvme engine
Thread-Index: AQHYYIgRJhLkdx73HkS1l95iTNicz60SEuQQ
Date:   Fri, 6 May 2022 16:55:31 +0000
Message-ID: <c57c33726a334fb5a49100f40fcce016@samsung.com>
In-Reply-To: <20220505131935.32076-2-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7djXc7oswaVJBou36FusvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DK2H7yG3vBEfmKnt0X2BoY78h1MXJySAiYSEy9
        +4K1i5GLQ0hgJaPEnTWHmSCcViaJqU2T2LsYOcCq/qy3goivZZTo3DWPEcL5wCjx+/p0dpBR
        QgJLGSW2nfEBaWAT0JR4u78AJCwiECDxuH0H2FBmgZmMEheutbGC1AgLWEj0T0mEqLGUWPdt
        MTuEbSTRtPQxG0gJi4CKxNcbFiBhXgErieWb5jGB2JwCthKPdp8GK2cUEJP4fmoNWJxZQFzi
        1pP5TBCPCUosmr2HGcIWk/i36yEbhK0ocf/7S7C3mIGuXL9LH6JVUWJK90N2iFWCEidnPmGB
        KJeUOLjiBgvI9RICvRwSHzY+gprjIrH81G6oXdISV69PZYYoameUmLvxC1T3BEaJ60+kIGxr
        iX+d19ghtvFJ/P31iHECo/IsJHfPQrhpFpKbZiG5aQEjyypG8dLi4tz01GLjvNRyveLE3OLS
        vHS95PzcTYzAdHH63+GCHYy3bn3UO8TIxMF4iFGCg1lJhFd4VkmSEG9KYmVValF+fFFpTmrx
        IUZpDhYlcd5lmRsShQTSE0tSs1NTC1KLYLJMHJxSDUwtvp9vMGlrCqmUHpi7/EzXI9uPv2Mb
        zLZO2fhuvfaSojMrPvdFGWyL13KXZT7Vd9LgxhWPXwxn7hzlf+Mq6dpcKHzAnVsvpye587rq
        9D9blrkuuz1Zafa6vlV/Aib9jTHRKmWdVT3FX6ngolf5k8eO/fnX5sr8PGzd9+exrfDKyYeM
        Z1hfbVbzvpaYU7dd+XLuy/OxKU+eC/21fC9/LC7IPzxY8ciOsot2nMftki6m+5/4fPuiXaGj
        25QozzkrczqKZy+8YPZiRXPLrgXn7lx8tmy+WTZL67FHPwq1P9awMW7mZxBlSVLJPCj6LlOl
        VDD24tOczoA/svrMx0K2vFeOz7Fi+xF0XDE9ki/hea4SS3FGoqEWc1FxIgABiO/EhgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LJbGCapMsSXJpksO+nlMXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6M7Se/sRccka/o2X2BrYHxjlwXIweHhICJxJ/1
        Vl2MXBxCAqsZJVZMX8kI4XxglJjy4zUzhLOUUWLam0MsIB1sApoSb/cXdDFycogI+Emcf7KV
        BaSGWWAmo8SFa22sIDXCAhYS/VMSIWosJdZ9W8wOYRtJNC19zAZSwiKgIvH1hgVImFfASmL5
        pnlMILaQwGFGiZkv3EFsTgFbiUe7T4O1MgqISXw/tQashllAXOLWk/lgtoSAgMSSPeeZIWxR
        iZeP/7FC2IoS97+/ZAdZxQx08fpd+hCtihJTuh+yQ6wVlDg58wkLRLmkxMEVN1gmMIrPQrJh
        FkL3LCTds5B0L2BkWcUoXlpcnJteUWyYl1quV5yYW1yal66XnJ+7iREYUaf/HY7cwXj01ke9
        Q4xMHIyHGCU4mJVEeIVnlSQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5xVynRgvJJCeWJKanZpa
        kFoEk2Xi4JRqYFoxS/GPcOg00c95Nyoe8+74IbXONPSYyYvc0DuGnU5n/fzuLDj1ZEt12ufb
        MbZbLv//Id58ROz8yrBqpZA01rcX3DI3imgfvHTCnP/bk0oOARnjyxPCviWenXCAKXzNAhmD
        7PcRq5yTHP7OP1xhEFRx9vPzNyIlU5fPWhzCJHO+slP8XaBkteeJ3hnn0lttH+q/Y2YqCYv5
        x2jYw/HXVjbt8aTNkgzXPLflqDFMb1o7Qegmh4dr765FnjGpQnJLGtY8M2A/Lrp0Y2dk8Caj
        g2+rdNhib09ZrOd1XE1cu2W7yp24CjOmePUzIm/vzNoSeFS7XPbTZ0nVpl8X55nJqyR9YbJL
        WJMzp3hSsH7ZCyWW4oxEQy3mouJEAAiGOm4XAwAA
X-CMS-MailID: 20220506165532uscas1p2ed1684f4bf344c14f6667a6e4db556ff
CMS-TYPE: 301P
X-CMS-RootMailID: 20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1@epcas5p4.samsung.com>
        <20220505131935.32076-2-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDUsIDIwMjIg
OToyMCBBTQ0KPiBUbzogYXhib2VAa2VybmVsLmRrDQo+IENjOiBmaW9Admdlci5rZXJuZWwub3Jn
OyBrcmlzaC5yZWRkeUBzYW1zdW5nLmNvbTsNCj4gc2ltb24ubHVuZEBzYW1zdW5nLmNvbTsgQW5r
aXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMS8z
XSBlbmdpbmVzL3hudm1lOiBhZGQgeG52bWUgZW5naW5lDQo+IA0KPiBUaGlzIHBhdGNoIGludHJv
ZHVjZXMgYSBuZXcgZmlvIGVuZ2luZSB0byB3b3JrIHdpdGggeE5WTWUgPj0gMC4yLjAuDQo+IHhO
Vk1lIHByb3ZpZGVzIGEgdXNlciBzcGFjZSBsaWJyYXJ5IChsaWJ4bnZtZSkgdG8gd29yayB3aXRo
IE5WTWUNCj4gZGV2aWNlcy4gVGhlIE5WTWUgZHJpdmVyIGJlaW5nIHVzZWQgYnkgbGlieG52bWUg
aXMgcmUtdGFyZ2V0YWJsZSBhbmQNCj4gY2FuIGJlIGFueSBvbmUgb2YgdGhlIEdOVS9MaW51eCBL
ZXJuZWwgTlZNZSBkcml2ZXIgdmlhIGxpYmFpbywNCj4gSU9DVExzLCBpb191cmluZywgdGhlIFNQ
REsgTlZNZSBkcml2ZXIsIG9yIHlvdXIgb3duIGN1c3RvbSBOVk1lDQo+IGRyaXZlci4NCj4gDQo+
IEZvciBtb3JlIGluZm8gdmlzaXQNCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBz
Oi8vcHJvdGVjdDIuZmlyZWV5ZS5jb20vdjEvdXJsP2s9YWQNCj4gNzM5YTY4LWNjZjg4ZjUyLWFk
NzIxMTI3LTc0ZmU0ODYwMDA4YS0NCj4gZTQ5MGQ1YzhhOTJkMDcyYyZxPTEmZT0wNzE0MDA0Ni04
Yjk5LTQ4NWEtYTZjZi0NCj4gMGMxNjg1NzA3YTY3JnU9aHR0cHMqM0EqMkYqMkZ4bnZtZS5pbyoy
Rl9fO0pTVWxKUSEhRXdWenFHb1RLQg0KPiBxdi0NCj4gMERXQUpCbSFDaGtVQWc4VjRGR2RMQWd3
NTRNVUREOFBScFZtbzFSQmVSZVpwZk1LeFd6OGENCj4gRE1zVXRHMUdZUFBjOXJoSm90NC1Wdzkk
DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3Byb3RlY3QyLmZpcmVleWUu
Y29tL3YxL3VybD9rPTRmDQo+IDlkOGFlNC0yZTE2OWZkZS00ZjljMDFhYi03NGZlNDg2MDAwOGEt
DQo+IGI1Y2Q0ODZmNDNlZDA0N2QmcT0xJmU9MDcxNDAwNDYtOGI5OS00ODVhLWE2Y2YtDQo+IDBj
MTY4NTcwN2E2NyZ1PWh0dHBzKjNBKjJGKjJGZ2l0aHViLmNvbSoyRk9wZW5NUERLKjJGeE5WTWUN
Cj4gX187SlNVbEpTVSEhRXdWenFHb1RLQnF2LQ0KPiAwRFdBSkJtIUNoa1VBZzhWNEZHZExBZ3c1
NE1VREQ4UFJwVm1vMVJCZVJlWnBmTUt4V3o4YQ0KPiBETXNVdEcxR1lQUGM5cmhKcVhHUTg3TCQN
Cj4gDQo+IENvLUF1dGhvcmVkLUJ5OiBBbmtpdCBLdW1hciA8YW5raXQua3VtYXJAc2Ftc3VuZy5j
b20+DQo+IENvLUF1dGhvcmVkLUJ5OiBTaW1vbiBBLiBGLiBMdW5kIDxzaW1vbi5sdW5kQHNhbXN1
bmcuY29tPg0KPiBDby1BdXRob3JlZC1CeTogTWFkcyBZbmRkYWwgPG0ueW5kZGFsQHNhbXN1bmcu
Y29tPg0KPiBDby1BdXRob3JlZC1CeTogTWljaGFlbCBCYW5nIDxtaS5iYW5nQHNhbXN1bmcuY29t
Pg0KPiBDby1BdXRob3JlZC1CeTogS2FybCBCb25kZSBUb3JwIDxrLnRvcnBAc2Ftc3VuZy5jb20+
DQo+IENvLUF1dGhvcmVkLUJ5OiBHdXJtZWV0IFNpbmdoIDxndXIuc2luZ2hAc2Ftc3VuZy5jb20+
DQo+IENvLUF1dGhvcmVkLUJ5OiBQaWVycmUgTGFiYXQgPHBsYWJhdEBtaWNyb24uY29tPg0KPiAt
LS0NCg0KPHNuaXA+DQoNCkRvIHdlIG5lZWQgYW4gU1BEWCBsaWNlbnNlIGlkZW50aWZpZXIgYXQg
dGhlIHRvcCBvZiB4bnZtZS5jPw0KDQo+ICsrKyBiL2VuZ2luZXMveG52bWUuYw0KPiBAQCAtMCww
ICsxLDEwMDAgQEANCj4gKy8qDQo+ICsgKiBmaW8geE5WTWUgSU8gRW5naW5lDQo+ICsgKg0KPiAr
ICogSU8gZW5naW5lIHVzaW5nIHRoZSB4TlZNZSBDIEFQSS4NCj4gKyAqDQoNCjxzbmlwPg0KDQo+
ICtzdGF0aWMgdm9pZCB4bnZtZV9maW9lX2NsZWFudXAoc3RydWN0IHRocmVhZF9kYXRhICp0ZCkN
Cj4gK3sNCj4gKwlzdHJ1Y3QgeG52bWVfZmlvZV9kYXRhICp4ZCA9IHRkLT5pb19vcHNfZGF0YTsN
Cj4gKwlpbnQgZXJyOw0KPiArDQo+ICsJZXJyID0gcHRocmVhZF9tdXRleF9sb2NrKCZnX3Nlcmlh
bGl6ZSk7DQo+ICsJaWYgKGVycikNCj4gKwkJWE5WTUVfREVCVUcoIkZBSUxFRDogcHRocmVhZF9t
dXRleF9sb2NrKCksDQo+IGVycjogJWQiLCBlcnIpOw0KPiArCQkvKiBOT1RFOiBub3QgcmV0dXJu
aW5nIGhlcmUgKi8NCj4gKw0KPiArCWZvciAodWludDY0X3QgaSA9IDA7IGkgPCB4ZC0+bmFsbG9j
YXRlZDsgKytpKSB7DQo+ICsJCWludCBlcnI7DQo+ICsNCj4gKwkJZXJyID0gX2Rldl9jbG9zZSh0
ZCwgJnhkLT5maWxlc1tpXSk7DQo+ICsJCWlmIChlcnIpDQo+ICsJCQlYTlZNRV9ERUJVRygieG52
bWVfZmlvZTogY2xlYW51cCgpOg0KPiBVbmV4cGVjdGVkIGVycm9yIik7DQo+ICsJfQ0KPiArCWVy
ciA9IHB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZnX3NlcmlhbGl6ZSk7DQo+ICsJaWYgKGVycikNCj4g
KwkJWE5WTUVfREVCVUcoIkZBSUxFRDogcHRocmVhZF9tdXRleF91bmxvY2soKSwNCj4gZXJyOiAl
ZCIsIGVycik7DQo+ICsNCj4gKwlmcmVlKHhkLT5pb2NxKTsNCj4gKwlmcmVlKHhkLT5pb3ZlYyk7
DQo+ICsJZnJlZSh4ZCk7DQo+ICsJdGQtPmlvX29wc19kYXRhID0gTlVMTDsNCj4gK30NCg0KSWYg
d2UgZmFpbCB0byBhY3F1aXJlIHRoZSBsb2NrIGFib3ZlIHdlIHNob3VsZCBub3QgdHJ5IHRvIHVu
bG9jayBpdC4gQWxzbywgd2UNCmRlY2xhcmUgZXJyIGEgc2Vjb25kIHRpbWUgaW5zaWRlIHRoZSBm
b3IgbG9vcC4NCg0KV2l0aCB0aGUgbWlub3IgaXNzdWVzIGFkZHJlc3NlZDoNCg0KUmV2aWV3ZWQt
Ynk6IFZpbmNlbnQgRnUgPHZpbmNlbnQuZnVAc2Ftc3VuZy5jb20+DQo=
