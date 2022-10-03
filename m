Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B19C433FE
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 04:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJCEHb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 00:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCEHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 00:07:30 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9832227B3A
        for <fio@vger.kernel.org>; Sun,  2 Oct 2022 21:07:27 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221003040723epoutp0314e01f6e3c0a01b45180679c86fe0b4a~ac4jYlHWd3205532055epoutp03G
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 04:07:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221003040723epoutp0314e01f6e3c0a01b45180679c86fe0b4a~ac4jYlHWd3205532055epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664770043;
        bh=ESe7cadC1Imbuvq3MJFUca8OCRpmjsOff202zx5O5/s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kNs6A4xNk+f8DSaWPooqEzGMNoXmjedQovnM6/XVI156Zv22cDpBKVLlTBY2r98fY
         lseqorq1py9pXTio1OwW33L71eVruZn+xrISFAfD6wJivDdrh43cUcroW8PEfXkOTe
         6knvX5z560KSvlBN+jrnj6/vaSB5IWdouSUDQDdM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221003040723epcas5p32a7a857c0a83c386eec3a758886d82ee~ac4jIEF1u1477814778epcas5p3x;
        Mon,  3 Oct 2022 04:07:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MgnNT5Cfmz4x9Pr; Mon,  3 Oct
        2022 04:07:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.E2.26992.2FF5A336; Mon,  3 Oct 2022 13:07:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221003034159epcas5p1018bd8a2413cdd569a6d01b135163d35~aciXgR9Qs2803028030epcas5p1q;
        Mon,  3 Oct 2022 03:41:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221003034159epsmtrp13adfa5dd4b5b1f572cdf02f1d1135de5~aciXfnKqV2294122941epsmtrp1s;
        Mon,  3 Oct 2022 03:41:59 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-e3-633a5ff209c4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.EE.18644.70A5A336; Mon,  3 Oct 2022 12:41:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221003034158epsmtip251ab728acba6c110ab71819a663caaa0~aciWf6Yt33133631336epsmtip2f;
        Mon,  3 Oct 2022 03:41:58 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, gost.dev@samsung.com, ankit.kumar@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH] engines/io_uring: add fixedbufs support for io_uring_cmd
Date:   Mon,  3 Oct 2022 09:01:52 +0530
Message-Id: <20221003033152.314763-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmpu6neKtkg7lbFC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLa4eWAnk8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RkfNj1hKvjOWnF6
        4UXWBsb3LF2MnBwSAiYS0x5OYO1i5OIQEtjNKPFjzxQ2kISQwCdGie7b2RCJz4wSjbO2scF0
        /Du0iAUisYtRYtPBiUxwVS/n/GUCqWITUJc48ryVsYuRg0NEQENizd1UkDCzQLbEp2sTGEFs
        YQFPiXkr+8FsFgFViS0/NoO18gpYSZxeMYkdYpm8xMxL39kh4oISJ2c+YYGYIy/RvHU2M8he
        CYFd7BL7jlyFus5FovfiGSYIW1ji1fEtUIOkJF72t0HZ6RI/Lj+FqimQaD62jxHCtpdoPdXP
        DHIzs4CmxPpd+hBhWYmpp9YxQezlk+j9/QSqlVdixzwYW0mifeUcKFtCYu+5BijbQ+L7g3mM
        kBCNlbg0+RbbBEb5WUjemYXknVkImxcwMq9ilEwtKM5NTy02LTDMSy2Hx2tyfu4mRnAC1PLc
        wXj3wQe9Q4xMHIyHGCU4mJVEeKcoWiYL8aYkVlalFuXHF5XmpBYfYjQFhvFEZinR5HxgCs4r
        iTc0sTQwMTMzM7E0NjNUEuddPEMrWUggPbEkNTs1tSC1CKaPiYNTqoFJ/E79k6ovr9refDnt
        dDuIf+Eufv9NS9gCHSc4Nptq1wYuNPrv76x1+1rfBGnxnLXWl+cpyjHsKmhus7j1+Uhf00pR
        82PuJ/7dmHRebnat1KLS1LvFAv7vN29/fyrhZ2jp7XjZBYxh290elZ0PPzlj7fmDq3TPb9m/
        svDTmbVrV23za392UvJMnYWxgaXkTPUnDgaXxebPN1waae5Utfdh8Fe9pi7Nv3Lyz3p3Pj3R
        1V9z9DPHwTbPhjyz2HMzPz13S5u6oVjBc6WjrUFGiPFnU2NWNXbrW6Jrj/O2FYsI/1z+co5J
        X/HKPdf4Jmq6rJv4X+OISkHusY9nt0wzDzqodWDnntdcj5Y5np6zrtmSXYmlOCPRUIu5qDgR
        AInrpjkJBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvC57lFWywZRWDos1V36zWzRN+Mts
        sfpuP5vFx1kvmC1uHtjJZLGhTdCBzWPnrLvsHpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+
        XQJXxodNT5gKvrNWnF54kbWB8T1LFyMnh4SAicS/Q4uAbC4OIYEdjBK7tn9jhEhISJx6uQzK
        FpZY+e85O0TRR0aJhe8usYMk2ATUJY48bwUrEhHQkji2rokNxGYWyJd4+HUqE4gtLOApMW9l
        P1gNi4CqxJYfm8HivAJWEqdXTGKHWCAvMfPSd3aIuKDEyZlPWCDmyEs0b53NPIGRbxaS1Cwk
        qQWMTKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYLDUUtrB+OeVR/0DjEycTAeYpTg
        YFYS4Z2iaJksxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dU
        A1OfZ9TXvwfi5Gd31a29aHAiRrhExWkJ/7lzlncY/hff3nPZgMeNm09I3eXHmpvlU0Pdl869
        nh+nHzyN75sf59cXbRc3N57/ZrD87Pdrk63PTEjT3qgjwpNd///p71s/nhl7aP450eBwZIma
        2NIFztwG1TuUuvdwNevyx869/3qdpds+Kz2Ngn3XL73uuVEabchRbbAxR2r+Rc7jFSt7psjF
        r1x7x+tkxq6j/rNr+77HOdn+TJtUqDaxtmOxkv2yS8Wqc1pWp7FcF1ESZljNvf0va8iGi/yx
        /taLq598t3f/kzBZzWyho8Xz3BlLeK2/26kxixtztnudqrX4stt0t8n1V/sqGRvXfHjZfFHH
        UEeJpTgj0VCLuag4EQCOOAMdtgIAAA==
X-CMS-MailID: 20221003034159epcas5p1018bd8a2413cdd569a6d01b135163d35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221003034159epcas5p1018bd8a2413cdd569a6d01b135163d35
References: <CGME20221003034159epcas5p1018bd8a2413cdd569a6d01b135163d35@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch enables fixedbufs support for io_uring_cmd. This has already
been done in t/io_uring, just do it here as well.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 engines/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index d0fc61dc..c679177f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -433,6 +433,10 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		ld->prepped = 0;
 		sqe->flags |= IOSQE_ASYNC;
 	}
+	if (o->fixedbufs) {
+		sqe->uring_cmd_flags = IORING_URING_CMD_FIXED;
+		sqe->buf_index = io_u->index;
+	}
 
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
-- 
2.25.1

