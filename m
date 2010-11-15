Return-Path: <jmoyer@redhat.com>
MIME-Version: 1.0
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 15 Nov 2010 06:36:23 -0700
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <x4962vyr9ns.fsf@segfault.boston.devel.redhat.com>
References: <20101109182801.GP15588@sebastiankayser.de>
	<AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
	<20101110082223.GB14261@sebastiankayser.de>
	<20101111162222.GO28050@sebastiankayser.de>
	<AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>
	<20101112134359.GR28050@sebastiankayser.de>
	<AANLkTik5=tSj9h-O8O5Bub8J86rRiyYrTx7mmX5asgqC@mail.gmail.com>
	<4CDEEEE5.5060305@fusionio.com>
In-Reply-To: <4CDEEEE5.5060305@fusionio.com> (Jens Axboe's message of "Sat,
 13	Nov 2010 21:02:45 +0100")
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Shawn Lewis <shawnlewis@google.com>, Sebastian Kayser <sebastian@skayser.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe <jaxboe@fusionio.com> writes:

>>> I wonder how many times I saw someone - including myself - fire up
>>> bonnie++ or iozone with a rather small test file compared to the full
>>> disk size ... Thanks very much everyone! This was an (overdue) eye
>>> opener.
>> In addition, testing with a file is dependent on the state of the file
>> system. For example, if you're using a 100GB file and there's not enough
>> contiguous free space to lay it out in one chunk you could have regions =
on
>> different parts of the disk. Further, even there is enough space, that s=
pace
>> could be near the inner or outer diameter which would also affect
>> performance.
>>=20
>> There is a way to get a file address to lba map (which would give you so=
me
>> insight into how a file is laid out). I think there's a syscall. Jens sh=
ould
>> know.
>
> Yep, you can use FIBMAP/FIEMAP to walk the extents of the file and get a
> full map of how it's laid out on disk. Not sure if there are tools
> that'll do this for you, if not is pretty trivial to write.

man 8 filefrag; it's part of e2fsprogs.  I'm sure xfs has its own
utility to do this, too.

Cheers,
Jeff

