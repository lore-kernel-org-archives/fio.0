Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33261 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755507AbcLSJtx (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Dec 2016 04:49:53 -0500
Received: by mail-qk0-f179.google.com with SMTP id t184so8643524qkd.0
        for <fio@vger.kernel.org>; Mon, 19 Dec 2016 01:49:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Mon, 19 Dec 2016 15:19:51 +0530
Message-ID: <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org

Hi Sitsofe,
Thanks for your detailed clarifications.
We followed the example FIO, and tried a few experiments.
Sharing them, our observations, and few follow-on qestions.

Our setup is a 2TB disk.
1. Tried with a config file as captured below, and wrote a 4GB file.
    --offset was the default (0 ?).
   We observe that -
   a. Writes happen based on the --size specified,  whereas Reads (and
verify) happen for the entire disk.
   b. Both the Write and Read performance (reported by IOPS) is
significantly lower than our expectations, and observations from
standalone FIO write, read (separate) runs.
   b. In the output (we captured to a log file using --eta,
--eta_newline options) , there are 3 sections that we see
       With w(1) , R(1) - ie both Writes & Reads are happening.
       With V(1), R(1) - where Reads and verify are happening.
       With _, R(1) - not clear ?


   Questions:
   a. Is the above behavior expected ? Why does FIO read the entire
disk - since we only wrote 4GB - is it possible to only read those
locations that were written to - even in a "randwrite" operation.
   b. Does the initial writes get interspersed with Reads ?
   c. What are the _, R(1) section ?
   d. Why does FIO read the entire disk - is there a way to restrict
to a start/end offset ?
   e. How do we know that there is any data miscompare - what is the
typical FIO output for miscompare ?
   f. Performance - the performance #s [BW, IOPS] - are much lower
than the values that we typically see with standalone (ie w/o verify).
Why ?


2. In order to check for the range of access, we then tried to limit
the access using
    --offset = <a value closer to the end of the disk>

    We observe that -
    a. Writes happen for the specified size, whereas Reads (and
verify) happen from the offset till end-of-disk.


Our primary intent are:
- Do Data Integrity checks to
      - write to various locations in the disk (using random writes)
      - be able to reliably read back from those same ("random")
locations, compare and ensure data integrity.
      - would "randseed" help us achieve this ?
      - do we need to use the "state" to be able to perform reads from
ONLY those random locations that we wrote to...

- Data Integrity @ performance:
      - The above data integrity, with accesses (both write & read)
happening at peak performance
      - In this case, we will need to have num_jobs>1 and qdepth>1 as well.
      - Would it help if we do a 2 step process (as asked earlier) for
           FIO writes @ peak write performance (iops, bandwidth)
           FIO read @ peak read performance,
        Compare thru other means.
        Is there a way to read from disk, to a file on the local host machine.

We wanted to understand, if FIO can help us achieve this intent or not.


Regards,
- Saju.


*****************FIO Config File ******************************
[global]
#time_based
group_reporting
direct=1
ioengine=libaio

bs=4k
iodepth=16
numjobs=1

[write-and-verify]
rw=randwrite
size=4G
verify=crc32c

refill_buffers
scramble_buffers=1

[device]
filename=/dev/XXXXX
***********************************************************************


******************* Sample Output *********************************
Jobs: 2 (f=2): [w(1),R(1)] [0.1% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
Jobs: 2 (f=2): [w(1),R(1)] [0.2% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
Jobs: 2 (f=2): [w(1),R(1)] [0.3% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
..
Jobs: 2 (f=2): [V(1),R(1)] [2.5% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
Jobs: 2 (f=2): [V(1),R(1)] [2.6% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
..
Jobs: 2 (f=2): [V(1),R(1)] [5.4% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
Jobs: 1 (f=1): [_(1),R(1)] [5.4% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
Jobs: 1 (f=1): [_(1),R(1)] [5.5% done] [nnnMB/mKB/0KB /s] [xxxK/yyyK/0
iops] [eta mm:ss]
...
Jobs: 1 (f=1): [_(1),R(1)] [99.9% done] [nnnMB/mKB/0KB /s]
[xxxK/yyyK/0 iops] [eta mm:ss]
Jobs: 1 (f=1): [_(1),R(1)] [100.0% done] [nnnMB/mKB/0KB /s]
[xxxK/yyyK/0 iops] [eta mm:ss]

On Sat, Dec 17, 2016 at 9:54 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 17 December 2016 at 10:45, Saju Nair <saju.mad.nair@gmail.com> wrote:
>> Hi FIO users,
>> I am a new user of FIO, and had a few basic questions.
>> I tried to search the existing QA in archives, and have not found an
>> exact answer.
>> Apologies, for the length of the mail and also if this is already
>> addressed (if so, kindly point me to that archive article).
>>
>> Referred to:
>> https://github.com/axboe/fio/issues/163
>
> #163 covers multiple issues (the last of which seems linked to the
> '%o' verification pattern). I'm not sure it's a simple starting
> example...
>
>> http://www.spinics.net/lists/fio/msg04104.html
>> http://www.spinics.net/lists/fio/msg03424.html
>>
>> We are trying to do Data Integrity checks using FIO, while performing
>> Sequential & Random Writes/Reads.
>>
>> 1. Basic Write/Read and offline comparison for Data Integrity:
>>    a. Is it possible to perform Random Writes to a portion of the disk
>> (using --offset, --size options), and read back from those locations.
>
> Yes - a simple example is
> fio --rw=randwrite --verify=crc32c --filename=examplefile --size=20M
> --offset=10M --name=verifytest
>
> Create a file that is 30Mbytes in size but only do randomly ordered
> I/O (that writes to each block exactly once) to the last 20MBytes of
> the file then afterwards verify that I/O that was written in that last
> 20Mbytes looks correct according to the header written to that block.
> Also see the basic-verify example
> (https://github.com/axboe/fio/blob/fio-2.15/examples/basic-verify.fio
> ).
>
>>    b. Is it possible to force FIO to access the same LBAs during
>> Writes and Reads, when it is random.
>
> That will happen with the above even if the writes happened in a random order.
>
>>    c. Is there a way to control the "randomness" using any seeds ?
>
> Yes see randseed= in the HOWTO
> (https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L456 ).
>
>>    d. Is there a need to use the "state" files ?
>
> In general if you want to verify I/O that was written by a *different*
> job you will probably need to make use of a state file. There are
> cases where you can get away without using a state file (e.g. you are
> writing the same size block across the entire disk and the writes
> include a verification header) but not all: sometimes you need to know
> things like "what was the random seed used and how far did the write
> job get" in order for the verification to be performed successfully.
>
>>    The intent was to get the data read back to a file, and then
>> compare against expected.
>>
>> 2. FIO comparison using *verify* options:
>>     We tried to do an FIO with
>>      --do_verify=1
>>      --verify=pattern
>>      --verify_pattern=TEST_PATTERN
>>      --rw=randwrite (or write - for sequential)
>>
>>     In this case, again a few follow-on Questions:
>>     a. Does FIO perform writes completely, ie based on --size, or --runtime
>>         and then do the read access to verify.
>
> With the initial example you put above fio will finish doing the
> random (or sequential) writes and then do a sequential verify (read)
> pass afterwards of the data that was written. However, IF you use
> --runtime and the runtime is exceeded while still in the write pass
> then no verification will happen at all (because there's no time left
> to do it).
>
>>         What parameters are used (for blk-size, numjobs, qdepth etc.)
>> during the  Reads operation.
>
> numjobs makes job clones so each clone is distinct job with various
> inherited parameters (see numjobs= in the HOWTO). For the other
> parameters you explicitly listed (bs, iodepth) the verify component of
> the job will use whatever was specified for that job as a whole.
>
>>     b. is there a way to get the results of the verify step into an
>> output file ?
>
> I don't understand the question - could you rephrase it with examples?
> Do you mean how long it took, if errors were found etc?
>
>>     c. The above questions on control of random accesses still exist.
>
> See the answer in 1b and 1c.
>
>>     d. We tried a run of the above kind, and the FIO run passed, ie
>> there were no obvious errors reported.
>>     e. In order to ensure that the verification was correct - we did a
>> 2 step process:
>>         [similar to one of the reference articles]
>>         FIO#1 - with Writes (--do_verify=0, --verify_pattern=PAT1)
>>         FIO#2 - for read/verify (--do_verify=1, --verify_pattern=PAT2)
>>        and got some errors..
>
> This is different to the example I gave above because you have two
> separate jobs - one doing the writing and another doing the
> reading/verifying. It's hard to say what went wrong without seeing the
> exact job/command line you used for FIO#1 and FIO#2. It would help if
> you could post the cut down versions of FIO#1 and FIO#2 that still
> show the problem.
>
>>        But, we are not yet sure if that has flagged ALL the locations
>> in error or not.
>>        Is there a way to ascertain this ?
>
> Probably depends on the job parameters as to whether ALL locations can
> be flagged. Generally speaking "partially damaged" blocks can't/won't
> be verified (see the "intact blocks" note for norandommap in the HOWTO
> - https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L1031 ). Unless you
> use verify_fatal=1 fio will try and report all locations it can that
> have a mismatch. Is that the information you're looking for?
>
>>     f. Are there any restrictions in the usage of --num_jobs in such a check..
>
> It's important to ensure that two (or more) jobs do NOT write
> different data (either due to contents and/or block size when using a
> header) to overlapping regions of the disk before the verification
> happens (this is in general - not just with numjobs). Put another way:
> if you have two simultaneous jobs overwriting the same regions of the
> disk with different data how can job #1 know what the correct data
> should be at verification time when it knows nothing of what the job
> #2 did (or when it did it) relative to its own I/O?
>
> --
> Sitsofe | http://sucs.org/~sits/
