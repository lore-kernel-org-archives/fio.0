Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36339 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161891AbcEaBfV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 30 May 2016 21:35:21 -0400
Received: by mail-io0-f176.google.com with SMTP id f8so117944924ioe.3
        for <fio@vger.kernel.org>; Mon, 30 May 2016 18:35:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANvN+en4j2JVHH3dBrJO4JXkbYKi=ZkiGFzPJGDEvN-QN7ow+w@mail.gmail.com>
References: <CAMy1HkEAccd5FwvUKpJMuaKtcGa_T18GXdivR06S8Ne7m0Qq=w@mail.gmail.com>
 <CANvN+en4j2JVHH3dBrJO4JXkbYKi=ZkiGFzPJGDEvN-QN7ow+w@mail.gmail.com>
From: Nitin Mathur <nitinmathur@gmail.com>
Date: Tue, 31 May 2016 09:34:40 +0800
Message-ID: <CAMy1HkHsn5hK_ptXRjqfXGKxbc+1XjCc8EjWFg_Bb7oebSEMMA@mail.gmail.com>
Subject: Re: fio error when using direct=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Tim Walker <tim.t.walker@seagate.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
I could figure out the problem,  thanks to Tim and Andrey.

The problem was my SSD was configured for 4K LBA size. I formatted the
drive to 512 bytes, and could issue the IOs seamlessly.

Thanks again for your kind support.
Nitin


On Tue, May 31, 2016 at 12:36 AM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> On Mon, May 30, 2016 at 6:34 PM, Nitin Mathur <nitinmathur@gmail.com> wrote:
>> I am getting the following error and need help from someone
>>
>> Test environment
>> CentOS 6.5
>> Linux kernel: 3.8.8, 64 bit
>> FIO version: fio-2.11
>>
>> I run the following command
>>
>>> ./fio --name=test_workld --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --iodepth=256 --size=100% --numjobs=4 --bssplit=512/4:64k/96 --random_distribution=zoned:50/5:50/95 --overwrite=1 --output=test_op --filename=/dev/nvme0n1 --group_reporting --runtime=1m --time_based
>>
>>
>> This means, I'm using libaio, with a queue depth of 256, and fio is
>> utilizing asynchronous IO engines. But when i run this command, it
>> results into an error "Invalid argument". If i change the parameter
>> --direct=0, I'm able to issue the command successfully.
>>
>> Can you help me to understand, why with direct=1, the fio command
>> results in an error  ?
>
> Running your exact command, with a regular file substituted for your
> nvme device, works as expected (Ubuntu 15.10), see the below output.
> I'd suggest to double-check for issues with your hardware;  notice
> also that, by switching the direct mode off, you're enabling the I/O
> buffering in the kernel that might shadow a hardware issue.
>
> Regards,
> Andrey
>
> test_workld: (g=0): rw=randrw, bs=512-64K/512-64K/512-64K,
> ioengine=libaio, iodepth=256
> ...
> fio-2.11-6-gaa7d2
> Starting 4 processes
>
> test_workld: (groupid=0, jobs=4): err= 0: pid=4737: Mon May 30 19:27:59 2016
>   read : io=4642.2MB, bw=79145KB/s, iops=1287, runt= 60061msec
>     slat (usec): min=3, max=172023, avg=771.14, stdev=5230.71
>     clat (msec): min=43, max=886, avg=294.99, stdev=114.25
>      lat (msec): min=43, max=886, avg=295.77, stdev=114.52
>     clat percentiles (msec):
>      |  1.00th=[   87],  5.00th=[  135], 10.00th=[  165], 20.00th=[  200],
>      | 30.00th=[  229], 40.00th=[  255], 50.00th=[  281], 60.00th=[  306],
>      | 70.00th=[  343], 80.00th=[  379], 90.00th=[  445], 95.00th=[  506],
>      | 99.00th=[  635], 99.50th=[  676], 99.90th=[  791], 99.95th=[  832],
>      | 99.99th=[  865]
>     bw (KB  /s): min= 2048, max=40470, per=24.95%, avg=19744.95, stdev=6431.47
>   write: io=6941.7MB, bw=118340KB/s, iops=1927, runt= 60061msec
>     slat (usec): min=4, max=202368, avg=1550.36, stdev=8194.83
>     clat (msec): min=2, max=1011, avg=330.34, stdev=126.13
>      lat (msec): min=32, max=1011, avg=331.89, stdev=126.56
>     clat percentiles (msec):
>      |  1.00th=[  100],  5.00th=[  153], 10.00th=[  184], 20.00th=[  227],
>      | 30.00th=[  258], 40.00th=[  285], 50.00th=[  314], 60.00th=[  347],
>      | 70.00th=[  379], 80.00th=[  424], 90.00th=[  494], 95.00th=[  562],
>      | 99.00th=[  701], 99.50th=[  766], 99.90th=[  873], 99.95th=[  906],
>      | 99.99th=[  979]
>     bw (KB  /s): min=  768, max=65677, per=24.96%, avg=29542.15, stdev=9138.77
>     lat (msec) : 4=0.01%, 50=0.08%, 100=1.17%, 250=30.63%, 500=60.28%
>     lat (msec) : 750=7.40%, 1000=0.43%, 2000=0.01%
>   cpu          : usr=0.19%, sys=5.02%, ctx=21162, majf=0, minf=44
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
>      issued    : total=r=77309/w=115753/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=256
>
> Run status group 0 (all jobs):
>    READ: io=4642.2MB, aggrb=79145KB/s, minb=79145KB/s, maxb=79145KB/s,
> mint=60061msec, maxt=60061msec
>   WRITE: io=6941.7MB, aggrb=118340KB/s, minb=118340KB/s,
> maxb=118340KB/s, mint=60061msec, maxt=60061msec
>
> Disk stats (read/write):
>   sda: ios=77373/115527, merge=39/148, ticks=2103080/5978492,
> in_queue=8081824, util=100.00%
>
>>
>> Thanks
>> Nitin
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
