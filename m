Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50563 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GRXtt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jul 2011 19:49:49 -0400
Received: by vxh35 with SMTP id 35so2017790vxh.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 16:49:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
	<CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
	<CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com>
	<CANWz5fi-=P5J=Op5o7-pr+3UMh+CLQMsnctem8hhOG2RnHuiLA@mail.gmail.com>
	<CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com>
Date: Mon, 18 Jul 2011 17:49:48 -0600
Message-ID: <CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Farina <daniel@heroku.com>
Cc: fio@vger.kernel.org

Could you add-in "--loops=3D10000"?

On Mon, Jul 18, 2011 at 5:28 PM, Daniel Farina <daniel@heroku.com> wrote:
> On Mon, Jul 18, 2011 at 4:11 PM, Chris Worley <worleys@gmail.com> wrote:
>> On Mon, Jul 18, 2011 at 3:46 PM, Daniel Farina <daniel@heroku.com> wrote:
>>> On Mon, Jul 18, 2011 at 12:35 PM, Chris Worley <worleys@gmail.com> wrot=
e:
>>>> Can we see your fio command? =EF=BF=BDI never use job files, and alway=
s use
>>>> timeouts successfully.
>>>
>>> Absolutely:
>>>
>>> # Doesn't terminate for "quite a while" (I wasn't willing to wait)
>>> time sudo fio --readonly --minimal --norandommap --timeout=3D5
>>> -name=3D/dev/sda1 --rw=3Drandread --size=3D1GB --direct=3D1
>>
>> Is that a single dash prior to "name"?
>
> Yes, although that could be due to some sort of oopsie on my part. =EF=BF=
=BDIt
> doesn't seem to matter (seen here with a small amount of data, hence
> timeout does not come into play):
>
> $ time sudo fio --readonly --minimal --norandommap --timeout=3D5
> -name=3D/dev/sda1 --rw=3Drandread --size=3D256k --direct=3D1
> --filename=3D/dev/sda1
> fio 1.55
> 2;/dev/sda1;0;0;256;529;495;0;0;0.000000;0.000000;366;14021;799.359375;17=
01.445859;367;14023;799.984375;1701.600223;0;0;0.000000%;0.000000;0.000000;=
0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0=
;0.000000%;0.000000;0.000000;2.024291%;0.000000%;76;0;30;100.0%;0.0%;0.0%;0=
.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;35.94%;57.81%;=
1.56%;1.56%;1.56%;0.00%;1.56%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.0=
0%
>
>
> real =EF=BF=BD =EF=BF=BD0m0.749s
> user =EF=BF=BD =EF=BF=BD0m0.030s
> sys =EF=BF=BD =EF=BF=BD 0m0.100s
>
> $ time sudo fio --readonly --minimal --norandommap --timeout=3D5
> --name=3D/dev/sda1 --rw=3Drandread --size=3D256k --direct=3D1
> --filename=3D/dev/sda1
> fio 1.55
> 2;/dev/sda1;0;0;256;655;400;0;0;0.000000;0.000000;407;568;435.375000;21.8=
59218;408;570;435.984375;21.941837;0;0;0.000000%;0.000000;0.000000;0;0;0;0;=
0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.00000=
0%;0.000000;0.000000;2.506266%;0.000000%;78;0;30;100.0%;0.0%;0.0%;0.0%;0.0%=
;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;98.44%;1.56%;0.00%;0.0=
0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
> real =EF=BF=BD =EF=BF=BD0m0.679s
> user =EF=BF=BD =EF=BF=BD0m0.010s
> sys =EF=BF=BD =EF=BF=BD 0m0.150s
>
>
> --
> fdr
>
