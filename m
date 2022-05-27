Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED761C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 17:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346093AbiE0RXR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 13:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiE0RXQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 13:23:16 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108FD13C0A2
        for <fio@vger.kernel.org>; Fri, 27 May 2022 10:23:11 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220527172307usoutp014741c006377e733defe4bca020df62b8~zBhfDyjyo2934629346usoutp01L;
        Fri, 27 May 2022 17:23:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220527172307usoutp014741c006377e733defe4bca020df62b8~zBhfDyjyo2934629346usoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653672187;
        bh=4TKe2G03lgloDLGzuszugboyf/YphAsfq6wwWNFx7W8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Kca0TAKhAhslpk9Wip1PJb/1IZZKiKNXNftfjTybi24q7DUSDHqjwoxca1HwuySR7
         F2D4hg5r7hl2PivJyl5x4kIFD13uU7bAs1ce/2shCnUctjSgRw9W7D27N4Zgw/4B6/
         I5cL7jBEloEFrwwgUdnGTEpSwgfL8jm64hYDQYZ4=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220527172306uscas1p14d4288495e8940c7fdd1821664073f30~zBhed9Bi50047800478uscas1p1-;
        Fri, 27 May 2022 17:23:06 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 21.48.09760.AF801926; Fri,
        27 May 2022 13:23:06 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527172306uscas1p28c55939b77f22a2ee0d7524865fc83f3~zBheLM8MI3168231682uscas1p2k;
        Fri, 27 May 2022 17:23:06 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-67-629108fa0a6e
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 6E.53.52349.AF801926; Fri,
        27 May 2022 13:23:06 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 10:23:05 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 10:23:05 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v2 7/8] engines/io_uring: Enable zone device support for
 io_uring_cmd I/O engine
Thread-Topic: [PATCH v2 7/8] engines/io_uring: Enable zone device support
        for io_uring_cmd I/O engine
Thread-Index: AQHYcSB4B8eFlAwsp0y6xgFDtgjOD60y+m6w
Date:   Fri, 27 May 2022 17:23:05 +0000
Message-ID: <e8ba3166edc44ab192b16fe5820160d4@samsung.com>
In-Reply-To: <20220526144809.14877-8-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7q/OCYmGXy6pmyx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY+/EfewFR/gqHl++wNLAOIWvi5GTQ0LAROLU
        nrfMILaQwEpGiUk3vbsYuYDsViaJhUems8MU9fe2skAk1jJKzF85jw3C+cQocfDDWkYIZxmj
        xIEXn4EyHBxsApoSb/cXgHSLCARIPG7fwQRSwyxwhFHiU9tdNpCEsECaxOTVO9khitIlNm4C
        uYMDyDaS+PyoDCTMIqAq8f3USrByXgEriY4dP8BO5RSwlTjZtYkFxGYUEAOqWcMEYjMLiEvc
        ejKfCeJqQYlFs/cwQ9hiEv92PWSDsBUl7n9/yQ6yihnozPW79CFaFSWmdD9kh1glKHFy5hMW
        iHJJiYMrboA9LyHQyyGx8tdEqDkuEgsXb4Mqkpa4en0qM0RRO6PE3I1foBITGCWuP5GCsK0l
        /nVeY4fYxifx99cjxgmMyrOQ3D0L4aZZSG6aheSmBYwsqxjFS4uLc9NTiw3zUsv1ihNzi0vz
        0vWS83M3MQJTxul/h3N3MO649VHvECMTB+MhRgkOZiUR3gtPe5OEeFMSK6tSi/Lji0pzUosP
        MUpzsCiJ8y7L3JAoJJCeWJKanZpakFoEk2Xi4JRqYJonsOCC3u+Yp492MuT81J3n/ij8hZzm
        V4feX8zZ910y0tRtFINjnQ+JM4a0V24WL2IIYHi9Xpkv8OTWgkNLlNT+tzkv2z1pbjsP992J
        FwudGC7MPs20WdogV+juuS4xz2kq0zc7KvOVR11ykciyDcyRnsbj98laSO3G0zwjXWNWtg5N
        I8sDrJcLpj17p9EQJrkwxOX2CgMRew0t2Tc37514cqtsw+6IH/wO9lXecr+PHE6ZkXlB4IfR
        Pgm+2Nq556+1frF/lXjhP9sHpyWGSzkPHa3ujtSfc6rW3vuKaAKbst6BQsGtZ4P2Lf5y0vbA
        pIK8gCDxuxWShrvF1meqz795bNOxzQzXLmder1grq8RSnJFoqMVcVJwIAE9V94+IAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapPuLY2KSwZt2AYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZeyfuYy84wlfx+PIFlgbGKXxdjJwcEgImEv29
        rSxdjFwcQgKrGSV+7bgC5XxilPh/Yy87hLOMUeJV0zsgh4ODTUBT4u3+ApBuEQE/ifNPtoI1
        MAscYZT41HaXDSQhLJAmMXn1TnaIonSJG01HGUF6RQSMJD4/KgMJswioSnw/tRKsnFfASqJj
        xw9miF2HGSV2dX9lBElwCthKnOzaxAJiMwqIATWsYQKxmQXEJW49mc8E8YKAxJI955khbFGJ
        l4//sULYihL3v78Eu5kZ6Ob1u/QhWhUlpnQ/ZIfYKyhxcuYTFohySYmDK26wTGAUn4VkwyyE
        7llIumch6V7AyLKKUby0uDg3vaLYMC+1XK84Mbe4NC9dLzk/dxMjMK5O/zscuYPx6K2PeocY
        mTgYDzFKcDArifBeeNqbJMSbklhZlVqUH19UmpNafIhRmoNFSZxXyHVivJBAemJJanZqakFq
        EUyWiYNTqoFprfEni8+Bh8N2lM2dqTZN7arIS4cj2XHHlxt+cfLifj6hTWHy7BOdq2cwFxTG
        Ka9XP/xMu/ndbEah/yHnp/AJWX87tuzPntJXQbevTOEq6j2Yr/LeNPzxeT1vl/TW3c4abKsF
        5LwVHOSDVuY1BW/nvvLrsEervpe4+UyX5llpGxf26DkZXVsudvPWJNbpnX+8Pml8OJmq/CXA
        rXxJ0JQLyyQs3Jj+OCwo2VVyZMWDa+e1tRXPZi/cH1P9iHV+n+skOWOWhp9y93KO7ppoN6Hy
        oe6iFrkTYt/qHrR529w0mNpyoLNsop9n5C3eD7rrJGZ5bp5x82HxosT+qPzulWdVZv8wiIr5
        9S5Tq7z18NfVSizFGYmGWsxFxYkAhqvo7hoDAAA=
