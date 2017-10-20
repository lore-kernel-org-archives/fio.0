Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:50815 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdJTVBm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Oct 2017 17:01:42 -0400
Received: by mail-ua0-f181.google.com with SMTP id v27so9204101uav.7
        for <fio@vger.kernel.org>; Fri, 20 Oct 2017 14:01:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145727ED714B57825C91A8E78F430@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB145727ED714B57825C91A8E78F430@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 20 Oct 2017 22:01:10 +0100
Message-ID: <CALjAwxiXzC8ar21smWAOMadiAUSqeLECNpu1ZzTvc2t1e20VXg@mail.gmail.com>
Subject: Re: fio offset with ba
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 20 October 2017 at 20:08, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> I don't quite follow the logic in the calculate offset function.  The offset parameter recently allows a percentage.  Suppose we set it to 50% and want to block align the IO's starting at 50% of device capacity, then block aligned to 8KB.
>
> # fio -version
> fio-3.1-60-g71aa
>
> # blockdev --getsize64 /dev/nvme1n1
> 3200631791616
>
> # fio --name=test_job --ioengine=libaio --direct=1 --rw=read --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme1n1 --runtime=1s --offset=50% --log_offset=1 --write_iops_log=test_job --ba=8k
>
> # cat test_job_iops.1.log
> 0, 1, 0, 4096, 1600315895808
> 0, 1, 0, 4096, 1600315899904
> 0, 1, 0, 4096, 1600315904000
> 0, 1, 0, 4096, 1600315908096
>
> So we can see the device has 3200631791616 bytes, 50% of which is 1600315895808 bytes, which happens to be 4KB aligned, but not 8KB aligned.  Even though we set the --ba=8k parameter, the offset LBA as logged in the iops.1.log shows

Hmm I see the same problem with this job:
fio --name=test_job --ioengine=null --rw=read --iodepth=1
--size=3200631791616 --bs=4k --number_ios=1 --offset=50% --ba=8k
--debug=io

[...]
io       15013 fill_io_u: io_u 0x236ad80:
off=1600315895808/len=4096/ddir=0io       15013 /test_job.0.0io
15013

I think your guess about only impacting random I/O is probably right because
fio --name=test_job --randrepeat=0 --ioengine=null --rw=randread
--iodepth=1 --size=3200631791616 --bs=4k --number_ios=1 --offset=50%
--ba=8k --debug=io

picks offsets that are 8k aligned.

> 4KB alignment.  Does --ba work for all IO's or only random IO's?  If all, does get_start_offset() control the raw offset value?  I don't see why the min(ba, bs) is used in the calculation, but perhaps I am missing something.  Thanks.

Where is min(ba, bs) done - do you mean the bits around
https://github.com/axboe/fio/commit/89978a6b26f81bdbd63228e2e2a86f604ee46c56#diff-4abbf037246dd2e450dc3f6a2ac77180R845?
I agree you probably want to take the maximum of all the block
alignments but what if one of the smaller ones is not a multiple of
the largest one?

Would you like to propose a patch?

-- 
Sitsofe | http://sucs.org/~sits/
