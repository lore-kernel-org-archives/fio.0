Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33901 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935166AbcHBOf0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Aug 2016 10:35:26 -0400
Received: by mail-oi0-f47.google.com with SMTP id l65so238846802oib.1
        for <fio@vger.kernel.org>; Tue, 02 Aug 2016 07:34:49 -0700 (PDT)
MIME-Version: 1.0
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Tue, 2 Aug 2016 22:29:18 +0800
Message-ID: <CABtFm2X1th74qPOKaT+UG7rA-X8bjiADLE7x3n3qBjS7YAibNg@mail.gmail.com>
Subject: create_on_open fails with "err=5/file:backend.c:498"
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi All,

With the latest version of FIO, i see that create_on_open failing
always with error "err=5/file:backend.c:498"

# fio --name=test --directory=/testdata --nrfiles=10 --size=1g
--refill_buffers=1 --direct=1 --create_on_open=1
test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.13-28-g059b6
Starting 1 process
fio: pid=8439, err=5/file:backend.c:498, func=full resid,
error=Input/output error

test: (groupid=0, jobs=1): err= 5 (file:backend.c:498, func=full
resid, error=Input/output error): pid=8439: Tue Aug  2 10:24:08 2016
  cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=57
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=1/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):

Disk stats (read/write):
    dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
aggrutil=0.00%
  sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

# fio --version
fio-2.13-28-g059b6

The execution was on RHEL7.2 and CentOS7.2

Thanks for your support.

--
Srinivasa R Chamarthy
