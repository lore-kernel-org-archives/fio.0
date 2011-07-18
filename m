Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63920 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1GRVqj convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jul 2011 17:46:39 -0400
Received: by gxk21 with SMTP id 21so1509505gxk.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 14:46:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
 <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
From: Daniel Farina <daniel@heroku.com>
Date: Mon, 18 Jul 2011 14:46:19 -0700
Message-ID: <CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Jul 18, 2011 at 12:35 PM, Chris Worley <worleys@gmail.com> wrote:
> Can we see your fio command? =EF=BF=BDI never use job files, and always u=
se
> timeouts successfully.

Absolutely:

# Doesn't terminate for "quite a while" (I wasn't willing to wait)
time sudo fio --readonly --minimal --norandommap --timeout=3D5
-name=3D/dev/sda1 --rw=3Drandread --size=3D1GB --direct=3D1
--filename=3D/dev/sda1

With a jobfile called jobs.fio:

[/dev/sda1]
rw=3Drandread
size=3D1GB
filename=3D/dev/sda1
direct=3D1

Everything is great:

time sudo fio --readonly --minimal --norandommap --timeout=3D5 jobs.fio
fio 1.55
2;/dev/sda1;0;0;41820;8563;5001;0;0;0.000000;0.000000;322;90574;460.528551;=
1378.863841;322;90575;461.305308;1378.867201;6880;9232;101.283584%;8469.333=
333;915.606903;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.0000=
00;0.000000;0;0;0.000000%;0.000000;0.000000;4.000000%;0.000000%;10467;0;35;=
100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.=
00%;95.88%;3.25%;0.60%;0.17%;0.05%;0.02%;0.00%;0.00%;0.03%;0.00%;0.00%;0.00=
%;0.00%;0.00%;0.00%


real	0m5.288s
user	0m0.200s
sys	0m0.150s


--=20
fdr
