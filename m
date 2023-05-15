Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C45C7EE24
	for <fio@archiver.kernel.org>; Mon, 15 May 2023 05:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjEOFuQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 May 2023 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjEOFuJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 May 2023 01:50:09 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108E82689
        for <fio@vger.kernel.org>; Sun, 14 May 2023 22:49:50 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230515054948epoutp03750ade47f324aa216786e3bff1299632~fOx6fyzVb1709417094epoutp03R
        for <fio@vger.kernel.org>; Mon, 15 May 2023 05:49:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230515054948epoutp03750ade47f324aa216786e3bff1299632~fOx6fyzVb1709417094epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684129788;
        bh=XK2fDVBcAhVfJt8g+lwVJz19fmN/a5+S4lzxiTvro14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTXsSiiksq0fGJqLMp5nM9M4Uchf8ir6VSnA2vAM4gNqbcZRK9DyoHaEELKXR7E2q
         pcfW1/AgUmnbwCVxVscd41j3Zf+lzl+d1uspSWmAvKibcfMXH2bIHW7bo49OrlwqKk
         634RbLtFsjLpX+OQPPp84F6RYctBuJrya0Mjv2Jc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230515054947epcas5p15f2e6ebb4afd0a8ff834de262acfb83f~fOx6DpYcd0373703737epcas5p1o;
        Mon, 15 May 2023 05:49:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QKT3G0qZ7z4x9Px; Mon, 15 May
        2023 05:49:46 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.6C.54880.8F7C1646; Mon, 15 May 2023 14:49:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230515054351epcas5p1f2922cc8507e9e6a57bb0228914ff0bc~fOsuURxdB2439524395epcas5p1r;
        Mon, 15 May 2023 05:43:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230515054351epsmtrp1e172a7b7f530c3767d59481ba76fce04~fOsuTXbKO1628916289epsmtrp1a;
        Mon, 15 May 2023 05:43:51 +0000 (GMT)
X-AuditID: b6c32a49-8c5ff7000001d660-d6-6461c7f88551
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.0D.27706.796C1646; Mon, 15 May 2023 14:43:51 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230515054350epsmtip2dc753c4c46a65170a65aafa807136165~fOstfQAKK0682106821epsmtip2b;
        Mon, 15 May 2023 05:43:50 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/2] engines/nvme: support for 64 LBA formats
