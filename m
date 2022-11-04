Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A05C433FE
	for <fio@archiver.kernel.org>; Fri,  4 Nov 2022 12:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiKDMiR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Nov 2022 08:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiKDMiG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Nov 2022 08:38:06 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323932DA92
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 05:38:05 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221104123802epoutp01017483ffb71882e8a41a05ba2881d06b~kYfikpNdE0583105831epoutp01c
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 12:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221104123802epoutp01017483ffb71882e8a41a05ba2881d06b~kYfikpNdE0583105831epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667565482;
        bh=c/wVkZ0G1jKOkKNqRo6tNfZ/rhyQwx45T1GcB9u/T2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwslY004rXzDj920mYQPCfLY9LdNWsemzDPay9dEkyxX/GL62bKvIoBfBUK1b19hn
         a93ZlEhH+hE+GZlwQlMr4zEL4TGMtj5emmsZ5vBuUylXOKSn6qUsc9ikscY7YoMrzX
         idHK4JmqxW/WkCbbewpQ0EvhgBzhr3K37twTu5Zw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221104123802epcas5p468851af64fa5225991a4b94b7028ead0~kYfiUf0Y01948819488epcas5p4H;
        Fri,  4 Nov 2022 12:38:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N3gBw4vwvz4x9Pt; Fri,  4 Nov
        2022 12:38:00 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.1B.01710.8A705636; Fri,  4 Nov 2022 21:38:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221104112441epcas5p211f3960a712ba954139173a9c3b343df~kXffz4Nc51885918859epcas5p2P;
        Fri,  4 Nov 2022 11:24:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221104112441epsmtrp1bb084cee46a4937d07d98edc71b81658~kXffzHjda1396613966epsmtrp1K;
        Fri,  4 Nov 2022 11:24:41 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-61-636507a87887
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.7B.14392.976F4636; Fri,  4 Nov 2022 20:24:41 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104112440epsmtip2fab3e499e03d3c312e37a22bcde7262c~kXfe4eZAo0554505545epsmtip2C;
        Fri,  4 Nov 2022 11:24:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] engines:io_uring: slat and clat calculation with
 sqthread_poll
Date:   Fri,  4 Nov 2022 16:43:13 +0530
Message-Id: <20221104111314.25535-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104111314.25535-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmuu4K9tRkg03PuCzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOOLdyPmvBVOGK1dceMzUwbuHvYuTk
        kBAwkXh9YClbFyMXh5DAbkaJCR0zmCGcT4wSj3c0MEI43xglbq5aytrFyAHW0rE7DSK+l1Hi
        /sXzUB2tTBKL395jBZnLJqAt8ertDWYQW0RAWGJ/RysLiM0sECpx8toXdhBbGMheur2DDcRm
        EVCV6Hg+gR1kAa+AjcTVAz4Q58lLrN5wgBkkzClgK7HthDzIKgmBZewSi2Z8Z4aocZE4tqmB
        HcIWlnh1fAuULSXxsr8Nys6W2PTwJxOEXSBx5EUvVK+9ROupfrD5zAKaEut36UOEZSWmnlrH
        BHExn0Tv7ydQrbwSO+bB2KoSf+/dZoGwpSVuvrsKZXtIzH7cDA4FIYEJjBJzrxlOYJSbhbBh
        ASPjKkbJ1ILi3PTUYtMCw7zUcniUJefnbmIEpygtzx2Mdx980DvEyMTBeIhRgoNZSYT307bk
        ZCHelMTKqtSi/Pii0pzU4kOMpsDQm8gsJZqcD0ySeSXxhiaWBiZmZmYmlsZmhkrivItnaCUL
        CaQnlqRmp6YWpBbB9DFxcEo1MEnMD1l1fenzl3ZB7ic6fIQ9Hl9Lvldx6R1/vO5uk2bdHK3r
        qtKz69nuha4LLT3n4u7hnqube1G20PPes+iskg1W5lZS97RXSlg+iVv66eQlVt6uLtnG/N9Z
        qWI2r3tUWuwi+JV/FnpOqbuyJXTKDYOJRZrWSimvvk8t/JzTK/B6zswXBhuNNXKsZ09LOOxR
        7ct3+FZd9a7Vk5I/75p09Ln5waKZPg8L0hJvfzqh9VTxj+LXxwub3xbIN7ja6kRqmX7T/Z9+
        Z2FCgM8MqYqe+I6lJz9qPvf8Mb1m58TKugNiWqUBTs/Oy6m+mPtC77p81dS8rtlfXxWxbWj3
        uN8StjZxUchLq4VmypGLYuzFlViKMxINtZiLihMBfAhhy9oDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSvG7lt5Rkg0OLJS3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4t3I+a8FU
        4YrV1x4zNTBu4e9i5OCQEDCR6Nid1sXIxSEksJtRYumNY2wQcWmJhesTuxg5gUxhiZX/nrOD
        2EICzUwSnyZlgdhsAtoSr97eYAaxRYBq9ne0soDYzALhEtMPTGYEsYUFgiXWtO9gBbFZBFQl
        Op5PYAcZzytgI3H1gA/EeHmJ1RsOMIOEOQVsJbadkIfYZCOxctFklgmMfAsYGVYxSqYWFOem
        5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHkJbmDsbtqz7oHWJk4mA8xCjBwawkwvtpW3KyEG9K
        YmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUxbvyT/yt+8sruv
        o/OO8iyRVp8Pv9vu5p7WkXK83uteLXDnrEqb25IPWqX5kz/kFrifsk/LXNznK3LNr9pum5TV
        diHD7Meej4U2vVzzWCwgX3XFxtXpptXTvctKxJ9zFaXfXs/+eY9wVOAJn9l/jndY/zmZJ9x/
        McPxlNrsl9+41m9YnPCw+5bdK+Hv/M2HtjYXHl27d4uWfuYWmfevLbVj15ruK4juEd56XetO
        BEvEffv5zLkPL/RZvDtSK7w5TXX2K8aP7HLzNC+aPWVZLxLc9cQt3EyF2eGzrYL+r5Yr7i86
        bsiocDFfbfdliNvy0/NMue+VtD1n0yN027o2GrR8thW5Ud/jaBJ381S6pRJLcUaioRZzUXEi
        ABBuauCPAgAA
