Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DF4C636D4
	for <fio@archiver.kernel.org>; Fri, 17 Feb 2023 07:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBQHIg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 17 Feb 2023 02:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQHIe (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Feb 2023 02:08:34 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7C69EC6
        for <fio@vger.kernel.org>; Thu, 16 Feb 2023 23:08:32 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230217070831epoutp01532d1b38f04bba4b998710034668361a~EiuzUducY0939909399epoutp01A
        for <fio@vger.kernel.org>; Fri, 17 Feb 2023 07:08:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230217070831epoutp01532d1b38f04bba4b998710034668361a~EiuzUducY0939909399epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676617711;
        bh=k31NfO8AuENqL6eKG6KGQ00T9Jc622S9WX61Ky/kSdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmQFQ45S11LmjExBGL00yYDJLLWSQZDbP6WTxNS5vDFZEZiChjPszwnLlrWh6mAaw
         IXJVDcnyojbjaiJ/3N4JmVbAX7LyTK1oQZ1SCoilGdVhzisqjA+EP+FhcwI5VhdIIL
         WCw+iXwXPBmp6NRVSC8v4EVsGQM61YL4uYzQm/I8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230217070830epcas5p2d3b8acf65cb8e0f2af1207228eebba05~EiuzClUzi0794507945epcas5p21;
        Fri, 17 Feb 2023 07:08:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4PJ2wF45wMz4x9Pt; Fri, 17 Feb
        2023 07:08:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.60.10528.DE72FE36; Fri, 17 Feb 2023 16:08:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230217070403epcas5p2f01122718255b22f003ba9f77f92f3b2~Eiq6iZ7x61533215332epcas5p2F;
        Fri, 17 Feb 2023 07:04:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230217070403epsmtrp2c8aa696c77dc0b9ff747a838c80b5025~Eiq6hvXMn2860028600epsmtrp2c;
        Fri, 17 Feb 2023 07:04:03 +0000 (GMT)
X-AuditID: b6c32a49-c17ff70000012920-c8-63ef27ed3eda
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.E9.17995.3E62FE36; Fri, 17 Feb 2023 16:04:03 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230217070403epsmtip10224c476ae67df63d8432ec0ecf1c573~Eiq5zhdkQ1450814508epsmtip1U;
        Fri, 17 Feb 2023 07:04:03 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] backend: fix runtime when used with thinktime
Date:   Fri, 17 Feb 2023 12:33:22 +0530
Message-Id: <20230217070322.14163-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217070322.14163-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmuu5b9ffJBuumS1usufKb3WL13X42
        i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsbD1IWPBF8GK56+amBoYl/F1MXJy
        SAiYSCzrPsTexcjFISSwm1Hi45tjzBDOJ0aJLV07WCCcz4wSd08sYINp+fvsGZgtJLCLUeJs
        HxeE3cwkcfBhAojNJqAt8ertDWYQW0RAWGJ/RysLiM0sECpx8toXdhBbWMBJYvf9/WA1LAKq
        Eh/OPQKzeQVsJPbuf8wIsUteYvWGA2BxTgFbiY7l28GukxBYxi5xY/ltZogiF4kLH9+zQ9jC
        Eq+Ob4GypSQ+v9sLdXS2xKaHP5kg7AKJIy96oXrtJVpP9QPZHEDHaUqs36UPEZaVmHpqHRPE
        zXwSvb+fQLXySuyYB2OrSvy9d5sFwpaWuPnuKpTtIdG1+DQ0SCcwSuy+tZZ9AqPcLIQVCxgZ
        VzFKphYU56anFpsWGOallsMjLTk/dxMjOE1pee5gvPvgg94hRiYOxkOMEhzMSiK8m26+SRbi
        TUmsrEotyo8vKs1JLT7EaAoMwInMUqLJ+cBEmVcSb2hiaWBiZmZmYmlsZqgkzqtuezJZSCA9
        sSQ1OzW1ILUIpo+Jg1OqgWnpsVrnv95mqq9sZ916GdsxLdFl5Z435+PeXoz7xz2h+zS/a1mq
        bxPHIj4btruv5YP2ckocy8iW/eqZ9bz0aAH7rSkdsRc+3vlV+fu10j8BmbuXFq2K8b0QfLu0
        5r70hD9G31ds+sPb9ji8dkb5i5dzlY0upwYzyhpMOHL4tn9/ijuLaFD/q7h0t769QXPWX5f8
        eVUruq9g9ddf7zWMzdovXw9a0fOr5mJW9kk+zpTTs34EXpT9uPm/5+a0J5wpCuJL6p7ltp9z
        FFL++W+Ga8x7WY8bizdV3/j9c9Zx9XOHAnjuMQhe2C6zcvfkRW6HfJ/qFfg+VXsisGrx0++C
        Lw5sdg5K/ndqZoS8WrF/4gZBJZbijERDLeai4kQAAyo2t9wDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJTvex2vtkg8bXxhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGUsbH3IWPBF
        sOL5qyamBsZlfF2MnBwSAiYSf589Y+ti5OIQEtjBKDF313LWLkYOoIS0xML1iRA1whIr/z1n
        h6hpZJJ4uvkEC0iCTUBb4tXbG8wgtghQ0f6OVrA4s0C4xPQDkxlBbGEBJ4nd9/eD1bAIqEp8
        OPcIzOYVsJHYu/8xI8QCeYnVGw6AxTkFbCU6lm8Hs4WAaho6Z7NPYORbwMiwilEytaA4Nz23
        2LDAKC+1XK84Mbe4NC9dLzk/dxMjOJC0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeTTffJAvxpiRW
        VqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAdGIHx7ebgUs0HhxK
        zKl69Pzblurm1/dXPNI4+TE1K0XDXjxwAW8GS/s+iytHVvoIR6z//lTo+sTGY2qGi1uUcz1y
        Jp62XvfIOoZLbl7gmfKXPHEbxW+wNUebJX+9NYG599n5y9u/bHVYay1dV3/5mEHm5TYZDVPn
        IGkX367li01qWMPOd78LCQ8wit1xwUTSbNKBfXc0LvZMvsm6SGXikTyVh7lG32cmR2kneEVn
        Xw3/KpFze1dheLpR5tPTl9gncju17wrcn/1h3aTmDe5zzxkqHWK4N/fMrL1u39fJJp0W+MER
        0Tt7ZeYuzYxK8UWFrdEHww++/JNhsrWuNIDDaeX6yg9FPx4o2vqFbJinqcRSnJFoqMVcVJwI
        AB9MJ92TAgAA
