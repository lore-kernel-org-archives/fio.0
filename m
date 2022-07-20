Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D880CCCA486
	for <fio@archiver.kernel.org>; Wed, 20 Jul 2022 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiGTJbe (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 20 Jul 2022 05:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbiGTJb1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Jul 2022 05:31:27 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EB958848
        for <fio@vger.kernel.org>; Wed, 20 Jul 2022 02:31:25 -0700 (PDT)
X-QQ-mid: bizesmtp65t1658309464t5kcqyci
Received: from eureka.localdomain ( [123.124.208.226])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 20 Jul 2022 17:30:51 +0800 (CST)
X-QQ-SSF: 01400000002000B0D000000A0000020
X-QQ-FEAT: hoArX50alxG/Em5tr+cjD56eDWqOPkiKaRqdDQ9vGGbrlnaAHGGwmB+D0Nsox
        OI9UqoySXCx41SDJA5Ofz1EJIBoDdK4d9gmoSc4YUoQeQG2/xjIr04w+qutBGoM92YUDf3y
        1+3pN3kuapLW2zbJs/aAkxNnelPShvLMVAhbcmX19iHrrJ5Zy9giqyCWt8bMYjP7hv2wjaC
        y1ACKxCStoTnT5iObt5JMD9LeUqtSV8LUJpmVBDI1529XhbwpXVXSLOQ9i3xL13KXuEdFN4
        TeT/QrKz8Ka6awfkWTB1d0yzJdE7y0f1R2+S/yuiBeOkXQdeatuLCZawllNd+TNDr269SjE
        FIP3ms0L+W2e4EH+/t77SpAeaS7uj63EZ5d1hLGHBSrnEWLXcdhM+yIkWkEU7sNahAkS2/u
        RWXZ5L+pVv4=
X-QQ-GoodBg: 1
From:   Wang You <wangyoua@uniontech.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@lst.de, jaegeuk@kernel.org, fio@vger.kernel.org,
        ming.lei@redhat.com, wangyoua@uniontech.com,
        wangxiaohua@uniontech.com
Subject: [PATCH 0/2] Improve mq-deadline performance in HDD
Date:   Wed, 20 Jul 2022 17:30:46 +0800
Message-Id: <20220720093048.225944-1-wangyoua@uniontech.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi jens,

We already know that batching requests can increase the storage
performance of some devices, but after testing, I found that it
will reduce the performance of some low and medium speed devices
when using the scheduler (especially mq-deadline), such as
rotational disks connected to a raid.

In order to balance the performance difference between different
devices, a more sophisticated mechanism may be needed to control
the number of batching (such as sometimes 1 is better),
but obviously this is not easy.

At the same time I noticed that when the mq-deadline scheduler select
a request for a higher sector outside the batch, deadline_fifo_request
is used to select the request within the fifo and restart the batch.
Selecting a request from a fifo tends to satisfy the request's timeline,
but it is not always very urgent.

So in the case of no expire, can the selection strategy of the first
request in the batch be changed? Because in devices with rotation
characteristics, proper sector access order is beneficial to performance.

This patch series includes the following two parts:

- Added a temporary sys interface nr_sched_batch to control the number
  of batching requests.

- Added a deadline_head_request function to select the request from the
  first of the red-black tree instead of the fifo when appropriate.

Thanks,

Wang.

Wang You (2):
  block: Introduce nr_sched_batch sys interface
  block/mq-deadline: Prioritize first request

 block/blk-mq-sched.c   |  4 +++-
 block/blk-sysfs.c      | 34 ++++++++++++++++++++++++++++++++++
 block/mq-deadline.c    | 42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h |  1 +
 4 files changed, 77 insertions(+), 4 deletions(-)

-- 
2.27.0