X-CMS-MailID: 20220527172306uscas1p28c55939b77f22a2ee0d7524865fc83f3
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51@epcas5p1.samsung.com>
        <20220526144809.14877-8-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDI2LCAyMDIy
IDEwOjQ4IEFNDQo+IFRvOiBheGJvZUBrZXJuZWwuZGsNCj4gQ2M6IGZpb0B2Z2VyLmtlcm5lbC5v
cmc7IGtyaXNoLnJlZGR5QHNhbXN1bmcuY29tOw0KPiBqb3NoaS5rQHNhbXN1bmcuY29tOyBhbnVq
MjAuZ0BzYW1zdW5nLmNvbTsgQW5raXQgS3VtYXINCj4gPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29t
Pg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjIgNy84XSBlbmdpbmVzL2lvX3VyaW5nOiBFbmFibGUgem9u
ZSBkZXZpY2Ugc3VwcG9ydA0KPiBmb3IgaW9fdXJpbmdfY21kIEkvTyBlbmdpbmUNCj4gDQo+IEFk
ZCB6b25lIGRldmljZSBzcGVjaWZpYyBpb2VuZ2luZV9vcHMgZm9yIGlvX3VyaW5nX2NtZC4NCj4g
KiBnZXRfem9uZWRfbW9kZWwNCj4gKiByZXBvcnRfem9uZXMNCj4gKiByZXNldF93cA0KPiAqIGdl
dF9tYXhfb3Blbl96b25lcw0KPiANCj4gQWRkIHRoZSBuZWNlc3NhcnkgTlZNZSBaTlMgc3BlY2Zp
Y2F0aW9uIG9wY29kZXMgYW5kIHN0cmN1dHVyZXMuIEFkZA0KPiBoZWxwZXIgZnVuY3Rpb25zIHRv
IHN1Ym1pdCBhZG1pbiBhbmQgSS9PIHBhc3N0aHJvdWdoIGNvbW1hbmRzIGZvcg0KPiB0aGVzZQ0K
PiBuZXcgTlZNZSBaTlMgc3BlY2lmaWMgY29tbWFuZHMuDQo+IA0KPiBGb3Igd3JpdGUgd29ya2xv
YWQgaW9kZXB0aCBtdXN0IGJlIHNldCB0byAxIGFzIHRoZXJlIGlzIG5vIElPIHNjaGVkdWxlcg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQW5raXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29t
Pg0KDQpJIHJhbiB0aGUgam9iIGZpbGUgYmVsb3cgb24gYW4gZW11bGF0ZWQgWk5TIGRldmljZSB1
bmRlciBRRU1VIGFuZCBmb3VuZA0Kbm8gcHJvYmxlbXMuDQoNCltnbG9iYWxdDQpmaWxlbmFtZT0v
ZGV2L25nMG4xDQppb2VuZ2luZT1pb191cmluZ19jbWQNCmNtZF90eXBlPW52bWUNCnpvbmVtb2Rl
PXpiZA0KYnM9MjU2Sw0KdmVyaWZ5PWNyYzMyYw0Kc3RvbmV3YWxsPTENCg0KW3dyaXRlLXBsYWlu
XQ0Kcnc9cmFuZHdyaXRlDQoNCltyYW5kd3JpdGUtcGxhaW5dDQpydz1yYW5kd3JpdGUNCg0KW3dy
aXRlLW9wdHNdDQpydz1yYW5kd3JpdGUNCnJlZ2lzdGVyZmlsZXM9MQ0Kc3F0aHJlYWRfcG9sbD0x
DQpzcXRocmVhZF9wb2xsX2NwdT0wDQoNCltyYW5kd3JpdGUtb3B0c10NCnJ3PXJhbmR3cml0ZQ0K
cmVnaXN0ZXJmaWxlcz0xDQpzcXRocmVhZF9wb2xsPTENCnNxdGhyZWFkX3BvbGxfY3B1PTANCg0K
VGVzdGVkLWJ5OiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPg0K
