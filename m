Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51640C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 16:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiE0QPz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiE0QPy (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 12:15:54 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D0D108ABC
        for <fio@vger.kernel.org>; Fri, 27 May 2022 09:15:53 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220527161551usoutp02cefb561163cd361d7827e4cf0f8c37bc~zAmwhN5lg1489914899usoutp02h;
        Fri, 27 May 2022 16:15:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220527161551usoutp02cefb561163cd361d7827e4cf0f8c37bc~zAmwhN5lg1489914899usoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653668151;
        bh=kFmnKTnWF61zgLY4ldI3xZCNC12cNLb/A/aupDBZD+U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=RQb41uvsUFmF3QVDU1UJxJcwTBXPYyeOUXYvB828weNHtvHlyAaB3z1pEaYHfGN5x
         Qm1UAK6+7gKNIyOXiGqjIunqrnODJ1D/zhldw28+Qg+nZVX1EKh0IsKVYO41rOMyIb
         MGBNh6LRx2wa9wTJT7xHw3ib6RTzzdT1HXQ+AdQ0=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220527161551uscas1p1dea1ab79e14d9841bb8c66540161bdaa~zAmwY2k9A2135921359uscas1p1q;
        Fri, 27 May 2022 16:15:51 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 87.1E.09749.739F0926; Fri,
        27 May 2022 12:15:51 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527161550uscas1p26478c0316f4fdfed9cdc655583889424~zAmvwpBbv2373123731uscas1p2W;
        Fri, 27 May 2022 16:15:50 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-19-6290f937083b
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 85.12.52349.639F0926; Fri,
        27 May 2022 12:15:50 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 09:15:49 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 09:15:49 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v2 6/8] zbd: Check for direct flag only if its block
 device
Thread-Topic: [PATCH v2 6/8] zbd: Check for direct flag only if its block
        device
Thread-Index: AQHYcSB4WRRFnUUAJEqy1R0Q+s+k5a0y48IQ
Date:   Fri, 27 May 2022 16:15:49 +0000
Message-ID: <36999baf8270426bb9f50848aab9fe7c@samsung.com>
In-Reply-To: <20220526144809.14877-7-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7rmPyckGUzaK26x+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr4+ymu+wFH7gq/m17y9jAeIari5GTQ0LAROLL
        9O/MILaQwEpGiYXfbCHsViaJp1MiYWpOvp8CVMMFFF/LKPHg8SpGCOcTo8Smjh1MEM4yRolP
        U66xdDFycLAJaEq83V8A0i0iECDxuB2ihlngCFBN2102kISwQKDE43lX2EHqRQSCJB6t14ao
        N5Lo/PSQCcRmEVCVWLmigxHE5hWwkljxECLOKWArsWXfM7A4o4CYxPdTa8DizALiEreezGeC
        uFpQYtHsPcwQtpjEv10P2SBsRYn731+CrWUGOnP9Ln2IVkWJKd0P2SFWCUqcnPmEBaJcUuLg
        ihssIOdLCEzkkOj80g4130XiyNJX7BC2tMTV61OZIYraGSXmbvwC1T2BUeL6EykI21riX+c1
        dohtfBJ/fz1inMCoPAvJ3bMQbpqF5KZZSG5awMiyilG8tLg4Nz212DgvtVyvODG3uDQvXS85
        P3cTIzBhnP53uGAH461bH/UOMTJxMB5ilOBgVhLhvfC0N0mINyWxsiq1KD++qDQntfgQozQH
        i5I477LMDYlCAumJJanZqakFqUUwWSYOTqkGpkNrpCo1bdqd5FTm+8YZMIsnuJVEHWmcLe74
        MDJp/4admU0KErm2zLm/XGeHL9ZTbdnI9D3+m6PR1u3dooU3t9a2CJzdb9vW9jlCvOZ/w4Po
        gG/M79fGrRT/sqPWcNL3x8K7zpd/u8Uu/bL//Iy1Fd6l/87u/aMnXLfsRvvGOzWSU+70/Dr4
        bpuY8XdGrpWzyrd2mR+8qRVVuZ9x41X+O5za028sK7tz7vAyuSUsy9c+eSljJHf+cB3X+4A+
        jyUPtu26vfR69L2m8jj9nczaWct2JZRvCE9h5X+9xHF3fkfLm5D9m+ODct7vFkgV+PlV0THx
        Q1Zkivu5XaXFVw4XMk08L5LEE7R67nQDttoIcSWW4oxEQy3mouJEAHiilzuHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCapGv2c0KSwcr/Ghar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyzm66y17wgavi37a3jA2MZ7i6GDk5JARMJE6+
        n8LcxcjFISSwmlHiV9MbNgjnE6PErv2LmSCcZYwSrX9PsHQxcnCwCWhKvN1fANItIuAncf7J
        VhaQGmaBI4wSn9rusoEkhAUCJR7Pu8IOURQk8X7yDCjbSKLz00MmEJtFQFVi5YoORhCbV8BK
        YsXDh1DLDjNK7L/8EayBU8BWYsu+Z2BFjAJiEt9PrQFrZhYQl7j1ZD4TxA8CEkv2nGeGsEUl
        Xj7+xwphK0rc//6SHeRoZqCj1+/Sh2hVlJjS/ZAdYq+gxMmZT1ggyiUlDq64wTKBUXwWkg2z
        ELpnIemehaR7ASPLKkbx0uLi3PSKYsO81HK94sTc4tK8dL3k/NxNjMDIOv3vcOQOxqO3Puod
        YmTiYDzEKMHBrCTCe+Fpb5IQb0piZVVqUX58UWlOavEhRmkOFiVxXiHXifFCAumJJanZqakF
        qUUwWSYOTqkGpn6Z2frvTv1Z1tze7zA1QrWQ52b4WoUkPZVWC/evNsInFZeq1Lb9sdu4V+2O
        yEXNZXPO1yg4+53s+6lStVzTfO23L+aui6cuLGe6eOeN+kuf8tn/8tZO/fXVUXDSzYXFZdIn
        P304H2QqtdDbJvqE23OhHc9uyWyc+G7eIoWCUtMqMeELlfOv2JxY7hdcsvdR345JdxuFy42+
        zGi/IH7bb6LRySLLxPwjTzvmNTFG1GofOnXu1ImvKk+Kpvkk9j5TNw+pemH253jaLq994hP2
        76vPv3fU5slvZcaPWXLhnFvkTOUNkr8Unt0kZ7fNYPdzKcu1l34+f9+yM9nj8yuVdu7Y0IRv
        T2xdWyqeaOQIJiixFGckGmoxFxUnAgAkPFr4GwMAAA==
