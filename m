Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2D3C433F5
	for <fio@archiver.kernel.org>; Thu, 10 Feb 2022 22:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbiBJW66 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Feb 2022 17:58:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbiBJW65 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Feb 2022 17:58:57 -0500
X-Greylist: delayed 334 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 14:58:57 PST
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E511105
        for <fio@vger.kernel.org>; Thu, 10 Feb 2022 14:58:57 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220210225316usoutp01ce6b8575f4d684571d1e8ab4946577ee~Sjpe6_B-61892218922usoutp01O;
        Thu, 10 Feb 2022 22:53:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220210225316usoutp01ce6b8575f4d684571d1e8ab4946577ee~Sjpe6_B-61892218922usoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644533596;
        bh=OPvySZFosMvskQ5Tp1jJiDsUgINJsT1M/pspEfNJUNM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sYHpjxbm17pyYXwbvuCxLpCb+pRO+/xuOTq6vam92HZm6O+KjLg+jZXpi6MVfloYW
         R8Aehgpehh/6kSh+gp754Kjnbd8/i43fCcdf6XtyoTBSW/3tuTyIr/l8kf3upeINUw
         /PQULFh68IOJ2IjuRa3LhxXPqTVB9oPHutz3YqoU=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220210225316uscas1p1435bf7e50519b858b27aa7704e0e9b15~SjpewEK6e1104211042uscas1p1B;
        Thu, 10 Feb 2022 22:53:15 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id BB.8B.10104.A5795026; Thu,
        10 Feb 2022 17:53:14 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220210225315uscas1p27882c964cb82a5afe2ce474ef7b73e57~SjpeRxm7t0388803888uscas1p2n;
        Thu, 10 Feb 2022 22:53:15 +0000 (GMT)
X-AuditID: cbfec36f-2fdff70000002778-89-6205975a2033
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 6D.3F.10042.1C795026; Thu,
        10 Feb 2022 17:54:57 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Thu, 10 Feb 2022 14:52:29 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Thu, 10 Feb 2022 14:52:29 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Odd (wrong?) behavior with :<nr> suffix on readwrite parameter
Thread-Topic: Odd (wrong?) behavior with :<nr> suffix on readwrite parameter
Thread-Index: AQHYHIgUCC64+qZ+JEe6MJ6DrT/qpqyNZlmQ
Date:   Thu, 10 Feb 2022 22:52:29 +0000
Message-ID: <65c1d4d55d0a41c1934d46b2c09dd9a6@samsung.com>
In-Reply-To: <CADqNVTrbc+gtK1PuLLZqaGTTeppXckTP-TFPaRT__iF63+f3Kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87pR01mTDHpXWlp8nPWC2WLezt/s
        Dkwe5zcqenzeJBfAFMVlk5Kak1mWWqRvl8CVseXmDpaCDRIVU2dsYWlgfCDexcjJISFgIjHv
        /XPmLkYuDiGBlYwSp3a/YYNwWpkknqz6y9LFyAFWdW+6EUR8LaPEo74zrBDOR0aJ9deus0A4
        Bxglmo+3MoN0sAloSrzdXwCyQkQgXOLrnP1MILawgLfE6bXN7BBxH4kdu9dB2UYSq5atZQWx
        WQRUJb7+aAOzeQWsJO7MvskGYnMKBEq83r4UzGYUEJP4fmoN2ExmAXGJW0/mM0G8IyixaPYe
        ZghbTOLfrodsELaixP3vL9khbBGJdd/fsoGcyQx05vpd+hBjFCWmdD9kh1grKHFy5hMWiHJJ
        iYMrbkDZvRwSB3t8IWwXidMbd0GNl5b4e3cZEygYJAQmM0p83XafDcJZzSjxcsElRogqa4mF
        f9ZDHc0n8ffXI8YJjMqzkPwwC+GmWUhumoXkpgWMLKsYxUuLi3PTU4uN8lLL9YoTc4tL89L1
        kvNzNzECU8bpf4fzdzBev/VR7xAjEwfjIUYJDmYlEd5T9cxJQrwpiZVVqUX58UWlOanFhxil
        OViUxHmXZW5IFBJITyxJzU5NLUgtgskycXBKNTBZ3GsouCg1Y9nTiGCpiYnbD//MCFv2qrFp
        ySmv+TqRgdeq8r5HdNw/+c5n9ZKTfTwLJ3R0annmeL6N+j5FoVgidClv59a/bd8e2p2Rvdi3
        UiKP923qAZ9twkccFzywzoz++HO2Wt1tX5H357s/pCze/+A698T5Rl43y27uUjjaylnV8v+x
        sYbi74j2nZV+Fg+eP2kQ0shbs9epagbjH5VOifyJiovmaa3QNUvhfXp00l6NTw6rJgi+XmGh
        326RmvR1/5czZ8qPNRyvttqqYvdyHuOB9y1nS15f39bg8FHQZ7KobXV4fA539re5j75KnnC+
        0ZLnx5Pz55MZR3DEXwa99yvOOh6UE6s6dXFf39luJZbijERDLeai4kQAJH0LqIgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCapHtwOmuSwaU9uhYfZ71gtpi38ze7
        A5PH+Y2KHp83yQUwRXHZpKTmZJalFunbJXBlbLm5g6Vgg0TF1BlbWBoYH4h3MXJwSAiYSNyb
        btTFyMUhJLCaUWLz+6/sEM5HRokPR76yQDgHGCXWTF/JDtLBJqAp8XZ/QRcjJ4eIQLjE1zn7
        mUBsYQFvidNrm9kh4j4SO3avg7KNJFYtW8sKYrMIqEp8/dEGZvMKWEncmX2TDWL+EkaJz533
        wBo4BQIlXm9fygZiMwqISXw/tQZsAbOAuMStJ/PBbAkBAYkle84zQ9iiEi8f/2OFsBUl7n9/
        yQ5hi0is+/6WDeRmZqCb1+/ShxijKDGl+yE7xA2CEidnPmGBKJeUOLjiBssERvFZSLbNQuie
        haR7FpLuBYwsqxjFS4uLc9Mrio3yUsv1ihNzi0vz0vWS83M3MQKj6vS/w9E7GG/f+qh3iJGJ
        g/EQowQHs5II76l65iQh3pTEyqrUovz4otKc1OJDjNIcLErivC+jJsYLCaQnlqRmp6YWpBbB
        ZJk4OKUamEw3OVg9qLqSYOw0cdWbw0Hc6576qbiEptsUTQoJZLCtm7tfIPHw7uesX4+crJD/
        kD7liMC/698kY696Hsm+Pyd+SfeMnazrH+4KucTlycZ+7rP8zYtui7SWvFixrbRuF59V+i8x
        E4bns+QltQx+bbm4QmYX+z27hMyMJ+/kHjetXfAx+aZiyrY4nz/GqwqXBb9L3//jo4rUlNUe
        9xmb58UbtF/imrH4lZxo63VfLfPiv0fSe46w2TidiLqYv/+tQLr/i417m2d//9Rz5rJTRZNA
        zvwNvrYLfi3xTS9ylTPc9tRkyrRzc3K3bps9nW3X9I/mGopXbObP+fP5HtO1zKqCY8eX+eou
        WJL2IOPk/R4ZJZbijERDLeai4kQAMtJn6xkDAAA=
