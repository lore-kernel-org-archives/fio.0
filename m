Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:32805 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbcL0Uus (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Dec 2016 15:50:48 -0500
Received: by mail-ua0-f174.google.com with SMTP id i68so87835960uad.0
        for <fio@vger.kernel.org>; Tue, 27 Dec 2016 12:50:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBZO1Ntun9LH0_mXbStrG14Rpv6B11zGgr7gZCMH-XoB8w@mail.gmail.com>
References: <CALjAwxgdYU-QHdyRe3B=bgEU7-9zLjGs7ayOts_D-juAq_Uiig@mail.gmail.com>
 <CAKV1nBZO1Ntun9LH0_mXbStrG14Rpv6B11zGgr7gZCMH-XoB8w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Dec 2016 20:44:15 +0000
Message-ID: <CALjAwxh5G0wRmgM1OLUWs5fD32_7EcZ_0ppmSaLtqVVfMm8LUA@mail.gmail.com>
Subject: Re: Faster fio verification
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 December 2016 at 15:15, Saju Nair <saju.mad.nair@gmail.com> wrote:
> Hi,
> Thanks..
> We will certainly try with the other verify=3D<options> of crc32c etc.
> You mention ..
>>>"During a verifying read the data of the block read is kept in RAM and
> if needed (depends on the verification type) the data to compare
> against is regenerated."
>
> This is what we wanted to try and exploit..
> If we have a host RAM of say 64GB, then, we wanted to understand if we
> could break into "N" sets of say 16GB reads and verify. ie:
> Assuming that we need to verify say 160GB of data, we could do :
>
> fio --rw=3Dwrite
> for i =3D 0 to 10 {
>   fio --rw=3Dread --size=3D16g --verify=3Dpattern|crc32c
> --verify_pattern=3D<expected data>
> }
>
> Would that result in each of the FIO reads any faster ?
>
> Regards,
> - Saju.
>
>
> On Tue, Dec 27, 2016 at 5:17 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrot=
e:
>> Hi,
>>
>> On 27 December 2016 at 04:33, Saju Nair <saju.mad.nair@gmail.com> wrote:
>>>
>>> > Re verification speed: When you say the speed is one tenth that of
>>> > regular reads are the "regular" reads also using numjobs=3D1? If not =
the
>>> > comparison isn't fair and you need to rerun it with numjobs=3D1
>>> > everywhere and tell us what the difference was for those runs.
>>>
>>> Yes, it was with num_jobs =3D 1 in both cases of "regular read" and "re=
ad-verify". I think it is understandable that there is a performance drop, =
since the compare/verify is done on-the-fly.. Where does FIO store the data=
 read, before the verify step is executed.
>>
>> During a verifying read the data of the block read is kept in RAM and
>> if needed (depends on the verification type) the data to compare
>> against is regenerated. Because of this very little or no data needs
>> to be stored during the write phase.
>>
>> One option to try and speed verification up (assuming you have the
>> spare CPUs) could be to use verify_async (see the HOWTO). Another
>> option could be to use faster verification comparisons (see verify=3Dstr
>> of the HOWTO). For example the verify=3Dcrc32c checksum calculation will
>> be hardware accelerated on recent x86 machines. Do either of these
>> make a difference?
>>
>> --
>> Sitsofe | http://sucs.org/~sits/



--=20
Sitsofe | http://sucs.org/~sits/
