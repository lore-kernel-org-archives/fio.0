Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB724C433EF
	for <fio@archiver.kernel.org>; Wed, 15 Jun 2022 17:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbiFORHD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240589AbiFORHD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jun 2022 13:07:03 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201374FC70
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 10:07:01 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220615170657usoutp0186f78978dc8ab5bc68b7ee957a12c5c6~42jy_KayT1068010680usoutp015;
        Wed, 15 Jun 2022 17:06:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220615170657usoutp0186f78978dc8ab5bc68b7ee957a12c5c6~42jy_KayT1068010680usoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655312817;
        bh=T01gwFNuPNSdFrB8LDI6dt1AQtNFqJ74z0qH8wqNIDc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=pcbbGepal0T4th4Cl60cSzvCUWByc+tDrUNHjeyS/0Ocks0rUTsJGNrJq6puv75m+
         El1icYoYTd3U/5IHxNzWnCnQJ6HApa5eKp3LUpahOUgAaM/mPp9SZ12OqobhT9E+14
         rbQ0Z1+W7xyXUqkqw3CSzws8k8TcS+KfSjmfycEI=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220615170657uscas1p231dfa791ba5173eb94d09785770c3161~42jyvpI2B2410024100uscas1p2I;
        Wed, 15 Jun 2022 17:06:57 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 94.98.09749.1B11AA26; Wed,
        15 Jun 2022 13:06:57 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220615170656uscas1p1b0f110cc9c06b2315bf3cbbacb44ac91~42jyNtZlJ1342313423uscas1p1V;
        Wed, 15 Jun 2022 17:06:56 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-32-62aa11b1745f
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id C1.80.52945.0B11AA26; Wed,
        15 Jun 2022 13:06:56 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Wed, 15 Jun 2022 10:06:55 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Wed,
        15 Jun 2022 10:06:55 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 2/5] ioengines: don't record issue_time if ioengines
 already do it
Thread-Topic: [PATCH 2/5] ioengines: don't record issue_time if ioengines
        already do it
