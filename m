Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:35521 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbcLSOCJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Dec 2016 09:02:09 -0500
Received: by mail-ua0-f176.google.com with SMTP id 2so18153737uax.2
        for <fio@vger.kernel.org>; Mon, 19 Dec 2016 06:02:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com> <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 19 Dec 2016 14:02:07 +0000
Message-ID: <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 19 December 2016 at 12:29, Saju Nair <saju.mad.nair@gmail.com> wrote:
>
> We tried with the sample [write-and-verify] in the link you specified..
>
> [write-and-verify]
> rw=randwrite
> bs=4k
> direct=1
> ioengine=libaio
> iodepth=16
> size=4g                  <-- added this line
> verify=crc32c
> filename=/dev/XXXX
>
> Unfortunately, we get an error from FIO (both 2.12 and 2.15- latest).
> fio-2.15
> Starting 1 process
> Jobs: 1 (f=1)^MJobs: 1 (f=1)
> Jobs: 1 (f=1): [w(1)] [30.0% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
> iops] [eta mm:ss]
> Jobs: 1 (f=1): [w(1)] [45.5% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
> iops] [eta mm:ss]
> Jobs: 1 (f=1): [w(1)] [54.5% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
> iops] [eta mm:ss]
> fio: pid=9067, err=84/file:io_u.c:1979, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
>
> From a search, this error has been faced by folks before, but, looks
> like it got fixed with "numjobs=1".
>
> We are already using numjobs=1.
> Are there any pointers on how to get around this issue.
> We hope that with the above fixed, we will be able to run regular data
> integrity checks.

Assuming the fio jobfile you posted above was complete (i.e. no global
section no other jobs etc) it looks like what you've hit is the error
message you get when a bad verification header is found during the
verify phase (i.e. there's been a mismatch between the expected and
read back data). fio normally goes on to print a message about
"verify: bad header [...]". Did you get that too (if so what did it
say) and do you get the same error on other disks that you know are
good (i.e. are you sure the disk isn't suffering a problem)?

> Now, onto the data-integrity checks at performance...
> Our device under test (DUT) is an SSD disk.
> Our standalone write and read performance is achieved at a num_jobs >
> 1, and qdepth > 1.
> This is validated in standalone "randwrite" and "randread" FIO runs.

Ah I see. I will note that highest possible performance is a bit at
odds with proving data integrity though because if I only care about
performance I can write any old junk and just throw the data I read
away (I've never known benchmark claims to be limited to verified data
runs)...

> We wanted to develop a strategy to be able to perform data-integrity
> checks @ performance.
> Wanted to check if it is feasible to do this check using FIO.
> Approach#1:
>  Extend the -do_verify approach, and do a write followed by verify in
> a single FIO run.
>  But, as you clarified - this will not be feasible with numjobs > 1.
>
> Approach#2:
> FIO job#1 - do FIO writes, with settings for full performance
> FIO job#2 - wait for job#1 and then, do FIO reads at performance.

A few ideas spring to mind:
1. Try the usual methods that speed up a "normal" single fio job - if
a single process/thread submits as much I/O as multiple ones it isn't
going to look different from the disk's perspective (assuming that it
sheer amount of simultaneous I/O triggering a problem). Things like
reducing calls that cost CPU, doing things in bigger batches to
amortize the cost etc should also help verification speed (but I'll
leave you to find those elsewhere). You can also look at the HOWTO
information related to verify_async= option to try and allow more
parallelism.
2. Split the disk into different regions and write/verify each region
separately from any other region. See offset_increment= in the HOWTO
for something that might help achieve this if you use numjobs. More
fiddly but a good exercise in learning how to create fio job files.

> Is there any inbuilt way to do an at-speed comparison in FIO.

Personally I'd start with 1. from above and after I got that going I'd
give 2. a go. If 1. can be made to get similar disk I/O numbers to
using multiple jobs then you might even stop there.

> If not, we wanted to see if we can use FIO to read from our DUT, to
> the host's memory or any other storage disk, and then do a simple
> application that compares the data.

fio isn't a copying tool so it won't "move" data for you (and doing so
would slow things down). However, if you somehow copied the contents
into a file fio could verify against the file. The problem you'll then
have to solve is finding a tool that copies the data faster than fio
does its verifying reads...

-- 
Sitsofe | http://sucs.org/~sits/
