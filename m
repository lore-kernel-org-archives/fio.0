Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E441C433FE
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 14:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347731AbiE0OqF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiE0OqE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 10:46:04 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2047B13FD4B
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:46:03 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220527144601usoutp0114c72ef3efd9f8cd33d7a24b29dca973~y-YUMZ5dZ2859928599usoutp01y;
        Fri, 27 May 2022 14:46:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220527144601usoutp0114c72ef3efd9f8cd33d7a24b29dca973~y-YUMZ5dZ2859928599usoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653662761;
        bh=sRmTIiHZB96CviJfT18RLoZXE/KCZjCZtdHWIvsC+wk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=mQ0zhYEUUyHBD/e0sngMGRf2YlPgoffiVzfKBKk12f4cd1muL2Tk8gp4kdDBUO10f
         039UwX/de/hmj3WHZHEdWF4+9Dv2466v9GZkFHaxNgviaevgROcZoUy9jGhS1Pcn7g
         05Sn2TwJIbEfp/3ThMEyx/y+87dyOF/c3DQTKDe4=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527144600uscas1p276892cd8480a816753f50f6c33468080~y-YTo-OwJ1794017940uscas1p2y;
        Fri, 27 May 2022 14:46:00 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 56.71.09749.824E0926; Fri,
        27 May 2022 10:46:00 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220527144600uscas1p186b4d096dfe33b6eaf326c406e5a29b7~y-YTPan-u1446214462uscas1p1q;
        Fri, 27 May 2022 14:46:00 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-4b-6290e4288cf1
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id FC.13.57470.724E0926; Fri,
        27 May 2022 10:45:59 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 07:45:59 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 07:45:58 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Thread-Topic: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
        functions
