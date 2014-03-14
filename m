Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <532349BF.4010307@kernel.dk>
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
	<532349BF.4010307@kernel.dk>
Date: Fri, 14 Mar 2014 12:45:30 -0700
Message-ID: <CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
Subject: Re: Possible bug when setting compression
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> Interesting, it would make sense to simply not scramble if the compression
> settings are set. That is what happens with refill_buffers right now, it has
> precedence over the scrambling. Or if you give a buffer pattern, that also
> disables the scrambling. I'll add the same for the compression settings.
>
> http://git.kernel.dk/?p=fio.git;a=commit;h=0574c885b82aea0332ab5fa35af84db0f3946726
>
> Care to give it a test spin, just to be on the safe side?
>
> --
> Jens Axboe
>

Hey Jens,

According to my test results below it worked for
buffer_compress_percentage, but not zero_buffers.  Also, it looks like
buffer_compress_percentage=0 is broken, unless =0 means disabling that
option altogether.

fio-2.1.6.1-11-g0574

buffer_compress_percentage=100
iops=83436

buffer_compress_percentage=50
iops=78625

buffer_compress_percentage=1
iops=52751

buffer_compress_percentage=0
iops=69433

zero_buffers
iops=69470

scramble_buffers=0
zero_buffers
iops=83369