X-CMS-MailID: 20220210225315uscas1p27882c964cb82a5afe2ce474ef7b73e57
CMS-TYPE: 301P
X-CMS-RootMailID: 20220208010644uscas1p132e264f9a90c2e515846440393203738
References: <CGME20220208010644uscas1p132e264f9a90c2e515846440393203738@uscas1p1.samsung.com>
        <CADqNVTrbc+gtK1PuLLZqaGTTeppXckTP-TFPaRT__iF63+f3Kg@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IE1vbmRheSwgRmVicnVhcnkgNywgMjAy
MiA2OjE1IFBNDQo+IFRvOiBmaW9Admdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IE9kZCAod3Jv
bmc/KSBiZWhhdmlvciB3aXRoIDo8bnI+IHN1ZmZpeCBvbiByZWFkd3JpdGUgcGFyYW1ldGVyDQo+
IA0KPiBJIHdhcyBwbGF5aW5nIHdpdGggdGhpcyBmZWF0dXJlIHRvZGF5LiBJdCBzZWVtcyBsaWtl
IGEgbmljZSBmZWF0dXJlIGFzIGl0IHdpbGwNCj4gYWxsb3cgeW91IHRvIHNpbXVsYXRlIGEgcmVh
ZCBvciB3cml0ZSBvZiBhIHNvbWV3aGF0IGZyYWdtZW50ZWQgZmlsZS4gRnJvbQ0KPiB0aGUgZG9j
cywgSSBjYW4gZG8gc29tZXRoaW5nIGxpa2UNCj4gLS1ydz1yYW5kcmVhZDo4DQo+IGFuZCBleHBl
Y3QgZmlvIHdpbGwgZG8gOCBJL09zICJiZWZvcmUgZ2V0dGluZyBhIG5ldyBvZmZzZXQiLiBTbyB3
aGVuIGZpbyBkb2VzDQo+IGl0cyByZWFkcywgdGhleSB3aWxsIG9jY3VyIGF0IG9mZnNldDEsIG9m
ZnNldDErYmxvY2tfc2l6ZSwNCj4gb2Zmc2V0MStibG9ja19zaXplKjIsIC4uLiBvZmZzZXQxK2Js
b2NrX3NpemUqNywgYW5kIHRoZW4gYXQgYSBuZXcNCj4gcmFuZG9tIG9mZnNldDIsIGZvbGxvd2Vk
IGJ5IG9mZnNldDIrYmxvY2tfc2l6ZSwgb2Zmc2V0MitibG9ja19zaXplKjIsIGV0Yy4uLg0KPiAN
Cj4gV2hhdCBJJ20gc2VlaW5nIHdpdGggdGhpcyBmZWF0dXJlIHRob3VnaCBpcyB0aGF0IHVzaW5n
IGl0IGNhdXNlcyB0aGUgZmlyc3Qgb2Zmc2V0DQo+IGNob3NlbiB0byBhbHdheXMgYmUgMCwgYW5k
IGl0IGlzIHVzZWQgKHBsdXMgbXVsdGlwbGVzIG9mIGJsb2NrIHNpemUpIGZvciB0aGUgZmlyc3QN
Cj4gNyAobnItMSkgSS9Pcy4gRm9yIGV4YW1wbGUsIHdpdGggdGhpcw0KPiBjb21tYW5kOg0KPiAN
Cj4gc3VkbyBmaW8gLS1pb2VuZ2luZT1saWJhaW8gLS1kaXJlY3Q9MSAtLW91dHB1dC1mb3JtYXQ9
anNvbisgLS1uYW1lPWpvYg0KPiAtLWZpbGVuYW1lPS9kZXYvbnZtZTFuMSAtLXNpemU9MTI4TUIg
LS1ydz1yYW5kcmVhZDo4IC0taW9kZXB0aD0xIC0tDQo+IGJzPTRLIC0td3JpdGVfYndfbG9nPWZp
b18wIC0tbG9nX29mZnNldD0xDQo+IA0KPiBUaGUgYmFuZHdpZHRoIGxvZyBlbnRyaWVzIGFyZSAo
ZmlmdGggY29sdW1uIGlzIHRoZSBvZmZzZXQpOg0KPiANCj4gMTQsIDI4OCwgMCwgNDA5NiwgMCwg
MA0KPiAxNCwgMzYxNDEsIDAsIDQwOTYsIDQwOTYsIDANCj4gMTQsIDM0NzE1LCAwLCA0MDk2LCA4
MTkyLCAwDQo+IDE0LCAzNDQwNiwgMCwgNDA5NiwgMTIyODgsIDANCj4gMTQsIDM0NzAwLCAwLCA0
MDk2LCAxNjM4NCwgMA0KPiAxNCwgMjc3NjYsIDAsIDQwOTYsIDIwNDgwLCAwDQo+IDE1LCAzNDYz
MywgMCwgNDA5NiwgMjQ1NzYsIDANCj4gMTUsIDIwMjMzLCAwLCA0MDk2LCA4MDkzNjk2LCAwDQo+
IDE1LCAzOTQwOSwgMCwgNDA5NiwgODA5Nzc5MiwgMA0KPiANCj4gVGhpcyBzZWVtcyBvZGQsIGFu
ZCBraW5kYSB3cm9uZyAtIHRoZSBmaXJzdCBuci0xIG9wcyBkbyBub3QgaGFwcGVuIGZyb20gYQ0K
PiByYW5kb20gb2Zmc2V0IGFzIHNwZWNpZmllZCBieSB0aGUgcmFuZHJlYWQvcmFuZHdyaXRlIHZh
bHVlLCBidXQgaW5zdGVhZA0KPiBmcm9tIG9mZnNldCAwLiBXaGVuIG9uZSBkb2VzIGEgcmFuZG9t
IEkvTyBvcGVyYXRpb24gd2l0aG91dCB0aGUgOjxucj4NCj4gc3VmZml4LCB0aGUgZmlyc3Qgb3Bl
cmF0aW9uIGlzIGZyb20gYSByYW5kb20gb2Zmc2V0LCBub3QgMC4NCj4gDQo+IEknbSBoYXBweSB0
byBmaW5kIGFuZCBmaXggdGhlIGJlaGF2aW9yLCBidXQgd2FudGVkIHRvIGZpcnN0IG1ha2Ugc3Vy
ZSBpdCBpc24ndA0KPiBpbnRlbnRpb25hbCBvciB0aGF0IEknbSBzb21laG93IG1pc3VuZGVyc3Rh
bmRpbmcgaXQuDQoNCkkgdHJpZWQgcnVubmluZyB3aXRoIHJhbmRyZXBlYXQ9MCBhbmQgc2F3IHRo
ZSBzYW1lIGJlaGF2aW9yIHlvdSBkaWQuIFdpdGggdGhlIGRlZmF1bHQgcmFuZHJlcGVhdD0xIGZp
byB3aWxsIGFsd2F5cyB1c2UgdGhlIHNhbWUgcmFuZG9tIG51bWJlciBzZWVkIGZvciBJTyBvZmZz
ZXRzLCBidXQgZXZlbiB3aXRoIHJhbmRyZXBlYXQ9MCwgcnc9cmFuZHJlYWQ6OCBhbHdheXMgc3Rh
cnRlZCBhdCBvZmZzZXQgMC4NCg0KSSBhZ3JlZSB3aXRoIHlvdXIgYXNzZXNzbWVudCB0aGF0IHJ3
PXJhbmRyZWFkOjggc2hvdWxkIHN0YXJ0IGF0IGEgcmFuZG9tIG9mZnNldC4NCg0KVmluY2VudA0K
