Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC905C4332F
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiEXOXi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiEXOXd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:33 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6379C5FF36
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142326usoutp0240a427d9a7387f07bb137b5c0172ac88~yEIvxP_Si2811228112usoutp02F;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220524142326usoutp0240a427d9a7387f07bb137b5c0172ac88~yEIvxP_Si2811228112usoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402206;
        bh=izL47GJbq9R79VVqB1qGhtRqoK/EDmUxEgcLfPKxwhA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=KASX17YyMBag50sZl2CYKtpxIZ3RXfKuhUjGTEk3n4AbYrslaqY52zgvhtZBC/0dS
         48VBIRvzd3mBxXmKguTMiI4SFUMYzJ1mfN8fxd1NozV9QMM+y+idoFwktmhUDvTe4h
         N/nJ5xOuGJdf8ta9ALq4XOpE+eCIlesvWXyQY2ro=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p1cee919946a3ed8177b814c7b9c8fc1c7~yEIvl1x4-1921619216uscas1p1c;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 91.D5.09760.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220524142325uscas1p269230921c0498a1c6205a132440d2f30~yEIvIcBqx0353603536uscas1p2B;
        Tue, 24 May 2022 14:23:25 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-d5-628cea5ed57a
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id C6.77.52945.D5AEC826; Tue,
        24 May 2022 10:23:25 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 24 May 2022 07:23:24 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        24 May 2022 07:23:24 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2 3/5] HOWTO: add blank line for prettier formatting
Thread-Topic: [PATCH v2 3/5] HOWTO: add blank line for prettier formatting
Thread-Index: AQHYb3nUIyBSlFWcB06Pne3zouW/wg==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-4-vincent.fu@samsung.com>
In-Reply-To: <20220524142229.135808-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djX87pxr3qSDD4s5rFYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcfzSEbaCn6wVcy//Z2pg/MDSxcjBISFgIrH0
        W0QXIxeHkMBKRonnh38xQTitTBLT/xxk7GLkBCt6vrObHSKxllHi2ecNzBDOJ0aJPc0/GSGc
        ZYwSN75DzGUT0JR4u78ApFtEIEzi56PtrCA2s4C6xLGNG9hAbGEBV4mWm0/ZIWq8JD7tWcgE
        YetJ7P14kwXEZhFQldjxdhNYnFfARmJR/y9GkPGcArYSC3/IgoQZBcQkvp9awwQxXlzi1pP5
        TBBHC0osmr2HGcIWk/i36yEbhK0ocf/7S3aIej2JG1OnsEHY2hLLFr5mhlglKHFy5hMWiHpJ
        iYMrbrCAvCgh0MohsXXxOXaIhIvE7mWvWCFsaYnpay5DFbUzSszd+AWqewKjxPUnUhC2tcS/
        zmtQm/kk/v56xDiBUXkWksNnITlqFpKjZiE5agEjyypG8dLi4tz01GLDvNRyveLE3OLSvHS9
        5PzcTYzApHH63+HcHYw7bn3UO8TIxMF4iFGCg1lJhDclrCdJiDclsbIqtSg/vqg0J7X4EKM0
        B4uSOO+yzA2JQgLpiSWp2ampBalFMFkmDk6pBqbitDVs+3b6cR3cpKSvudhz/f+rfyQEljNe
        f3XyJuc07gczVl17eyX70Vfnzs3PpojbCAesSfy2eNpFVz3Tvr3MPBlvo2X5pA2mqKhHFrMc
        78/5ddfhtrDgb0/WRZ9iih7NcGfYHFzYsvGG0xuLbVmysoUJU53rPHJDTUTVOV8fbpPbkLvg
        4kMnF+nd1pJLWvf+fC0jsn0tw8YKk9073t6qZc/8E6X0u2J17e1TpvcnLjWculu6RZL3HbOR
        Zc/r1L+rbzTN+bDxjqfZr3OzlVPPvbM/aRDO9tjhQtbhvxvm3pzW3nrzrd4SsW3W98+9aDwo
        p2Gh/lwhVGaTQUhoX29vq2zbu4QVe59/2Pf8opqkEktxRqKhFnNRcSIApef4hYkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqBv7qifJYMIrNYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZxy8dYSv4yVox9/J/pgbGDyxdjJwcEgImEs93
        drN3MXJxCAmsZpSY9+UxG4TziVHizaPHUJlljBJLHi4CauHgYBPQlHi7vwCkW0QgTOLno+2s
        IDazgLrEsY0b2EBsYQFXiZabT9kharwkPu1ZyARh60ns/XgTbDOLgKrEjrebwOK8AjYSi/p/
        MYLYQkD20Rt72EBWcQrYSiz8IQsSZhQQk/h+ag0TxCpxiVtP5jNBPCAgsWTPeWYIW1Ti5eN/
        rBC2osT97y/ZIer1JG5MncIGYWtLLFv4mhliraDEyZlPoAEhKXFwxQ2WCYzis5CsmIWkfRaS
        9llI2hcwsqxiFC8tLs5Nryg2zkst1ytOzC0uzUvXS87P3cQIjKvT/w7H7GC8d+uj3iFGJg7G
        Q4wSHMxKIrwpYT1JQrwpiZVVqUX58UWlOanFhxilOViUxHk9YifGCwmkJ5akZqemFqQWwWSZ
        ODilGpis0upb1kqWFl6qe7pwV3lq87f18WURZ72O7Pq1c+a+DmeRZ47V9zpzHSPs9n3d6G4q
        oeJ8jf90Fhdbj7CAbGh83+GcSXVHC/PmOCUweuWc4xPhvvVEZy5XwzNVtmK5LGFRLrOptVe3
        tW3OCXzxL+V+cNzV0jM5Dy7nuJQJyfP++yAqfOJOM8PXyz3O4csvzebhVn699MWTJYubsoz2
        ZR0TFPr/oCekYs+V1QodL3b22eTl1AtN4dhZJNHh6XQgsOexIlPmv13ScU9Ud61UEoq7Vuj8
        4fLV91G+/88u9TdZGFQdnKR5u1z42zKeFV96D6mzX3zxwfVL/KPcsCKN/L0xa5+lyJWyr7e4
        xdm9UomlOCPRUIu5qDgRACMHwaQaAwAA
X-CMS-MailID: 20220524142325uscas1p269230921c0498a1c6205a132440d2f30
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142325uscas1p269230921c0498a1c6205a132440d2f30
References: <20220524142229.135808-1-vincent.fu@samsung.com>
        <CGME20220524142325uscas1p269230921c0498a1c6205a132440d2f30@uscas1p2.samsung.com>
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
