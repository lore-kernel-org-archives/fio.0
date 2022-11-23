Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2461C433FE
	for <fio@archiver.kernel.org>; Wed, 23 Nov 2022 12:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbiKWMOf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiKWMOU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Nov 2022 07:14:20 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAE125E81
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 04:14:06 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221123121405epoutp0443b7a8ad11828f566d41dac9fb0e7ae2~qNbDJnpq_1882718827epoutp04S
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 12:14:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221123121405epoutp0443b7a8ad11828f566d41dac9fb0e7ae2~qNbDJnpq_1882718827epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669205645;
        bh=/S2iEJIHnj4pQLMLi1D68xUnTpXQ8xp9DJU1iHtBKNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTfocuON2QxwgAoeyobdM5j5aMiSw3Ep9CoKWxbeMktTOd4onJsFM7R38/GNKQKUw
         TjWeGvysUwBrvBp6DKqA5fZj8Fc5+fPTY09Wc0L3mRMXUtJ/xnR2gnXNQDE/lTW/Po
         4d4RBFz2ZasYxK75Q82GDNwBHP8i/GEjmwQhPDRA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221123121404epcas5p16c60eb93d1387375592510241abadca0~qNbCu0mCG1442914429epcas5p1W;
        Wed, 23 Nov 2022 12:14:04 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NHKmW2t7mz4x9Pp; Wed, 23 Nov
        2022 12:14:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.4C.56352.A8E0E736; Wed, 23 Nov 2022 21:14:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221123113912epcas5p3afe2a347b0069a830a04e6ff43d7659a~qM8mBhf780411404114epcas5p34;
        Wed, 23 Nov 2022 11:39:12 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221123113912epsmtrp1ffcb6f680c64493ee039e56ebffbe39b~qM8mA8G1P2031420314epsmtrp1p;
        Wed, 23 Nov 2022 11:39:12 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-fd-637e0e8a9fa4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.F3.18644.0660E736; Wed, 23 Nov 2022 20:39:12 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221123113911epsmtip183eba1ae5c6cf652a0df53368593c8e7~qM8lSIlxZ2286322863epsmtip1L;
        Wed, 23 Nov 2022 11:39:11 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/2] engines:io_uring: fix clat calculation for sqthread
 poll
