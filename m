Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198C4C433EF
	for <fio@archiver.kernel.org>; Wed, 22 Jun 2022 12:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiFVMaE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Jun 2022 08:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiFVMaE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Jun 2022 08:30:04 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C150862F8
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 05:30:02 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220622122959epoutp0311358f4d72b0c7fc1643f7cacd79e956~68S_DxEnn1390413904epoutp03Z
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 12:29:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220622122959epoutp0311358f4d72b0c7fc1643f7cacd79e956~68S_DxEnn1390413904epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655900999;
        bh=heDDC8fiIcgnJEOTbpkDyA2ncqb66O9WXPEhNwqo41Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPEvV8Bhsqyq/WGW93TY9n3KkzRGM5obIX4Jo2VnvzJ03Cs35fScwMl0Ag+42Avgs
         i6Xd4gALl95DNSMZ7AiolT0igM+XikdLa7nJL2a+1dbeYAH5n5UOkfBxlNFa+tOjcA
         eVeO1LqzK2hKFWOvbrCD3wkwgwulpauuclk65rks=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220622122959epcas5p1780a7bf7b5e20d18775d5fb298b4ffd9~68S9zD7q71931719317epcas5p1O;
        Wed, 22 Jun 2022 12:29:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LSjPx1BScz4x9Pp; Wed, 22 Jun
        2022 12:29:57 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.AE.09662.54B03B26; Wed, 22 Jun 2022 21:29:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220622113125epcas5p4fe3b0d3ba33ad990a8857a20a70d2445~67f1xs2nJ1302813028epcas5p4g;
        Wed, 22 Jun 2022 11:31:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220622113125epsmtrp2f9ce583d09793848e94cc61c68d12858~67f1xC-5Y2607126071epsmtrp2c;
        Wed, 22 Jun 2022 11:31:25 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-c2-62b30b45ec53
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.EF.08802.D8DF2B26; Wed, 22 Jun 2022 20:31:25 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220622113124epsmtip2b5b343a210e48be184c4535fd9ca29d0~67f1BKXOU2168521685epsmtip2b;
        Wed, 22 Jun 2022 11:31:24 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] configure: add option to disable xnvme build
