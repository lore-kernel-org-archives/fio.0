Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:40799 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbeHOT6G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Aug 2018 15:58:06 -0400
Received: by mail-wr1-f47.google.com with SMTP id h15-v6so1706042wrs.7
        for <fio@vger.kernel.org>; Wed, 15 Aug 2018 10:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxi8xoYS9wuzE3sZCfpR2i2HqcORyY+=_fVwo4HvvtkG3g@mail.gmail.com>
References: <CAPSTwmT79gq_WY89XpQ-VPNYi27sSDokZFxBmOrUhLCGRzCXww@mail.gmail.com>
 <CALjAwxi8xoYS9wuzE3sZCfpR2i2HqcORyY+=_fVwo4HvvtkG3g@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Wed, 15 Aug 2018 11:05:06 -0600
Message-ID: <CAPSTwmSOeiK1zWnz_6o8BfbnnDn9VOvqy7ddXRH1WcdLV6w+Tw@mail.gmail.com>
Subject: Re: FIO Question with random I/O
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks for the detailed explanation Sitsofe.

So if I have --percentage_random flag, fio doesn't fill 5% of the
drive or may exit without filling 5% of the drive?

If so is there a way to fill 5% partly sequential and partially
random. I mean, in the same job to have combination of both sequential
and random writes


Sorry for side track, one another question, is there a way you know to
exit fio completely
There are some instances where drive dropped off from the system due
to timeout but fio process still exists.
With the parameters I shared in the thread before, fio seems to be
running. Tried with --exitall_on_error and --continue_on_error flags

Case where the drive dropped off the system
ps -ef | grep fio
root      3476  3459  0 Aug14 pts/1    00:00:00 sudo fio --thread
--minimal --ioengine=libaio --numjobs=1 --exitall_on_error
--filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs65536_rwrandwrite_qd30 --buffer_pattern=64206 --iodepth=30
--write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
--max_latency=30s --continue_on_error=none --size=100%
--percentage_random=50 --bs=65536 --rwmixread=50 --randseed=1234
--time_based=1 --runtime=86400 --rw=randwrite
root      3477  3476  2 Aug14 pts/1    00:22:39 [fio]


Happy case, where the drive is healthy
ps -ef | grep fio
root     15944 15927  0 10:34 pts/2    00:00:00 sudo fio --thread
--minimal --ioengine=libaio --numjobs=1 --exitall_on_error
--filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs65536_rwrandwrite_qd30 --buffer_pattern=64206 --iodepth=30
--write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
--max_latency=30s --continue_on_error=none --size=100%
--percentage_random=0 --bs=65536 --rwmixread=50 --randseed=1234
--time_based=1 --runtime=86400 --rw=randwrite
root     15945 15944 44 10:34 pts/2    00:06:13 fio --thread --minimal
--ioengine=libaio --numjobs=1 --exitall_on_error
--filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs65536_rwrandwrite_qd30 --buffer_pattern=64206 --iodepth=30
--write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
--max_latency=30s --continue_on_error=none --size=100%
--percentage_random=0 --bs=65536 --rwmixread=50 --randseed=1234
--time_based=1 --runtime=86400 --rw=randwrite

Regards,
Gnana

On Tue, Aug 14, 2018 at 11:33 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On Tue, 14 Aug 2018 at 21:56, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>
>> Hi,
>>
>> I am experiencing data miscompare during verify with FIO after random write
>>
>> Also the time for the random I/O operation is lesser than what it
>> takes for sequential I/O operation for the same 5%. So wanted to
>> ensure
>> 1. If I am missing the essential parameters to be passed to FIO
>> 2. If any parameters passed are not essential
>>
>> Parameters for Write:
>> sudo fio --thread --minimal --ioengine=libaio --numjobs=1
>> --exitall_on_error --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
>> --name=bs65536_rwrandwrite_qd3 --buffer_pattern=64206 --iodepth=3
>> --write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
>> --max_latency=30s --continue_on_error=none --size=5%
>> --percentage_random=50 --bs=65536 --randseed=1234 --rw=randwrite
>>
>>
>> Parameters for Verify:
>> sudo fio --thread --minimal --ioengine=libaio --numjobs=1
>> --exitall_on_error --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
>> --name=bs65536_rwrandverify_qd3 --buffer_pattern=64206 --iodepth=3
>> --write_bw_log=/tmp/nvme0n1_bandwidth.log --log_avg_msec=1000
>> --max_latency=30s --continue_on_error=none --size=5%
>> --percentage_random=50 --bs=65536 --randseed=1234 --rw=randread
>> --verify=pattern --verify_pattern=64206
>
> (In this case --verify=pattern will supersede --buffer_pattern so you
> don't need --buffer_pattern but having both there is harmless)
>
>> The message from fio looks as below
>> fio: got pattern '00', wanted 'ce'. Bad bits 5
>> fio: bad pattern block offset 0
>> pattern: verify failed at file /dev/nvme0n1 offset 86291775488, length 0
>> fio: verify type mismatch (0 media, 18 given)
>> fio: got pattern '00', wanted 'ce'. Bad bits 5
>> fio: bad pattern block offset 0
>> pattern: verify failed at file /dev/nvme0n1 offset 86291906560, length 0
>> fio: verify type mismatch (0 media, 18 given)
>
> Split verification (separate write and verification stages) tends to
> be a tricky business when you aren't doing a simple full write of a
> specified region (in your case you aren't because you have have
> percentage_random in there which can lead to overwrites and unwritten
> regions). For example, the writing stage can "stop short" and the
> verification stage doesn't actually know just how far the first run
> got (so if the first stage bailed out due to latency being too high
> that can lead the second job to verify areas that have never been
> written). Sometimes you can use verify_state_load
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-state-load
> ) to workaround this. Something else you can try is to make the second
> job more like the first by changing "--rw=randread" to "--rw=randwrite
> --verify_only" (I can't remember whether randread will always follow
> the same sequence as randwrite so I guess that will cover that case).
>
> There was a mailing list thread called "How to ensure split
> verification will generate the same configs as write phase?"
> (https://www.spinics.net/lists/fio/msg06754.html ) which discusses
> some of this and there's also
> https://github.com/axboe/fio/issues/322#issuecomment-283265965 which
> goes through the different forms of verification. If you have the
> option I'd recommend not using split verification and using post write
> stage verification (i.e. add --verify=pattern --verify_pattern=64206
> to your first job and let it do verification immediately after the
> writes finish).
>
> --
> Sitsofe | http://sucs.org/~sits/