Thread-Index: AQHYgAeXX1Hbmdfg3ESlLF8U0k4Wha1RDfEA//+RR2A=
Date:   Wed, 15 Jun 2022 17:06:55 +0000
Message-ID: <fbe6eea8b6134e92b52a78af25a1fc94@samsung.com>
In-Reply-To: <CADqNVTpODU3u5siLtvDT8jCBGUZtprMSVi2eqaM9VRbWJ_DuCw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsWy7djX87obBVclGdw4yGmx+m4/m8XHWS+Y
        Lebt/M3uwOxx+Wypx/mNih6fN8kFMEdx2aSk5mSWpRbp2yVwZVzZ9pat4IVCxcnm5SwNjH/k
        uxg5OCQETCQ+TFbtYuTiEBJYySjxcPk9FginlUnizt5XjF2MnGBFs5b0M4HYQgJrGSU6XzJB
        FH1ilNh38zuUs4xR4s6dJawgY9kENCXe7i8AMUUENCS+/eYD6WUWCJM4NeMfK4gtLBAhcWrz
        DVaIkkiJo8cDQMIiAlYS66b0gK1lEVCV6PnwmR3E5gWKT197DczmFAiUWHfzGguIzSggJvH9
        1BomiPHiEreezGeCOFlQYtHsPcwQtpjEv10P2SBsRYn731+yg6xlBjpy/S59iFZFiSndD6FW
        CUqcnPmEBaJcUuLgihvgIJEQmMoh8ezPD2iQuEgc+z8bape0xPQ1l6GK2hkl5m78AtU9gVHi
        +hMpCNta4l8nxAPMAnwSf389YpzAqDwLyd2zEG6aheSmWUhuWsDIsopRvLS4ODc9tdg4L7Vc
        rzgxt7g0L10vOT93EyMwfZz+d7hgB+OtWx/1DjEycTAeYpTgYFYS4TULXpkkxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnHdZ5oZEIYH0xJLU7NTUgtQimCwTB6dUA5M4W9J+6Zm721Ku61ecPNE6
        5Wys4+4nbtoyQj6iF5TYr7tYhS33XviRLV7Y65bD7JeaJYLr196uOfXlW2Rxnorc5RUbxC4F
        LzdM8/x4tFgxOV4hPNBlS83Pu6Uh04LKvz0te2dspLdJ4qPLisNvv5+Pk7p7zv/B5bk3Nsgd
        d1knIvSKf28Ah/I90wuft6/UspBN2hSWePXZv3TlO4ZsS9crfFl3q4oxVSWuVvyEoY7X0+3O
        mX8NdpdYN+xYdOyNwQXVsoUvdSYr7xW/xHj0v3vJrL61L8ysX1wInzGJ9fUeyQvz6/Y9/5Gj
        myxStOn5uZm25xNbghz38a2+vOSdbsqT1SGbKhXMZ/wuL/G6nKakxFKckWioxVxUnAgABg01
        8Y4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LJbGCapLtBcFWSwbkdihar7/azWXyc9YLZ
        Yt7O3+wOzB6Xz5Z6nN+o6PF5k1wAcxSXTUpqTmZZapG+XQJXxpVtb9kKXihUnGxeztLA+Ee+
        i5GTQ0LARGLWkn6mLkYuDiGB1YwSO9ffY4dwPjFK3Pu1jRHCWcYo8XvZMyCHg4NNQFPi7f4C
        EFNEQEPi228+kEHMAmESp2b8YwWxhQUiJE5tvgFmiwhESsz68I8dwraSWDelhxHEZhFQlej5
        8BkszgsUn772GtTeLiaJfwv/soAkOAUCJdbdvAZmMwqISXw/tYYJYpm4xK0n85kgPhCQWLLn
        PDOELSrx8jHEERICihL3v79kB7mTGejk9bv0IVoVJaZ0P4TaKyhxcuYTFohySYmDK26wTGAU
        n4VkwyyE7llIumch6V7AyLKKUby0uDg3vaLYOC+1XK84Mbe4NC9dLzk/dxMjMM5O/zscs4Px
        3q2PeocYmTgYDzFKcDArifCaBa9MEuJNSaysSi3Kjy8qzUktPsQozcGiJM7rETsxXkggPbEk
        NTs1tSC1CCbLxMEp1cDEeVRo8sOfD+S3rChQVX01mz3AgYvDqqhvdsmcPxJHvA+1aDUvWc+l
        uCFFIpTtuHtNdmD/tNXWQfumz1BbeW+WbONmtx8JbZeCH3RYBpoZ14h1ZCvGOsV8XDZt5ZGS
        x32FO0473utTiZFnTgw4mjWpwHB9ateqaVvkcgRk09juP22Oa0/85br825nJ3z3vJC9p+eQr
        8Pndwzt/T0W4eNWf28t0zYz/6CdpbnOT4LrVH8QlStuMvRlC84+cml5ZcbRg3aO7TxROaX2u
        WufE0HHZpN5mJr/JzbziY3bTTjYurffg6ekveKvwIvFIhzWX/II7V7nzT09u3nj//7fyyypP
        4zhNV6+dvJpV8oi9wwYlluKMREMt5qLiRACu42W0IgMAAA==
X-CMS-MailID: 20220615170656uscas1p1b0f110cc9c06b2315bf3cbbacb44ac91
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9
References: <CGME20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9@uscas1p1.samsung.com>
        <20220614155822.307771-1-vincent.fu@samsung.com>
        <20220614155822.307771-3-vincent.fu@samsung.com>
        <CADqNVTpODU3u5siLtvDT8jCBGUZtprMSVi2eqaM9VRbWJ_DuCw@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxNSwgMjAy
