Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35738 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2DFAQ7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 20:16:59 -0400
Message-ID: <4F7E35F2.5010701@kernel.dk>
Date: Thu, 05 Apr 2012 18:16:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: query on verify_dump option
References: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com>
In-Reply-To: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-05 17:20, Suresh Dhanarajan wrote:
> Hi,
> 
> I am trying data integration cases with verify_pattern option.
> I am not seeing any dump file generated for the mismatch.
> Here are the steps i followed,
> Started fio and waited till 30 % writes done the disk and issued a dd
> write on the same disc for the first 512 bytes with pattern zero.
> then waited till verify gets completed.
> I can see the error's in the output log file but not the dump file.
> 
> Here is my job file.
> 
> [global]
> size=10g
> direct=1
> filename=/dev/sdc
> verify_pattern=0x01010101
> verify=meta
> bs=64k
> group_reporting
> 
> [write-phase]
> rw=write
> do_verify=0
> 
> [verify-phase]
> stonewall
> rw=read
> do_verify=1
> continue_on_error=all
> verify_dump=1
> ~
> 
> 
> 
> Let me know if i am missing something over here.

You don't get the .received and .expected files?

> 2)Also i have one query like verify_pattern option is it possible to
> provide known pattern for write and reads this will be very useful in
> DI verification test cases

Not sure I understand this one. You are already providing the pattern
you want. What am I missing?

-- 
Jens Axboe

