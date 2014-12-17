Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48824 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQU1y (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Dec 2014 15:27:54 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so101963wiw.3
        for <fio@vger.kernel.org>; Wed, 17 Dec 2014 12:27:53 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Dec 2014 14:27:53 -0600
Message-ID: <CAEyTGCfpBS1jE09EkGVFyMU5mn4Rtpt6aozdyyid2bxke+QvVQ@mail.gmail.com>
Subject: Huge eta with R/W mix job and job hangs
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,
  I am using the below job file, and this works fine when the numjobs
is less(ex: 5,10) however when I specify a huge numjobs , the job
hangs and shows a huge eta as shown below.

# fio FIO_Test.job
test: (g=0): rw=randrw, bs=71K-71K/20K-20K/20K-20K, ioengine=posixaio,
iodepth=32
...
fio-2.1.10
Starting 20 processes
Killed1 (f=1): [__________________m_] [0.0% done] [0KB/0KB/0KB /s]
[0/0/0 iops] [eta 1158050441d:06h:50m:07s]


When I just run a 100% Reads (71K) or 100% writes(20K) separately
with the below below parameters it works fine, but it is only when i
do a mix of reads and writes.

Any idea what is going on and if i am missing something?
OS:RHEL7
HDDs(sdf):2x300GB Hdds on RAID10

[test]
 name=test
 ioengine=posixaio
 invalidate=1
 iodepth=32
 bs=71K,20K
 group_reporting=1
 rw=randrw
 rwmixread=96
 rwmixwrite=4
 direct=1
 buffered=0
 size=1M
 time_based
 runtime=300
 filename=/dev/sdf
 numjobs=64

Please help!!
Thanks
