Return-Path: <msmucr@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130405083902.GL9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com> <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk> <20130405083902.GL9683@kernel.dk>
From: =?UTF-8?Q?Michal_=C5=A0mucr?= <msmucr@gmail.com>
Date: Mon, 8 Apr 2013 01:28:53 +0200
Message-ID: <CAHBo9gn2t6khrMGBsL4omOmiFoGZzfRCOmS9KfLRmRjPa4F-3w@mail.gmail.com>
Subject: Re: How to re-use default sequential filenames?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

2013/4/5 Jens Axboe <axboe@kernel.dk>:
> and then 'write' and 'read' job would be sharing those files. Let me
> know if it works for you.

Thank you for patch Jens.
Re-using files working for me and i also like that string format
specification. Compiled with last git and tested on Mac OS X and
Centos 5.
I played with fio and sequence tests, it already helps me to get
figures much closer to real world utilization. I always struggled with
generic synthetic benchmarks as it usually don't work with sequences.
So i can roughly set IO sizes, modes, but for example can't simulate
performance differences caused by different file allocation between
one huge file (with few extents due to filesystem internal
optimization) and thousands of files.
Great!

Michal

P.S.: Here is what i tried as single thread HD video job. (and as
example where application read whole frame at once, so bs is
uncommonly equal filesize).

[global]
ioengine=sync
buffered=0
filesize=8305664
bs=8305664
nrfiles=3000
openfiles=1
filename_format=HD_sequence_test.$filenum.dpx
file_service_type=sequential
directory=/mnt/test/io

[2min-sequence-write]
rw=write

[2min-sequence-read]
stonewall
rw=read

