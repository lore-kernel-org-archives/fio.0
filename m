Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1423C433EF
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 21:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383173AbhLCVOj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:14:39 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13307 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbhLCVOi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Dec 2021 16:14:38 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20211203211113usoutp02e19022937acf6357aaa73e3c589fbc92~9WvsFqa3y2719027190usoutp02Y;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20211203211113usoutp02e19022937acf6357aaa73e3c589fbc92~9WvsFqa3y2719027190usoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1638565873;
        bh=vqz4eNMQyhR9Rc2LgGYRUq6V6DOGYOvvHxTfIunDqyY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=p9TnCZKx2ZOIzmD5N0ByLZJoESKAptNhcaj4oLhpOHs2k0lTo7Zc5nPqA7M8HfWy6
         aw0wB++B18DQv7zO632CmqNs1w90eSLr68VJNucAstloxZ7XUKxq1a0QNLsbdQw4J8
         hJDTw3MoAwYBfTUSIV8utCIoN/MFeRaxZiQfPX2U=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211203211113uscas1p2e09bf35837e8b74c3b30d661dbf15dca~9Wvr-Xrxx2327923279uscas1p2v;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 06.B4.10104.1F78AA16; Fri, 
        3 Dec 2021 16:11:13 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211203211113uscas1p11b7b2306b70944816d8bb99624dc10b5~9WvrvgvNL1936919369uscas1p1i;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
X-AuditID: cbfec36f-315ff70000002778-3f-61aa87f18a1d
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 65.8B.09671.0F78AA16; Fri, 
        3 Dec 2021 16:11:12 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 3 Dec 2021 13:10:10 -0800
Received: from SSI-EX1.ssi.samsung.com ([::1]) by SSI-EX1.ssi.samsung.com
        ([fe80::f93d:5544:8666:3356%7]) with mapi id 15.01.2242.008; Fri, 3 Dec 2021
        13:10:10 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/2] libfio: drop unneeded reset of rwmix_issues