Date:   Wed, 23 Nov 2022 16:57:37 +0530
Message-Id: <20221123112738.24820-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221123112738.24820-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmum4XX12yQcN2S4s1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD
        453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
        S2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iznr5bw1hwQLDiwpy5jA2ML3i7GDk5
        JARMJBbf2snSxcjFISSwm1Hi0v8eZgjnE6PEt+nH2CCcz4wSh67/Z4Jp+fz0MTtEYhejxMMN
        a6GcViaJ/Z27WECq2AS0JV69vcEMYosICEvs72gFizMLhEqcvPYFqIGDQ1ggSOLeJReQMIuA
        qsSnN/9ZQWxeARuJhWv3Qy2Tl1i94QDYGE4BW4lJ876yguySEFjGLrFo41s2iCIXiZ7lb6Ea
        hCVeHd/CDmFLSbzsb4OysyU2PfwJVVMgceRFLzOEbS/ReqqfGeQeZgFNifW79CHCshJTT61j
        gjiZT6L39xOoVl6JHfNgbFWJv/dus0DY0hI3312Fsj0k2iY1Q8N0AqPE0aZTjBMY5WYhrFjA
        yLiKUTK1oDg3PbXYtMA4L7UcHmvJ+bmbGMGJSst7B+OjBx/0DjEycTAeYpTgYFYS4a33rEkW
        4k1JrKxKLcqPLyrNSS0+xGgKDMCJzFKiyfnAVJlXEm9oYmlgYmZmZmJpbGaoJM67eIZWspBA
        emJJanZqakFqEUwfEwenVAOTt8TRU/+6+u37u098kdk6Xz9z5tPJepaHFp694/JfTib8d9er
        4OjJByTkvwov4f8Q9nFBxpqXFv/uxm69Ifr12c5L1cLJX+s39Ds+nyJVf/7avylbHgqKT5AQ
        u7xp6b3I7omry2eGPzvP5vW378L92//XPExrj+5ga6psOfT7QfehrEtbGPIay9WKTmwyV+xn
        D9985Y7Y1fPcy/zNWXkS2CRbHW/demOwuoLPRPZsY2twkJLxyutuSecuvbCsq1yQdu4Ee+ey
        yil/j4RqfNhxnWHdzV1ZR/4oPztQNq1s6lmVhHrWhTlGZtllj7fc/RsqHv/NJWxxc/za/Zty
        k66dmvKeQf/NqXVzQ86nP1n06qwSS3FGoqEWc1FxIgB/6Vtn3QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSnG4CW12ywaUFIhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGU8fbeGseCA
        YMWFOXMZGxhf8HYxcnJICJhIfH76mB3EFhLYwShxZK5vFyMHUFxaYuH6RIgSYYmV/54DlXAB
        lTQzSRw8twesnk1AW+LV2xvMILYIUNH+jlYWEJtZIFxi+oHJjCC2sECAxJwHf8DqWQRUJT69
        +c8KYvMK2EgsXLufCWKBvMTqDQfA5nAK2EpMmveVFeIeG4lvS7awTWDkW8DIsIpRMrWgODc9
        t9iwwCgvtVyvODG3uDQvXS85P3cTIziMtLR2MO5Z9UHvECMTB+MhRgkOZiUR3nrPmmQh3pTE
        yqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamBRX8JuylM4ymmPf
        Xj1t2kxf0Yn/19w/snbudNu4qR/Fs3XL77bMcZ4X394hMNl5ZWjijssqwSK33748Jthd+kvV
        96YQe4mgbd0PLt1LqxNNf3EHNB8Q6No2VbKyw8J0w8Pk52sjM5IvTnO/8etS2PvZs/oLZ6ya
        Yrl9ukiq2uLdWXKtqr/XXCyrOZHut9Hc9653vozgpvetx3z19gRduc5zW8nib4LL8neNIX9r
        5LZa/ejf81auNPmoUEmEynSePo4zDrPYrj47WaHn1c38sVigYivrDkaTG1p56lc+br5enyw2
        e8Ysjssh8xVlHq56KHnM443sF7+7PAHB9ZWMIibpfXFrS5/P9HBLOsz7SYmlOCPRUIu5qDgR
        AOmWpV+SAgAA
X-CMS-MailID: 20221123113912epcas5p3afe2a347b0069a830a04e6ff43d7659a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123113912epcas5p3afe2a347b0069a830a04e6ff43d7659a
References: <20221123112738.24820-1-ankit.kumar@samsung.com>
        <CGME20221123113912epcas5p3afe2a347b0069a830a04e6ff43d7659a@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When sqthread_poll is specified for io_uring and io_uring_cmd I/O
engines, fio reports garbage value for completion latencies. This is
because the issue time was not recorded. Added a change for that.
On the other hand submission latency for sqthread poll is really just
the time it takes to fill in the SQ ring entries and any syscall
required to wake up the idle kernel thread. So there is really no need
to report those.

This fixes the issue: https://github.com/axboe/fio/issues/1484

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 3c656b77..a9abd11d 100644
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
@@ -804,6 +808,14 @@ static int fio_ioring_queue_init(struct thread_data *td)
 			p.flags |= IORING_SETUP_SQ_AFF;
 			p.sq_thread_cpu = o->sqpoll_cpu;
 		}
+
+		/*
+		 * Submission latency for sqpoll_thread is just the time it
+		 * takes to fill in the SQ ring entries, and any syscall if
+		 * IORING_SQ_NEED_WAKEUP is set, we don't need to log that time
+		 * separately.
+		 */
+		td->o.disable_slat = 1;
 	}
 
 	/*
@@ -876,6 +888,14 @@ static int fio_ioring_cmd_queue_init(struct thread_data *td)
 			p.flags |= IORING_SETUP_SQ_AFF;
 			p.sq_thread_cpu = o->sqpoll_cpu;
 		}
+
+		/*
+		 * Submission latency for sqpoll_thread is just the time it
+		 * takes to fill in the SQ ring entries, and any syscall if
+		 * IORING_SQ_NEED_WAKEUP is set, we don't need to log that time
+		 * separately.
+		 */
+		td->o.disable_slat = 1;
 	}
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		p.flags |= IORING_SETUP_SQE128;
-- 
2.17.1

