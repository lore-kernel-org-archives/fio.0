Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1FEC04A94
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjHNJlS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjHNJk5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:40:57 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3D9109
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:40:54 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230814094052epoutp012bc9338ae4e4c4cb41c7ea2bf55b52e8~7NopRK0sW1215812158epoutp01C
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:40:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230814094052epoutp012bc9338ae4e4c4cb41c7ea2bf55b52e8~7NopRK0sW1215812158epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006052;
        bh=M+sXAPoqerwFy/USckfpRDouksV4c56ba2uil8BFMpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITa/VSt8DoFnsa8j0kDjaS2ZVLTn75RXpLkwRICh2o4zYbnljPfVJPo3mv0mf8tT5
         4hL9GxcZkBZqjOoRTDSo0G7Cc2mCArqv/92iXB8XMxmpAQaJo/AZWdNtScRSIiCjKu
         EIy7/tk4cTSfO9GM/2Hl69+8iCNzkfKFmO47e6LQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230814094052epcas5p17613371d99c8b639660da7ed1a309002~7NooxXx541317113171epcas5p18;
        Mon, 14 Aug 2023 09:40:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RPTst3t6xz4x9Q2; Mon, 14 Aug
        2023 09:40:50 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.3E.55522.2A6F9D46; Mon, 14 Aug 2023 18:40:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230814093838epcas5p31b8e832e14afecd49ac828505f325b74~7NmsDFUSy2609626096epcas5p3F;
        Mon, 14 Aug 2023 09:38:38 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230814093838epsmtrp21aad4fb5b597edd3d7d785e18c9faf42~7NmsCXeLy1882118821epsmtrp2O;
        Mon, 14 Aug 2023 09:38:38 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-42-64d9f6a25b27
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.CF.14748.E16F9D46; Mon, 14 Aug 2023 18:38:38 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093837epsmtip1038684fbb236f513a3421483d72dbf64~7Nmq5Dm7D1005010050epsmtip1F;
        Mon, 14 Aug 2023 09:38:36 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 01/10] engines:io_uring: add missing error during open
 file
Date:   Mon, 14 Aug 2023 20:27:38 +0530
Message-Id: <20230814145747.114725-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmlu6ibzdTDB7PlrFYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdsf7+GvaCuZwVVx5PYGlg7GfvYuTkkBAwkZjxsoOti5GLQ0hgN6PEhwUnoZxPjBKr
        m/+wQjjfGCWaeq6zwLQs7prLDJHYyyjxaONfRgink0niw+Q2VpAqNgFtiVdvbwBVcXCICGhI
        rLmbClLDLNDCKLG7ezYrSFxYIEBixnpXkHIWAVWJ+++3gC3gFbCV+NXxlg1imbzEzEvfwW7l
        FLCT+D/lNztEjaDEyZlPwOqZgWqat84GO0hC4CO7RHdHM9heCQEXic3t0hBzhCVeHd8C9bOU
        xOd3e6HmZ0tseviTCcIukDjyopcZwraXaD3VDzaGWUBTYv0ufYiwrMTUU+uYINbySfT+fgLV
        yiuxYx6MrSrx995taFhJS9x8dxXK9pBY9PEgNEAnMkps+vOAcQKjwiwk78xC8s4shNULGJlX
        MUqmFhTnpqcWmxYY5qWWwyM5OT93EyM4cWp57mC8++CD3iFGJg7GQ4wSHMxKIry33K+lCPGm
        JFZWpRblxxeV5qQWH2I0BYb3RGYp0eR8YOrOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2x
        JDU7NbUgtQimj4mDU6qBaXPi6R2aO93vx/RmHhD9FaIcq2/GECM445uryCz23zWd/UKTK7dE
        h6Wb/o2678q7X2R+3PPEzbn63+ufzhLmXJr2ZGZ3c+em5YxOVUcDO7i2rVydfdtVNPGvUube
        p3fjXvcV3Y0038w2ZcqLMrHUHLlXCeejWB4ckWWy82WR+prbet1YVNzq0+MbXf4TLlW/Xtd/
        dZv4YdbomK1Wnv8vFr//VqReVBTx/2NV9j4JlhQdzg8TNtnPrXOZfUfRadertlMnr9Z7vrnF
        95tzrlPxNCdphWu3TZ4snMIsFsJx6XWG6Gc2vQAz0yPmhcl3Qva1vfaUbiwLnle3WivI4lGl
        S/Ui5j/J/J8X2GTmLJNSYinOSDTUYi4qTgQA2lRRTyUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnK7ct5spBs/fclqsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGWsv7+GvWAuZ8WVxxNYGhj72bsYOTkkBEwkFnfNZe5i5OIQ
        EtjNKDFv0VW2LkYOoIS0xML1iRA1whIr/z1nh6hpZ5JY+GY3K0iCTUBb4tXbG8wgtoiAlsSx
        dU1sIEXMAl2MEnt3T2MDSQgL+EnMed0BVsQioCpx//0WFhCbV8BW4lfHWzaIDfISMy99B7uI
        U8BO4v+U32C2EFDNqoV7WSHqBSVOznwC1ssMVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3P
        TTYsMMxLLdcrTswtLs1L10vOz93ECA5uLY0djPfm/9M7xMjEwXiIUYKDWUmE95b7tRQh3pTE
        yqrUovz4otKc1OJDjNIcLErivIYzZqcICaQnlqRmp6YWpBbBZJk4OKUamHwYX4mWFipHsdw8
        l+euvXjbnrUKvs82f27Mfy6a5WDtKLxM07a2Yu4TxtcPflm/3vzzrsrnKYFJSw4Ls8hJ3Vpx
        ZZPq7sK/Qje/6GudFQiPTl+2c7HHKuf/PKERV74ez5u6/XKy++Q9T04sW7T6/KyzvxW9L2ic
        e3bu9oJptzsj1NfF+s8oyyj7fWixaqn63eI1JcrlmsEOAdpB9mu+BBvc1bVpLbzWcjTx/ZE6
        vZ0nTnq88PcVcauYbFnN5XJrtV9g5FqpZYEry+0OPZOJLjnF3lXSaHX4ccdG3XmF0ZYWnlfy
        F39YWzc7XkZT+aax+/Tikgmne69terGGobl6116vaOYEAcdVbiyJJhsaupRYijMSDbWYi4oT
        AYZ1E8vdAgAA
X-CMS-MailID: 20230814093838epcas5p31b8e832e14afecd49ac828505f325b74
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093838epcas5p31b8e832e14afecd49ac828505f325b74
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093838epcas5p31b8e832e14afecd49ac828505f325b74@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This change ensures the error is propogated to upper layers to make fio
exit with a non-zero return code.
Add filename for errors when block size is not a multiple of logical
blocks.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index b361e6a5..09065463 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1115,10 +1115,12 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 			if (td->o.min_bs[ddir] % lba_size ||
 				td->o.max_bs[ddir] % lba_size) {
 				if (data->lba_ext)
-					log_err("block size must be a multiple of "
-						"(LBA data size + Metadata size)\n");
+					log_err("%s: block size must be a multiple of (LBA data size + Metadata size)\n",
+						f->file_name);
 				else
-					log_err("block size must be a multiple of LBA data size\n");
+					log_err("%s: block size must be a multiple of LBA data size\n",
+						f->file_name);
+				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
                 }
-- 
2.25.1

