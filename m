Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33902 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763756AbcLVEse (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2016 23:48:34 -0500
Received: by mail-qk0-f177.google.com with SMTP id q68so103373359qki.1
        for <fio@vger.kernel.org>; Wed, 21 Dec 2016 20:48:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg7x7ae+M7vHAr31BAOZ68a-UNrMqcMyqCeeYmS-N1NTA@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
 <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
 <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
 <CAKV1nBaM=Cj4qHcyQSJuBmTB4htAupp4Uyh1TEAF_bjk8XJtqQ@mail.gmail.com>
 <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com>
 <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com> <CALjAwxg7x7ae+M7vHAr31BAOZ68a-UNrMqcMyqCeeYmS-N1NTA@mail.gmail.com>
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Thu, 22 Dec 2016 10:18:32 +0530
Message-ID: <CAKV1nBZfDgy_+4nAOYXni0m=Q0WUNrn-_q9J_+XuwWRZR03Enw@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
Thanks. Please find the stderr messages snippet.
We get the offsets where FIO observed failures, during the "verify" phase.
The nvme**.<num>.received - is reported to contain 0.

However, when we try a "dd" to access the location (offset) specified
- we do see proper data.
It might be an issue in our DUT, and we will investigate further.

Thanks for your help.

Regards,
- Saju.

*************************************************************
/root/demo/fio-2.12/bin/fio test.fio -eta=3Dalways --eta-newline=3D1 1 tee
fiol.log=E2=80=A2rite-and-verify: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4=
K,
ioengine=3Dlibaio, iodepth=3D16
=E2=80=A2rite-and-verify: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K,
ioengine=3Dlibaio, iodepth=3D16
fio-2.12
starting 1 process
fio: got pattern '00', wanted '99'. Bad bits 4
fio: bad pattern block offset 0
   received data dumped as nvme0n1.12288.received
   expected data dumped as nvme0n1.12288.expected
fio: verify type mismatch (0 media, 14 given)
fio: got pattern '00', wanted '99'. Bad bits 4
fio: bad pattern block offset 0
   received data dumped as nvmeOn1.40960.received
   expected data dumped as nvme0n1.40960.expected
fio: verify type mismatch (0 media, 14 given)


On Tue, Dec 20, 2016 at 6:56 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 20 December 2016 at 12:26, Saju Nair <saju.mad.nair@gmail.com> wrote:
>>
>> Thanks for your clarifications.
>> We ran with a --continue_on_error=3Dverify,
>> to let the FIO complete the full compare..
>>
>> We tried to do a sequential write and compare, using the FIO config
>> file as below, and to bring in the complexity of "random" as a 2nd
>> step.
>> [write-and-verify]
>> rw=3Dwrite
>> bs=3D4k
>> direct=3D1
>> ioengine=3Dlibaio
>> iodepth=3D16
>> size=3D2m
>> verify=3Dpattern
>> verify_pattern=3D0x33333333
>> continue_on_error=3Dverify
>> verify_dump=3D1
>> filename=3D/dev/XXXX
>>
>> FIO reports errors and we see files of the following names created:
>> <filename>.<num>.received
>> <filename>.<num>.expected
>>
>> Wanted help in interpreting the result.
>>
>> We wrote 2MB worth of data, with blocksize =3D 4K.
>> So, ideally is it expected to do 2MB/4KB =3D 512 IO operations
>>
>> 1) The received/expected files:
>> Are they for each 4K offset that failed the comparison ?
>
> I bet you can deduce this from the size and names of the files...
>
>> Is the <num> to be interpreted as the (num/bs)-th block that failed ?
>>    For ex: if the num=3D438272, and bs=3D4096 =3D> 107th block failed ?
>>
>> It would be useful to know this information - so that we can debug furth=
er,
>> FYI, if we try a "dd" command and check the disk, based on the above
>> calculation - the data is proper (as expected).
>
> You never answered my question about what you are doing with stderr.
> I'll repeat it here:
>
>>> Are you doing something like redirecting stdout to a file but not
>>> doing anything with stderr? It would help if you include the command
>>> line you are using to run fio in your reply.
>
> Can you answer this question and post the full command line you ran
> fio with? I think it might have relevance to your current question.
>
>> 2) What were the locations that were written to..
>> Tried fio-verify-state <.state_file>, and get the below:
>> Version:        0x3
>> Size:           408
>> CRC:            0x70ca464a
>> Thread:         0
>> Name:           write-and-verify
>> Completions:    16
>> Depth:          16
>> Number IOs:     512
>> Index:          0
>> Completions:
>>         (file=3D 0) 2031616
>>         (file=3D 0) 2035712
>>         (file=3D 0) 2039808
>>         (file=3D 0) 2043904
>>         (file=3D 0) 2048000
>>         (file=3D 0) 2052096
>>         (file=3D 0) 2056192
>>         (file=3D 0) 2060288
>>         (file=3D 0) 2064384
>>         (file=3D 0) 2068480
>>         (file=3D 0) 2072576
>>         (file=3D 0) 2076672
>>         (file=3D 0) 2080768
>>         (file=3D 0) 2084864
>>         (file=3D 0) 2088960
>>         (file=3D 0) 2093056
>>
>> How do we interpret the above content to understand the locations of Wri=
tes.
>
> Perhaps fio tracks how far through the sequence it got rather than
> individual locations written (this would be necessary to handle things
> like loops=3D)? I personally don't know the answer to this but you can
> always take a look at the source code.
>
> --
> Sitsofe | http://sucs.org/~sits/
