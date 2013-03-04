Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63886 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3CDOTb (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 4 Mar 2013 09:19:31 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi8so2089675wib.7
        for <fio@vger.kernel.org>; Mon, 04 Mar 2013 06:19:30 -0800 (PST)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Mon, 4 Mar 2013 14:19:09 +0000
Message-ID: <CANUChTxj5=ZXXkJkkRs-mFoWH7mX+DXjE+5KwYtuUFY3hvXqhw@mail.gmail.com>
Subject: Seq Write with holes
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to setup a job file that tests interleaved data, so in
theory writing 256K blocks with a gap of 256K in between, the end
results is that I would like to write extra data into the gaps and
make sure it is not corrupting neighbouring areas.

But I'm having a problem with the first part.

Here is the jobfile:-

[global]
ioengine=libaio
direct=1
filename=/dev/sdb
verify=meta
verify_backlog=1
verify_dump=1
verify_fatal=1
stonewall

[Job 2]
name=SeqWrite256K
description=Sequential Write with 1M Bands (256K)
rw=write:1M
bs=256K
do_verify=0
verify_pattern=0x33333333
size=1G

[Job 4]
name=SeqVerify256K
description=Sequential Read/Verify from Sequential Write (256K)
rw=read:1M
bs=256K
do_verify=1
verify_pattern=0x33333333
size=1G

There seems to be a bug (or maybe by design) when using the 'size='
variable.  It seems to count the gaps (1M) within the size of 1G, but
only on the write, the reads seems to report the IO transferred as 1G

Here is the status of the runs:-

Run status group 0 (all jobs):
  WRITE: io=209920KB, aggrb=34039KB/s, minb=34039KB/s, maxb=34039KB/s,
mint=6167msec, maxt=6167msec

Run status group 1 (all jobs):
   READ: io=1025.0MB, aggrb=36759KB/s, minb=36759KB/s, maxb=36759KB/s,
mint=28553msec, maxt=28553msec

And you can see the Write IO is a lot lower than the Read IO, even
though I have asked it to cover the same disk space.

It could be that this is by design and it is my jobfile that is not
setup correctly, has anybody tried something like this before?

Thanks,
Gavin Martin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
