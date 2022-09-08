Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81210C54EE9
	for <fio@archiver.kernel.org>; Thu,  8 Sep 2022 15:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiIHO77 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Sep 2022 10:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiIHO76 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Sep 2022 10:59:58 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956D55209B
        for <fio@vger.kernel.org>; Thu,  8 Sep 2022 07:59:55 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220908145953usoutp01d90ab49e1a890c818d282748ef6f4be4~S6qHVwFYI3098830988usoutp01V;
        Thu,  8 Sep 2022 14:59:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220908145953usoutp01d90ab49e1a890c818d282748ef6f4be4~S6qHVwFYI3098830988usoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662649193;
        bh=Sy7GzxwlLdpot9hvZ5bXEga2QHx8s05UfZKxKR9gSwY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uACVvbkSiFk4D7LpY3jxhFNAR55Hx8OmDndjTZCgfTlbk7KA8DUM3HplJsGuHPP5P
         x+GRdOffPbunUrYuIX1Ygqh4zbGY6JCbfJOwn7+Agvhag1gkEttLGzj1/9RtEQuTom
         hq/KwjiNyZpA4PBXLeXpCWhVqjyrdv5R8+0o1FMI=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220908145953uscas1p1fdaebabf819f1ed49f15bc96d008bb18~S6qHIuiwT2305723057uscas1p1P;
        Thu,  8 Sep 2022 14:59:53 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id CB.41.18126.8630A136; Thu, 
        8 Sep 2022 10:59:52 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220908145952uscas1p166c407fdf0182e892b233a8269babc86~S6qGxDPD-2507725077uscas1p1B;
        Thu,  8 Sep 2022 14:59:52 +0000 (GMT)
X-AuditID: cbfec36f-ff9ff700000146ce-0c-631a03684318
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id FB.4E.08434.8630A136; Thu, 
        8 Sep 2022 10:59:52 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Thu, 8 Sep 2022 07:59:51 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Thu,
        8 Sep 2022 07:59:51 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Nick Neumann <nick@pcpartpicker.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Best practices for handling drive failures during a run?
Thread-Topic: Best practices for handling drive failures during a run?
Thread-Index: AQHYwtKq7u+o7wDXFU+M/iv0YYC8g63Vm+yw
Date:   Thu, 8 Sep 2022 14:59:51 +0000
Message-ID: <99cd72aca6274227825d5a50b263bab8@samsung.com>
In-Reply-To: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWy7djXc7oZzFLJBpvvmlt8nPWC2WLezt/s
        Dkwe5zcqenzeJBfAFMVlk5Kak1mWWqRvl8CVMevCbpaCe7wVOx4eYWpg3MDbxcjJISFgIrGm
        cT9LFyMXh5DASkaJc92v2SCcViaJc1f7mWCq5vQfYIVIrGWUuHd6GhOE85FRYsvH61CZpYwS
        ex52APVzcLAJaEq83V8A0i0iEC7xdc5+sEnCAq4SyzZPYQcpERFwkzi+IR2ixEiibcoHFpAw
        i4CKxNJF8SBhXgErieu7tzKDhDkFAiWmd4MNZBQQk/h+ag3YQGYBcYlbT+ZDnSkosWj2HmYI
        W0zi366HbBC2osT97y/BljID3bV+lz5Eq6LElO6H7BCbBCVOznzCAlEuKXFwxQ1wmEgINHJI
        rPr1B2q+i8TXBfcYIWxpib93lzFBFLUzSszd+AWqewKjxPUnUhC2tcS/zmvsENv4JP7+esQI
        coSEAK9ER5vQBEalWUhemIVw3iwk581Cct4CRpZVjOKlxcW56anFRnmp5XrFibnFpXnpesn5
        uZsYgcni9L/D+TsYr9/6qHeIkYmD8RCjBAezkgiv6FqJZCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8yzI3JAoJpCeWpGanphakFsFkmTg4pRqYjLjdb9/YOyGzj6V52t0Ci7sWk967aO553Fsy
        L/5vs/rz5TyHfy7qPWJgtfm536bb2gx6E6+b6c+yurNhlwt7Je+V18L2F6yeTd4U3cvLIe7y
        t9xwf1zd6RfpUyr+zYlJvsR7cUXZNJn3a00DFxvGzFZYO3kv0+JT3FOa+i9PbEx4NGPCRd1D
        k//lbvnp2brf23qX6ITt+dq79D6Kt4vw7LzmkmC2e0/IKpN/etObb9QLa63R/pvH+dhohZBI
        wskN344d5z6u4hDRZppkZLGLb86JA09sTDuV+676Kq89lds3kfm12KEbSj8mqd31fyAbaiQi
        HnIuPjm8TDZrxtLVXJ2LZdUdOjwCtha5+1qbKrEUZyQaajEXFScCAKX9A+iFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWS2cA0UTeDWSrZ4NVCOYuPs14wW8zb+Zvd
        gcnj/EZFj8+b5AKYorhsUlJzMstSi/TtErgyZl3YzVJwj7dix8MjTA2MG3i7GDk5JARMJOb0
        H2DtYuTiEBJYzSgx7+wudgjnI6PEjWNLoZyljBKzr3cDlXFwsAloSrzdXwDSLSIQLvF1zn4m
        EFtYwFVi2eYp7CAlIgJuEsc3pEOUGEm0TfnAAhJmEVCRWLooHiTMK2AlcX33VmaI6UsYJSat
        PskEUsMpECgxvRtsOqOAmMT3U2vApjMLiEvcejKfCeJmAYkle84zQ9iiEi8f/2OFsBUl7n9/
        CXYBM9CR63fpQ7QqSkzpfsgOsVZQ4uTMJywQ5ZISB1fcYJnAKDYLyYZZCN2zkHTPQtK9gJFl
        FaN4aXFxbnpFsVFearlecWJucWleul5yfu4mRmDknP53OHoH4+1bH/UOMTJxMB5ilOBgVhLh
        FV0rkSzEm5JYWZValB9fVJqTWnyIUZqDRUmc92XUxHghgfTEktTs1NSC1CKYLBMHp1QD07Lt
        vxv6DY/rv1XafvDdvPUyzPEpLy5WvfmTLPV55d1dMuINoWkJZZNZvB5HphybtNxqQnS87s52
        sWc2LutWhj5cVqOYfvRrxDrbtbnWHz6tUDj6x7ixaF3IntvlxfVzn+nW8kV9F0q6mDlvzYqF
        V++/yJHN6V8gV571vW7xy6ij2TNyt/854FY7W35CZqmRengG567l0p8k7rAXHfxVeb/c71P9
        Af/tfxh3C8wveqXJk7y7T3/lDZYtN+eEGUqISWkqRZcvUu2deGztNf4HkdO/10+f/7fs/+R7
        nvePbwp1fPD4XU9FduwbhhWLWoIvPvBSP+YZu2F/emXOeoEvpeq9vRt0elasZFNsa3xqcEeJ
        pTgj0VCLuag4EQD/UIB7CwMAAA==
