Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD510EB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjHIGC7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjHIGC5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:02:57 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5DE1BFE
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:02:51 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230809060249epoutp01bf2f70e4f056ede77e16834e5e154477~5ob1dsE6T3201032010epoutp01D
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:02:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230809060249epoutp01bf2f70e4f056ede77e16834e5e154477~5ob1dsE6T3201032010epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560969;
        bh=KJPkrTDJ4jrZ4NGa3MHBN1SpbcZmDJa31aF7pDF4grA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srXFWbCbkn6PWAmUV7fNwzKxVH4ZMslPc+50wRljeM6v4g3T2spp7xLejfk4QZjf7
         7YU1A9cNbIxJR+P0HRsQguafSRPmLpwF1/swGdwPZyHG93U+ZrHfgfJ+0znu7ThSO0
         /4iU12xdenUfj2Y/Qfd3Ddhx4AjRcOrmvyIYsrZY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230809060249epcas5p2704d27161246c2c649efa2ba99c094e7~5ob1PMeZX2962629626epcas5p2G;
        Wed,  9 Aug 2023 06:02:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RLKGc1n7Pz4x9QG; Wed,  9 Aug
        2023 06:02:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.37.06099.80C23D46; Wed,  9 Aug 2023 15:02:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230809055413epcas5p2b3c6bfe3a2a8e7aef81b4a6c9b2e7a28~5oUVFmuya1825418254epcas5p2L;
        Wed,  9 Aug 2023 05:54:13 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230809055413epsmtrp2cae714a6ee905aa6ffe12ea4a16110bc~5oUVEnaAS0724607246epsmtrp25;
        Wed,  9 Aug 2023 05:54:13 +0000 (GMT)
X-AuditID: b6c32a4b-d308d700000017d3-bb-64d32c08e6c8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.D2.64355.50A23D46; Wed,  9 Aug 2023 14:54:13 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055412epsmtip1b689d19c9af14085b1d9a252dfec41b9~5oUT_DLim0564305643epsmtip1W;
        Wed,  9 Aug 2023 05:54:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 01/10] engines:io_uring: add missing error during open file
Date:   Wed,  9 Aug 2023 16:43:05 +0530
Message-Id: <20230809111314.76947-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmui6HzuUUgyv3OSzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnLPl9iK3gNktF49bzbA2Ml5m7GDk5JARMJL6d3s/YxcjFISSwm1Fi27Q3UM4nRonZ
        5w8xwTmLbtxkh2n5sXE/C0RiJ6NE1/91UFWdTBJ//3SyglSxCWhLvHp7A2gJB4eIgIbEmrup
        IDXMAi2MEru7Z4PVCAt4S6z7NQvMZhFQlZj/fjILiM0rYCPxsfUn1DZ5iZmXvoPZnAK2EqvW
        3ICqEZQ4OfMJmM0MVNO8dTYzyAIJgbfsEv8PXmYCWSwh4CJxdWMZxBxhiVfHt0DNlJL4/G4v
        G4SdLbHp4U8mCLtA4siLXmjA2Eu0nuoHu59ZQFNi/S59iLCsxNRT65gg1vJJ9P5+AtXKK7Fj
        HoytKvH33m0WCFta4ua7q1C2h8SCs+uhATeBUWLSsdNsExgVZiF5ZxaSd2YhrF7AyLyKUTK1
        oDg3PbXYtMA4L7UcHsvJ+bmbGMGpU8t7B+OjBx/0DjEycTAeYpTgYFYS4bUNvpQixJuSWFmV
        WpQfX1Sak1p8iNEUGN4TmaVEk/OByTuvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU
        1ILUIpg+Jg5OqQamEt2aanX52bv/VAufebFtGlvWtNa5Tkwd3CebZwcs95wqoLrxgbFsfoXN
        B8P59/x0w5vvtmb9a3K3/W/+t+DahRQdiWeH47/F6bq+37FIdaUMB4OJxPqdd70uh32InfDS
        woh1Ribv9vpCEY63G8q9ty5O7Jyk5ejafs4yfmKBxQovrT+8Mq3Jvh9v/106vSqq/eik3TVH
        zu0orCl8bH40fsXu04ceyZwRkD3hNPEY73/uCYXeZ4UCHb4myUxRZTi27uKGVo2HAk6uctL/
        c04E6DEle32x+bfuq/wf27ebkqw+PD7uFSbkO+Vfetwsq+im/s3Lt9qu3Vl09pey9aaIhRsF
        Ni8P+Xs4/F3O1/QTSizFGYmGWsxFxYkAwTrN8iYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnC6r1uUUg+t3jCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDKW/D7EVnCbpaJx63m2BsbLzF2MnBwSAiYSPzbuZ+li5OIQ
        EtjOKHFv2lb2LkYOoIS0xML1iRA1whIr/z1nh6hpZ5J4+fMbE0iCTUBb4tXbG2CDRAS0JI6t
        a2IDKWIW6GKU2Lt7GhtIQljAW2Ldr1msIDaLgKrE/PeTWUBsXgEbiY+tP9khNshLzLz0Hczm
        FLCVWLXmBliNEFDNwrcTmSHqBSVOznwCFmcGqm/eOpt5AqPALCSpWUhSCxiZVjGKphYU56bn
        JhcY6hUn5haX5qXrJefnbmIEB7VW0A7GZev/6h1iZOJgPMQowcGsJMJrG3wpRYg3JbGyKrUo
        P76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFqEUyWiYNTqoEpJLvyvy53fsPMnyGfNs+x
        euUSOffcZEaVex77l0bMYTvHIMbXYpvNcvFx/71m87jdqs/V9q/MCk7iip91pkh/YYpKR5RR
        Sef5i8eeKAcKWF3VnBP8Mr/0Qn7zTQ7DK+wOxavZKkV6spfmHaqacHVVq9zchDZ/xf/1BSVf
        687czTz9cHrYBiEH8dCLVm9nZE0QaHl9tMb45+9H/eX3rDjND1quD1kivttxip/jbq6srv4r
        qbJuC19ttLOYu3rHk+iCMqm+7zHHUqOinh3tmBpWnZwrOmdFU9vLHbVPTK3ea3T7SHxY/Gin
        2NToQ1MFnvGeeHqi3HZ2v0BW+6VVwo/cuT+3/WL9teFL3+ocv/lKLMUZiYZazEXFiQCFcPSj
        2QIAAA==
X-CMS-MailID: 20230809055413epcas5p2b3c6bfe3a2a8e7aef81b4a6c9b2e7a28
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055413epcas5p2b3c6bfe3a2a8e7aef81b4a6c9b2e7a28
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055413epcas5p2b3c6bfe3a2a8e7aef81b4a6c9b2e7a28@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index b361e6a5..135b982d 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1119,6 +1119,7 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 						"(LBA data size + Metadata size)\n");
 				else
 					log_err("block size must be a multiple of LBA data size\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
                 }
-- 
2.25.1

