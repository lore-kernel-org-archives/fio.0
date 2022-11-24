Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EB8C43217
	for <fio@archiver.kernel.org>; Thu, 24 Nov 2022 13:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKXNAW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 24 Nov 2022 08:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiKXNAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Nov 2022 08:00:19 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867BB94A60
        for <fio@vger.kernel.org>; Thu, 24 Nov 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pVmS04CNadKbL425zW54s+yhg+sDIe2lUIXnfDUiReg=; b=Lp5slRFIocHYfKyn0Qcl+dubZU
        h9SoP7ycYL7FHE2IbAAqsD/QiJ5wvzk8N+I4XGpOteGv/N+ffECZEdIynf1q2bIERkLVzh+0u9MGs
        vwxTAX6isjTuMBBLuRqv53P8hTqFhgXFduxBP3NUoHWRPAADYfyvYFWBrQ7o7T517ZmPv0oIClLxA
        aOZxInNJVe+mw3NICCDm3uY1RqbYCuXk8VkZvmlBWhvWcgmv6GSmjjtndeHjTYJhICZI9gYpAUDVD
        NJ+yPcbBDfQARieFIX5RafiQS9hpR/S6/5Tqgoi9FtjvQ5yt+YKqz8IXI3J6BifBg0sOgJcX2Zf4I
        rjQLwwLA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oyBpk-004AJ6-M4
        for fio@vger.kernel.org; Thu, 24 Nov 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0803A1BC0106; Thu, 24 Nov 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221124130002.0803A1BC0106@kernel.dk>
Date:   Thu, 24 Nov 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit ede04c27b618842e32b2a3349672f6b59a1697e1:

  test: add large pattern test (2022-11-18 19:36:10 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 72044c66ac7055a98c9b3021c298c81849e3c990:

  doc: update about sqthread_poll (2022-11-23 14:06:03 -0500)

----------------------------------------------------------------
Ankit Kumar (2):
      engines:io_uring: fix clat calculation for sqthread poll
      doc: update about sqthread_poll

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/chienfuchen32/fio

chienfuchen32 (1):
      update documentation typo

 HOWTO.rst          |  6 ++++--
 engines/io_uring.c | 20 ++++++++++++++++++++
 fio.1              |  4 +++-
 3 files changed, 27 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index e796f961..4419ee1b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2299,7 +2299,9 @@ with the caveat that when used on the command line, they must come after the
 	kernel of available items in the SQ ring. If this option is set, the
 	act of submitting IO will be done by a polling thread in the kernel.
 	This frees up cycles for fio, at the cost of using more CPU in the
-	system.
+	system. As submission is just the time it takes to fill in the sqe
+	entries and any syscall required to wake up the idle kernel thread,
+	fio will not report submission latencies.
 
 .. option:: sqthread_poll_cpu=int : [io_uring] [io_uring_cmd]
 
@@ -4501,7 +4503,7 @@ Trace file format v2
 ~~~~~~~~~~~~~~~~~~~~
 
 The second version of the trace file format was added in fio version 1.17.  It
-allows to access more then one file per trace and has a bigger set of possible
+allows to access more than one file per trace and has a bigger set of possible
 file actions.
 
 The first line of the trace file has to be::
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
diff --git a/fio.1 b/fio.1
index 9e33c9e1..a156bf5d 100644
--- a/fio.1
+++ b/fio.1
@@ -2090,7 +2090,9 @@ sqthread_poll option.
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
-the cost of using more CPU in the system.
+the cost of using more CPU in the system. As submission is just the time it
+takes to fill in the sqe entries and any syscall required to wake up the idle
+kernel thread, fio will not report submission latencies.
 .TP
 .BI (io_uring,io_uring_cmd)sqthread_poll_cpu \fR=\fPint
 When `sqthread_poll` is set, this option provides a way to define which CPU
