Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:35355 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbcLTN0i (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 08:26:38 -0500
Received: by mail-ua0-f182.google.com with SMTP id 2so47741128uax.2
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 05:26:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
 <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
 <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
 <CAKV1nBaM=Cj4qHcyQSJuBmTB4htAupp4Uyh1TEAF_bjk8XJtqQ@mail.gmail.com>
 <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com> <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 20 Dec 2016 13:26:36 +0000
Message-ID: <CALjAwxg7x7ae+M7vHAr31BAOZ68a-UNrMqcMyqCeeYmS-N1NTA@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 20 December 2016 at 12:26, Saju Nair <saju.mad.nair@gmail.com> wrote:
>
> Thanks for your clarifications.
> We ran with a --continue_on_error=verify,
> to let the FIO complete the full compare..
>
> We tried to do a sequential write and compare, using the FIO config
> file as below, and to bring in the complexity of "random" as a 2nd
> step.
> [write-and-verify]
> rw=write
> bs=4k
> direct=1
> ioengine=libaio
> iodepth=16
> size=2m
> verify=pattern
> verify_pattern=0x33333333
> continue_on_error=verify
> verify_dump=1
> filename=/dev/XXXX
>
> FIO reports errors and we see files of the following names created:
> <filename>.<num>.received
> <filename>.<num>.expected
>
> Wanted help in interpreting the result.
>
> We wrote 2MB worth of data, with blocksize = 4K.
> So, ideally is it expected to do 2MB/4KB = 512 IO operations
>
> 1) The received/expected files:
> Are they for each 4K offset that failed the comparison ?

I bet you can deduce this from the size and names of the files...

> Is the <num> to be interpreted as the (num/bs)-th block that failed ?
>    For ex: if the num=438272, and bs=4096 => 107th block failed ?
>
> It would be useful to know this information - so that we can debug further,
> FYI, if we try a "dd" command and check the disk, based on the above
> calculation - the data is proper (as expected).

You never answered my question about what you are doing with stderr.
I'll repeat it here:

>> Are you doing something like redirecting stdout to a file but not
>> doing anything with stderr? It would help if you include the command
>> line you are using to run fio in your reply.

Can you answer this question and post the full command line you ran
fio with? I think it might have relevance to your current question.

> 2) What were the locations that were written to..
> Tried fio-verify-state <.state_file>, and get the below:
> Version:        0x3
> Size:           408
> CRC:            0x70ca464a
> Thread:         0
> Name:           write-and-verify
> Completions:    16
> Depth:          16
> Number IOs:     512
> Index:          0
> Completions:
>         (file= 0) 2031616
>         (file= 0) 2035712
>         (file= 0) 2039808
>         (file= 0) 2043904
>         (file= 0) 2048000
>         (file= 0) 2052096
>         (file= 0) 2056192
>         (file= 0) 2060288
>         (file= 0) 2064384
>         (file= 0) 2068480
>         (file= 0) 2072576
>         (file= 0) 2076672
>         (file= 0) 2080768
>         (file= 0) 2084864
>         (file= 0) 2088960
>         (file= 0) 2093056
>
> How do we interpret the above content to understand the locations of Writes.

Perhaps fio tracks how far through the sequence it got rather than
individual locations written (this would be necessary to handle things
like loops=)? I personally don't know the answer to this but you can
always take a look at the source code.

-- 
Sitsofe | http://sucs.org/~sits/
