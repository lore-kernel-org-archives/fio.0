Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53F7F22B.1090904@gmail.com>
References: <53F29D76.9080108@gmail.com>
	<53F7C2C6.7000703@kernel.dk>
	<53F7F22B.1090904@gmail.com>
Date: Sat, 23 Aug 2014 07:17:58 +0100
Message-ID: <CALjAwxhWTOTDy1dRf+qxoVmesy2yug=8p=KDpC4+Yg8=ceYUOA@mail.gmail.com>
Subject: Re: multiple --name parameters with non-file engine?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Mark Nelson <mark.a.nelson@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 23 August 2014 02:45, Mark Nelson <mark.a.nelson@gmail.com> wrote:
> Thanks Jens.  What I'd like to be able to do is start multiple fio processes
> but have each one only write to a non-overlapping portion of the block
> device.  Preferably I wouldn't have to manually figure out the ranges
> myself.  Any way to do something like that?

A quick Google for "fio zones jobs" tuns up
http://www.spinics.net/lists/fio/msg01791.html where the fourth answer
on that page seems relevant to your case.

For each job (essentially name section) you can set an offset and a
size and I/O will be done between offset and offset+size. If you want
to move the starting offset of each extra job automatically you could
use offset_increment
(http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=73e58ff695c3384df30094d6c15ebe9ed615460f;hb=HEAD#l770
). You can also use numjobs
(http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=73e58ff695c3384df30094d6c15ebe9ed615460f;hb=HEAD#l1275
) to automatically create job clones.

Perhaps this sort of "parallel non-overlapping zoned I/O" case would
be a useful example fio job file (for example I never realised size
was relative to offset...)?

-- 
Sitsofe | http://sucs.org/~sits/

