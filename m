Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:40343 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725760AbeIQEtJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Sep 2018 00:49:09 -0400
Received: by mail-it0-f42.google.com with SMTP id h23-v6so8747880ita.5
        for <fio@vger.kernel.org>; Sun, 16 Sep 2018 16:24:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhGmEV=G21Vaw0rRgmLy4BFs2Yhqw4K5yNS2MXwGFvUtQ@mail.gmail.com>
References: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com>
 <CALjAwxhGmEV=G21Vaw0rRgmLy4BFs2Yhqw4K5yNS2MXwGFvUtQ@mail.gmail.com>
From: smitha sunder <sundersmitha@gmail.com>
Date: Sun, 16 Sep 2018 16:24:31 -0700
Message-ID: <CA+zhgFR1V4yKg+gf0QUcuZy47R=-CqyK+_jKVJS4WKDtRb77hQ@mail.gmail.com>
Subject: Re: No I/O performed by windowsaio/get_io_u: zero buflen
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Sun, Sep 16, 2018 at 3:02 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On Sat, 15 Sep 2018 at 23:14, smitha sunder <sundersmitha@gmail.com> wrot=
e:
>>
>> Hello all,
>>
>> I have a 30TB drive and I am running into an issue with random writes.
>> I went through this thread :
>> https://www.spinics.net/lists/fio/msg06294.html that seems to be fixed
>> already.
>
> I think that was something different regarding different blocksizes
> per direction.
>
>> I see the same issue with random reads as well.
>> So not sure what is the issue here in my case; any help is greatly appre=
ciated.
>>
>>
>> Read Capacity results:
>>    Protection: prot_en=3D1, p_type=3D1, p_i_exponent=3D0 [type 2 protect=
ion]
>>    Logical block provisioning: lbpme=3D1, lbprz=3D1
>>    Last logical block address=3D58781073407 (0xdaf9fffff), Number of
>> logical blocks=3D58781073408
>>    Logical block length=3D512 bytes
>>    Logical blocks per physical block exponent=3D3 [so physical block
>> length=3D4096 bytes]
>>    Lowest aligned logical block address=3D0
>> Hence:
>>    Device size: 30095909584896 bytes, 2.87017e+007 MiB, 30095.9 GB
>>
>>
>> C:\Program Files (x86)\fio>fio --ioengine=3Dwindowsaio --group_reporting
>> --direct=3D1 --size=3D100% --bs=3D4K --thread --filename=3D\\.\PhysicalD=
rive1
>> --name=3Dprecond --rw=3Drandwrite --iodepth=3D1 --numjobs=3D1
>> --debug=3Dio,random
>
> <snip>
>
>> io       3372  fill: io_u 0A458780:
>> off=3D0x144365e7d000,len=3D0x0,ddir=3D1,file=3D\\.\PhysicalDrive1
>> io       3372  get_io_u: zero buflen on 0A458780
>> io       3372  get_io_u failed
>> io       3372  drop page cache \\.\PhysicalDrive1
>> random   3372  off rand 17311067694306724737
>
> That offset is crazy big - I'm sure it's bigger than a petabyte so my
> guess is that something is overflowing. If you use --size=3D27g does the
> job go through?
>
> [...]
>
>> I don=E2=80=99t see this issue if I use bs=3D8K or I use ba=3D512,8K, et=
c.
>
> --
> Sitsofe | http://sucs.org/~sits/
Hi Sitsofe,

Thanks for the reply!

Yes; If I use --size=3D27G or if provide the exact size that the OS
displays, then the job goes through.

Thanks

