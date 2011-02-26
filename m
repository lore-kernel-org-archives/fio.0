Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48885 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1BZUbU convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 26 Feb 2011 15:31:20 -0500
Received: by vws12 with SMTP id 12so2238005vws.19
        for <fio@vger.kernel.org>; Sat, 26 Feb 2011 12:31:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D616775.8050908@fusionio.com>
References: <932143.86482.qm@web161913.mail.bf1.yahoo.com>
	<4D616775.8050908@fusionio.com>
Date: Sat, 26 Feb 2011 20:31:19 +0000
Message-ID: <AANLkTi=nLVRq6=AFvhsoWX_ThjHrxaqkw=kcyLUQrr13@mail.gmail.com>
Subject: Re: uneven IOPS among HD
From: Josh Aune <luken@omner.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: john smith <whalajam@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sunday, February 20, 2011, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-02-17 03:14, john smith wrote:
>> I have a couple of questions:
>>
>> 1) if it is normal (and if so, why) that while running a number of ident=
ical jobs (e.g 4), each bound to a different CPU (cpu_allowed=3Di) and each=
 performing sequential (bs=3D512) reads on (e.g. 4) different HD, fio repor=
ts IOPS numbers that are highly unbalanced among HD with one HD reporting m=
ore than 7x of the IOPS of the minimum IOPS HD.
>> Different runs may show most of the IOPS on a different HD, so it's not =
that one HD is faster.
>>
>> Here are some possibly interesting parameters:
>>
>> ioengine=3Dlibaio
>> iodepth=3D32
>> direct=3D1
>
> There should be very little variance between runs, and between jobs.
> Each are separate threads/processes, so most of the variance you will
> see will be due to system "artifacts". So I'd suggest you look there. If
> you don't pin to specific CPUs, do you see smaller or larger
> differences?
>
> Are you doing random or sequential IO? Could also be timing differences
> in submission and dispatch from the IO scheduler.

Is hyper threading enabled?  Could be running some of the jobs on the
same CPU core.

Does it track to different sockets?


>
>> 2) why increasing "iodepth' (eg to 512) decreses the IOPS results signif=
icantly (by 10x)?
>
> You probably don't want a larger depth in fio than the system supports.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>
