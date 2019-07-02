Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f43.google.com ([209.85.166.43]:40443 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBAEF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 Jul 2019 20:04:05 -0400
Received: by mail-io1-f43.google.com with SMTP id n5so32899697ioc.7
        for <fio@vger.kernel.org>; Mon, 01 Jul 2019 17:04:05 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Mon, 1 Jul 2019 17:03:52 -0700
Message-ID: <CAF+0mvm4RkkOV1S53Q5HDsvmt0g8RfLFm1nGc-i0U+8NcV-2WA@mail.gmail.com>
Subject: Concurrent random and sequential IO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi group,

I'm trying to create a workload that is 50% random read and 50%
sequential write. Is the command line below accurate for that
workload?

fio --ioengine=libaio --direct=1 --size=100% --bs=16k --rw=randrw
--percentage_random=50,50 --numjobs=1 --iodepth=32 --runtime=600
--time_based --norandommap --randrepeat=0 --refill_buffers --name=job1
--filename=/dev/sdb