Date:   Mon, 15 May 2023 16:33:39 +0530
Message-Id: <20230515110340.21984-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515110340.21984-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmhu6P44kpBhtv8lusufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM1s74gs+8FZNnlDUw/ubq
        YuTkkBAwkbizfylrFyMXh5DAbkaJdcePMEI4nxglLv+ZxALhfGOUOH1lKhNMy/x9n9ghEnsZ
        JR7cboNq6WSS+Nb1mBWkik1AW+LV2xvMILaIgLDE/o5WFhCbWSBL4sSKNjBbWMBB4tWXB2D1
        LAKqEpeOzAKr5xWwkdh/5hDUNnmJmZe+s4PYnAK2Eg3bf7NA1AhKnJz5BGqmvETz1tnMEPWn
        2CWWzJeEsF0k7v3dzgZhC0u8Or6FHcKWknjZ3wZlZ0tsevgTaleBxJEXvVBz7CVaT/UD2RxA
        8zUl1u/ShwjLSkw9tY4JYi2fRO/vJ1CtvBI75sHYqhJ/791mgbClJW6+uwple0j8WXwLGlYT
        GCVW3n/MPoFRYRaSd2YheWcWwuoFjMyrGCVTC4pz01OLTQsM81LL4XGcnJ+7iRGcDrU8dzDe
        ffBB7xAjEwfjIUYJDmYlEd72mfEpQrwpiZVVqUX58UWlOanFhxhNgeE9kVlKNDkfmJDzSuIN
        TSwNTMzMzEwsjc0MlcR51W1PJgsJpCeWpGanphakFsH0MXFwSjUwZc76Z3DZOjdUQDL5hKDx
        o9MRXw36JR/dK3c8GPTjWZycCaOvX+x2v9epIpGH5/KXsC/6PO2QAPOOoONfWl/te8LtsN4p
        VufCgjn5zVf2pji9vLFftupLtcy6czGeOhYyD7MUi46eXTdl4on7kyL1n23dWBqxWvDdHSNu
        XpsNO1xXBa1d838jf9eBwHt85eaCfQobw3Xq99k9V7cJqF/YYc2mqZmz/vuh2Q/bOBWmrNn4
        91SjwVLZjD6lyV8i/u+M2LNqun/U1SnK8/tC1pQdaPW0WMAUfOy9cOeB9qp55lX9/2NffmSq
        6LHbH7HovJvOO8+CQ5eqemcYHzxsLMvOzz39YeEWoRPpX+YXvrNVUGIpzkg01GIuKk4EAEK1
        xkIQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWy7bCSvO70Y4kpBjMuqlmsufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsErozW
        zviCz7wVk2eUNTD+5upi5OSQEDCRmL/vE3sXIxeHkMBuRonH//8DORxACWmJhesTIWqEJVb+
        ew5V084ksffvaWaQBJuAtsSrtzfAbBGgov0drSwgvcwCeRLfVqmAhIUFHCRefXnACmKzCKhK
        XDoyC6ycV8BGYv+ZQ0wQ8+UlZl76zg5icwrYSjRs/80CYgsB1Sy/togJol5Q4uTMJ2BxZqD6
        5q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwsGpp7mDc
        vuqD3iFGJg7GQ4wSHMxKIrztM+NThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliS
        mp2aWpBaBJNl4uCUamBy0i58eFFrw/oTLMdSTzz62WN++lSzh6sbA9uTDacEdmRtO3G2IYY7
        LWXDn/jMO/tkWafomBzLOsTSmjF56dut1vZ2brxMlcVlqT9tInPmCj6dy/VM6mrZp/ccs1dP
        0TZe1yod43ndhKFls9z/yhvvf1bkLU0XWr7Y6Ywon6zzql0RX4+e+B3+7nz2S6s9nR7/N5yu
        ctr7KsOQJe6jWODtXe80+mzM68TKbjB/7+O7/Pv5nKSAfZILzvXJ1b13uHf10jrN5ocMf85P
        v3q72HJxY5vV4hV3nn+UkWibuON2t4yOw2zfF4LpPTP9V98X15C4f0jueNJLS7d8E5lzdWva
        03Zm8P/zuTbXJOSbn+s1JZbijERDLeai4kQAyY4rG8UCAAA=
X-CMS-MailID: 20230515054351epcas5p1f2922cc8507e9e6a57bb0228914ff0bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515054351epcas5p1f2922cc8507e9e6a57bb0228914ff0bc
References: <20230515110340.21984-1-ankit.kumar@samsung.com>
        <CGME20230515054351epcas5p1f2922cc8507e9e6a57bb0228914ff0bc@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The NVM command set specification 1.0c supports 64 LBA formats.
The 0-based nlbaf field specifies the number of LBA formats.
The flbas field is used to calculate the current LBA format, in which
bit 0-3 indicates lsb and bit 5-6 indicates msb of the format index.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 14 +++++++++++++-
 engines/nvme.h |  3 +--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index fd2161f3..96a5f064 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -99,6 +99,7 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	struct nvme_id_ns ns;
 	int namespace_id;
 	int fd, err;
+	__u32 format_idx;
 
 	if (f->filetype != FIO_TYPE_CHAR) {
 		log_err("ioengine io_uring_cmd only works with nvme ns "
@@ -131,7 +132,18 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	}
 
 	*nsid = namespace_id;
-	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+
+	/*
+	 * 16 or 64 as maximum number of supported LBA formats.
+	 * From flbas bit 0-3 indicates lsb and bit 5-6 indicates msb
+	 * of the format index used to format the namespace.
+	 */
+	if (ns.nlbaf < 16)
+		format_idx = ns.flbas & 0xf;
+	else
+		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
+
+	*lba_sz = 1 << ns.lbaf[format_idx].ds;
 	*nlba = ns.nsze;
 
 	close(fd);
diff --git a/engines/nvme.h b/engines/nvme.h
index 408594d5..9d6288c8 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -134,8 +134,7 @@ struct nvme_id_ns {
 	__le16			endgid;
 	__u8			nguid[16];
 	__u8			eui64[8];
-	struct nvme_lbaf	lbaf[16];
-	__u8			rsvd192[192];
+	struct nvme_lbaf	lbaf[64];
 	__u8			vs[3712];
 };
 
-- 
2.25.1

