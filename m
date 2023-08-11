Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5DDC41513
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjHKHqv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbjHKHqu (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:46:50 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5852D4F
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:46:48 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230811074645epoutp01beb936bb5bf9fb692a51b5b1d8804801~6RJJNZvdP2539025390epoutp01s
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:46:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230811074645epoutp01beb936bb5bf9fb692a51b5b1d8804801~6RJJNZvdP2539025390epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740005;
        bh=M+sXAPoqerwFy/USckfpRDouksV4c56ba2uil8BFMpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0ZGNdAIZ+6OuPMOz6KbBvfxSk09XIX+Z0vTEaNOEP3TGG95u3bSXvZ3OY+O8/u6z
         C5abeF9BLFSecHnk3e7/3sjSbsYY+uujJcloAS24ZQQMi45mwFlQwsnFGkggLTE4OK
         CbvFusnMrJcM+LKfMNpXIxxt+UXNgNlo+8r2rrWI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230811074644epcas5p34971516c3c76f69a807a1279a111a4ba~6RJI7g7HH1113011130epcas5p3g;
        Fri, 11 Aug 2023 07:46:44 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RMbTZ6fPpz4x9Q9; Fri, 11 Aug
        2023 07:46:42 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.63.55522.267E5D46; Fri, 11 Aug 2023 16:46:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060634epcas5p1dbf9887e516cd6e5369b0eb2e491751a~6Pxre6lg02603726037epcas5p1F;
        Fri, 11 Aug 2023 06:06:34 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230811060634epsmtrp2e7d3b6fa8936c536ad3701550fa054d2~6PxreSWFI2376023760epsmtrp2B;
        Fri, 11 Aug 2023 06:06:34 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-41-64d5e7628c21
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.60.30535.AEFC5D46; Fri, 11 Aug 2023 15:06:34 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060633epsmtip132580b7f24931b3ab3851a4d5c30262f~6PxqUTHjZ0091300913epsmtip1W;
        Fri, 11 Aug 2023 06:06:33 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 01/10] engines:io_uring: add missing error during open
 file
Date:   Fri, 11 Aug 2023 16:55:38 +0530
Message-Id: <20230811112547.92345-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmlm7S86spBrv/mlqsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOWH9/DXvBXM6KK48nsDQw9rN3MXJySAiYSPS+mcDSxcjFISSwm1FiUsNNZgjnE6PE
        u013oZxvjBKHD21lhGm53dvHBpHYyyjR27efEcLpZJK4/XE92GA2AW2JV29vALVzcIgIaEis
        uZsKUsMs0MIosbt7NitIXFggQGLpGwGQchYBVYm7HevYQGxeARuJaRcmMUMsk5eYeek7O0g5
        p4CtxKIVYhAlghInZz5hAbGZgUqat84GO1RC4CO7xIv+91C9LhKzt8+EOlpY4tXxLVA/S0l8
        freXDcLOltj08CcThF0gceRFL1SvvUTrqX6w85kFNCXW79KHCMtKTD21jgliL59E7+8nUK28
        EjvmwdiqEn/v3WaBsKUlbr67CmV7SHQfmwUNqgmMElePbmWdwKgwC8k/s5D8Mwth9QJG5lWM
        kqkFxbnpqcWmBYZ5qeXwSE7Oz93ECE6cWp47GO8++KB3iJGJg/EQowQHs5IIr23wpRQh3pTE
        yqrUovz4otKc1OJDjKbA8J7ILCWanA9M3Xkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5ak
        ZqemFqQWwfQxcXBKNTCxNa6tz9/8qTkm+2M2m8/7L0YRDJIVZ7Sn/zm164Wnq5CL3MvglKjA
        Mhmr6G9cHySVDEPCjis5Fl0s4OOWLFlx8M9VDd5Y3l2KKRzpZqF5hZ28vx/09QdUyQucDnue
        897F077+tbGl0brPqadPG+o+MNrKWbXW6jf7s+UnvThcXH5e23xh6vLoxU4/9j5oqly41jJf
        vk69PnCP1r4ZszbHTz58iqs4bc0L3hJ50wvOIsu6HTnWnv+4t/5k77Hldj768YJxS1nEHxVH
        r4xMMjz3TDJ/QePB6WePR0tNmHY2cbXut4Xrg1cGHpWefOnmeiajODfGxAVPN3k6PrzTb+Gu
        uSTaUCU77XRp1b6viUosxRmJhlrMRcWJADl+1bYlBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnO6r81dTDF5cULVYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MpYf38Ne8FczoorjyewNDD2s3cxcnJICJhI3O7tY+ti5OIQ
        EtjNKPHrXjNrFyMHUEJaYuH6RIgaYYmV/56zQ9S0M0m09c5iAkmwCWhLvHp7gxnEFhHQkji2
        rglsELNAF6PE3t3T2EASwgJ+Eiuv7gCzWQRUJe52rAOzeQVsJKZdmMQMsUFeYual7+wgizkF
        bCUWrRADCQsBlbya+RuqXFDi5MwnLCA2M1B589bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfY
        sMAoL7Vcrzgxt7g0L10vOT93EyM4tLW0djDuWfVB7xAjEwfjIUYJDmYlEV7b4EspQrwpiZVV
        qUX58UWlOanFhxilOViUxHm/ve5NERJITyxJzU5NLUgtgskycXBKNTDFyhUkbZgwK7rKJkss
        33POs4fPWqIbPWw+eKo+8FlaVDFV5nhWjP7Zrdevvw18aORmVpcZtIkzVTPPcNuew/vFbrdK
        rHjf7VfwObHwiX1AxP8K/bI9+7gLblb7hiYXKuXyFi/6xvd3Qupc+b4SVp/qi/e/K6s6XD0c
        58HNEfp0xu6Nsa+uLtHx6l6r5X42K2nvnepo6ZxbHzdZ8t/+2tcaEnjgW9sd1wN/r3SVLy8x
        6fE4Mvkc364Hb97YxYRkcHtMKeh7d33yx+ov717Gnlwad6t7VkqqEse780lFjUtvPEs9leS2
        cPfnxvtpdu803+3h2fG6+uG36Of5GZKz3YwnTXVh/vb/qk/gafG6FaFKLMUZiYZazEXFiQDi
        zsxV3AIAAA==
X-CMS-MailID: 20230811060634epcas5p1dbf9887e516cd6e5369b0eb2e491751a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060634epcas5p1dbf9887e516cd6e5369b0eb2e491751a
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060634epcas5p1dbf9887e516cd6e5369b0eb2e491751a@epcas5p1.samsung.com>
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

