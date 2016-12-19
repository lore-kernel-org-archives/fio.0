Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33003 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbcLSLAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Dec 2016 06:00:07 -0500
Received: by mail-ua0-f182.google.com with SMTP id b35so70602237uaa.0
        for <fio@vger.kernel.org>; Mon, 19 Dec 2016 03:00:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com> <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 19 Dec 2016 11:00:06 +0000
Message-ID: <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Before I forget - you using the latest HEAD build of fio? If not can
you update to it (include the version you updated to) and rerun any
tests?

On 19 December 2016 at 09:49, Saju Nair <saju.mad.nair@gmail.com> wrote:
>
> Thanks for your detailed clarifications.
> We followed the example FIO, and tried a few experiments.
> Sharing them, our observations, and few follow-on qestions.
>
> Our setup is a 2TB disk.
> 1. Tried with a config file as captured below, and wrote a 4GB file.
>     --offset was the default (0 ?).
>    We observe that -
>    a. Writes happen based on the --size specified,  whereas Reads (and
> verify) happen for the entire disk.

Your job file looks a bit suspect (perhaps you were thinking of
vdbench configuration formats when you made the jobfile):
[global]
...

[write-and-verify]
...
[device]
filename=/dev/XXXXX

Only "global" is special as a jobname (the bit in square brackets) -
in the above you have one global section and two jobs: one job named
"write-and-verify" and the other job called "device". Bear in mind
that the non-global options in the "write-and-verify" job don't affect
the "device" job and the options in the "device" job do not affect the
"write-and-verify" job. I suspect you wanted filename=/dev/XXXXX in
the global section and no [device] job at all. See "4.0 Job file
format" in the HOWTO for details.

>    b. Both the Write and Read performance (reported by IOPS) is
> significantly lower than our expectations, and observations from
> standalone FIO write, read (separate) runs.

See above. You'll have to ensure your jobfile is correct otherwise you
might find you have been making a file called "write-and-verify" in
the current working directory. Further, the "write-and-verify" and
"device" jobs will have been running simultaneously. You might also
benefit from the allow_file_create=0 option (since you appear to be
working with block devices) as that can warn you when you are trying
to access things that don't already exist (and might otherwise be
created).

>    b. In the output (we captured to a log file using --eta,
> --eta_newline options) , there are 3 sections that we see
>        With w(1) , R(1) - ie both Writes & Reads are happening.
>        With V(1), R(1) - where Reads and verify are happening.
>        With _, R(1) - not clear ?

_ appears when a job has finished running and has been reaped - see
"6.0 Interpreting the output" in the HOWTO.

I'm going to skip over some of the following for now but I do
recommend checking your job file and (re)reading the HOWTO to see if
some of them are already answered there.

>    Questions:
>    a. Is the above behavior expected ? Why does FIO read the entire
> disk - since we only wrote 4GB - is it possible to only read those
> locations that were written to - even in a "randwrite" operation.
>    b. Does the initial writes get interspersed with Reads ?
>    c. What are the _, R(1) section ?
>    d. Why does FIO read the entire disk - is there a way to restrict
> to a start/end offset ?
>    e. How do we know that there is any data miscompare - what is the
> typical FIO output for miscompare ?
>    f. Performance - the performance #s [BW, IOPS] - are much lower
> than the values that we typically see with standalone (ie w/o verify).
> Why ?
>
>
> 2. In order to check for the range of access, we then tried to limit
> the access using
>     --offset = <a value closer to the end of the disk>
>
>     We observe that -
>     a. Writes happen for the specified size, whereas Reads (and
> verify) happen from the offset till end-of-disk.

See above with respect to the strange looking job file.

> Our primary intent are:
> - Do Data Integrity checks to
>       - write to various locations in the disk (using random writes)
>       - be able to reliably read back from those same ("random")
> locations, compare and ensure data integrity.
>       - would "randseed" help us achieve this ?

randseed can help you do that but it might be overkill for your
particular example.

>       - do we need to use the "state" to be able to perform reads from
> ONLY those random locations that we wrote to...

Not necessarily, e.g. if the write and verify are in the same "fio
job" you don't need state files.

> - Data Integrity @ performance:
>       - The above data integrity, with accesses (both write & read)
> happening at peak performance
>       - In this case, we will need to have num_jobs>1 and qdepth>1 as well.

Using higher iodepths I follow but I think increasing numjobs against
the same single disk is the wrong way when doing verification for
reasons I stated in previous emails.

>       - Would it help if we do a 2 step process (as asked earlier) for
>            FIO writes @ peak write performance (iops, bandwidth)
>            FIO read @ peak read performance,
>         Compare thru other means.

Splitting the writing and verifying into two is always an option but I
doubt it will dramatically speed things up.

>         Is there a way to read from disk, to a file on the local host machine.

I don't understand this last question - read what from the disk and
put what into the file?

-- 
Sitsofe | http://sucs.org/~sits/
