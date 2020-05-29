Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388007AbgE2DuO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 May 2020 23:50:14 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B55FC08C5C6
        for <fio@vger.kernel.org>; Thu, 28 May 2020 20:50:14 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c35so656079edf.5
        for <fio@vger.kernel.org>; Thu, 28 May 2020 20:50:14 -0700 (PDT)
MIME-Version: 1.0
From: MARK CALLAGHAN <mdcallag@gmail.com>
Date: Thu, 28 May 2020 20:50:00 -0700
Message-ID: <CAFbpF8MmryafvBom4Vqu6TW-D8R6kxxnsXN1v+QoFsiVu4rK+w@mail.gmail.com>
Subject: Question about "Laying out IO file(s)" behavior
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was confused by the results while running a sequence of fio tests
that use 8 files. The files are created by the first run of fio,
reused by each run of fio and are shared by the jobs within each run.
The problem is that when fio creates the files:
* with --rw=write then it just does fallocate and then the test starts
* otherwise it does fallocate and then (probably) fully writes the
file prior to doing the requested test

I was confused by the results because the tests used direct IO and fio
was reporting far more iops than iostat. The problem is that when the
first test is "--rw=write" if it is not run long enough the the files
are not fully written and I assume that later tests that read the
unwritten parts of the files are fast because that read doesn't go to
storage. But if the first test is "--rw=randread" then the files are
fully written before the randread reads are done.

Is this expected and/or documented?

--- If this is the first test and the files don't exist when fio is started:

fio --name=foobar --rw=write --direct=1 --bs=4k --numjobs=1
--ioengine=psync --filesize=100G --runtime=30 --group_reporting
--filename=td1:td2:td3:td4:td5:td6:td7:td8 --randrepeat=0

--- then fallocate is done for the files, and then the test starts ...

write(1, "write: Laying out IO file(s) (8 "..., 52) = 52
unlink("td1")                           = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "td1", O_WRONLY|O_CREAT, 0644) = 3
fallocate(3, 0, 0, 107374182400)        = 0
fadvise64(3, 0, 107374182400, POSIX_FADV_DONTNEED) = 0
close(3)

--- But if this is the first test and the files don't exist when fio is started

fio --name=write --rw=randread --direct=1 --bs=4k --numjobs=1
--ioengine=psync --filesize=100G --runtime=30 --group_reporting
--filename=td1:td2:td3:td4:td5:td6:td7:td8 --randrepeat=0

--- then fallocate is done for the files and it looks like they are
fully written ...

write(1, "write: Laying out IO file(s) (8 "..., 52) = 52
unlink("td1")                           = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "td1", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 3
fallocate(3, 0, 0, 107374182400)        = 0
ftruncate(3, 107374182400)              = 0
write(3, ..., 4096) = 4096
... repeat many write() calls

-- 
Mark Callaghan
mdcallag@gmail.com

