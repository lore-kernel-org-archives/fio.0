Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BDAC433EF
	for <fio@archiver.kernel.org>; Tue, 24 May 2022 14:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiEXOXg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 May 2022 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiEXOXd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 May 2022 10:23:33 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A96663E8
        for <fio@vger.kernel.org>; Tue, 24 May 2022 07:23:31 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220524142326usoutp015f1cd5e9a252ffe57c60d6e6d7460937~yEIvpRLot1656716567usoutp01I;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220524142326usoutp015f1cd5e9a252ffe57c60d6e6d7460937~yEIvpRLot1656716567usoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653402206;
        bh=UcFD0i3NOiIKiAoyJK6SpWI658+alFrr/u2cB/7CXeE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=XRlLuLtZLYB5nh5anaG/sGszgiTHy6uzFFW2mvquyJmSlG19Bznog6+7xGiDO/ZQA
         q8O62iHYJM76kVXimTVd/pX1N5ByVtzkHDuM7bph5IC9sENflNGJC4zFC44d3MUc7U
         D56VKNW/z2+jC/6fa4FihuP0IZXW92dec8EEmaqU=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142326uscas1p17d4dec5b6228731dc7f9a68d6b256a18~yEIvfPILn1921619216uscas1p1a;
        Tue, 24 May 2022 14:23:26 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 21.D5.09760.E5AEC826; Tue,
        24 May 2022 10:23:26 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220524142325uscas1p139f830316e1e51e34a35e1fa64923b2d~yEIu67Rkn0862908629uscas1p1J;
        Tue, 24 May 2022 14:23:25 +0000 (GMT)
X-AuditID: cbfec36d-51bff70000002620-d4-628cea5e62f3
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 96.77.52945.D5AEC826; Tue,
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
Subject: [PATCH v2 2/5] configure: refer to zlib1g-dev package for zlib
 support
Thread-Topic: [PATCH v2 2/5] configure: refer to zlib1g-dev package for zlib
        support
Thread-Index: AQHYb3nTK1F4EWnKNUmlWwh94Gawgg==
Date:   Tue, 24 May 2022 14:23:24 +0000
Message-ID: <20220524142229.135808-3-vincent.fu@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djXc7pxr3qSDLZ9ZbVYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVseblDraCNraKC8tWsDQwvmHpYuTkkBAwkVje
        1MXaxcjFISSwklHi8IM37BBOK5NEZ/82Jpiqc/8WQVWtZZTYsPYcE4TziVFiT/NPRghnGaPE
        je8fgAZzcLAJaEq83V8A0i0iECbx89F2VhCbWUBd4tjGDWwgtrBAoMSKjUvYYGr2zW9nhLD1
        JF4d28wOYrMIqErseLsJ7ApeARuJVT2d7CDjOQVsJRb+kAUJMwqISXw/tYYJYry4xK0n86GO
        FpRYNHsPM4QtJvFv10M2CFtR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDLFKUOLkzCfQIJKUOLji
        BgvIixICrRwSH+d0Qy1wkTh17RfUUGmJ6WsuQxW1M0rM3fgFqnsCo8T1J1IQtrXEv85rUJv5
        JP7+esQ4gVF5FpLDZyE5ahaSo2YhOWoBI8sqRvHS4uLc9NRiw7zUcr3ixNzi0rx0veT83E2M
        wLRx+t/h3B2MO2591DvEyMTBeIhRgoNZSYQ3JawnSYg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
        sswNiUIC6YklqdmpqQWpRTBZJg5OqQYmuwtPJwvpmpw1eMZ9heFn8Z/Wqarb7NoqnPW4Dghl
        KLlLRsWe/qL2U+Ov2f3oR3+a2Jo+BTllaHPsd1+lOsfM9oyEU+GxbTc4Apg7DP/JHKtKe+MY
        fs8kI9t5qrJpZpbWKn3HCTP/tLyMFPVwv1r81nryw1cHnoimPpt1waZVLEZDItUj6K5uQEX3
        uiOKv6N+n1xoKDIlW2vy/YNX7u09/Db6eXLBAklNX413q3Z2vW9VKZ7MdSa87Eqn7jyp179l
        uT4vcbbjPr114UTdFStWR9rM3LJMbQ3ffEM2VaEFiqd1HhSWHcw/mv7cyMKk5FXE3wiztXMm
        yk4WC9VQEjExZIy985VTVvOX0b9Zk2cpsRRnJBpqMRcVJwIARGmaFIoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCaqBv7qifJYP9HMYvVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZa17uYCtoY6u4sGwFSwPjG5YuRk4OCQETiXP/
        FrF2MXJxCAmsZpToXLOLBcL5xCjx5tFjdghnGaPEkoeLgDIcHGwCmhJv9xeAdIsIhEn8fLSd
        FcRmFlCXOLZxAxuILSwQKLFi4xI2mJoXb/+wQth6Eq+ObWYHsVkEVCV2vN3EBGLzCthIrOrp
        BIsLAdlHb+xhA1nFKWArsfCHLEiYUUBM4vupNUwQq8Qlbj2ZzwTxgIDEkj3nmSFsUYmXj/+x
        QtiKEve/v2SHqNeTuDF1ChuErS2xbOFrZoi1ghInZz6BBoSkxMEVN1gmMIrPQrJiFpL2WUja
        ZyFpX8DIsopRvLS4ODe9otg4L7Vcrzgxt7g0L10vOT93EyMwrk7/Oxyzg/HerY96hxiZOBgP
        MUpwMCuJ8KaE9SQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5/WInRgvJJCeWJKanZpakFoEk2Xi
        4JRqYFI8tGqZ+6p4I41qrxPtWWXzErlbHSayffBMte1RMLvUNOFGqCzPDF7FSP2JMve3rGvT
        Fuw8K/y7IWnxRI3T7e1P0tp3r2abm9j8uGJ3hN+vt2Gs3z/e75vZUqpald3vadj3/LUoM+Oc
        gn0r1r/9zhnI4CO6kNV7/bIbTdyd6n/tjEMiekQdm/cdeRZodXHHhJcxj/NsdKP5JPiumj/c
        v/Fl9C4mJxnur7k7g+ZUzBFlf+ce0lpQXvFm6h/VSI/wQ6G/5VOr1actfh3Zw98Xv4Ftbm2M
        X0XlzMkx/0L2dp789mFbdYf+1o6HqVc32jz/2nzgnOXZ9/e1pzI6c2pIuFo9beedEOY2h5nx
        gaSjEktxRqKhFnNRcSIAVvGe1xoDAAA=
X-CMS-MailID: 20220524142325uscas1p139f830316e1e51e34a35e1fa64923b2d
CMS-TYPE: 301P
X-CMS-RootMailID: 20220524142325uscas1p139f830316e1e51e34a35e1fa64923b2d
References: <20220524142229.135808-1-vincent.fu@samsung.com>
        <CGME20220524142325uscas1p139f830316e1e51e34a35e1fa64923b2d@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent Debian-based distributions provide zlib support in the zlib1g-dev
package.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 95b60bb7..4ee536a0 100755
--- a/configure
+++ b/configure
@@ -3142,7 +3142,7 @@ if test "$libzbc" =3D "yes" ; then
   output_sym "CONFIG_LIBZBC"
 fi
 if test "$zlib" =3D "no" ; then
-  echo "Consider installing zlib-dev (zlib-devel, some fio features depend=
 on it."
+  echo "Consider installing zlib1g-dev (zlib-devel) as some fio features d=
epend on it."
   if test "$build_static" =3D "yes"; then
     echo "Note that some distros have separate packages for static librari=
es."
   fi
--=20
2.25.1