Thread-Index: AQHYcSBrMr2Im5piY0WW8UedfBpca60yzLqg
Date:   Fri, 27 May 2022 14:45:58 +0000
Message-ID: <9e2905ec01eb4350b1896491fc29dc8b@samsung.com>
In-Reply-To: <20220526144809.14877-4-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+69bteVcZ2Vxw0Xrhdb4ZYvgWRJkYTQF6UsqMi2eTPxbe26
        VavIim04MQcF0iKVErdssrIStTDcUjBfKiq1xQhzWollVpalzpxXyW8/zvmf5/w4PCTO/0EI
        yKy8AlqdJ88Rc3hEfdv486gNXrNi84xZEH/HU8qJH7N8wndgya+6NMk/6kQp2EHetgw6J0tL
        q2WJR3nHe7vXqgwBp4yTdQGF6CdhQoEkUHEwbu4KMCEeyaduI7jVU8HxN/iUHgN9FSyEJpyN
        iA3VImgrakds6DuCqV+nWK5G0FMUbkIkyaEk8OWJyl9eQaXAgLEB88/i1FME3w2euQUhVBr8
        aR8k2NB+MI0+QyzHQNtAFdfPBLUOJvttmJ+DqK3Q4xuZ40BqO7hqOufyiFoFv5/Z5+o4FQpu
        bwXGSgfDzeuPcZZXga+pn8NyBLz//Znr98RnPR1NMnY0Aq4W93PZVcHQfs07f6AwaLH1EX5/
        oEpImBqvmX8zCTpfPpgPCWHaU42xISOCG/cWzmtG0OsVsJwAvqIeLrttOUz//YDMaI1lkbfl
        v5NlkZNlkVMlImpQqIZhcjNpJjaPPill5LmMJi9TqszPrUOz/6LD51I1ILd7TOpEGImcCEhc
        vCLoxWCJgh+UIT+to9X56WpNDs04kZAkxKFB1Vl35XwqU15AZ9O0ilYvdDEyUFCIHYqoVSZf
        nqhsDZcof9mPDX7rTi6DMxf04Y1pB5om3I8ciaKwSH2tsC/fOqM4+FHMP7M5Ctfoy8qToi+m
        xDyU7Nxide00DHWFPzBdAdNFyYFebgFaWaIdqaOaY6X1XDN/SDkVkJporK8fOC8L6XUII5dc
        Uuz7XCFyDT0ZtpUXx2hbCg83tCRYM8pdYXep+z8563flmzjaUd3WDarmhntOnbM1Mnbk3YnU
        mdUSu0eYZI22Cd9+nd5m3mNOT+FadwdXpNnPvfYakvSHiGH1+RvOpY/Vw/JH+rNxstI29xFH
        8yatTlKy92xwaHZ338YOwbLiLM+ldyKv5I0NMYligjkuj96Iqxn5Pyo4pnuGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapKv+ZEKSwcN+S4vVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZ18+pFLSxVrT/3sTawPiFpYuRk0NCwETix6Gd
        jF2MXBxCAqsZJRq+LGKHcD4xSjQ1nWKCcJYxSqybfpe1i5GDg01AU+Lt/gKQbhEBP4nzT7ay
        gNQwCxxhlPjUdpcNJCEsECrx8+RTFoiiMInfLctZIWwjiWOPl7CD2CwCqhK/H65gArF5Bawk
        rv17A7XsMKPEkpXrwIo4BWwlDq86wwhiMwqISXw/tQasgVlAXOLWk/lMED8ISCzZc54ZwhaV
        ePn4HyuErShx//tLdpCjmYGOXr9LH6JVUWJK90N2iL2CEidnPoEGhaTEwRU3WCYwis9CsmEW
        QvcsJN2zkHQvYGRZxSheWlycm15RbJSXWq5XnJhbXJqXrpecn7uJERhXp/8djt7BePvWR71D
        jEwcjIcYJTiYlUR4LzztTRLiTUmsrEotyo8vKs1JLT7EKM3BoiTO+zJqYryQQHpiSWp2ampB
        ahFMlomDU6qBaVF79uXYWxJpHK6vHX3XJs08fere3X3FXkffFC//J+V38RXrKpFz0227RM3f
        yIcxJQUpCDZetjD4HNLhkOR4es3bl99vNba5aN991mt+Nlyz28vCwbLBTqXwTJ2elv1Jratr
        1rKxRqxkSTWJN/30m738+5N9N7n6O/ivHbcREj+9NXxayk3pkyau4pektTZv3r1N97NK8JV0
        b91t3NG3dJ2nXX1iukBoAk+NoksRz0OL3viCrPKnCj0qRYpusxfJ3sxmOPynVvtI5dcHh91i
        9CRFHRVvbMj8o+FjumbHn71Oy4U3W3z6F+/Bfu5IiuPJI11eLz0PM/PkHVn/b/a93Z/W7VvE
        xJn581nuwYczlViKMxINtZiLihMBhTIoKxoDAAA=
X-CMS-MailID: 20220527144600uscas1p186b4d096dfe33b6eaf326c406e5a29b7
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526145400epcas5p348be0238746b1cc70fae627a63a43eba
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
        <20220526144809.14877-4-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KDQo+ICsNCj4gKwlpZiAoaW9fdS0+ZGRpciA9PSBE
RElSX1JFQUQpDQo+ICsJCWNtZC0+b3Bjb2RlID0gbnZtZV9jbWRfcmVhZDsNCj4gKwlpZiAoaW9f
dS0+ZGRpciA9PSBERElSX1dSSVRFKQ0KPiArCQljbWQtPm9wY29kZSA9IG52bWVfY21kX3dyaXRl
Ow0KDQpDb25zaWRlciBjaGFuZ2luZyB0aGlzIHRvIGEgc3dpdGNoIHN0YXRlbWVudCBhbmQgYWRk
aW5nIGEgZGVmYXVsdDogY2FzZQ0KaW4gY2FzZSBzb21lb25lIHRyaWVzIHRvIHNlbmQgYW4gdW5z
dXBwb3J0ZWQgY29tbWFuZC4NCg0KU2luY2UgdGhpcyBpcyBpbiB0aGUgIGZhc3QgcGF0aCBhIHN3
aXRjaCBzdGF0ZW1lbnQgd291bGQgYWxzbyByZWR1Y2UgdGhlIG51bWJlcg0Kb2YgdGltZXMgZGRp
ciBpcyBjaGVja2VkLg0K
