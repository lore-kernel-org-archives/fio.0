Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgDVHX7 (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 22 Apr 2020 03:23:59 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B00C03C1A6
        for <fio@vger.kernel.org>; Wed, 22 Apr 2020 00:23:58 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id g74so1379061qke.13
        for <fio@vger.kernel.org>; Wed, 22 Apr 2020 00:23:58 -0700 (PDT)
MIME-Version: 1.0
From: KaiKai Chen <fast.marmot@gmail.com>
Date: Wed, 22 Apr 2020 00:23:46 -0700
Message-ID: <CAH8AYr4Boyh=1r9f96Qf66htO=oUET4RyiwiE0ZC=ZoOELzjDw@mail.gmail.com>
Subject: Write and verify
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I have some basic questions:

1. Is following a correct understanding?
If time_based is not set and nrfiles = 1 and size = 1GB.
A sequential write job will write 1GB worth of data and create a
"solid" 1GB file (writes will cover all file blocks).
A random write job with norandommap = 0 will write 1GB worth of data
and create a "solid" 1GB file (writes will cover all file blocks).
A random write job with norandommap = 1 will write 1GB worth of data
and create a 1GB file with potential "holes"  (some file blocks may
not be written).

2. Is the following a valid usage of fio's write and verify capabilities?
If so, is it possible to add "time_based" and "runtime" parameters to
the write-job and still expect verify-job to function correctly (i.e.
verify data that was written within runtime)?
Also, does "verify_only=1" mean the verify-job's "rw" parameter is
ignored? (suppose we've written sequentially, but want to verify the
data through random or sequential reads)
https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-verify-only
mentioned that "verify_only" flag "Do not perform specified workload,
only verify data still matches previous invocation of this workload."

[write-job]
ioengine=libaio
bs=4K
size=1GB
numjobs=2
iodepth=64
rw=randwrite
direct=1
verify_state_save=1
verify=crc32c
do_verify=0
serialize_overlap=1

[verify-job]
ioengine=libaio
bs=4K
size=1GB
numjobs=2
verify_state_load=1
verify_only=1
iodepth=64
rw=randread
direct=1
verify=crc32c

Thanks!

