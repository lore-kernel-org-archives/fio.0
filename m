Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34497 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757693AbcLTM01 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 07:26:27 -0500
Received: by mail-qk0-f178.google.com with SMTP id q68so46514463qki.1
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 04:26:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
 <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
 <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
 <CAKV1nBaM=Cj4qHcyQSJuBmTB4htAupp4Uyh1TEAF_bjk8XJtqQ@mail.gmail.com> <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com>
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Tue, 20 Dec 2016 17:56:25 +0530
Message-ID: <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
Thanks for your clarifications.
We ran with a --continue_on_error=verify,
to let the FIO complete the full compare..

We tried to do a sequential write and compare, using the FIO config
file as below, and to bring in the complexity of "random" as a 2nd
step.
[write-and-verify]
rw=write
bs=4k
direct=1
ioengine=libaio
iodepth=16
size=2m
verify=pattern
verify_pattern=0x33333333
continue_on_error=verify
verify_dump=1
filename=/dev/XXXX

FIO reports errors and we see files of the following names created:
<filename>.<num>.received
<filename>.<num>.expected

Wanted help in interpreting the result.

We wrote 2MB worth of data, with blocksize = 4K.
So, ideally is it expected to do 2MB/4KB = 512 IO operations

1) The received/expected files:
Are they for each 4K offset that failed the comparison ?
Is the <num> to be interpreted as the (num/bs)-th block that failed ?
   For ex: if the num=438272, and bs=4096 => 107th block failed ?

It would be useful to know this information - so that we can debug further,
FYI, if we try a "dd" command and check the disk, based on the above
calculation - the data is proper (as expected).

2) What were the locations that were written to..
Tried fio-verify-state <.state_file>, and get the below:
Version:        0x3
Size:           408
CRC:            0x70ca464a
Thread:         0
Name:           write-and-verify
Completions:    16
Depth:          16
Number IOs:     512
Index:          0
Completions:
        (file= 0) 2031616
        (file= 0) 2035712
        (file= 0) 2039808
        (file= 0) 2043904
        (file= 0) 2048000
        (file= 0) 2052096
        (file= 0) 2056192
        (file= 0) 2060288
        (file= 0) 2064384
        (file= 0) 2068480
        (file= 0) 2072576
        (file= 0) 2076672
        (file= 0) 2080768
        (file= 0) 2084864
        (file= 0) 2088960
        (file= 0) 2093056

How do we interpret the above content to understand the locations of Writes.

Thanks,
- Saju.








On Tue, Dec 20, 2016 at 2:04 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 19 December 2016 at 17:15, Saju Nair <saju.mad.nair@gmail.com> wrote:
>>
>> On the possible data-verify error,
>> 1. Yes, the config file is what I used.
>> 2. Did not get the verify : bad header info. but got a line as below.
>> write-and-verify: (groupid=0, jobs=1): err=84 (file:io_u.c:1979,
>> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
>> wide character): pid=9067: Mon Dec 19 03:47:40 2016
>>     Wish that the response was more intuitive!.
>
> Yeah.. the error message is a bit strange (see
> http://www.spinics.net/lists/fio/msg04977.html for why),
>
>> 3. Below message shows
>>
>> Run status group 0 (all jobs):
>>    READ: io=264KB, aggrb=XXXXKB/s, minb=XXXXKB/s, maxb=XXXXKB/s,
>> mint=tmsec, maxt=tmsec
>>   WRITE: io=4096.0MB, aggrb=YYYYYKB/s, minb=YYYYYKB/s, maxb=YYYYYKB/s,
>> mint=t2msec, maxt=t2msec
>>
>> Appears to indicate that 4GB had been written to, but, reads happened
>> only upto 264KB, by when we possibly got  an error ?
>> Is there a way to get additional info - like what was expected, and
>> what was actually written, which sector (address) is in error ?
>
> Normally whenever fio has hit mismatches information about the problem
> offset is printed to stderr. I've just run a quick check on a device
> that always returns zeros and here's what I got:
>
> write-and-verify: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K,
> ioengine=libaio, iodepth=16
> fio-2.15-25-gea8d
> Starting 1 process
> verify: bad magic header 0, wanted acca at file /dev/mapper/fake
> offset 259043328, length 4096
> verify: bad magic header 0, wanted acca at file /dev/mapper/fake
> offset 3179520000, length 4096
> fio: pid=15333, err=84/file:io_u.c:1983, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
>
> write-and-verify: (groupid=0, jobs=1): err=84 (file:io_u.c:1983,
> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
> wide character): pid=15333: Mon Dec 19 19:10:01 2016
>
> Are you doing something like redirecting stdout to a file but not
> doing anything with stderr? It would help if you include the command
> line you are using to run fio in your reply.
>
> See the HOWTO (I say that a lot right?) for information on the
> verify_dump= job option which will cause the contents of failing
> blocks to be recorded within files within the current working
> directory. If the verification header is correct but the contents is
> wrong you will also get a dump of the expected data in a separate
> file. You might want to try this out before you enable the following
> option because if there are a lot of distinct blocks that mismatch a
> lot of files will be generated...
>
>> Can we set the
>> --continue_on_error=verify, to get all the errors ?
>
> Yes - I was mistaken earlier about all errors being printed by default
> with verify_fatal=0 so perhaps the HOWTO needs to be updated.
> continue_on_error is actually a job option so it can go into the job
> file if you prefer.
>
>> -------------------------------------
>>
>> On the Data Integrity @ performance-
>> our thought was that for us to ensure that the max performance also is
>> backed up by having data integrity to pass..
>> Let me think through the suggestions that you have provided for the same..
>> Many thanks, really appreciate your valuable support & suggestions.
>
> --
> Sitsofe | http://sucs.org/~sits/
