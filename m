Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36455 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdAXPTe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2017 10:19:34 -0500
Received: by mail-wm0-f47.google.com with SMTP id c85so186712236wmi.1
        for <fio@vger.kernel.org>; Tue, 24 Jan 2017 07:19:23 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
 <c7fc722c-f3ca-4abe-7202-8ca67b5e59a0@gmail.com>
 <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <48506f17-d810-117b-2d70-e4a788907a72@gmail.com>
Date: Tue, 24 Jan 2017 16:19:21 +0100
MIME-Version: 1.0
In-Reply-To: <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Andrey,

> Changing sector to 4k is easy, this can really help. see DCT manual, it’s there.
> This can be relevant for you https://itpeernetwork.intel.com/how-to-configure-oracle-redo-on-the-intel-pcie-ssd-dc-p3700/

After overcoming my issues with isdct, and reformatting the NVMes to 4k 
sector size, success!

9.5 mio IOPS =)

This is another 34% faster than before.

So: thanks a bunch for your tip!

Cheers,
/Tobias


Next steps:

- approach MD developers about bottlenecks there
- approach PostgreSQL about using pread/pwrite (instead of lseek/read/write)


randread-individual-nvmes: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, 
ioengine=libaio, iodepth=128
...
fio-2.1.11
Starting 128 threads
Jobs: 128 (f=2048): [r(128)] [100.0% done] [37244MB/0KB/0KB /s] 
[9534K/0/0 iops] [eta 00m:00s]
randread-individual-nvmes: (groupid=0, jobs=128): err= 0: pid=25406: Tue 
Jan 24 15:57:19 2017
   read : io=1083.9GB, bw=36964MB/s, iops=9462.8K, runt= 30026msec
   cpu          : usr=9.00%, sys=77.01%, ctx=49252920, majf=0, minf=16512

