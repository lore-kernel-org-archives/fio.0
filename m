Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:40222 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbeCXRdG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Mar 2018 13:33:06 -0400
Received: by mail-ua0-f174.google.com with SMTP id n20so947281ual.7
        for <fio@vger.kernel.org>; Sat, 24 Mar 2018 10:33:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 24 Mar 2018 17:32:34 +0000
Message-ID: <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

On 23 March 2018 at 21:45, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 23 March 2018 at 16:08, Kris Davis <Kris.Davis@wdc.com> wrote:
>> In fio version 2.20 a test seems to have been added to backend.c which "may" falsely report that no I/O has occurred.
[...]
>> In the following fio test, the error message is logged, even though it appears that everything has run ok (fio built from main below, but results appear to be the same with at least fio version 2.21)
>> (It's also interesting to note that the estimated "eta" is also grossly inaccurate [captured while running below] - but that is a different issue I think).

Yeah that's going to be a separate issue. The thread_eta() in eta.c
doesn't look at the number of I/Os only the guessed total bytes and
how far through fio has progressed through that.

>> You can see the " Random-read-4K-QD1: No I/O performed by libaio, perhaps try --debug=io option for details?" error message below, which "appears" to be false.
>>
>>     $ fio --ioengine=libaio --loops=32 --direct=1 --numjobs=1--norandommap --randrepeat=0 --size=16GB --filename=/dev/sdb --name=Random-read-4K-QD1 --rw=randread --bs=4K --iodepth=1 --number_ios=8192
>>     Random-read-4K-QD1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
>>     fio-3.5-60-g69c5
>>     Starting 1 process
>>     Jobs: 1 (f=1): [r(1)][0.2%][r=30.9MiB/s,w=0KiB/s][r=7898,w=0 IOPS][eta 04h:45m:35s]
>>
>>     Random-read-4K-QD1: No I/O performed by libaio, perhaps try --debug=io option for details?
>>
> [...]
>>
>> I added a print message which showed that both ddir_rw_sum(bytes_done) and did_some_io values were zero at that point in the code.
>> I didn't try to dig into the operation of the bytes_done and did_some_io values further, yet.
>>
>>
>> Also, I noticed that if option "--io_size=32M" was used instead of "number_ios=8192", then the eta appeared to be accurate - so the eta issue does "appear" to be independent - I can open a separate discussion or issue if desired.

A separate discussion would be good.

> Just quickly looking I think this is down to number_ios=<val> being
> paired with loops=32 but I haven't had time to dig further...

After getting the wrong end of the stick and wondering if Jens was
trying to make number_ios only account for the current loop's I/O with
https://github.com/axboe/fio/commit/cf8a46a75f38afe07ebf823210f95543999e3116
("Make 'loops' honor full write+verify loops") I think one of the
changes there was just a simple mistake while fixing other areas up.
Can you see if https://github.com/sitsofe/fio/tree/loops_numberios
fixes what you were seeing?

-- 
Sitsofe | http://sucs.org/~sits/
