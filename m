Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D3FC433F5
	for <fio@archiver.kernel.org>; Wed,  2 Mar 2022 18:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbiCBSVL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Mar 2022 13:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiCBSVK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Mar 2022 13:21:10 -0500
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D12F2D1DE
        for <fio@vger.kernel.org>; Wed,  2 Mar 2022 10:20:25 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220302182023usoutp01974ac0fe31b850ed8e5e740297da6658~Yo08TJS131431814318usoutp01K;
        Wed,  2 Mar 2022 18:20:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220302182023usoutp01974ac0fe31b850ed8e5e740297da6658~Yo08TJS131431814318usoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646245223;
        bh=J/lplgJv7zDIVYrR3sNObvgwlq3xRHxupkS/ARZ25TI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nJ+yNfV4JZQeNR2QWN3COzLpeerM/SSGATwbdtSF4Y570evinET/8F0p6pDQKuqsq
         hXr3V12nvyqaAJNVEJitMt9RZ9C2qPD9XThq1ifu9ZHQsJ7CnUT1nCpKEwhkWDUvda
         qXz06lSQBQ2AyBUVaN3zRihbUVJQWQ0vXfXFpd0M=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220302182023uscas1p1183300bf865a6c3851a4a077691f79a3~Yo08I630j2311923119uscas1p16;
        Wed,  2 Mar 2022 18:20:23 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 9A.84.09744.765BF126; Wed, 
        2 Mar 2022 13:20:23 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220302182023uscas1p20a73a801e4aae03bb6d1cac56ac6eaf5~Yo074KPOM1370813708uscas1p2c;
        Wed,  2 Mar 2022 18:20:23 +0000 (GMT)
X-AuditID: cbfec36d-879ff70000002610-0b-621fb567b4ee
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 7B.B7.09657.765BF126; Wed, 
        2 Mar 2022 13:20:23 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Wed, 2 Mar 2022 10:19:20 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Wed, 2 Mar 2022 10:19:20 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Not logging zero entry intervals when using --log_avg_msec
 seems problematic
Thread-Topic: Not logging zero entry intervals when using --log_avg_msec
        seems problematic
