Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35292 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbcLZLaC (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Dec 2016 06:30:02 -0500
Received: by mail-qt0-f173.google.com with SMTP id c47so306552998qtc.2
        for <fio@vger.kernel.org>; Mon, 26 Dec 2016 03:30:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhDo2p=LFG-r6ZcGbiEk26sZgO8BAnVCrUFXRDVQ9DTkw@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
 <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
 <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
 <CAKV1nBaM=Cj4qHcyQSJuBmTB4htAupp4Uyh1TEAF_bjk8XJtqQ@mail.gmail.com>
 <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com>
 <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com>
 <CALjAwxg7x7ae+M7vHAr31BAOZ68a-UNrMqcMyqCeeYmS-N1NTA@mail.gmail.com>
 <CAKV1nBZfDgy_+4nAOYXni0m=Q0WUNrn-_q9J_+XuwWRZR03Enw@mail.gmail.com> <CALjAwxhDo2p=LFG-r6ZcGbiEk26sZgO8BAnVCrUFXRDVQ9DTkw@mail.gmail.com>
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Mon, 26 Dec 2016 17:00:00 +0530
Message-ID: <CAKV1nBaVHBaFXaKoKVD2Xbqfsejrn7y7ufWGx=rPcd=ekVgKKQ@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks.
Apologies for the delay - Based on  the FIO debug messages, we figured
out that there was an underlying issue in the drive HW, and eventually
figured out the problem and fixed it.
FIO based data integrity works fine for us now, although at lower performan=
ce.
The read-verify step runs at about 1/10-th of the normal "read" performance=
.

Note that we keep "numjobs=3D1" - in order to not create any
complications due to this, in the verify stage.

I am not sure if this is possible, but, can FIO store the data read
into the RAM of the host machine ?
If so, one solution we are exploring is to break our existing
read-verify step to :

break into N smaller # FIO accesses, and foreach of N
   FIO reads - to RAM of host machine
   special program to mem-compare against expected data.



Regards,
- Saju.

On Thu, Dec 22, 2016 at 12:35 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote=
:
> Hi,
>
> Bear in mind I can't see your current test.fio (which must be
> different from the one you previously posted because fio appears to be
> searching for 0x99 whereas the previous job was searching for 0x33) so
> if you have extra options in there they may invalidate any analysis I
> make.
>
> On 22 December 2016 at 04:48, Saju Nair <saju.mad.nair@gmail.com> wrote:
>> Hi,
>> Thanks. Please find the stderr messages snippet.
>> We get the offsets where FIO observed failures, during the "verify" phas=
e.
>> The nvme**.<num>.received - is reported to contain 0.
>>
>> However, when we try a "dd" to access the location (offset) specified
>> - we do see proper data.
>> It might be an issue in our DUT, and we will investigate further.
>
> I'm guessing you didn't use iflag=3Dnocache or (iflag=3Ddirect + reading
> in aligned block sizes) on your dd - are you sure your dd wasn't just
> reading out of Linux's page cache? For example for an offset of 12288
> you could use dd iflag=3Ddirect if=3D/dev/nvme0n1 bs=3D4k skip=3D3 count=
=3D1 |
> hexdump (bear in mind it is better to do this directly after the fio .
> Do you also get this same effect on disks you know to be good?
>
> This is all very suspicious. If the change above somehow returns the
> same data as fio I think you've got a problem on your hands. If the
> problem goes away when you add end_fsync=3D1 to the fio job file then
> that suggests someone has configured the NVMe devices for speed and
> has thrown away safety.
>
>> *************************************************************
>> /root/demo/fio-2.12/bin/fio test.fio -eta=3Dalways --eta-newline=3D1 1 t=
ee
>
> This line seems garbled (" 1 tee"? Did you have to re-enter all output
> by hand?) but assuming the real command line is correct your tee will
> only save stdout to a file and not stderr. See
> http://stackoverflow.com/questions/692000/how-do-i-write-stderr-to-a-file=
-while-using-tee-with-a-pipe
> for suggestions on also saving stderr while using tee...
>
>> fiol.log=E2=80=A2rite-and-verify: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4=
K-4K,
>> ioengine=3Dlibaio, iodepth=3D16
>> =E2=80=A2rite-and-verify: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K,
>> ioengine=3Dlibaio, iodepth=3D16
>> fio-2.12
>
> ^^^ Might be worth upgrading to the latest fio release (2.16) so you
> don't hit any fixed issues.
>
>> starting 1 process
>> fio: got pattern '00', wanted '99'. Bad bits 4
>> fio: bad pattern block offset 0
>
> ^^ Notice how this says the block offset, what it found and what it
> wanted. This should make working out where to look straight forward.
>
>>    received data dumped as nvme0n1.12288.received
>>    expected data dumped as nvme0n1.12288.expected
>> fio: verify type mismatch (0 media, 14 given)
>> fio: got pattern '00', wanted '99'. Bad bits 4
>> fio: bad pattern block offset 0
>>    received data dumped as nvmeOn1.40960.received
>>    expected data dumped as nvme0n1.40960.expected
>> fio: verify type mismatch (0 media, 14 given)
>>
>>
>> On Tue, Dec 20, 2016 at 6:56 PM, Sitsofe Wheeler <sitsofe@gmail.com> wro=
te:
>>> Hi,
>>>
>>> On 20 December 2016 at 12:26, Saju Nair <saju.mad.nair@gmail.com> wrote=
:
>>>>
>>>> Thanks for your clarifications.
>>>> We ran with a --continue_on_error=3Dverify,
>>>> to let the FIO complete the full compare..
>>>>
>>>> We tried to do a sequential write and compare, using the FIO config
>>>> file as below, and to bring in the complexity of "random" as a 2nd
>>>> step.
>>>> [write-and-verify]
>>>> rw=3Dwrite
>>>> bs=3D4k
>>>> direct=3D1
>>>> ioengine=3Dlibaio
>>>> iodepth=3D16
>>>> size=3D2m
>>>> verify=3Dpattern
>>>> verify_pattern=3D0x33333333
>>>> continue_on_error=3Dverify
>>>> verify_dump=3D1
>>>> filename=3D/dev/XXXX
>>>>
>>>> FIO reports errors and we see files of the following names created:
>>>> <filename>.<num>.received
>>>> <filename>.<num>.expected
>>>>
>>>> Wanted help in interpreting the result.
>>>>
>>>> We wrote 2MB worth of data, with blocksize =3D 4K.
>>>> So, ideally is it expected to do 2MB/4KB =3D 512 IO operations
>>>>
>>>> 1) The received/expected files:
>>>> Are they for each 4K offset that failed the comparison ?
>>>
>>> I bet you can deduce this from the size and names of the files...
>>>
>>>> Is the <num> to be interpreted as the (num/bs)-th block that failed ?
>>>>    For ex: if the num=3D438272, and bs=3D4096 =3D> 107th block failed =
?
>>>>
>>>> It would be useful to know this information - so that we can debug fur=
ther,
>>>> FYI, if we try a "dd" command and check the disk, based on the above
>>>> calculation - the data is proper (as expected).
>>>
>>> You never answered my question about what you are doing with stderr.
>>> I'll repeat it here:
>>>
>>>>> Are you doing something like redirecting stdout to a file but not
>>>>> doing anything with stderr? It would help if you include the command
>>>>> line you are using to run fio in your reply.
>>>
>>> Can you answer this question and post the full command line you ran
>>> fio with? I think it might have relevance to your current question.
>>>
>>>> 2) What were the locations that were written to..
>>>> Tried fio-verify-state <.state_file>, and get the below:
>>>> Version:        0x3
>>>> Size:           408
>>>> CRC:            0x70ca464a
>>>> Thread:         0
>>>> Name:           write-and-verify
>>>> Completions:    16
>>>> Depth:          16
>>>> Number IOs:     512
>>>> Index:          0
>>>> Completions:
>>>>         (file=3D 0) 2031616
>>>>         (file=3D 0) 2035712
>>>>         (file=3D 0) 2039808
>>>>         (file=3D 0) 2043904
>>>>         (file=3D 0) 2048000
>>>>         (file=3D 0) 2052096
>>>>         (file=3D 0) 2056192
>>>>         (file=3D 0) 2060288
>>>>         (file=3D 0) 2064384
>>>>         (file=3D 0) 2068480
>>>>         (file=3D 0) 2072576
>>>>         (file=3D 0) 2076672
>>>>         (file=3D 0) 2080768
>>>>         (file=3D 0) 2084864
>>>>         (file=3D 0) 2088960
>>>>         (file=3D 0) 2093056
>>>>
>>>> How do we interpret the above content to understand the locations of W=
rites.
>>>
>>> Perhaps fio tracks how far through the sequence it got rather than
>>> individual locations written (this would be necessary to handle things
>>> like loops=3D)? I personally don't know the answer to this but you can
>>> always take a look at the source code.
>>>
>>> --
>>> Sitsofe | http://sucs.org/~sits/
>
> --
> Sitsofe | http://sucs.org/~sits/
