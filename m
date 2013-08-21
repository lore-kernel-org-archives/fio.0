Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:38243 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3HUAVX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 Aug 2013 20:21:23 -0400
Received: by mail-ve0-f179.google.com with SMTP id c13so912611vea.10
        for <fio@vger.kernel.org>; Tue, 20 Aug 2013 17:21:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52131CC5.9020508@grnet.gr>
References: <CAPet_21dehFMKwU25L+ho1uRWOO6w_p7LqxxyJe5gQ5a9G0M5A@mail.gmail.com>
	<52131CC5.9020508@grnet.gr>
Date: Tue, 20 Aug 2013 17:21:22 -0700
Message-ID: <CAPet_21F_B1AwRu4Q7zW=FPvrNfMuX_LhU2ywuwu2Trwy79k_g@mail.gmail.com>
Subject: Re: Using LFSR
From: Juan Casse <jcasse@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: Juan Casse <jcasse@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

It turns out that a change I made to the code caused the error. lfsr
works. Thank you Alex.

On Tue, Aug 20, 2013 at 12:37 AM, Alex Pyrgiotis <apyrgio@grnet.gr> wrote:
> On 08/20/2013 02:11 AM, Juan Casse wrote:
>> Hi,
>>
>> How is LFSR used?
>>
>> When running the job file:
>>
>> [global]
>> readwrite=randwrite
>> size=64k
>> bs=8192
>> random_generator=lfsr
>> [test_job]
>>
>> fio returns:
>>
>> "fio: failed allocating random map. If running a large number of jobs,
>> try the 'norandommap' option or set 'softrandommap'. Or give a larger
>> --alloc-size to fio."
>>
>> I tried the recommendations in the message above to no avail. I also
>> tried other combinations of size, bs, and readwrite.
>
> Hi Juan,
>
> Could you provide the fio version you are using (fio -v)? I'm currently
> using the latest version from git and I don't see these results.
> Specifically, what I'm getting is:
>
> -------------------------------
> test_job: (g=0): rw=randwrite, bs=8K-8K/8K-8K/8K-8K, ioengine=sync,
> iodepth=1
> fio-2.1.2-13-g3e10
> Starting 1 process
> Value is 7
> Value is 6
> Value is 4
> Value is 0
> Value is 1
> Value is 5
> Value is 2
> Value is 3
>
> test_job: (groupid=0, jobs=1): err= 0: pid=24672: Tue Aug 20 10:27:28 2013
>   write: io=65536B, bw=64000KB/s, iops=8000, runt=     1msec
>     clat (usec): min=6, max=43, avg=11.50, stdev=12.75
>      lat (usec): min=7, max=44, avg=11.88, stdev=12.99
>     clat percentiles (usec):
> <...snip...>
>     lat (usec) : 10=87.50%, 50=12.50%
>   cpu          : usr=0.00%, sys=0.00%, ctx=16, majf=0, minf=41
> <...snip...>
>
> Run status group 0 (all jobs):
>   WRITE: io=64KB, aggrb=64000KB/s, minb=64000KB/s, maxb=64000KB/s,
> mint=1msec, maxt=1msec
>
> Disk stats (read/write):
>   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> -------------------------------
>
> The output has been cut in some parts for readability reasons. Also, the
> "Value is..." lines have been added to show which blocks fio is hitting.
>
> Regards,
> Alex
>
> --
> Alex | apyrgio@grnet.gr
