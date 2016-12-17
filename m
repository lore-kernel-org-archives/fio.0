Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:36120 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752821AbcLQQYk (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Dec 2016 11:24:40 -0500
Received: by mail-ua0-f173.google.com with SMTP id 3so50518633uaz.3
        for <fio@vger.kernel.org>; Sat, 17 Dec 2016 08:24:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Dec 2016 16:24:38 +0000
Message-ID: <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 17 December 2016 at 10:45, Saju Nair <saju.mad.nair@gmail.com> wrote:
> Hi FIO users,
> I am a new user of FIO, and had a few basic questions.
> I tried to search the existing QA in archives, and have not found an
> exact answer.
> Apologies, for the length of the mail and also if this is already
> addressed (if so, kindly point me to that archive article).
>
> Referred to:
> https://github.com/axboe/fio/issues/163

#163 covers multiple issues (the last of which seems linked to the
'%o' verification pattern). I'm not sure it's a simple starting
example...

> http://www.spinics.net/lists/fio/msg04104.html
> http://www.spinics.net/lists/fio/msg03424.html
>
> We are trying to do Data Integrity checks using FIO, while performing
> Sequential & Random Writes/Reads.
>
> 1. Basic Write/Read and offline comparison for Data Integrity:
>    a. Is it possible to perform Random Writes to a portion of the disk
> (using --offset, --size options), and read back from those locations.

Yes - a simple example is
fio --rw=randwrite --verify=crc32c --filename=examplefile --size=20M
--offset=10M --name=verifytest

Create a file that is 30Mbytes in size but only do randomly ordered
I/O (that writes to each block exactly once) to the last 20MBytes of
the file then afterwards verify that I/O that was written in that last
20Mbytes looks correct according to the header written to that block.
Also see the basic-verify example
(https://github.com/axboe/fio/blob/fio-2.15/examples/basic-verify.fio
).

>    b. Is it possible to force FIO to access the same LBAs during
> Writes and Reads, when it is random.

That will happen with the above even if the writes happened in a random order.

>    c. Is there a way to control the "randomness" using any seeds ?

Yes see randseed= in the HOWTO
(https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L456 ).

>    d. Is there a need to use the "state" files ?

In general if you want to verify I/O that was written by a *different*
job you will probably need to make use of a state file. There are
cases where you can get away without using a state file (e.g. you are
writing the same size block across the entire disk and the writes
include a verification header) but not all: sometimes you need to know
things like "what was the random seed used and how far did the write
job get" in order for the verification to be performed successfully.

>    The intent was to get the data read back to a file, and then
> compare against expected.
>
> 2. FIO comparison using *verify* options:
>     We tried to do an FIO with
>      --do_verify=1
>      --verify=pattern
>      --verify_pattern=TEST_PATTERN
>      --rw=randwrite (or write - for sequential)
>
>     In this case, again a few follow-on Questions:
>     a. Does FIO perform writes completely, ie based on --size, or --runtime
>         and then do the read access to verify.

With the initial example you put above fio will finish doing the
random (or sequential) writes and then do a sequential verify (read)
pass afterwards of the data that was written. However, IF you use
--runtime and the runtime is exceeded while still in the write pass
then no verification will happen at all (because there's no time left
to do it).

>         What parameters are used (for blk-size, numjobs, qdepth etc.)
> during the  Reads operation.

numjobs makes job clones so each clone is distinct job with various
inherited parameters (see numjobs= in the HOWTO). For the other
parameters you explicitly listed (bs, iodepth) the verify component of
the job will use whatever was specified for that job as a whole.

>     b. is there a way to get the results of the verify step into an
> output file ?

I don't understand the question - could you rephrase it with examples?
Do you mean how long it took, if errors were found etc?

>     c. The above questions on control of random accesses still exist.

See the answer in 1b and 1c.

>     d. We tried a run of the above kind, and the FIO run passed, ie
> there were no obvious errors reported.
>     e. In order to ensure that the verification was correct - we did a
> 2 step process:
>         [similar to one of the reference articles]
>         FIO#1 - with Writes (--do_verify=0, --verify_pattern=PAT1)
>         FIO#2 - for read/verify (--do_verify=1, --verify_pattern=PAT2)
>        and got some errors..

This is different to the example I gave above because you have two
separate jobs - one doing the writing and another doing the
reading/verifying. It's hard to say what went wrong without seeing the
exact job/command line you used for FIO#1 and FIO#2. It would help if
you could post the cut down versions of FIO#1 and FIO#2 that still
show the problem.

>        But, we are not yet sure if that has flagged ALL the locations
> in error or not.
>        Is there a way to ascertain this ?

Probably depends on the job parameters as to whether ALL locations can
be flagged. Generally speaking "partially damaged" blocks can't/won't
be verified (see the "intact blocks" note for norandommap in the HOWTO
- https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L1031 ). Unless you
use verify_fatal=1 fio will try and report all locations it can that
have a mismatch. Is that the information you're looking for?

>     f. Are there any restrictions in the usage of --num_jobs in such a check..

It's important to ensure that two (or more) jobs do NOT write
different data (either due to contents and/or block size when using a
header) to overlapping regions of the disk before the verification
happens (this is in general - not just with numjobs). Put another way:
if you have two simultaneous jobs overwriting the same regions of the
disk with different data how can job #1 know what the correct data
should be at verification time when it knows nothing of what the job
#2 did (or when it did it) relative to its own I/O?

-- 
Sitsofe | http://sucs.org/~sits/
