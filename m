Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1AFEB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjHIGDU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjHIGDT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:19 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412821BF3
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:05 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230809060303epoutp016f1769a99a719cc867eb8ef0608150a4~5ocCP7ZCR3078730787epoutp01A
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230809060303epoutp016f1769a99a719cc867eb8ef0608150a4~5ocCP7ZCR3078730787epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560983;
        bh=lwpuni5fiwTz43zHZP6vnkU5/IwlesjkW4ru/K/Zoj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhkK/u202udVpRs2Q68faVriyCzG4464whoKa+jAQtSo8b4OWx3PHWKSza9DGqAhU
         LDWetkRuCzf8B0L+cAr9KUe9Qo988CJLjAopQWTaQC+BZKIsFLF8QFUhbTSvFKlyf9
         tDODIVqJNpUDJCPlSSAbZ4s+EezYUv+TDizHxGWY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230809060303epcas5p1c0094cf2b098e2ed928c52f7bc1934fa~5ocB4g5jd2138521385epcas5p1o;
        Wed,  9 Aug 2023 06:03:03 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RLKGr5mrWz4x9Pv; Wed,  9 Aug
        2023 06:03:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.48.55173.41C23D46; Wed,  9 Aug 2023 15:03:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230809055419epcas5p3462a62ad9f23138722473c996e704082~5oUZ-MPM82900529005epcas5p3p;
        Wed,  9 Aug 2023 05:54:19 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055419epsmtrp18391b71fff378bdc388028294139a74b~5oUZ_YdEQ3173431734epsmtrp1K;
        Wed,  9 Aug 2023 05:54:19 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-df-64d32c14fe36
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.D0.14748.A0A23D46; Wed,  9 Aug 2023 14:54:19 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055417epsmtip16e25670f164d679de8ff0a759ba42ae2~5oUY2hOqy0788007880epsmtip1C;
        Wed,  9 Aug 2023 05:54:17 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 05/10] io_u: move engine data out of union
Date:   Wed,  9 Aug 2023 16:43:09 +0530
Message-Id: <20230809111314.76947-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmlq6IzuUUg1cX9CzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnTDr5i62ggaXi7LdrTA2MPcxdjJwcEgImEv9a3jB1MXJxCAnsYZQ4+fgBI4TziVHi
        x+ULYFVCAt8YJY7eDupi5ADrODSNB6JmL6PEq88d7BBOJ5NE9w4Qh5ODTUBb4tXbG8wgDSIC
        GhJr7qaC1DALtDBK7O6ezQpSIyxgJTFt3mkwm0VAVeJ51z4mEJtXwEZi7a69rBDnyUvMvPQd
        bCangK3EqjU3WCBqBCVOznwCZjMD1TRvnQ31zld2ievPTCFsF4nFFyYwQdjCEq+Ob2GHsKUk
        Xva3QdnZEpse/oSqKZA48qIXao69ROupfrD7mQU0Jdbv0ocIy0pMPbWOCWItn0Tv7ydQrbwS
        O+bB2KoSf+/dZoGwpSVuvrsKZXtIbL35CRrSExgldvw+zjyBUWEWkndmIXlnFsLqBYzMqxil
        UguKc9NTk00LDHXzUsvhkZycn7uJEZw4tQJ2MK7e8FfvECMTB+MhRgkOZiURXtvgSylCvCmJ
        lVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YuvNK4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJ
        zU5NLUgtgulj4uCUamCaubK/pfJ4TzqD1Ka6v1WK29MvhxnlqU68kPY39oP0foPHJjPXPNJT
        WsE2T71Bf7e59qMLLK5Vb/ckvNiwz1WtwueByCuTxOCW07wx4ep+P46X2nTM+FjXXv2o4JtF
        lC/n3/BnszRz3e337G5Vilno4XWc657tqg92Oq03nVQ9bpzwYo66x2fWfHrJyjLWk5yPIwyk
        JgYxbHh4+96j27yTivIfZwtZFH36uGqJW/MM/6br62Wt33sYTquVavyn8vzXpKOdph28F1S0
        GWb83bo1O+l9avAy9dY5OTKtxesiV00p2K7v1tRZEfXWJ3LO4raXUQf4Kp4nHFG68qOaWyfw
        ZVSp9pqvRyzkrk2c+kiJpTgj0VCLuag4EQBzjO6JJQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnC631uUUg6kbmS3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDImnfzFVtDAUnH22zWmBsYe5i5GDg4JAROJQ9N4uhi5OIQE
        djNKLP/RwQgRl5ZYuD6xi5ETyBSWWPnvOTuILSTQziRx/JkliM0moC3x6u0NZhBbREBL4ti6
        JjaQOcwCXYwSe3dPYwNJCAtYSUybd5oVxGYRUJV43rWPCcTmFbCRWLtrLyvEAnmJmZe+gy3g
        FLCVWLXmBgvEMhuJhW8nMkPUC0qcnPkELM4MVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3P
        TTYsMMxLLdcrTswtLs1L10vOz93ECA5sLY0djPfm/9M7xMjEwXiIUYKDWUmE1zb4UooQb0pi
        ZVVqUX58UWlOavEhRmkOFiVxXsMZs1OEBNITS1KzU1MLUotgskwcnFINTOe25dzJqn888+hG
        jh/nJnPPtNl3SdNindOh/R3MPwsbPO6uzHe+UPjh0pJ3NyY/Z3jRd3RFe+s6bsstT76XP9gi
        z7I0RXXFnauG4UqKXzsC2l5I9uXOf7v288xnpv41T1OWHjHKnLdTwqrGN/ZRyJOs3WoHV33O
        Y/kf8ufk7bPrLLf2vvm6OsV4owGX5pQXbcqvN/BV3I5UtD2e3Xz49ombN91kP/6LY+r/L3WU
        UfPSgTYG7c+FX1asSeKeGLvunRCv87PjO9X6eefKzMvOEsl/LFLpx6Dnb8DzUjY/0jSbldF3
        9+tDzTWBX91frsxof7++hmuveybjrYPZATMdtVQWLl60a+WPz58y1j5Z+2etEktxRqKhFnNR
        cSIAE+SD/NsCAAA=
X-CMS-MailID: 20230809055419epcas5p3462a62ad9f23138722473c996e704082
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055419epcas5p3462a62ad9f23138722473c996e704082
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055419epcas5p3462a62ad9f23138722473c996e704082@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

io_uring_cmd ioengine requires engine data to store nvme protection
information data.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 io_u.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.h b/io_u.h
index b432a540..786251d5 100644
--- a/io_u.h
+++ b/io_u.h
@@ -89,8 +89,8 @@ struct io_u {
 	union {
 		unsigned int index;
 		unsigned int seen;
-		void *engine_data;
 	};
+	void *engine_data;
 
 	union {
 		struct flist_head verify_list;
-- 
2.25.1

