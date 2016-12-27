Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36578 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbcL0EdH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Dec 2016 23:33:07 -0500
Received: by mail-qk0-f170.google.com with SMTP id n21so205756223qka.3
        for <fio@vger.kernel.org>; Mon, 26 Dec 2016 20:33:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxh8Pkgwi2jMUubZCJu-N-7+u8MDFyZw93Uzw28MK2Gz0A@mail.gmail.com>
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
 <CAKV1nBZfDgy_+4nAOYXni0m=Q0WUNrn-_q9J_+XuwWRZR03Enw@mail.gmail.com>
 <CALjAwxhDo2p=LFG-r6ZcGbiEk26sZgO8BAnVCrUFXRDVQ9DTkw@mail.gmail.com>
 <CAKV1nBaVHBaFXaKoKVD2Xbqfsejrn7y7ufWGx=rPcd=ekVgKKQ@mail.gmail.com> <CALjAwxh8Pkgwi2jMUubZCJu-N-7+u8MDFyZw93Uzw28MK2Gz0A@mail.gmail.com>
From: Saju Nair <saju.mad.nair@gmail.com>
Date: Tue, 27 Dec 2016 10:03:06 +0530
Message-ID: <CAKV1nBaMT803yqRYeTJka55KehLxxvr-=9h3Af0pXG6-PZSeJA@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi ,Hi,

I'm glad to hear you got to the bottom of things - were you able to
get dd to return the same data as fio in the end and if so how (it
might help others)? What was the change that solved your HW issue
(again it might help someone else in the future)?
>> The problem was in the LBA -> physical address mapping in our Hardware D=
UT, - it was a functional bug in the specific controller software.. On the =
"dd" correlation - it was not 100%, because this bug was not consistent in =
the mapping. Very specific to the DUT.

Re verification speed: When you say the speed is one tenth that of
regular reads are the "regular" reads also using numjobs=3D1? If not the
comparison isn't fair and you need to rerun it with numjobs=3D1
everywhere and tell us what the difference was for those runs.
>>Yes, it was with num_jobs =3D 1 in both cases of "regular read" and "read=
-verify". I think it is understandable that there is a performance drop, si=
nce the compare/verify is done on-the-fly.. Where does FIO store the data r=
ead, before the verify step is executed.

Re store data to RAM: as stated in previous emails fio isn't a bulk
data copying/moving tool so you would have to write new code to make
it act as such.
>>Thanks, understood.

On Mon, Dec 26, 2016 at 7:55 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> (Resenting because Google's mobile web client forces HTML mail)
>
> Hi,
>
> I'm glad to hear you got to the bottom of things - were you able to get d=
d
> to return the same data as fio in the end and if so how (it might help
> others)? What was the change that solved your HW issue (again it might he=
lp
> someone else in the future)?
>
> Re verification speed: When you say the speed is one tenth that of regula=
r
> reads are the "regular" reads also using numjobs=3D1? If not the comparis=
on
> isn't fair and you need to rerun it with numjobs=3D1 everywhere and tell =
us
> what the difference was for those runs.
>
> Re store data to RAM: as stated in previous emails fio isn't a bulk data
> copying/moving tool so you would have to write new code to make it act as
> such.
>
> On 26 December 2016 at 05:30, Saju Nair <saju.mad.nair@gmail.com> wrote:
>> Thanks.
>> Apologies for the delay - Based on  the FIO debug messages, we figured
>> out that there was an underlying issue in the drive HW, and eventually
>> figured out the problem and fixed it.
>> FIO based data integrity works fine for us now, although at lower
>> performance.
>> The read-verify step runs at about 1/10-th of the normal "read"
>> performance.
>>
>> Note that we keep "numjobs=3D1" - in order to not create any
>> complications due to this, in the verify stage.
>>
>> I am not sure if this is possible, but, can FIO store the data read
>> into the RAM of the host machine ?
>> If so, one solution we are exploring is to break our existing
>> read-verify step to :
>>
>> break into N smaller # FIO accesses, and foreach of N
>>    FIO reads - to RAM of host machine
>>    special program to mem-compare against expected data.
>>
>>
>>
>> Regards,
>> - Saju.
>
> --
> Sitsofe | http://sucs.org/~sits/