X-CMS-MailID: 20221104112441epcas5p211f3960a712ba954139173a9c3b343df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104112441epcas5p211f3960a712ba954139173a9c3b343df
References: <20221104111314.25535-1-ankit.kumar@samsung.com>
        <CGME20221104112441epcas5p211f3960a712ba954139173a9c3b343df@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When sqthread_poll is specified for io_uring and io_uring_cmd I/O engines,
fio doesn't report submission latency and the completion latency is too big.
Latency data before:

fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
    clat (msec): min=1120.1k, max=1120.1k, avg=1120092.65, stdev= 8.32
     lat (usec): min=104, max=5312, avg=132.81, stdev=325.05
    clat percentiles (msec):
     |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
     | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
     | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
  lat (msec)   : >=2000=100.00%

As kernel polling thread handles the submission, there is no way to know when
the actual submission happened. We can only rely on the commit hook and
measure the issue time.
Latency data after the change:

fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
    slat (nsec): min=50, max=2230, avg=146.68, stdev=138.08
    clat (usec): min=105, max=5151, avg=132.98, stdev=314.89
     lat (usec): min=105, max=5153, avg=133.13, stdev=315.03
    clat percentiles (usec):
     |  1.00th=[  106],  5.00th=[  108], 10.00th=[  109], 20.00th=[  110],
     | 30.00th=[  111], 40.00th=[  113], 50.00th=[  114], 60.00th=[  115],
     | 70.00th=[  117], 80.00th=[  118], 90.00th=[  119], 95.00th=[  121],
     | 99.00th=[  123], 99.50th=[  123], 99.90th=[ 5145], 99.95th=[ 5145],
     | 99.99th=[ 5145]
  lat (usec)   : 250=99.61%
  lat (msec)   : 10=0.39%

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6906e0a4..0d18fd4a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -637,12 +637,16 @@ static int fio_ioring_commit(struct thread_data *td)
 	 */
 	if (o->sqpoll_thread) {
 		struct io_sq_ring *ring = &ld->sq_ring;
+		unsigned start = *ld->sq_ring.head;
 		unsigned flags;
 
 		flags = atomic_load_acquire(ring->flags);
 		if (flags & IORING_SQ_NEED_WAKEUP)
 			io_uring_enter(ld, ld->queued, 0,
 					IORING_ENTER_SQ_WAKEUP);
+		fio_ioring_queued(td, start, ld->queued);
+		io_u_mark_submit(td, ld->queued);
+
 		ld->queued = 0;
 		return 0;
 	}
-- 
2.17.1

