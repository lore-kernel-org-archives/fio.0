Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C53C6FA83
	for <fio@archiver.kernel.org>; Sat, 10 Sep 2022 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiIJD4S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Sep 2022 23:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIJD4R (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Sep 2022 23:56:17 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7C1ACA03
        for <fio@vger.kernel.org>; Fri,  9 Sep 2022 20:56:10 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220910035606usoutp0213f088987828291a20e9441277a8bd54~TY5Io7yNC1407914079usoutp02g;
        Sat, 10 Sep 2022 03:56:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220910035606usoutp0213f088987828291a20e9441277a8bd54~TY5Io7yNC1407914079usoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662782166;
        bh=t5ylU0Vcz9ts1JzYy0cvzp98mSWHdIBzQRkTSA5x2hA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ehp1uwxlDEeJCmYSIg1N1ihC5tVY/pN1tlddWItVo/HPmJMXl8Rz86eI5sAf2S0P3
         pPnDuAS/d/WDwz7D6hUzWIhUa2/2Ro4N6NNE8xoWsMOQ2lvdculSJ+6rkjwTP/rAxk
         nVN/1ex8aphJ8GbTF8M7ArX2gSXQRcSTEUT/TL5Y=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220910035606uscas1p29d0e1f0d8cae3de601f8d2c4f48d5c69~TY5IMKBr-2997829978uscas1p22;
        Sat, 10 Sep 2022 03:56:06 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 08.B4.35398.6DA0C136; Fri, 
        9 Sep 2022 23:56:06 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220910035605uscas1p11889e97757a220ae18568ec60f5ecc10~TY5Hk6F2m0712807128uscas1p1u;
        Sat, 10 Sep 2022 03:56:05 +0000 (GMT)
X-AuditID: cbfec370-82fff70000028a46-91-631c0ad66f84
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id A2.B9.03193.5DA0C136; Fri, 
        9 Sep 2022 23:56:05 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 9 Sep 2022 20:56:04 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        9 Sep 2022 20:56:04 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Best practices for handling drive failures during a run?
Thread-Topic: Best practices for handling drive failures during a run?
Thread-Index: AQHYwtKq7u+o7wDXFU+M/iv0YYC8g63Vm+ywgAC5rICAAX97gIAALkEQ
Date:   Sat, 10 Sep 2022 03:56:04 +0000
Message-ID: <9b0021d903894664ab0a698ff19588d0@samsung.com>
In-Reply-To: <CADqNVTpkMUVx2+tUXTRivNqsejbP_Sto90pihzm+L210=MC25A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWy7djX87rXuGSSDT5eE7L4OOsFs8W8nb/Z
        HZg8zm9U9Pi8SS6AKYrLJiU1J7MstUjfLoErY93vqewFW6QqNi05yt7AeEeyi5GTQ0LAROLa
        +pNMXYxcHEICKxkl7r9YzQ7htDJJXNq7lQWm6sDOJqjEWkaJl1dWsoMkhAQ+MkosOsoNYS9l
        lPj7SbGLkYODTUBT4u3+ApCwiEC4xNc5+5lAbGEBV4llm6ewg5SICLhJHN+QDlHiJtFw7jYb
        iM0ioCpxcNVZVpASXgErifMfjEFMToFAiZdPDUEqGAXEJL6fWgM2kFlAXOLWk/lMEEcKSiya
        vYcZwhaT+LfrIRuErShx//tLsKXMQHet36UP0aooMaX7IdgbvECtJ2c+gfpVUuLgihssIL9K
        CPxll+g5cQdqpovElwVvoWxpielrLkMVtTNKzN34Bap7AqPE9SdSELa1xL/Oa+wQ2/gk/v56
        xAhyhIQAr0RHm9AERqVZSF6YhXDeLCTnzUJy3gJGllWM4qXFxbnpqcXGeanlesWJucWleel6
        yfm5mxiBieL0v8MFOxhv3fqod4iRiYPxEKMEB7OSCC+LoXSyEG9KYmVValF+fFFpTmrxIUZp
        DhYlcd5lmRsShQTSE0tSs1NTC1KLYLJMHJxSDUxVfVLbGMPXOy13YhUzCojtu1iisdc7Uig7
        Rdo7zvnfq0e/S+/89j+/2mZVnvYaBhGm0Oe9xUplS//fjy69fO/ci7OnrePcjPtZbBaoHHzH
        zC62YVvTjohItm93zEVka+L7vu8Sv3tnq8CRhXUVEcqb27xbzvWoz3JYslxfvP3n8gRRlhPM
        i051HGGcncc19eTticc8tkUuXNBZem1/1AFl/o187rMOqG15E2b/Wljn3qOORduWrLl6yTGS
        6/U94VPxVdX7tFa9PVb88NZxox2HIjOUT0qe1Qk6ypq0k/9mgpvWzK8fTS/I2iRtmu3+pDvA
        a6PItRBDuQO6reu0z3YHKaa90w86OrHH+4+ujqESS3FGoqEWc1FxIgD6aFsigwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWS2cA0Ufcql0yywcUlKhYfZ71gtpi38ze7
        A5PH+Y2KHp83yQUwRXHZpKTmZJalFunbJXBlrPs9lb1gi1TFpiVH2RsY70h2MXJySAiYSBzY
        2cTexcjFISSwmlHi/5erjBDOR0aJy8dboZyljBLfLk4Hcjg42AQ0Jd7uLwDpFhEIl/g6Zz8T
        iC0s4CqxbPMUdpASEQE3ieMb0iFK3CQazt1mA7FZBFQlDq46ywpSwitgJXH+gzHE9MdMEt9v
        9INN5xQIlHj51BCknFFATOL7qTVg05kFxCVuPZnPBHGzgMSSPeeZIWxRiZeP/7FC2IoS97+/
        BLuAGejI9bv0IVoVJaZ0P2QHsXkFBCVOznzCAlEuKXFwxQ2WCYxis5BsmIXQPQtJ9ywk3QsY
        WVYxipcWF+emVxQb56WW6xUn5haX5qXrJefnbmIERs7pf4djdjDeu/VR7xAjEwfjIUYJDmYl
        EV4WQ+lkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwesRPjhQTSE0tSs1NTC1KLYLJMHJxSDUw9
        PYIzT5/fM43plpZItN2Wy7O+fvBRsFTLbNlwUNxJJ2ST98m7Acs+2DvdPSQd4e4THhIssPvC
        Gkb5iM37Dln8n/q0fdqX5u6QQOG3RhoTy3h8vNXl9RJK3C3KWtizrX683Gvwc2plfsyJ3guN
        tcVKvG3PxPknxc3YvX2J5r+SeDN1t0fJuV8edceazpZ/YJcfGpaVf47l4WnL2e0Xl3bL7QtJ
        2vD0+Ey/tDM7jNJMJaM3Pdzvaeg+La7/xBSPet/fFwodo66H/e6WEHp7NHbajamndixXWhNx
        /cp68a9aDz1do10PHTzP/So94jDz1p0RPoHJU+fdKg+dZ6fMmtOzurnl4sKld7tl+5yl2pRY
        ijMSDbWYi4oTASmxOIQLAwAA
X-CMS-MailID: 20220910035605uscas1p11889e97757a220ae18568ec60f5ecc10
CMS-TYPE: 301P
X-CMS-RootMailID: 20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1
References: <CGME20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1@uscas1p1.samsung.com>
        <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
        <99cd72aca6274227825d5a50b263bab8@samsung.com>
        <CADqNVTpvftJZaJ2AepPMcbaJJr7vYMaLdivCf85j8Rwrq_02Fw@mail.gmail.com>
        <CADqNVTpkMUVx2+tUXTRivNqsejbP_Sto90pihzm+L210=MC25A@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDksIDIw
MjIgMTozNiBQTQ0KPiBUbzogVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT4NCj4g
U3ViamVjdDogUmU6IEJlc3QgcHJhY3RpY2VzIGZvciBoYW5kbGluZyBkcml2ZSBmYWlsdXJlcyBk
dXJpbmcgYSBydW4/DQo+IA0KPiBPbiBUaHUsIFNlcCA4LCAyMDIyIGF0IDk6NTkgQU0gVmluY2Vu
dCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNvbT4NCj4gd3JvdGU6DQo+ID4gVGhlIG51bGxfYmxr
IGRldmljZSBzdXBwb3J0cyBlcnJvciBpbmplY3Rpb24gdmlhIHRoZSBiYWRibG9ja3MgY29uZmln
ZnMNCj4gPiB2YXJpYWJsZS4gU28geW91IGNvdWxkIHVzZSBpdCBmb3IgdGVzdGluZy4gVGhlcmUg
aXMgYSBoZWxwIGd1aWRlIGZvciBzZXR0aW5nDQo+IHVwDQo+ID4gbnVsbF9ibGsgZGV2aWNlcyB2
aWEgY29uZmlnZnMgYXQNCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vcHJv
dGVjdDIuZmlyZWV5ZS5jb20vdjEvdXJsP2s9YmQNCj4gYjc0ODk3LWRjY2FhMGQwLWJkYjZjM2Q4
LTc0ZmU0ODVmZmYzMC0NCj4gMDY1MGExY2NjNGU1Y2ExYSZxPTEmZT0yOTEwNzVmYy1mZmEyLTQz
MjItOTM5Ny0NCj4gMTk4YjYwMzg0MjYyJnU9aHR0cHMqM0EqMkYqMkZ6b25lZHN0b3JhZ2UuaW8q
MkZkb2NzKjJGZ2V0dGluZy0NCj4gc3RhcnRlZCoyRm51bGxibGtfXztKU1VsSlNVbCEhRXdWenFH
b1RLQnF2LQ0KPiAwRFdBSkJtIVc5ck93TWdscUtLYUNuUXRGWTV1eHdCVVNrakxYMWxoQWxQekJR
bnJmckdtV1NlSl8NCj4gNGprZ2RhOXdhNkdFTldZYWlHeklISUI3SEhXVW5TN3NpNjdhUSQNCj4g
DQo+IFNvIHRoaXMgd2FzIHJlYWxseSBuaWNlIHRvIGxlYXJuIGFib3V0IGFuZCBwcmV0dHkgZWFz
eSB0byB1c2UuDQo+IChBbHRob3VnaCBJIHdpbGwgc2F5IEkgc2F3IGFsbCBraW5kcyBvZiB3ZWly
ZCBiZWhhdmlvciBsaWtlIHRoZSBkZXZpY2UNCj4gc2F5aW5nIGl0IGRpZG4ndCBzdXBwb3J0IE9f
RElSRUNULCBvdGhlciB3YWNreSBiZWhhdmlvciwgSSBiZWxpZXZlIGR1ZQ0KPiB0byBtYWtpbmcg
Y29uZmlnIGNoYW5nZXMgd2hpbGUgdGhlIGRldmljZSB3YXMgcG93ZXJlZCBvbi4pDQo+IA0KPiBX
aXRoIGl0LCBmaW8gZGlkIHJldHVybiBpbW1lZGlhdGVseSBhZnRlciB0aGUgZXJyb3IsIHJldHVy
biBhbiBlcnJvcg0KPiBjb2RlLCBwcmludCBlcnJvciBtZXNzYWdlcyBhYm92ZSB0aGUganNvbiBv
dXRwdXQsIGFuZCBzZXQgZXJyb3IgdG8gNQ0KPiBpbiB0aGUganNvbiBmb3IgdGhlIGpvYi4NCj4g
DQo+IFVuZm9ydHVuYXRlbHksIHRoZSBzYW1lIGRpZCBub3QgaGFwcGVuIHdpdGggdGhlIGRyaXZl
IGhhbmcvYWJvcnQvcmVzZXQNCj4gSSBoaXQuIFdoaWNoIG11c3QgbWVhbiBubyBJL08gZXJyb3Ig
d2FzIGFjdHVhbGx5IHJldHVybmVkIHRvIGZpby4NCj4gQ2hlY2tpbmcgdGhlIGZpbyBsYXRlbmN5
IGxvZywgdGhhdCBsYXN0IHJlYWQgcmVwb3J0ZWQgYSBsYXRlbmN5IG9mDQo+IDYzLjYgc2Vjb25k
cy4NCj4gDQo+IEknbSBndWVzc2luZyBmaW8gc2F0IGluIHdhaXRfZm9yX2NvbXBsZXRpb24gYWxs
IG9mIHRoaXMgdGltZS4gRm9yIHNvbWUNCj4gcmVhc29uIHRoZSBkcml2ZSdzIGJlaGF2aW9yIHdh
c24ndCBlbm91Z2ggdG8gY2F1c2UgYW4gSS9PIGVycm9yIC0NCj4gcGVyaGFwcyBpdCB3b3VsZCBo
YXZlIGV2ZW50dWFsbHkuDQo+IA0KPiBBbnkgb3RoZXIgdGhvdWdodHMgb24gd2h5IHRoZSBPUyB3
YXMgd2lsbGluZyB0byBsZXQgdGhpcyByZWFkIGdvIGZvcg0KPiBzbyBsb25nIHdpdGhvdXQgYW4g
SS9PIGVycm9yPyBJIHZlcmlmaWVkDQo+IC9zeXMvbW9kdWxlL252bWVfY29yZS9wYXJhbWV0ZXJz
L2lvX3RpbWVvdXQgaXMgMzAsIGJ1dA0KPiAvc3lzL21vZHVsZS9udm1lX2NvcmUvcGFyYW1ldGVy
cy9tYXhfcmV0cmllcyBpcyA1LCBzbyBtYXliZSB0aGF0IGlzDQo+IHRoZSBpc3N1ZS4NCj4gDQo+
IFRoYW5rcywNCj4gTmljaw0KDQpZb3UgY291bGQgdGVzdCB5b3VyIHRoZW9yeSBhYm91dCBtYXhf
cmV0cmllcyBieSBjcmVhdGluZyBhbiBOVk1lIGZhYnJpY3MNCmxvb3BiYWNrIGRldmljZSBiYWNr
ZWQgYnkgbnVsbF9ibGsgd2l0aCBlcnJvciBpbmplY3Rpb24uIFRoZW4gdHJ5IHRvIGFjY2VzcyBv
bmUNCm9mIHRoZSBiYWQgYmxvY2tzIHZpYSB0aGUgbnZtZSBkZXZpY2UgYW5kIHNlZSBpZiB0aGUg
ZGVsYXkgYmVmb3JlIGZpbyBzZWVzDQp0aGUgZXJyb3IgZGVwZW5kcyBvbiBpb190aW1lb3V0IGFu
ZCBtYXhfcmV0cmllcyBpbiB0aGUgd2F5IHRoYXQgeW91IGV4cGVjdC4NCg0KSSdtIGNjJ2luZyB0
aGUgbGlzdCBvbiB0aGlzIHJlcGx5IGluIGNhc2UgYW55b25lIGVsc2Ugd2FudHMgdG8gY2hpbWUg
aW4uDQoNClZpbmNlbnQNCg==