Date:   Wed, 22 Jun 2022 16:55:46 +0530
Message-Id: <20220622112546.13503-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220622112546.13503-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmpq4r9+YkgyWnOCzWXPnNbrH6bj+b
        xcdZL5gtFm5cxuTA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGesXnqHseA0T8XD7e0sDYz3ObsYOTgkBEwk
        5s4r6GLk5BAS2M0ocbbbpouRC8j+xCjxsXcHK0TiM6PE6YMhIDZI/fk9RxghinYxSty+9gzK
        aWWS2DWjnQ2kik1AW+LV2xvMILaIgLDE/o5WFhCbWSBS4tO/mWBThQUcJbZvmwVmswioSlxp
        WswIYvMK2Eisu7OPEWKbvMTqDQfA5nAK2EosnfWXCWSZhMAidom1kxayQRS5SFzu/8MCYQtL
        vDq+hR3ClpL4/G4vVE22xKaHP5kg7AKJIy96mSFse4nWU/3MoKBgFtCUWL9LHyIsKzH11Dom
        iJv5JHp/P4Fq5ZXYMQ/GVpX4e+821FppiZvvrkLZHhK/n3WwQgJlAqPEgqM/GCcwys1CWLGA
        kXEVo2RqQXFuemqxaYFhXmo5PM6S83M3MYKTk5bnDsa7Dz7oHWJk4mA8xCjBwawkwmvDvSFJ
        iDclsbIqtSg/vqg0J7X4EKMpMAAnMkuJJucD02NeSbyhiaWBiZmZmYmlsZmhkjiv19VNSUIC
        6YklqdmpqQWpRTB9TBycUg1MxlNeZLzurrOZk6a0fbWaGptUw36LU0nWjV7BXyKqvJeIn85s
        zq9h45nPYLnape785og9Hj1CSd8P7VxfU+dd+6ht1vyVW6JyVDsv71HL3SPz6pTbgYf1cWGP
        kpxKLX3X7WU/zzA1dSJTxkZHZ0u2Bytv7l71//fKvV37Exv6DeYeLF+4sVL8ocQDp4XluTGT
        vuu/Tevz2HZv5kXT90sFj22X/LPhldjzeOtKjdvq8QXHL14rffJJ+MSs+OC++lXxN/WaNiUs
        7SlVfuJks9LjaOVUiR6GY1sm6/nM23t/clpo4ps3R4rU9hqLiep4FS09Wd8mLljxu3av/mbL
        TgmPu4IfxKN36xko/th0reScEktxRqKhFnNRcSIADs8On9cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsWy7bCSvG7v301JBn0rNS3WXPnNbrH6bj+b
        xcdZL5gtFm5cxuTA4nH5bKlH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZaxeeoex4DRPxcPt
        7SwNjPc5uxg5OSQETCTO7znCCGILCexglFj2X66LkQMoLi2xcH0iRImwxMp/z9m7GLmASpqZ
        JHomTwKrZxPQlnj19gYziC0CVLS/o5UFxGYWiJbYf6YZzBYWcJTYvm0WK4jNIqAqcaVpMVgv
        r4CNxLo7+xghFshLrN5wAGwOp4CtxNJZf5kg7rGR2L38POsERr4FjAyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCw0dLawfjnlUf9A4xMnEwHmKU4GBWEuG14d6QJMSbklhZlVqU
        H19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANT4pEfNRoRua895jY2lCRY
        XSw/+I6TySZtos8CJa97nKYpB1J8jzAVvP7kEyw0U76+VYTr94VWsetrNzHpnNy7Wmiigc53
        vUsiay8XV/tmXXFLKo748ZslO/VxXMsph55fM25J7Dku2c9h6eT+NuZkyE6GGR3sL49o9CpX
        8J1R3bZh4omDu7IXT0oL3pl2/Wj2gohNTW+Oe26W7FiwcrbFxb8TqhL2fPl4RdVjYdXBw6qF
        p8LW7+889WjfEbeSO9/CZ0QW/VPUq7Y+0cZ7QsVgpsaEANv/eutbmD6xzP34W/GkyHaW90Kz
        l6t3NcbqW0ifPaVaOE/swJIlF6xLahiWCv/4YxscXcDrxrrA6sYMJZbijERDLeai4kQASeGc
        I44CAAA=
X-CMS-MailID: 20220622113125epcas5p4fe3b0d3ba33ad990a8857a20a70d2445
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220622113125epcas5p4fe3b0d3ba33ad990a8857a20a70d2445
References: <20220622112546.13503-1-ankit.kumar@samsung.com>
        <CGME20220622113125epcas5p4fe3b0d3ba33ad990a8857a20a70d2445@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add option to disable xnvme build even if found.
Remove enable xnvme build option, as xnvme support
is already being probed.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index 510af424..04a1d0e2 100755
--- a/configure
+++ b/configure
@@ -171,7 +171,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libnfs="no"
-xnvme="no"
+xnvme=""
 libzbc=""
 dfs=""
 dynamic_engines="no"
@@ -241,7 +241,7 @@ for opt do
   ;;
   --disable-libzbc) libzbc="no"
   ;;
-  --enable-xnvme) xnvme="yes"
+  --disable-xnvme) xnvme="no"
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
@@ -294,7 +294,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
-  echo "--enable-xnvme          Enable xnvme support"
+  echo "--disable-xnvme         Disable xnvme support even if found"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
   echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
@@ -2619,7 +2619,7 @@ fi
 
 ##########################################
 # Check if we have xnvme
-if test "$xnvme" != "yes" ; then
+if test "$xnvme" != "no" ; then
   if check_min_lib_version xnvme 0.2.0; then
     xnvme="yes"
     xnvme_cflags=$(pkg-config --cflags xnvme)
-- 
2.17.1

