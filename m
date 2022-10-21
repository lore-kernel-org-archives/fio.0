Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48405C4332F
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 07:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJUHOm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 03:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJUHOj (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 03:14:39 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAC13F30F
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 00:14:35 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221021071431epoutp049f99404822dc7ee9c55ba7a997c157e7~gBDEm91FM2755327553epoutp04-
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 07:14:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221021071431epoutp049f99404822dc7ee9c55ba7a997c157e7~gBDEm91FM2755327553epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666336471;
        bh=ozyspuzrC5djaFOB6zO/A7aFUR3+0fagtHoRZPBAJNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9hZGD2BU1C2CEiDfcjD4rB7cG4tUQUQH8fnXACHu3uAYKZjuqCkeJwe4VrFh6V0s
         dNkcdDtS+k7IN8gOIDUI2Ot3Z0qDEQZQWEq7WwOhNgOmRTDJFElbZhWy/NcTiWWlXL
         mDP8jhIIQoftc2bXFvQ9U6O87YM61m0lepGMypKI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221021071430epcas5p1b781bba20d4b82b3478940ae87d7ae43~gBDENLQNZ1107211072epcas5p1P;
        Fri, 21 Oct 2022 07:14:30 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mtwh55lBvz4x9Q1; Fri, 21 Oct
        2022 07:14:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.D0.56352.5D642536; Fri, 21 Oct 2022 16:14:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221021070024epcas5p1681096dac12973aaa9c25658ad5e2287~gA2wElc0x1535115351epcas5p1j;
        Fri, 21 Oct 2022 07:00:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021070024epsmtrp1611d40fab72523b38a30ca074afc145f~gA2wD8N2-2613626136epsmtrp1i;
        Fri, 21 Oct 2022 07:00:24 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-4a-635246d5244b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.E8.18644.88342536; Fri, 21 Oct 2022 16:00:24 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221021070023epsmtip291dafd4489f64799e67541a78cf3c22e~gA2vP7Ttw1507115071epsmtip2c;
        Fri, 21 Oct 2022 07:00:23 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] stat: fix segfault with fio option bandwidth-log
Date:   Fri, 21 Oct 2022 12:19:00 +0530
Message-Id: <20221021064900.12341-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021064900.12341-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmpu5Vt6Bkg91bWC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOeDLbs+ATW8WXRQ9ZGxiPsHYxcnJI
        CJhIzDlzjbmLkYtDSGA3o8TuaVuZIJxPQM72d4wgVUICnxklmvbnwXQ8+DqbBaJoF6PEmuMf
        WCGcViaJhXs/gnWwCWhLvHp7gxnEFhEQltjf0coCYjMLhEqcvPaFHcQWFnCVOD7nPVg9i4Cq
        xLvpa9lAbF4BG4mG43NZILbJS6zecABsDqeArUTHn1tsEPFV7BJ35thB2C4Scw9thPpHWOLV
        8S3sELaUxMv+Nig7W2LTw59MEHaBxJEXvcwQtr1E66l+IJsD6DZNifW79CHCshJTT61jgjiZ
        T6L39xOoVl6JHfNgbFWJv/duQ50pLXHz3VUWkDESAh4SGy7GQ4JkAqPEpPPTWSYwys1C2LCA
        kXEVo2RqQXFuemqxaYFxXmo5PMqS83M3MYJTlJb3DsZHDz7oHWJk4mA8xCjBwawkwlvwLiBZ
        iDclsbIqtSg/vqg0J7X4EKMpMPgmMkuJJucDk2ReSbyhiaWBiZmZmYmlsZmhkjjv4hlayUIC
        6YklqdmpqQWpRTB9TBycUg1MzhuvnmnfP6nv0OR5J3+dFchk67nmFe0lOu3mJJHcT2/92HQe
        F20tvim9+P4dtc9rBI+Fv2Q025z1v9Jk9YPE6WtnCW2cmLDubPvy2Zrawa6OV8QUTXk9Pv7g
        u/kxpY/TZ4XM1rtMAbcStEvuaJXqLZuU9Gfi0nW/GJxPha+M2efj9mHBeZndT/fba9hvKffY
        eEZMVz1sxSqrT9d+Rb3YculmXjhDXMqLxqlrmRkjFqutv3+4aL7MFfnNGtf0rFym+Ai2r5No
        luOu0Qwpa5wtw+398YqkzXrfsjZ3m6hZaf5F8T7n8xIqI+1yqrlmTRA8EcjRH9s+pe5Mjsu9
        BpfLG5lP3HVz2WStcvHOauZVSizFGYmGWsxFxYkAQKLmfdoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvG6Hc1CyweZDihZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGU8me1Z8Imt
        4suih6wNjEdYuxg5OSQETCQefJ3N0sXIxSEksINR4tOme4xdjBxACWmJhesTIWqEJVb+e84O
        UdPMJLFy7xEWkASbgLbEq7c3mEFsEaCi/R2tYHFmgXCJ6QcmM4LYwgKuEsfnvAezWQRUJd5N
        X8sGYvMK2Eg0HJ/LArFAXmL1hgNgczgFbCU6/twCqxECqpm24zHjBEa+BYwMqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxgsNIS2sH455VH/QOMTJxMB5ilOBgVhLhLXgXkCzEm5JY
        WZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDE5NpT9Y+1kXn55Z9
        XqLdWxCR5/GW73DzX4mA3pn/VN1O+xmfu3z1ZbK0iPjOf2tyg0s3haX+Ypt9MeNH0M83B6X4
        TjyIjmO7YF25WUqz0PXLu/Oq59/Ma2/Ykf9gW5pWGl9j1IS1qe++r3m2tFb4TwS/f3fwl6Ss
        1HMsyZMfT7zaf/R8TC17TGER728u5Rc/KpYyXlld+3vt05INqxbXSrp55YQVSe3c+Hjuh09X
        5m67a2DReSs5oOrZlEkGxu6XLknOzd5lsc2Mr7j7WwX7+tiYGmM9lb8il17dkvj/0c10wROZ
        l1Nuu7SyvHaRNG398mT1qbOfLZOvHitpSfi1v/77Pdn585k/c1t3O+6oPq/EUpyRaKjFXFSc
        CADs+wEtkgIAAA==
X-CMS-MailID: 20221021070024epcas5p1681096dac12973aaa9c25658ad5e2287
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021070024epcas5p1681096dac12973aaa9c25658ad5e2287
References: <20221021064900.12341-1-ankit.kumar@samsung.com>
        <CGME20221021070024epcas5p1681096dac12973aaa9c25658ad5e2287@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The log_params for aggregate read, write and trim only specify
log type. As a result the io_log doesn't have the relevant
thread_data structure. With fio option bandwidth-log this results
in segmentation fault.
Add a check and use DEF_LOG_ENTRIES for such case.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index 949af5ed..b963973a 100644
--- a/stat.c
+++ b/stat.c
@@ -2870,7 +2870,10 @@ static struct io_logs *get_new_log(struct io_log *iolog)
 	 * forever
 	 */
 	if (!iolog->cur_log_max) {
-		new_samples = iolog->td->o.log_entries;
+		if (iolog->td)
+			new_samples = iolog->td->o.log_entries;
+		else
+			new_samples = DEF_LOG_ENTRIES;
 	} else {
 		new_samples = iolog->cur_log_max * 2;
 		if (new_samples > MAX_LOG_ENTRIES)
-- 
2.17.1

