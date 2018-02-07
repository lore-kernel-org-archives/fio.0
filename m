Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:52236 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBGATb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Feb 2018 19:19:31 -0500
Received: by mail-wm0-f54.google.com with SMTP id g1so6976452wmg.2
        for <fio@vger.kernel.org>; Tue, 06 Feb 2018 16:19:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
 <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com> <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Tue, 6 Feb 2018 17:19:29 -0700
Message-ID: <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com>
Subject: Re: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org

Thanks for your input sitsofe. Appreciate it

Experimented few loops and ran into the below failures even when I
didn't pass in the write offset to FIO. The block size is 4k on the
drive

2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - The arguments
passed are: sudo fio --thread --direct=1 --minimal --ioengine=libaio
--numjobs=1 --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
--name=bs16384_rwwrite_qd256 --buffer_pattern=1193046 --iodepth=256
--size=100% --percentage_random=0 --bs=256k --ba=4k --rw=write
2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
offset=27160215552, buflen=262144

2018-02-05 07:20:53,033-07 ERROR    l_IoActionsLinux - Error in FIO
run: fio: io_u error on file /dev/nvme0n1: Input/output error: write
offset=27205828608,


Similarly if I pass offsets that aren't aligned with file system
underneath, is there a way to inform fio to round it up

Regards,
Gnana

On Tue, Feb 6, 2018 at 6:31 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 6 February 2018 at 05:15, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>
>> Occasionally stepping into couple of failures with FIO with arguments
>> captured below
>> So wanted to get opinion on if I am missing something in parameters
>>
>> Failure 1:
>> The arguments passed are: sudo fio --thread --direct=1 --minimal
>> --ioengine=libaio --numjobs=1 --filename=/dev/nvme0n1 -o
>> /tmp/nvme0n1_temp.log --name=bs16384_rwwrite_qd256 --buffer_pattern=0
>> --iodepth=256 --size=409600 --percentage_random=0 --bs=256k
>> --offset=625181037 --rw=write
>>
>> Error in FIO run: fio: io_u error on file /dev/nvme0n1: Invalid
>> argument: write offset=625181037, buflen=262144
>>
>> Error in FIO run: fio: io_u error on file /dev/nvme0n1: Invalid
>> argument: write offset=625443181, buflen=262144
>
> Requesting direct/unbuffered access comes with conditions on some
> platforms. In the case of Linux direct=1 is mapped to O_DIRECT and on
> Linux to use O_DIRECT you often have to send I/O whose size and offset
> are aligned to the underlying filesystem/device
> (logical) block size (this is a simplified generalisation but is kind of all you
> need to know for fio, see the NOTES section for O_DIRECT in the
> open(2) man page for gory details - https://linux.die.net/man/2/open
> ). I don't know what block size your NVMe device
> exposes but I'm going to guess it's at least 4k. So let's see if your
> job might violate the alignment rule assuming this:
>
> --bs=256k - this is ok because 262144 is a multiple of 4096.
> --offset=625181037 - we've got a problem. 625181037 is NOT a multiple
> of 4096 and yet you are asking for I/O to start at that byte offset.
> This violates the O_DIRECT constraint (you will only send down well
> aligned I/O) so it's likely every I/O of this job will fail for being
> badly aligned. Thus the problem occurred because you requested I/O to
> start at an unaligned offset causing all I/Os to be unaligned.
>
>> Failure 2:
>>
>> Write followed by verify:
>> sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
>> --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
>> --name=bs16384_rwwrite_qd256 --buffer_pattern=1 --iodepth=256
>> --size=40960 --percentage_random=0 --bs=16384 --rw=write
>>
>>
>> sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
>> --filename=/dev/nvme0n1 -o /tmp/nvme0n1_temp.log
>> --name=bs16384_rwverify_qd256 --buffer_pattern=1 --iodepth=256
>> --size=40960 --percentage_random=0 --bs=16384 --rw=read
>> --verify=pattern --verify_pattern=1
>>
>> Error in starting FIO: fio: got pattern '00', wanted '01'. Bad bits 1
>> fio: bad pattern block offset 2048
>>
>> pattern: verify failed at file /dev/nvme0n1 offset 0, length 16843009
>> fio: verify type mismatch (257 media, 18 given)
>> fio: got pattern '00', wanted '01'. Bad bits 1
>> fio: bad pattern block offset 2048
>> pattern: verify failed at file /dev/nvme0n1 offset 16384, length 16843009
>> fio: verify type mismatch (257 media, 18 given)
>> fio: got pattern '00', wanted '01'. Bad bits 1
>> fio: bad pattern block offset 2048
>> pattern: verify failed at file /dev/nvme0n1 offset 32768, length 16843009
>> fio: verify type mismatch (257 media, 18 given)
>
> In the above ignore "length 16843009" - that's just your pattern
> (0x01010101) being interpreted as a 32 bit unsigned int. Also ignore
> "verify type mismatch (257 media, 18 given)" that's your pattern
> (0x01010) being interpreted as a 16 bit unsigned int. Perhaps when
> doing a headerless verify the length should be fudged to be the block
> size and the media type check skipped? However it's a bit strange as
> to why it would fail in the first place.
>
> I just ran
> ./fio --thread --direct=1 --ioengine=libaio --numjobs=1
> --filename=/tmp/fio.tmp --name=bs16384_rwwrite_qd256
> --buffer_pattern=1 --iodepth=256 --size=40960 --percentage_random=0
> --bs=16384 --rw=write
> ./fio --thread --direct=1 --ioengine=libaio --numjobs=1
> --filename=/tmp/fio.tmp --name=bs16384_rwverify_qd256
> --buffer_pattern=1 --iodepth=256 --size=40960 --percentage_random=0
> --bs=16384 --rw=read --verify=pattern --verify_pattern=1
>
> (where /tmp was part of an XFS filesystem) and don't get an error. Are
> you sure the fio job you ran before bs16384_rwverify_qd256 had
> buffer_pattern=1 - I notice in Failure 1 you were using
> buffer_pattern=0...
>
> You might find it easier to construct your jobs like this:
> fio --direct=1 --ioengine=libaio --name=write_pattern
> --filename=/dev/nvme0n1 --size=32k --bs=16k --rw=write
> --verify=pattern --verify_pattern=1 --do_verify=0
> fio --direct=1 --ioengine=libaio --name=verify_pattern
> --filename=/dev/nvme0n1 --size=32k --bs=16k --rw=read --verify=pattern
> --verify_pattern=1
>
> --
> Sitsofe | http://sucs.org/~sits/
