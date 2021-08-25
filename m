Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240769AbhHYQS1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Aug 2021 12:18:27 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB3C0613CF
        for <fio@vger.kernel.org>; Wed, 25 Aug 2021 09:17:41 -0700 (PDT)
Received: from [2a00:1398:9:f612:f16c:129a:2c38:447d] (helo=kit-msx-50.kit.edu)
        by scc-mailout-kit-02.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (envelope-from <hans-peter.lehmann@kit.edu>)
        id 1mIvH6-0000gU-5h
        for fio@vger.kernel.org; Wed, 25 Aug 2021 17:57:12 +0200
From: Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Subject: Question: t/io_uring performance
Message-ID: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
Date: Wed, 25 Aug 2021 17:57:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


Hello,

I am currently trying to run the t/io_uring benchmark but I am unable to achieve the IOPS that I would expect. In 2019, Axboe achieved 1.6M IOPS [3] or 1.7M IOPS [1] using a single CPU core (4k random reads). On my machine (AMD EPYC 7702P, 2x Intel P4510 NVMe SSD, separate 3rd SSD for the OS), I can't even get close to those numbers.

Each of my SSDs can handle about 560k IOPS when running t/io_uring. Now, when I launch the benchmark with both SSDs, I still only get about 580k IOPS, from which each SSD gets about 300k IOPS. When I launch two separate t/io_uring instances, I get the full 560k IOPS on each device. To me, this sounds like the benchmark is CPU bound. Given that the CPU is quite decent, I am surprised that I only get half of the single-threaded IOPS that my SSDs could handle (and 1/3 of what Axboe got).

I am limited to using Linux 5.4.0 (Ubuntu 20.04) currently but the numbers from Axboe above are from 2019, when 5.4 was released. So while I don't expect to achieve insane numbers like Axboe in a more recent measurement [4], 580k seems way less than it should be. Does someone have an idea what could cause this significant difference? You can find some more measurement outputs below, for reference.

Best regards
Hans-Peter Lehmann

= Measurements =

Performance:
# t/io_uring -b 4096 /dev/nvme0n1 /dev/nvme1n1
i 3, argc 5
Added file /dev/nvme0n1 (submitter 0)
Added file /dev/nvme1n1 (submitter 0)
sq_ring ptr = 0x0x7f9643d92000
sqes ptr    = 0x0x7f9643d90000
cq_ring ptr = 0x0x7f9643d8e000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=1207502
IOPS=578400, IOS/call=32/31, inflight=102 (64, 38)
IOPS=582784, IOS/call=32/32, inflight=95 (31, 64)
IOPS=583040, IOS/call=32/31, inflight=125 (61, 64)
IOPS=584665, IOS/call=31/32, inflight=114 (64, 50)

Scheduler for both SSDs disabled:
# cat /sys/block/nvme0n1/queue/scheduler
[none] mq-deadline

Most time is spent in the kernel:
# time t/io_uring -b 4096 /dev/nvme0n1 /dev/nvme1n1
[...]
real    0m8.770s
user    0m0.156s
sys     0m8.514s

Call graph:
# perf report
- 93.90% io_ring_submit
   - [...]
     - 75.32% io_read
         - 67.13% blkdev_read_iter
           - 65.65% generic_file_read_iter
               - 63.20% blkdev_direct_IO
                 - 61.17% __blkdev_direct_IO
                     - 45.49% submit_bio
                       - 43.95% generic_make_request
                           - 33.30% blk_mq_make_request
                             + 8.52% blk_mq_get_request
                             + 8.02% blk_attempt_plug_merge
                             + 5.80% blk_flush_plug_list
                             + 1.48% __blk_queue_split
                             + 1.14% __blk_mq_sched_bio_merge
                             + [...]
                           + 7.90% generic_make_request_checks
                         0.62% blk_mq_make_request
                     + 8.50% bio_alloc_bioset

= References =

[1]: https://kernel.dk/io_uring.pdf
[2]: https://github.com/axboe/fio/issues/579#issuecomment-384345234
[3]: https://twitter.com/axboe/status/1174777844313911296
[4]: https://lore.kernel.org/io-uring/4af91b50-4a9c-8a16-9470-a51430bd7733@kernel.dk/T/#u