MiAxMToyNyBBTQ0KPiBUbzogVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT4NCj4g
Q2M6IGF4Ym9lQGtlcm5lbC5kazsgZmlvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIDIvNV0gaW9lbmdpbmVzOiBkb24ndCByZWNvcmQgaXNzdWVfdGltZSBpZiBpb2VuZ2lu
ZXMNCj4gYWxyZWFkeSBkbyBpdA0KPiANCj4gT24gVHVlLCBKdW4gMTQsIDIwMjIgYXQgMTA6NTkg
QU0gVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4g
PiBpb191cmluZywgaW9fdXJpbmdfY21kLCBhbmQgbGliYWlvIHJlY29yZCBpc3N1ZV90aW1lIGlu
c2lkZSB0aGUNCj4gaW9lbmdpbmUNCj4gPiBjb2RlIHdoZW4gdGhlaXIgY29tbWl0IGZ1bmN0aW9u
cyBhcmUgY2FsbGVkLiBTbyB3ZSBkb24ndCBuZWVkIHRvDQo+IHJlY29yZA0KPiA+IGlzc3VlX3Rp
bWUgYWdhaW4gZm9yIHRoZXNlIGlvZW5naW5lcyBpbiB0ZF9pb19xdWV1ZS4NCj4gPg0KPiA+IElm
IHdlIGRvIGZpbGwgaXNzdWVfdGltZSB0d2ljZSwgdGhlbiBtZWFuKHNsYXQpICsgbWVhbihjbGF0
KSAhPQ0KPiA+IG1lYW4obGF0KToNCj4gDQo+IEknbSBhIGxpdHRsZSBiaXQgY29uZnVzZWQgdGhv
dWdoIHdoeSBub3QgcmVjb3JkaW5nIGlzc3VlX3RpbWUgYWdhaW4gaW4NCj4gdGRfaW9fcXVldWUg
aXMgY29uc2lkZXJlZCB0aGUgcmlnaHQgZml4LiBCeSBoYXZpbmcgc29tZSBpb2VuZ2luZXMgdGhh
dA0KPiByZWNvcmQgaXNzdWVfdGltZSBpbiB0aGVpciBjb21taXQgZnVuY3Rpb25zLCBhbmQgb3Ro
ZXJzIHRoYXQgZG8gbm90DQo+IChhbmQgdGh1cyBoYXZlIGl0IHJlY29yZGVkIGluIHRkX2lvX3F1
ZXVlKSwgY29tcGFyaW5nIGNsYXQgYmV0d2VlbiB0d28NCj4gZGlmZmVyZW50IGVuZ2luZXMgaXNu
J3QgYW4gYXBwbGVzLXRvLWFwcGxlcyBjb21wYXJpc29uLiBBbiBpb2VuZ2luZQ0KPiB0aGF0IGRv
ZXMgbm90IHJlY29yZCBpc3N1ZV90aW1lIGluIGl0cyBjb21taXQgZ2V0cyBhICJkaXNjb3VudCIg
b2YNCj4gc29ydHMgaW4gaXRzIG1lYXN1cmVkIGNsYXQsIHNpbmNlIGl0cyBpc3N1ZV90aW1lIGlz
IG5vdCByZWNvcmRlZCB1bnRpbA0KPiBsYXRlci4gRG9lcyB0aGF0IG1ha2Ugc2Vuc2UsIG9yIGFt
IEkgbWlzc2luZyBzb21ldGhpbmc/IChIYXMgYmVlbiBhDQo+IGZldyBtb250aHMgc2luY2UgSSd2
ZSBiZWVuIGluIHRoZSBjb2RlIGluIGRldGFpbCwgc28gdGhhdCdzIHBvc3NpYmxlLikNCg0KWW91
IG1ha2UgYSBnb29kIHBvaW50IGFuZCBJJ20gZ2xhZCB5b3UgYnJvdWdodCB0aGlzIHVwIGZvciBk
aXNjdXNzaW9uLg0KDQpXZSBjdXJyZW50bHkgaGF2ZSB0aHJlZSBsYXRlbmN5IHBhdGh3YXlzIGZv
ciBhc3luYyBpb2VuZ2luZXM6DQoNCigxKSBhc3luYyB3L28gY29tbWl0OiByZWNvcmQgaXNzdWVf
dGltZSBpbiB0ZF9pb19xdWV1ZSBhZnRlciBxdWV1ZQ0KKDIpIGFzeW5jIHcvY29tbWl0IHRoYXQg
KmRvZXMgbm90KiByZWNvcmQgaXNzdWVfdGltZTogcmVjb3JkcyBpc3N1ZV90aW1lIGluDQp0ZF9p
b19xdWV1ZSBhZnRlciBxdWV1ZSAoc2xhdCBub3QgcmVwb3J0ZWQpDQooMykgYXN5bmMgdy9jb21t
aXQgdGhhdCAqZG9lcyogcmVjb3JkIGlzc3VlX3RpbWU6IGlzc3VlX3RpbWUgcmVjb3JkZWQgaW4N
CmJvdGggdGRfaW9fcXVldWUgYW5kIGNvbW1pdA0KDQpJIHRoaW5rIHRoZSByaWdodCBsb25nLXRl
cm0gc29sdXRpb24gaXMgdG8gbWFrZSB0aGUgaW9lbmdpbmVzIGluICgyKSBjb25mb3JtIHRvDQoo
MSkgb3IgKDMpLiBUaGVuIHdlIGNhbiBoYXZlIGZhaXIgY29tcGFyaXNvbnMuIEJ1dCB3aGF0ICdx
dWV1ZScgYW5kICdjb21taXQnDQptZWFuIGZvciB0aGVtIGRvZXNuJ3QgY29tcGxldGVseSBtYXRj
aCB3aGF0IHRoZSB0d28gbWVhbiBmb3IgbGliYWlvIGFuZA0KaW9fdXJpbmcuDQoNCkZvciBsaWJh
aW8gYW5kIGlvX3VyaW5nICdxdWV1ZScgcHJlcGFyZXMgYW4gSU8gYW5kICdjb21taXQnIGFjdHVh
bGx5IHNlbmRzIGl0DQp0byB0aGUgT1MuIFNvIGl0J3MgYXBwcm9wcmlhdGUgdG8gcmVjb3JkIGlz
c3VlX3RpbWUgYWZ0ZXIgY29tbWl0LiBCdXQsIGZvcg0KZXhhbXBsZSwgdGFrZSBhIGxvb2sgYXQg
dGhlIG5mcyBpb2VuZ2luZSdzIGNvbW1pdDoNCg0KaHR0cHM6Ly9naXRodWIuY29tL2F4Ym9lL2Zp
by9ibG9iL21hc3Rlci9lbmdpbmVzL25mcy5jI0wyODUNCg0KbmZzIGlzbid0IGRvaW5nIHdoYXQg
bGliYWlvIGFuZCBpb191cmluZyBhcmUgZG9pbmcgd2l0aCBjb21taXQuDQoNClRoZXJlIGFyZSBm
b3VyIGlvZW5naW5lcyB0aGF0IGZhbGwgaW50byBjYXRlZ29yeSAoMik6IGltZV9haW8sIG5mcywg
bnVsbCwgYW5kDQpjcHBfbnVsbC4gSXQgd291bGQgdGFrZSBzb21lIHRpbWUgdG8gdGVzdCB0aGUg
Y2hhbmdlcyBidXQgcHJvYmFibHkgaXQgd291bGQgYmUNCnN0cmFpZ2h0Zm9yd2FyZCB0byBtYWtl
IG5mcyBjb25mb3JtIHRvICgxKSBhbmQge251bGwsIGNwcF9udWxsfSBjb25mb3JtIHRvICgzKQ0K
YnV0IEkgaGF2ZSBubyBpZGVhIGFib3V0IGltZV9haW8uDQoNCkkgdGhpbmsgdGhlIGN1cnJlbnQg
cGF0Y2ggaXMgYW4gaW1wcm92ZW1lbnQgb3ZlciB3aGF0IHdlIGN1cnJlbnRseSBoYXZlLiAgUGx1
cw0KaXQgcmVhbGx5IGJvdGhlcnMgbWUgdGhhdCBtZWFuKHNsYXQpICsgbWVhbihjbGF0KSAhPSBt
ZWFuKGxhdCkgYW5kIHRoaXMNCnJlc29sdmVzIHRoYXQgaXNzdWUuICBJZiBzb21lb25lIGNvbWVz
IGFsb25nIHRvIGZpeCBldmVyeXRoaW5nIHVwIHRoZW4gd2UgY2FuDQpnZXQgcmlkIG9mIEZJT19B
U1lOQ0lPX1NFVFNfSVNTVUVfVElNRSBhbmQgaW5zdGVhZCBvZiB0ZF9pb19xdWV1ZSBjaGVja2lu
ZyBmb3INCnRoYXQgZmxhZyBiZWZvcmUgc2V0dGluZyBpc3N1ZV90aW1lIGl0IGNhbiBpbnN0ZWFk
IGNoZWNrIGZvciB0aGUgcHJlc2VuY2Ugb2YgYQ0KY29tbWl0IGhvb2suDQoNCg==