Thread-Topic: [PATCH 2/2] libfio: drop unneeded reset of rwmix_issues
Thread-Index: AQHX6Ion5Bl50+BB8Eeh+pdPll++BQ==
Date:   Fri, 3 Dec 2021 21:10:10 +0000
Message-ID: <20211203211050.51241-3-vincent.fu@samsung.com>
In-Reply-To: <20211203211050.51241-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7djXc7of21clGnycpmmx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr49b02ywF7awVB47OZ21g7GPpYuTkkBAwkXhx
        bDkbiC0ksJJRYtER3i5GLiC7lUni+uKDcEVb155kg0isZZR4s+0MK4TzgVHieNMWRggHqP3X
        3c3sXYwcHGwCmhJv9xeAdIsIhEn8fLSdFcRmFlCXOLZxA9g6YQEHiZ6DJ1kgalwlFt07wAph
        60l87T4CFmcRUJH4trGfFWQkr4C1xJ5VwSBhTgEbiZ232phBbEYBMYnvp9YwQYwXl7j1ZD4T
        xNGCEotm72GGsMUk/u16yAZhK0rc//6SHaJeT+LG1ClsELa2xLKFr8HqeYF6T858AvW8pMTB
        FTdYQF6UEOjkkDjT+4IVIuEicWv7Zqhl0hJXr0+FWnaOUeLBv2CIhuuMEiu+LIZqsJZY+Gc9
        1KV8En9/PWKcwKg8C8nhs5AcNQvJUbOQHLWAkWUVo3hpcXFuemqxUV5quV5xYm5xaV66XnJ+
        7iZGYNI4/e9w/g7G67c+6h1iZOJgPMQowcGsJMJrUrkqUYg3JbGyKrUoP76oNCe1+BCjNAeL
        kjjv6T8NiUIC6YklqdmpqQWpRTBZJg5OqQYmEWcZw4yJdUbTlWQXz3sh71bNFLj5UfBnmY0l
        Yg2fNvNNbg48y6tn2nPw6zM5u8Pt7x8WBah8W8onxPpQ+//s/aICVw0+Zp0KlPDjarvA/G7j
        F8XplXs2Gz3ya+X9ZHf5iiefaelpXf3971XOeGm470tXn//iePqeaDM5len77xhIf8pbETfb
        YbWE1HqTvQbP32648S31wtr9j64Wq6kk3Jjy5RLvs+vazQrX2SVXyX5VtdN/cee/sfbCzHrF
        i0c/2+59eD//Zq5TxO8QG2eOtQwndvSoiGk9ePs6LH33gjVB7s/efnQuMXZiuax7884XtfiW
        WdEcB075+wp/XuvREbFtd9Hi0qua73faOLm+UGIpzkg01GIuKk4EALYfaamJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LJbGCaqPuxfVWiwXsNi9V3+9ksPs56wezA
        5HH5bKnH501yAUxRXDYpqTmZZalF+nYJXBm3pt9mKWhnrThwdD5rA2MfSxcjJ4eEgInE1rUn
        2boYuTiEBFYzSjx/vY8dwvnAKHFi80ZGCGclo0R3y28gh4ODTUBT4u3+ApBuEYEwiZ+PtrOC
        2MwC6hLHNm5gA7GFBRwkeg6eZIGocZVYdO8AK4StJ/G1+whYnEVAReLbxn5WkJG8AtYSe1YF
        g4SFgMzDHc/ASjgFbCR23mpjBrEZBcQkvp9awwSxSlzi1pP5TBAPCEgs2XOeGcIWlXj5+B8r
        hK0ocf/7S3aIej2JG1OnsEHY2hLLFr4Gq+cVEJQ4OfMJNCAkJQ6uuMEygVF8FpIVs5C0z0LS
        PgtJ+wJGllWM4qXFxbnpFcWGeanlesWJucWleel6yfm5mxiBUXX63+HIHYxHb33UO8TIxMF4
        iFGCg1lJhNekclWiEG9KYmVValF+fFFpTmrxIUZpDhYlcV4h14nxQgLpiSWp2ampBalFMFkm
        Dk6pBqZT0+L3Jc+9Yf1cmFGi4pNZNAv/pIfx3LUqlooiplW/T4tZN2gxT5+ouEGeq5aFKeKL
        c8OWH4kX8soWRFs8PmzT0D8lbPa04O77K0P+vStZ9Shq7t0fVR/e1m4t/SEsvfec/o9r/pES
        unPPhZ6o8Y2SNHP5H7TZpt88JJlrxtJfHF1GJbd+v4vyNvT+PGXanf5XKtcX9r4OubE/kL38
        3Yfq5E5ro3MWGgsi2O9Jxdl7miut2684kaerJ+LkA7kruqevHllX07eE59faXOnXXeXPV7xW
        eWvXnG62UHOf3Okfy9i97yY1/c+UvTfFcdqzpwL75vXtOH5CI3vuu7fJj/e/Mp5tvPKOftjb
        fd0Tb2UosRRnJBpqMRcVJwIAxjye3hkDAAA=
X-CMS-MailID: 20211203211113uscas1p11b7b2306b70944816d8bb99624dc10b5
CMS-TYPE: 301P
X-CMS-RootMailID: 20211203211113uscas1p11b7b2306b70944816d8bb99624dc10b5
References: <20211203211050.51241-1-vincent.fu@samsung.com>
        <CGME20211203211113uscas1p11b7b2306b70944816d8bb99624dc10b5@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

We don't need to repeatedly reset rwmix_issues inside a loop. We
actually don't need to reset it at all inside reset_all_stats() because
this is already done in reset_io_counters().

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 libfio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libfio.c b/libfio.c
index ed5906d4..198eaf2e 100644
--- a/libfio.c
+++ b/libfio.c
@@ -140,7 +140,6 @@ void reset_all_stats(struct thread_data *td)
 		td->io_issues[i] =3D 0;
 		td->ts.total_io_u[i] =3D 0;
 		td->ts.runtime[i] =3D 0;
-		td->rwmix_issues =3D 0;
 	}
=20
 	set_epoch_time(td, td->o.log_unix_epoch);
--=20
2.25.1