X-CMS-MailID: 20220527161550uscas1p26478c0316f4fdfed9cdc655583889424
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38@epcas5p2.samsung.com>
        <20220526144809.14877-7-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDI2LCAyMDIy
IDEwOjQ4IEFNDQo+IFRvOiBheGJvZUBrZXJuZWwuZGsNCj4gQ2M6IGZpb0B2Z2VyLmtlcm5lbC5v
cmc7IGtyaXNoLnJlZGR5QHNhbXN1bmcuY29tOw0KPiBqb3NoaS5rQHNhbXN1bmcuY29tOyBhbnVq
MjAuZ0BzYW1zdW5nLmNvbTsgQW5raXQgS3VtYXINCj4gPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29t
Pg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjIgNi84XSB6YmQ6IENoZWNrIGZvciBkaXJlY3QgZmxhZyBv
bmx5IGlmIGl0cyBibG9jayBkZXZpY2UNCj4gDQo+IG52bWUtbnMgZ2VuZXJpYyBjaGFyYWN0ZXIg
ZGV2aWNlcyBjdXJyZW50bHkgZG8gbm90IHN1cHBvcnQgT19ESVJFQ1QNCj4gZmxhZy4NCj4gQ2hl
Y2sgZm9yIGZpbyBvcHRpb24gZm9yIGRpcmVjdCBmbGFnIG9ubHkgaWYgZmlsZXR5cGUgaXMgYSBi
bG9jayBkZXZpY2UuDQo+IA0KPiB0L3piZCBza2lwIHRlc3QgY2FzZSAjMSBmb3IgY2hhcmFjdGVy
IGRldmljZXMgYXMgZG9uJ3QgcmVxdWlyZQ0KPiBkaXJlY3QgSS9PLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQW5raXQgS3VtYXIgPGFua2l0Lmt1bWFyQHNhbXN1bmcuY29tPg0KPiAtLS0NCg0KSSB0
ZXN0ZWQgdGhpcyB3aXRoIGEgem9uZWQgc2NzaV9kZWJ1ZyBkZXZpY2UgY3JlYXRlZCBieToNCg0K
bW9kcHJvYmUgc2NzaV9kZWJ1ZyB6YmM9Mg0KDQpJIG9ic2VydmVkIHRoYXQgcnVubmluZw0KDQp0
L3piZC90ZXN0LXpiZC1zdXBwb3J0IC10IDEgLWwgL2Rldi9zZzINCg0Kb24gdjEgb2YgdGhpcyBw
YXRjaCBzZXJpZXMgcHJvZHVjZWQgYSB0ZXN0IGZhaWx1cmUgd2hlcmVhcyBvbiB2MiBvZiB0aGlz
IHBhdGNoIHNlcmllcyB0aGUgdGVzdCBjYXNlIGlzIGFwcHJvcHJpYXRlbHkgc2tpcHBlZC4NCg0K
VGVzdGVkLWJ5OiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPg0K
