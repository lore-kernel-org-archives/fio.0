Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE9FC433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 17:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354316AbiE0RbD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 13:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343620AbiE0RbC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 13:31:02 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9375C362
        for <fio@vger.kernel.org>; Fri, 27 May 2022 10:31:00 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220527173059usoutp02b330dadb2c7cd1b13ae757dfd7f8b045~zBoXAcf9n1063910639usoutp02W;
        Fri, 27 May 2022 17:30:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220527173059usoutp02b330dadb2c7cd1b13ae757dfd7f8b045~zBoXAcf9n1063910639usoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653672659;
        bh=b8TgvQgd3PPw4QnbLNesJQy/e3I5sYq8/0c00UEblyo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=g4C57fl61jrbPl4GdjYa2/jGr/2Qdj3rXXaO6Kar7rCiF/pr2goF3viGu/H8d8Cum
         ICW+dhtrP5s0kAQgqdCefCIfv5binM3HVlWDNxriw1+4PbRt3P6QiJw8q7/W0Xr+OO
         a3l4FF6jx9mGY6XGJLBZ+Ie/24d3YnDb/5oOcBRE=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527173059uscas1p203fe28105d281a7953144f8f6448cac0~zBoWtbtGs3205732057uscas1p2H;
        Fri, 27 May 2022 17:30:59 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 95.60.09642.3DA01926; Fri,
        27 May 2022 13:30:59 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527173059uscas1p20e9182ab39dd219fe0f07a9ffe81b5de~zBoWbA9In2886928869uscas1p2Z;
        Fri, 27 May 2022 17:30:59 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-42-62910ad3030d
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 5D.A5.57470.2DA01926; Fri,
        27 May 2022 13:30:58 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 10:30:58 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 10:30:57 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH v2 8/8] examples: add 2 example job file for
 io_uring_cmd engine
Thread-Topic: [PATCH v2 8/8] examples: add 2 example job file for
        io_uring_cmd engine
Thread-Index: AQHYcSB8WMNBHPMJ2Ei4Ph8pYpC2Iq0y/L8Q
Date:   Fri, 27 May 2022 17:30:57 +0000
Message-ID: <3f857eda853f4c4187482a6695e6a025@samsung.com>
In-Reply-To: <20220526144809.14877-9-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7qXuSYmGTxZLmqx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr4++uaYwF5zgqprd+Z25g3MDRxcjJISFgIjFt
        51fmLkYuDiGBlYwSF67cYINwWpkkPj+fyAxT1TvnKStEYi2jxKrtV6GqPjFK7N71GSqzjFGi
        cUYvkMPBwSagKfF2fwFIt4hAgMTj9h1MIDXMAkcYJT613WUDSQgLhEk0939jhCgKl1h4cCYr
        hG0kceLnThaQOSwCqhInv1mCmLwCVhINL/RAKjgFbCWePFgO1skoICbx/dQaJhCbWUBc4taT
        +UwQRwtKLJq9B+oBMYl/ux6yQdiKEve/v2QHGckMdOX6XfoQrYoSU7ofsoPYvECtJ2c+YYEo
        l5Q4uOIGlD2RQ6L7aymE7SLx9dBeVghbWuLv3WVgH0oItDNKzN34BaphAqPE9SdSELa1xL/O
        a+wQy/gk/v56xDiBUXkWkrNnIZw0C8lJs5CctICRZRWjeGlxcW56arFRXmq5XnFibnFpXrpe
        cn7uJkZgwjj973D+Dsbrtz7qHWJk4mA8xCjBwawkwnvhaW+SEG9KYmVValF+fFFpTmrxIUZp
        DhYlcd5lmRsShQTSE0tSs1NTC1KLYLJMHJxSDUxO2QpVn1h83sg+0JIu7Fl67v3D664FL456
        MtRvl5t4O3CZWWsIU8RicUtXJreT930tN/nb3qg+VbfrKtNUv+ecMskCiVklW02e/5i+r3Hq
        CYYjq089/rnJfrrjZOk3FaVXbx2omHv4/vTt3cJTVXit/gU8NC2IcLlyeLqGW9O5bo/19wR+
        MRvqLZq66zHftOmbpyit4ogJ2iex5u/itukS5W9uPjXpbrba9qM9Y+Iq88uff2j2WZ172M+W
        Ij0jI8doZcf73dFXDh9m4Pt9LH+LjY1JTL1lwZWSSQqshlsvLutPnvDqcvvap+VvGmy/SUls
        UXcLiT+zj/X0BB2r5Fmy89/wX1jD9T3kRqpY+9XLSizFGYmGWsxFxYkApvNHqocDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LJbGCaqHuJa2KSwdleK4vVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZf3dNYyw4x1ExvfU7cwPjBo4uRk4OCQETid45
        T1m7GLk4hARWM0psO/+JCcL5xChx+utHNghnGaPEr01/2LsYOTjYBDQl3u4vAOkWEfCTOP9k
        KwtIDbPAEUaJT2132UBqhAXCJH7+D4GoCZf4de0WM4RtJHHi504WkBIWAVWJk98sQUxeASuJ
        hhd6EJsOM0r8O93CBlLOKWAr8eTBckYQm1FATOL7qTVMIDazgLjErSfzmSAeEJBYsuc8M4Qt
        KvHy8T9WCFtR4v73l2AXMwNdvH6XPkSrosSU7ofsIDavgKDEyZlPWCDKJSUOrrjBMoFRfBaS
        DbMQumch6Z6FpHsBI8sqRvHS4uLc9Ipio7zUcr3ixNzi0rx0veT83E2MwJg6/e9w9A7G27c+
        6h1iZOJgPMQowcGsJMJ74WlvkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHel1ET44UE0hNLUrNT
        UwtSi2CyTBycUg1M61+9m215PqNtfrGecbhadcvuW1OVDcOl959Ucjx9ZttiPjuftYYHlmfW
        1GwrYd0SFW6in3zgkkRH9kQ+g423qsM+St3+wVjoHnLrwJSIoqyF++YusrOdx5L03CU2JZE7
        /63jLZuM2ArZ4sMHjOKCiq6YuWRvc7djmXP///o7MnUluxYfM2R2+BOnd/QVw6Ztj96mCWvK
        XYr3zTgrtTiipZdLSf96+u7I1b9ubei9wnhsrbVd9HyRi30npu+Nnte/b9KNUKHjP+NK1k8R
        FS2wOLZymcubCru+p912HTeLE95tefV56ZZfrlwbRFhmuVpF7D4tUi67bFZdc0Q6l5dO+9+Y
        qJBKE2Z7u6MdP58psRRnJBpqMRcVJwIAoX0djxgDAAA=
