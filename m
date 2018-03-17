Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:43338 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbeCQFm6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Mar 2018 01:42:58 -0400
Received: by mail-vk0-f54.google.com with SMTP id p189so7570354vkd.10
        for <fio@vger.kernel.org>; Fri, 16 Mar 2018 22:42:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54DB864B-BBFF-4276-B86F-A069F22367F8@gmail.com>
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <13EF5126-4D32-4706-8495-B193C124826B@gmail.com> <BN3PR0401MB145715070B7B9F0C71A902318FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <902A0A2A-8708-4A94-A09E-5D3C9BFB48FF@gmail.com> <SN6PR04MB4064D865EBEB79DE2219218D8FD70@SN6PR04MB4064.namprd04.prod.outlook.com>
 <54DB864B-BBFF-4276-B86F-A069F22367F8@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 05:42:27 +0000
Message-ID: <CALjAwxhKo7grzp1_Pyhg8pgUs+MVLbrtWRDWyHrNhCh=mk=gog@mail.gmail.com>
Subject: Re: random_generator=lfsr overhead with more disks?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Green <mishagreen@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, fio <fio@vger.kernel.org>

On 16 March 2018 at 22:32, Michael Green <mishagreen@gmail.com> wrote:
> Possibly.  Who can have a look at the code?
>
>> On Mar 16, 2018, at 6:30 PM, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>>
>> OK, 61% cpu with lfsr and 82% cpu without lfsr.  But the throughput is propositionally higher without lfsr, so perhaps that's why cpu util is higher.
>>
>> I'm wondering if the lfsr code is single threaded in nature or stuck waiting on a mutex, thereby slowing down the throughput and hence the lower latency.

Sounds unlikely - there are no locks at all in
https://github.com/axboe/fio/blob/master/lib/lfsr.c and each file gets
its own lsfr generator.

> fio-2.2.11
> Starting 8 threads

Could you repeat the problem on a recent version of fio (see
https://github.com/axboe/fio/releases for what we're up to)? If it
happens there we could do with the output from Linux's perf
for each of the runs to see what might be sucking the time. It would also
help if you strip the line you are using down to the bare minimum that
still shows the problem (e.g. if you can remove numa, lock it to CPUs
make it happen on a pure randread workload etc).

I did two runs using the null ioengine on a four CPU system:

fio --thread=1 --direct=1 --group_reporting=1 --ioengine=null
--name=PT7 --rw=randrw --rwmixread=100 --iodepth=1 --numjobs=4
--bs=4096 --size=450GiB --runtime=10
PT7: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=null, iodepth=40
...
fio-3.5-57-g5b2f-dirty
[...]
Run status group 0 (all jobs):
   READ: bw=545MiB/s (572MB/s), 545MiB/s-545MiB/s (572MB/s-572MB/s),
io=5455MiB (5720MB), run=10001-10001msec

fio --thread=1 --direct=1 --group_reporting=1 --ioengine=null
--name=PT7 --rw=randrw --rwmixread=100 --iodepth=1 --numjobs=4
--bs=4096 --size=450GiB --runtime=10 --random_generator=lfsr
PT7: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=null, iodepth=40
...
fio-3.5-57-g5b2f-dirty
[...]
Run status group 0 (all jobs):
   READ: bw=637MiB/s (668MB/s), 637MiB/s-637MiB/s (668MB/s-668MB/s),
io=6374MiB (6684MB), run=10001-10001msec

Here the bandwidth was higher with --random_generator=lfsr suggesting
it had lower overhead in my case.

-- 
Sitsofe | http://sucs.org/~sits/