X-CMS-MailID: 20230217070403epcas5p2f01122718255b22f003ba9f77f92f3b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230217070403epcas5p2f01122718255b22f003ba9f77f92f3b2
References: <20230217070322.14163-1-ankit.kumar@samsung.com>
        <CGME20230217070403epcas5p2f01122718255b22f003ba9f77f92f3b2@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Runtime for fio jobs when used in conjuction with thinktime,
thinktime_iotime and thinktime_spin were sometimes more than
what is specified. Add a fix so that fio doesn't spin or sleep
for any duration beyond runtime.

For the first cycle fio starts by doing I/O for
thinktime + thinktime_iotime, which should just be for
thinktime_iotime. Add a fix for that.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 backend.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/backend.c b/backend.c
index 0ccc7c2b..995be032 100644
--- a/backend.c
+++ b/backend.c
@@ -866,6 +866,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 			     struct timespec *time)
 {
 	unsigned long long b;
+	unsigned long long runtime_left;
 	uint64_t total;
 	int left;
 	struct timespec now;
@@ -874,7 +875,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 	if (td->o.thinktime_iotime) {
 		fio_gettime(&now, NULL);
 		if (utime_since(&td->last_thinktime, &now)
-		    >= td->o.thinktime_iotime + td->o.thinktime) {
+		    >= td->o.thinktime_iotime) {
 			stall = true;
 		} else if (!fio_option_is_set(&td->o, thinktime_blocks)) {
 			/*
@@ -897,11 +898,24 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 
 	io_u_quiesce(td);
 
+	left = td->o.thinktime_spin;
+	if (td->o.timeout) {
+		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
+		if (runtime_left < (unsigned long long)left)
+			left = runtime_left;
+	}
+
 	total = 0;
-	if (td->o.thinktime_spin)
-		total = usec_spin(td->o.thinktime_spin);
+	if (left)
+		total = usec_spin(left);
 
 	left = td->o.thinktime - total;
+	if (td->o.timeout) {
+		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
+		if (runtime_left < (unsigned long long)left)
+			left = runtime_left;
+	}
+
 	if (left)
 		total += usec_sleep(td, left);
 
@@ -930,8 +944,10 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 		fio_gettime(time, NULL);
 
 	td->last_thinktime_blocks = b;
-	if (td->o.thinktime_iotime)
+	if (td->o.thinktime_iotime) {
+		fio_gettime(&now, NULL);
 		td->last_thinktime = now;
+	}
 }
 
 /*
-- 
2.17.1