X-CMS-MailID: 20220527173059uscas1p20e9182ab39dd219fe0f07a9ffe81b5de
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526145406epcas5p255f21b413d5dd504ff415bb38577200b
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145406epcas5p255f21b413d5dd504ff415bb38577200b@epcas5p2.samsung.com>
        <20220526144809.14877-9-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmtpdCBLdW1hciBbbWFpbHRv
OmFua2l0Lmt1bWFyQHNhbXN1bmcuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDI2LCAyMDIy
IDEwOjQ4IEFNDQo+IFRvOiBheGJvZUBrZXJuZWwuZGsNCj4gQ2M6IGZpb0B2Z2VyLmtlcm5lbC5v
cmc7IGtyaXNoLnJlZGR5QHNhbXN1bmcuY29tOw0KPiBqb3NoaS5rQHNhbXN1bmcuY29tOyBhbnVq
MjAuZ0BzYW1zdW5nLmNvbQ0KPiBTdWJqZWN0OiBbUEFUQ0ggdjIgOC84XSBleGFtcGxlczogYWRk
IDIgZXhhbXBsZSBqb2IgZmlsZSBmb3INCj4gaW9fdXJpbmdfY21kIGVuZ2luZQ0KPiANCj4gRnJv
bTogQW51aiBHdXB0YSA8YW51ajIwLmdAc2Ftc3VuZy5jb20+DQo+IA0KPiBleGFtcGxlcy91cmlu
Zy1jbWQtbmcuZmlvIGhhcyB1c2FnZSBmb3IgY29udmVudGlvbmFsIG52bWUtbnMgY2hhcg0KPiBk
ZXZpY2UNCj4gZXhhbXBsZXMvdXJpbmctY21kLXpvbmVkLmZpbyBoYXMgdXNhZ2UgZm9yIFpOUyBu
dm1lLW5zIGNoYXIgZGV2aWNlDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbnVqIEd1cHRhIDxhbnVq
MjAuZ0BzYW1zdW5nLmNvbT4NCj4gQ28tYXV0aG9yZWQtYnk6IEFua2l0IEt1bWFyIDxhbmtpdC5r
dW1hckBzYW1zdW5nLmNvbT4NCj4gLS0tDQoNCkEgbWlub3Igbml0OiBjb25zaWRlciBwdXR0aW5n
IGlvZW5naW5lPWlvX3VyaW5nX2NtZCBhbmQgY21kX3R5cGU9bnZtZSBkaXJlY3RseSBpbiB0aGUg
am9iIGZpbGUuDQoNClRlc3RlZC1ieTogVmluY2VudCBGdSA8dmluY2VudC5mdUBzYW1zdW5nLmNv
bT4NCg0K
