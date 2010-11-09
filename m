Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0KINQX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Nov 2010 08:16:23 -0500
Message-ID: <4CD949A5.4070606@fusionio.com>
Date: Tue, 09 Nov 2010 14:16:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: RFC: Data pattern buffer filling race condition fix
References: <201011061035.18709.bvanassche@acm.org> <4CD690DF.6090807@fusionio.com> <AANLkTimVcMvOH55xZvTFHxbZHesTXoyi=Y3bRqnALLTS@mail.gmail.com> <4CD7F53E.1050201@fusionio.com> <AANLkTinSscynOzVHfNO_fFMyuqgaaEN0tJTK6GHpj=54@mail.gmail.com>
In-Reply-To: <AANLkTinSscynOzVHfNO_fFMyuqgaaEN0tJTK6GHpj=54@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Radha Ramachandran <radha@google.com>

On 2010-11-09 12:53, Bart Van Assche wrote:
> On Mon, Nov 8, 2010 at 2:03 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> On 2010-11-07 13:58, Bart Van Assche wrote:
>>> On Sun, Nov 7, 2010 at 12:43 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>
>>>> On 2010-11-06 10:35, Bart Van Assche wrote:
>>>>> On multicore non-x86 CPUs fio has been observed to frequently reports false
>>>>> data verification failures with I/O engine libaio and I/O depths above one.
>>>>> This is because of a race condition in the function fill_pattern(). The code
>>>>> in that function only works correct if all CPUs of a multicore system
>>>>> observe store instructions in the order they were issued. That is the case for
>>>>> multicore x86 systems but not for all other CPU families, such as e.g. the
>>>>> POWER CPU family.
>>>>>
>>>>> [ ... ]
>>
>> Forgive me, but I'm still a little confused. This second write_barrier()
>> is now protecting against the order of the fill and the length
>> assignment. IOW, if you see the new length, you are guaranteed to also
>> see the new content. This means that the first memory barrier should be
>> a read_barrier().
>>
>> And ditto for the other case.
>>
>> Can you verify whether that works as expected and send an updated patch?
> 
> Hello Jens,
> 
> I'm afraid that I will have to do more testing and that I'll have to
> make sure that I understand the entire fio code base before I can
> develop and send a new patch - something I do not have the time for
> now unfortunately. I ran into this issue on 32-bit 2.6.34.7 kernel
> while running a test on a local ext3 filesystem, something I will have
> to analyze further before I can proceed:
> 
> $ valgrind ./fio --ioengine=libaio --overwrite=1 --verify=md5
> --iodepth=10 --direct=1 --loops=10 --size=1MB --name=test --thread
> --numjobs=10 --group_reporting
> ==13318== Memcheck, a memory error detector
> ==13318== Copyright (C) 2002-2010, and GNU GPL'd, by Julian Seward et al.
> ==13318== Using Valgrind-3.7.0.SVN and LibVEX; rerun with -h for copyright info
> ==13318== Command: ./fio --ioengine=libaio --overwrite=1 --verify=md5
> --iodepth=10 --direct=1 --loops=10 --size=1MB --name=test --thread
> --numjobs=10 --group_reporting
> ==13318==
> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=10
> ...
> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=10

This looks pretty straight forward - the file is created, but not filled
with a verifiable pattern. You want to run the workload with rw=write
at least once first, then you can use a read-only verify workload later
if you want.

-- 
Jens Axboe