Thread-Index: AQHYKbojhU82Q8on2ESRbYxrCIopbaysavDg
Date:   Wed, 2 Mar 2022 18:19:19 +0000
Message-ID: <dd8cee13d295483e9be4e1a375823a3a@samsung.com>
In-Reply-To: <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWy7djX87rpW+WTDO6sUrH4OOsFs8W8nb/Z
        HZg8zm9U9Pi8SS6AKYrLJiU1J7MstUjfLoErY9LcVcwFfTIV3z5cZW9g3CDdxcjJISFgIvHu
        9SH2LkYuDiGBlYwSzTsnQTmtTBLLj95lhKnqn7mSuYuRAyixllFiUhlIWEjgA6PE2+OJEPX7
        GSUOL38GVsMmoCnxdn8BSI2IQLjE1zn7mUBsYYFoiXX7e5kh4jESWx49Z4GwjSQOvP3NBmKz
        CKhI/DrzkhFkDK+AlcT7ifYgYU6BQIkpP76BtTIKiEl8P7UGbCSzgLjErSfzmSCuFJRYNHsP
        M4QtJvFv10M2CFtR4v73l+wgI5mBLlu/Sx+iVVFiSvdDdhCbF6j15MwnLBDlkhIHV9xgAflK
        QqCRQ+LWvB5WkF4JAReJBztFIGqkJaavuQxVM5lR4uu2+2wQzmpGiZcLLkGDzVriX+c1doht
        fBJ/fz1ihBjEK9HRJjSBUWkWkhdmIZw3C8l5s5Cct4CRZRWjeGlxcW56arFhXmq5XnFibnFp
        Xrpecn7uJkZgqjj973DuDsYdtz7qHWJk4mA8xCjBwawkwituLZ8kxJuSWFmVWpQfX1Sak1p8
        iFGag0VJnHdZ5oZEIYH0xJLU7NTUgtQimCwTB6dUA1Mwm9x0MdarFgpLH6zVfS/6uEbjXPWj
        GWfPHj2/aGblpITQu2mvE+evPhcTaWpq13OiV/Fg6NailbdEpTIYlhwt8F11s3zhC5ePE+bK
        zWz6kD1579qICVm+KW90tKV+CtYEMYi8NEi5uMTrxv4PX6d/Otl9+UzeNtGlG8PjndfP/Trb
        8YFdofPcGy+jjse8Fa/9vbnX4KeRpZ9d3SajbxxPZ7Ks+rP/uXG1ktzOp5Ji0bYNbSq1s5c/
        zvr5YSuT2KwX7dnfwwyLoyc0Hu3PmvLRlJFbgXHfwR/VO6QEOYV8iy58WrAq79WNn3wJDlOV
        Whg6aie1aRkuaD5fPOV93+npMmH59UtOnY+O5Hn8TVRJiaU4I9FQi7moOBEAtfMT4oQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWS2cA0STd9q3ySwf8mfouPs14wW8zb+Zvd
        gcnj/EZFj8+b5AKYorhsUlJzMstSi/TtErgyJs1dxVzQJ1Px7cNV9gbGDdJdjJwcEgImEv0z
        VzJ3MXJxCAmsZpR4OPcxI4TzgVHizumPjCBVQgL7GSVuTwnuYuTgYBPQlHi7vwAkLCIQLvF1
        zn4mEFtYIFpi8rPJrBDxGIkTa+ZD2UYSB97+ZgOxWQRUJH6deckIMoZXwEri/UR7iFVLGCVO
        Pn8CtopTIFBiyo9vzCA2o4CYxPdTa8DmMwuIS9x6Mp8J4mgBiSV7zjND2KISLx//Y4WwFSXu
        f3/JDjKfGejM9bv0IVoVJaZ0P2QHsXkFBCVOznzCAlEuKXFwxQ2WCYxis5BsmIXQPQtJ9ywk
        3QsYWVYxipcWF+emVxQb56WW6xUn5haX5qXrJefnbmIExs7pf4djdjDeu/VR7xAjEwfjIUYJ
        DmYlEV5xa/kkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwesRPjhQTSE0tSs1NTC1KLYLJMHJxS
        DUyGM7dP+bBo67o69sn1d5wnyMw/3D5NWetq7k61Sw/VTESVU1c5zRXu/NF3SnZjWMPVZesO
        mzGeMdW6dPHakgscMxQP7e6vfcnl8i+nQfT6Nqf1gb/229tbWcy/9TJ1Gi//cZH0oqRrqtMV
        /nRXFsTs+fLr2YYMr5NMa7MZpL+a+vL86Yh4xZ4qsX92xcLpKpq66ULbeLMtel7nnXrJ+af/
        2ba107QcKlSjtx7Izk9Ytm+5S4V8lYDG9UmJSnsE/3tYd6q3icd2N6st5EiNizUsMXSt3+py
        LS+lvJI33E6mStdS+IBHt/37/d9emJ7udeiwPLo4WTiu3f3344vvtnZ0lf7LKzF58vi6wl0T
        SyWW4oxEQy3mouJEAEj6s7IMAwAA
X-CMS-MailID: 20220302182023uscas1p20a73a801e4aae03bb6d1cac56ac6eaf5
CMS-TYPE: 301P
X-CMS-RootMailID: 20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44
References: <CGME20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44@uscas1p1.samsung.com>
        <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAyNCwg
MjAyMiAzOjA3IFBNDQo+IFRvOiBmaW9Admdlci5rZXJuZWwub3JnDQo+IENjOiBheGJvZUBrZXJu
ZWwuZGsNCj4gU3ViamVjdDogTm90IGxvZ2dpbmcgemVybyBlbnRyeSBpbnRlcnZhbHMgd2hlbiB1
c2luZyAtLWxvZ19hdmdfbXNlYyBzZWVtcw0KPiBwcm9ibGVtYXRpYw0KPiANCj4gSSB3YXMgZGln
Z2luZyBpbnRvIHRoZSBiYW5kd2lkdGgvaW9wcyBsb2dnaW5nIGNvZGUgaW4gc3RhdC5jIGFmdGVy
IHRoaW5raW5nDQo+IGFib3V0IGhvdyB0byBjb21wdXRlIGFuIGF2ZXJhZ2UgYmFuZHdpZHRoL2lv
cHMgb3ZlciBhIHBlcmlvZCBvZiB0aW1lDQo+IGdpdmVuIGludGVydmFsIGxvZyBlbnRyaWVzLg0K
PiANCj4gSSBub3RpY2VkIHNvbWV0aGluZyBjb25jZXJuaW5nLiBXaGVuIHRoZXJlIGlzIGFuIGlu
dGVydmFsIHdoZXJlIG5vdGhpbmcNCj4gaGFwcGVuZWQgKGUuZy4gbm8gcmVhZCBpb3BzKSwgbm90
aGluZyBpcyBsb2dnZWQgYnV0IHRoZSB0aW1lIG9mIGxhc3QgaW50ZXJ2YWwgaXMNCj4gYWR2YW5j
ZWQgKHRoZXJlIGlzIG9ubHkgb25lIHN1Y2ggdGltZSBmb3IgZWFjaCBsb2csIHNoYXJlZCBieSBh
bGwgZGlyZWN0aW9ucykuDQo+IA0KPiBUaGlzIG1ha2VzIHNlbnNlIGZvciBhIGNhc2Ugd2hlbiB5
b3UgYXJlIG9ubHkgZG9pbmcgcmVhZHMgYW5kIGRvbid0IHdhbnQNCj4gd3JpdGUgZW50cmllcyBp
biB5b3VyIGxvZy4gQnV0IGl0IG1lYW5zIHRoYXQgbG9va2luZyBhdCBhIGxvZyBmaWxlIGNhbiBi
ZSBwcmV0dHkNCj4gbWlzbGVhZGluZy4gSWYgeW91IGFyZSBsb2dnaW5nIHdpdGggYW4gaW50ZXJ2
YWwgb2YgMTAwbXMgYnV0IG9ubHkgb25lIHJlYWQgaXMNCj4gb2NjdXJyaW5nIHBlciBzZWNvbmQs
IHlvdSBnZXQgYSBsb2cgZm9yIGlvcHMgbGlrZSB0aGlzOg0KPiANCj4gMTQ5LCA2LCAwLCAwLCAw
DQo+IDEwNTYsIDEwLCAwLCAwLCAwDQo+IDIwNjQsIDksIDAsIDAsIDANCj4gMzA3MiwgMTAsIDAs
IDAsIDANCj4gNDA4MSwgMTAsIDAsIDAsIDANCj4gDQo+IElmIHlvdSB0dXJuIHRoZSBpbnRlcnZh
bCB1cCB0byBldmVyeSAxMCBtcywgeW91IGdldCB0aGlzOg0KPiAxNDksIDYsIDAsIDAsIDANCj4g
MTAxMSwgMTAwLCAwLCAwLCAwDQo+IDIwMTEsIDEwMCwgMCwgMCwgMA0KPiAzMDExLCAxMDAsIDAs
IDAsIDANCj4gNDAxMSwgMTAwLCAwLCAwLCAwDQo+IA0KPiBUaG9zZSB6ZXJvIGVudHJpZXMgYXJl
IGFjdHVhbGx5IHJlYWxseSBpbXBvcnRhbnQgaW4gYSBjYXNlIGxpa2UgdGhpcy4NCj4gVGhvc2Ug
bG9ncyBkbyBub3QgbG9vayBsaWtlIGxvZ3MgZm9yIGEgam9iIHRoYXQgZGlkIDEgcmVhZCBwZXIg
c2Vjb25kLg0KPiBUaGlzIGlzIGFuIGV4dHJlbWUgZXhhbXBsZSB0byBzaG93IHRoZSBwcm9ibGVt
LCBhbmQgb2YgY291cnNlIHdlIGtub3cNCj4gd2hhdCdzIGdvaW5nIG9uIGhlcmUuDQo+IA0KPiBC
dXQgd2hhdCBpZiB5b3UncmUgZG9pbmcgYSBwcmFjdGljYWwgdGVzdCBvbiBzdG9yYWdlIHdpdGgg
YSBmYWlybHkgc21hbGwgbG9nDQo+IGludGVydmFsLCBhbmQgdGhlIHN0b3JhZ2UgaGljY3VwcyBh
bmQgcHJvY2Vzc2VzIG5vIG9wZXJhdGlvbnMgaW4gYW4gaW50ZXJ2YWw/DQo+IEl0IGNhbiBiZSBp
bXBvc3NpYmxlIHRvIGtub3cgaWYgYW4gYXBwYXJlbnQgImdhcCIgaW4gYSBsb2cgZmlsZSBpcyBi
ZWNhdXNlIHRoZXJlDQo+IHdhcyBhIHplcm8gZW50cnkgb3IgYSBzeXN0ZW0gaGljY3VwIGNhdXNl
ZCB0aGUgbG9nZ2luZyBwcm9jZXNzIHRvIHJ1biBhIGxpdHRsZQ0KPiBsYXRlLg0KPiANCj4gQW55
IHRob3VnaHRzPyBKdXN0IGxvZ2dpbmcgdGhlIHplcm8gZW50cmllcyB3b3VsZCB3b3JrLCBidXQg
YXQgdGhlIGV4cGVuc2UNCj4gb2Ygbm9pc2UgaW4gbG9ncy4NCj4gDQo+IChPbmUgb3B0aW9uIEkg
Y2FuIHRoaW5rIG9mIGlzIHJlbWVtYmVyaW5nLCBwZXIgZGlyZWN0aW9uLCB0aGF0IHRoZSBsYXN0
IGludGVydmFsDQo+IHdhcyBhIHplcm8tZW50cnkgb25lLCBhbmQgdGhlbiB3cml0aW5nIHRoYXQg
aWYgYSBub24temVybyBpbnRlcnZhbCBpcyBsYXRlcg0KPiBlbmNvdW50ZXJlZC4gQWxzbyB0aGUg
bGFzdCBlbnRyeSBwZXIgZGlyZWN0aW9uIG11c3QgYWx3YXlzIGJlIHdyaXR0ZW4sIGlmIGFueQ0K
PiBub24temVybyBpbnRlcnZhbCBmb3IgdGhhdCBkaXJlY3Rpb24gd2FzIGV2ZXIgd3JpdHRlbi4p
DQo+IA0KPiBUaGFua3MsDQo+IE5pY2sNCg0Kc3RhdC5jOl9fYWRkX3NhbXBsZXMoKSBpcyB3aGVy
ZSBsb2cgZW50cmllcyBhcmUgYWRkZWQuIEl0IGNvbnRhaW5zIGEgY29udGludWUgc3RhdGVtZW50
IHdoaWNoIHNraXBzIGVudHJpZXMgZHVyaW5nIGxvZyBpbnRlcnZhbHMgd2l0aCBubyBJTy4gSSB3
b3VsZCBzdGFydCBwb2tpbmcgYXJvdW5kIHRoZXJlIGlmIHlvdSB3YW50IGxvZyBlbnRyaWVzIGZv
ciB0aG9zZSBpbnRlcnZhbHMuIFBlcmhhcHMgbWFrZSB0aGUgbmV3IGJlaGF2aW9yIGFuIG9wdGlv
biBmb3IgdGhvc2UgdGhhdCBkZXBlbmQgb24gdGhlIGN1cnJlbnQgYmVoYXZpb3IuDQoNClZpbmNl
bnQNCg==
