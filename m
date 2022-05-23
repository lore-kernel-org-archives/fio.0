Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD167C4321E
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiEWSmZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiEWSll (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:41:41 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81FD18AAA4
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:22:37 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175713usoutp0238d3375f35e1a8567167c677a9bfdb9f~xzaIB_wBg2714927149usoutp02K;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523175713usoutp0238d3375f35e1a8567167c677a9bfdb9f~xzaIB_wBg2714927149usoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328633;
        bh=izL47GJbq9R79VVqB1qGhtRqoK/EDmUxEgcLfPKxwhA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Axl6qusUvJrbm2DSC8dXRtE4/Gs1gBhiIpt9Nryix3ZS/qYW5vsvfku0gcrKEqxE5
         YC9JNh/WLFk2pee9MJgrdNRh/b37VImintY5nZNvyrVEJqH8iXwuI2BOfOUDKn9JGA
         0wjWdZ3cGAZVMdBBAWoERXcBpVHop9BN0Q0KS4rE=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p2eea0d9f68d9ce1619e4c3ee58b64f3ef~xzaH8ZZpT2501325013uscas1p2M;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id E2.1A.09642.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p1fdef83b69c4e85c245176318cbec3dee~xzaHd-Yna0796107961uscas1p1s;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-cb-628bcaf9040f
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 73.5D.57470.9FACB826; Mon,
        23 May 2022 13:57:13 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:12 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:12 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/6] HOWTO: add blank line for prettier formatting
Thread-Topic: [PATCH 3/6] HOWTO: add blank line for prettier formatting
Thread-Index: AQHYbs6Hmebgk5zmEECTW7BME0MZxA==
Date:   Mon, 23 May 2022 17:57:12 +0000
Message-ID: <20220523175650.130895-4-vincent.fu@samsung.com>
In-Reply-To: <20220523175650.130895-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7o/T3UnGazZZmCx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr4/ilI2wFP1kr5l7+z9TA+IGli5GDQ0LARGJj
        S1oXIxeHkMBKRomVczvYIJxWJon5Xx7DFe37HgkRX8sosX/pVaiiT4wSi878Y4FwljFK/Lz8
        gRmkg01AU+Lt/oIuRk4OEYEwiZ+PtrOC2MwC6hLHNm5gA7GFBZwkrj1bwwxR4y7x5PwcRghb
        T+Lz5AdMIDaLgKrEon9XweK8AjYSu5+/ZQexOQVsJXYu+gxmMwqISXw/tYYJYr64xK0n88Fs
        CQFBiUWz9zBD2GIS/3Y9ZIOwFSXuf3/JDlGvJ3Fj6hQ2CFtbYtnC18wQuwQlTs58wgJRLylx
        cMUNsB8lBDo5JF4vPAa1wEXi/rUGVghbWuLv3WVMEEXtjBJzN36B6p7AKHH9iRSEbS3xr/Ma
        1GY+ib+/HjFOYFSeheTwWUiOmoXkqFlIjlrAyLKKUby0uDg3PbXYKC+1XK84Mbe4NC9dLzk/
        dxMjMGmc/nc4fwfj9Vsf9Q4xMnEwHmKU4GBWEuHdntiRJMSbklhZlVqUH19UmpNafIhRmoNF
        SZx3WeaGRCGB9MSS1OzU1ILUIpgsEwenVAOTx/WafbYCTwty+U7teRBRHyT3eEPtyux9bfe8
        Q6v7Q67nZujcyq2zEOBMs3p9sN+cz3LCue2P1n98PyUxRXvhtK+u9TYZtnM0UostjZhmPzrx
        Pd7m1E3TLU0Ldkv9jO+cKdnzUajeRYXhXkNc0pSfB8XnRxakxBnlivQdtz5lt/jpLr+pwuc9
        plk6FMlELVfa+qRiUZxDwCImFVbZiWEyz/LKFhyXWXWNz77hV7tC5BezR+ICS1UDzhvsymoT
        mXPu0+n3KXfLr5VWTXwjyeYRdbKx0qAlz2sd17zjTf/vPwjWTlhUvYzz5p73RuHLN0tpSIt8
        146bI+3NqzZn/alZa9Y9VDZujD6VYjaf/YASS3FGoqEWc1FxIgCn1GA1iQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqPvzVHeSwdGZPBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyjl86wlbwk7Vi7uX/TA2MH1i6GDk4JARMJPZ9
        j+xi5OIQEljNKNG6uJ8FwvnEKHHq2SQoZxmjxK/L75hAOtgENCXe7i/oYuTkEBEIk/j5aDsr
        iM0soC5xbOMGNhBbWMBJ4tqzNcwQNe4ST87PYYSw9SQ+T37ABGKzCKhKLPp3FSzOK2Ajsfv5
        W3YQWwjI/vqlgwXE5hSwldi56DNYnFFATOL7qTVMELvEJW49mQ9mSwgISCzZc54ZwhaVePn4
        HyuErShx//tLdoh6PYkbU6ewQdjaEssWvmaG2CsocXLmExaIekmJgytusExgFJ+FZMUsJO2z
        kLTPQtK+gJFlFaN4aXFxbnpFsVFearlecWJucWleul5yfu4mRmBcnf53OHoH4+1bH/UOMTJx
        MB5ilOBgVhLh3Z7YkSTEm5JYWZValB9fVJqTWnyIUZqDRUmc92XUxHghgfTEktTs1NSC1CKY
        LBMHp1QDU+GM/zqlt9fzHpnx29LrXam224bUCrecqhNhgQeLHwfWbS27t3b9p4KpLa57tt+7
        qqJscDJNX3h+6+sGlcKG0Fl/71xbX/XYrnJ+31yun0qJBWvLFFY8ZWZgm3ctiXWrk3Hvbenl
        XCVvzDrDLrQvX7f1InPhY6k81fas0GVpH6IXJcaWeBQphKwXdA75YxVdNbNXN8/4lOrpc88q
        OLttFXnqHy5cFKk1a/4iF3et07cFzWyrms4UP9p+/L7+ivd2PnffcBXtNnnlFjFxpejl69eZ
        JhdpzH5ZyWNTVs4aOSGtKTg79VW5n9kGXoVpVSW7EvUvp1QKeofk73/m3sz1tPDmq/jP0+ti
        HoZHJ6UqsRRnJBpqMRcVJwIArPYB0hoDAAA=
X-CMS-MailID: 20220523175713uscas1p1fdef83b69c4e85c245176318cbec3dee
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175713uscas1p1fdef83b69c4e85c245176318cbec3dee
References: <20220523175650.130895-1-vincent.fu@samsung.com>
        <CGME20220523175713uscas1p1fdef83b69c4e85c245176318cbec3dee@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

There needs to be a blank line between the name of an option and its
description in order for the formatting to look nice at
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ignore-zone=
-limits,

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index 84bea5c5..eee386c1 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1064,6 +1064,7 @@ Target file/device
 	thread/process.
=20
 .. option:: ignore_zone_limits=3Dbool
+
 	If this option is used, fio will ignore the maximum number of open
 	zones limit of the zoned block device in use, thus allowing the
 	option :option:`max_open_zones` value to be larger than the device
--=20
2.25.1
