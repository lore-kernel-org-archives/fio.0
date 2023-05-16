Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E55C77B7A
	for <fio@archiver.kernel.org>; Tue, 16 May 2023 06:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjEPG7d (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 May 2023 02:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjEPG73 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 May 2023 02:59:29 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AFC198
        for <fio@vger.kernel.org>; Mon, 15 May 2023 23:59:24 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230516065922epoutp01ef4626b3df860802192a6805ce48d467~fjX8KOPpV1314513145epoutp01J
        for <fio@vger.kernel.org>; Tue, 16 May 2023 06:59:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230516065922epoutp01ef4626b3df860802192a6805ce48d467~fjX8KOPpV1314513145epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684220362;
        bh=zu6pkJjzURCDiqHvu2k6zfosJoBywdPcqwOiz7PTPGo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HPLZHFzFQTsSDzaJNtH3lha73RBuwwr3HhFzJ8LeIWNEHwQjHyZiP9P65CsNp8MXr
         TdiEVJHZXqchTJWGoOZ4KRRPb/9q+5Kx9DY204X3H7CdceFsOGo8e0/eWxDDQWNbHX
         B9GwR+sUhQRJfEmE3Jv7wvIUmiOFX+2XBcLrsNdA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230516065922epcas5p4cb171b6d852869331ccd6ba2cf422fc3~fjX732k7x0616506165epcas5p4Q;
        Tue, 16 May 2023 06:59:22 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QL6Y4650dz4x9QP; Tue, 16 May
        2023 06:59:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.CA.57769.5C923646; Tue, 16 May 2023 15:59:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230516065713epcas5p213f17bd22ff9c5256940dc420e6c07c9~fjWDy7bhE1389813898epcas5p2R;
        Tue, 16 May 2023 06:57:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516065713epsmtrp2b4071845c297de52b3fc6213f4aea3cd~fjWDyQdC52195421954epsmtrp2_;
        Tue, 16 May 2023 06:57:13 +0000 (GMT)
X-AuditID: b6c32a4a-f3bfd7000001e1a9-e9-646329c5cdc4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.C5.27706.94923646; Tue, 16 May 2023 15:57:13 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230516065712epsmtip230bcb078aa7efb53a21518929275fae5~fjWDF38xI1271912719epsmtip2Y;
        Tue, 16 May 2023 06:57:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] fix  coverity issue
Date:   Tue, 16 May 2023 17:47:16 +0530
Message-Id: <20230516121717.28508-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmlu5RzeQUg+kHLC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOWPvnMmtBM3NF68qHrA2Mu5m6GDk5
        JARMJPZcn88CYgsJ7GaUuNeV2sXIBWR/YpS4vPszK4TzjVHi84teZpiOp0u7WCE69gJ1nMyD
        KOpkkpjZdxBsFJuAtsSrtzfAGkQEhCX2d7SCxZkFQiVOXvvCDmILC2hInFr3iK2LkYODRUBV
        4uZyMZAwr4CNxLwv71ghdslLzLz0nR0iLihxcuYTqDHyEs1bZzOD7JUQWMcucXvvQajjXCTO
        nvoD9ZqwxKvjW9ghbCmJz+/2skHY2RKbHv6EqimQOAL3mL1E66l+ZpB7mAU0Jdbv0ocIy0pM
        PbWOCWIvn0Tv7ydQrbwSO+bB2KoSf+/dZoGwpSVuvrsKZXtIHNx1jA0SVrESRzfPYp3AKD8L
        yTuzkLwzC2HzAkbmVYySqQXFuempxaYFRnmp5fBoTc7P3cQITnVaXjsYHz74oHeIkYmD8RCj
        BAezkghv+8z4FCHelMTKqtSi/Pii0pzU4kOMpsAgnsgsJZqcD0y2eSXxhiaWBiZmZmYmlsZm
        hkrivOq2J5OFBNITS1KzU1MLUotg+pg4OKUamGSbN2jdeCu4YEpJQPn68Lkn19Z9nrdie8Rh
        kSW9655tffPU0J0nftLKjYHvOzbGPX+rufNHYPcfJh4/Xf3UxUujVvG6/5ZLrWR0MpD2/f69
        /+T8m09F1Wy+WHiaxZa0nVT1XdQ04YT8mr4Eoz79be3nFrae414Wu29lUZ3891D5xJh3ynIH
        2LOqZ4g+FS5Yon75sn73q2X/ZzmzMG8//2mz5sZdmya3HOnvl468zOrW+IRbqjx4p7Ko/LHy
        fcpF1UfqrW1/hj2cHph/afLSc3+D8j8mBUwyOm148E+p5csb03VkklOP158xUp6U/fzXk2Nu
        2bMTjgkbBqZ6qnD9maH84EmD0IHFrE4ffy691q3EUpyRaKjFXFScCAC0q4A3/gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsWy7bCSvK6nZnKKwb3V7BZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGWs/XOZtaCZ
        uaJ15UPWBsbdTF2MnBwSAiYST5d2sXYxcnEICexmlNh0pputi5EDKCEtsXB9IkSNsMTKf8/Z
        IWramSSe/FjJDJJgE9CWePX2BpgtAlS0v6OVBcRmFgiXmH5gMiOILSygIXFq3SOwmSwCqhI3
        l4uBhHkFbCTmfXnHCjFfXmLmpe/sEHFBiZMzn0CNkZdo3jqbeQIj3ywkqVlIUgsYmVYxSqYW
        FOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgSHnZbmDsbtqz7oHWJk4mA8xCjBwawkwts+Mz5F
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBiajTYIFqmft
        5zdff/0wdYt33vUJrxatfmK6Skp93nz/590zHsT6NMzV7ZZhvaz9rGhy+2n/4jPJT75NnrDX
        6PoPXm+x1sk7NE0b5taoVTheM9SOF3YvXnAgzY0/iO8Od4nmm6LsCbFPz84uO3svVCLYdk7t
        2bpDPB9b/rwpf5N84kmgqj3/jWflP2OPqJ67LCZxL+hPMa8H/9/j5v/D+qfPL9uUHu2g+UbE
        suX44zn5Kdxxfns6k5iuffx13cRpysl7F7ds2/w7zdtbrXoqz+q0BwUmr5OMr6i3uIvdW1T1
        f5qlqtPWTRFbtuUnxLlHJRqsrnmgVpsezCjeLFIXmx7vfOKZlsQ2W5nZ00/rL1RiKc5INNRi
        LipOBABaG/7kqgIAAA==
X-CMS-MailID: 20230516065713epcas5p213f17bd22ff9c5256940dc420e6c07c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230516065713epcas5p213f17bd22ff9c5256940dc420e6c07c9
References: <CGME20230516065713epcas5p213f17bd22ff9c5256940dc420e6c07c9@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch fixes the below mentioned coverity issue
CID 455020:  Integer handling issues  (BAD_SHIFT)
/engines/io_uring.c: 1201 in fio_ioring_cmd_open_file()

Fixes: 345fa8f ("engines/io_uring_cmd: add extended LBA support")

Ankit Kumar (1):
  engines/io_uring: fix coverity issue

 engines/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.1

