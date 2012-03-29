Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab2C2RjA (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Mar 2012 13:39:00 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: odd result with iodepth
References: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
Date: Thu, 29 Mar 2012 13:38:57 -0400
In-Reply-To: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
	(Chuck Tuffli's message of "Thu, 29 Mar 2012 10:10:07 -0700")
Message-ID: <x49bonfwbm6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: fio@vger.kernel.org

Chuck Tuffli <ctuffli@gmail.com> writes:

> I've been testing disk performance using fio, and am seeing results I
> can't explain. This may not necessarily be a problem with fio, or
> perhaps I'm not using the some of the parameters correctly. The
> testing uses the latest fio.git on a RHEL system running a 2.6.32
> kernel.
>
> The fio test is:
>
> fio --name=global --ioengine=libaio --rw=read --bs=512 --size=500m
> --iodepth=32 --direct=1 --filename=/dev/sdb --name=job1
>
> The IOPs reported in this case appears to correlate with an external analyzer.
>
> If I change the iodepth to 64, fio reports double the IOPs reported in
> the previous case, but the performance measured by the analyzer is the
> same as in the iodepth=32 case (i.e. half what fio reports). I tried
> the iodepth=64 case with another disk performance tool, and it is
> reporting the same results as the external analyzer.
>
> Interestingly, using iodepth=32 and adding a second job (--name=job2)
> seems to have the same effect as iodepth=64 (reported performance is
> 2x compared to the external analyzer).
>
> Am I doing something obviously wrong? What else can/should I check? TIA

What's the maximum queue depth for the sd device?  I'll bet it's 32...

Cheers,
Jeff