X-CMS-MailID: 20220908145952uscas1p166c407fdf0182e892b233a8269babc86
CMS-TYPE: 301P
X-CMS-RootMailID: 20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1
References: <CGME20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1@uscas1p1.samsung.com>
        <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIE5ldW1hbm4gW21haWx0
bzpuaWNrQHBjcGFydHBpY2tlci5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDcs
IDIwMjIgMTE6NTggQU0NCj4gVG86IGZpb0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogQmVz
dCBwcmFjdGljZXMgZm9yIGhhbmRsaW5nIGRyaXZlIGZhaWx1cmVzIGR1cmluZyBhIHJ1bj8NCj4g
DQo+IEkgd2FzIHdvbmRlcmluZyBpZiB0aGVyZSB3ZXJlIGFueSByZWNvbW1lbmRhdGlvbnMvc3Vn
Z2VzdGlvbnMgb24NCj4gaGFuZGxpbmcgZHJpdmUgZmFpbHVyZXMgZHVyaW5nIGEgZmlvIHJ1bi4g
SSBoaXQgb25lIHllc3RlcmRheSB3aXRoIGENCj4gNjAgc2Vjb25kIG1peGVkIHVzZSB0ZXN0IG9u
IGFuIFNTRC4gNTEgc2Vjb25kcyBpbiwgdGhlIGRyaXZlIGJhc2ljYWxseQ0KPiBzdG9wcGVkIHJl
c3BvbmRpbmcuIChBIHNlcGFyYXRlIHByb2dyYW0gdGhhdCBwZXJpb2RpY2FsbHkgY2FsbHMNCj4g
c21hcnRjdGwgdG8gZ2V0IGRyaXZlIHN0YXRlIGFsc28gc2hvd2VkIHNvbWV0aGluZyB3YXMgdXAs
IGFzIGRhdGEgbGlrZQ0KPiB0ZW1wZXJhdHVyZSB3YXMgbWlzc2luZy4pDQo+IA0KPiBBdCAxMDcg
c2Vjb25kcywgYSByZWFkIGNvbXBsZXRlZCwgYW5kIGZpbyBleGl0ZWQuDQo+IA0KPiBJdCBtYWRl
IG1lIHdvbmRlciB3aGF0IHdvdWxkIGhhdmUgaGFwcGVuZWQgaWYgdGhlIHRlc3Qgd2FzIG5vdCB0
aW1lDQo+IGxpbWl0ZWQgLSBlLmcuLCBhIGZ1bGwgZHJpdmUgd3JpdGUuIFdvdWxkIGl0IGhhdmUg
anVzdCBodW5nLCB3YWl0aW5nDQo+IGZvcmV2ZXI/IE9yIHdvdWxkIHRoZSBPUyBldmVudHVhbGx5
IGdldCBiYWNrIHRvIGZpbyBhbmQgdGVsbCBpdCB0aGUNCj4gc3VibWl0dGVkIG9wZXJhdGlvbnMg
aGF2ZSBmYWlsZWQgYW5kIGZpbyB3b3VsZCBleGl0Pw0KPiANCj4gQW55IGlkZWFzIG9uIHdheXMg
dG8gdGVzdCB0aGUgYmVoYXZpb3IsIG9yIGFyZWFzIG9mIHRoZSBjb2RlIHRvIGxvb2sgYXQ/DQo+
IA0KDQpUaGUgbnVsbF9ibGsgZGV2aWNlIHN1cHBvcnRzIGVycm9yIGluamVjdGlvbiB2aWEgdGhl
IGJhZGJsb2NrcyBjb25maWdmcw0KdmFyaWFibGUuIFNvIHlvdSBjb3VsZCB1c2UgaXQgZm9yIHRl
c3RpbmcuIFRoZXJlIGlzIGEgaGVscCBndWlkZSBmb3Igc2V0dGluZyB1cA0KbnVsbF9ibGsgZGV2
aWNlcyB2aWEgY29uZmlnZnMgYXQgaHR0cHM6Ly96b25lZHN0b3JhZ2UuaW8vZG9jcy9nZXR0aW5n
LXN0YXJ0ZWQvbnVsbGJsaw0KDQpWaW5jZW50DQo=
