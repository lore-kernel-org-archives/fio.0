Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48299 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1EEEjM convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 5 May 2011 00:39:12 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so1932906wwa.1
        for <fio@vger.kernel.org>; Wed, 04 May 2011 21:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinaacqHwb+UfoBbhC2V4EO9z6ZTpg@mail.gmail.com>
References: <BANLkTinaacqHwb+UfoBbhC2V4EO9z6ZTpg@mail.gmail.com>
Date: Wed, 4 May 2011 22:39:11 -0600
Message-ID: <BANLkTinVT0yeg36ONDvckhm2N0DtWqFUog@mail.gmail.com>
Subject: Re: fio accessing boot drive
From: Josh Aune <luken@omner.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wednesday, May 4, 2011, Vikram Seth <seth.vik@gmail.com> wrote:
> Hi,
>
> I started using fio recently for raw disk performance testing.
> I noticed at times that while I am running the attached test file on
> /dev/sdb, which is a raid 6 volume, there is lot of activity on the
> boot disk /dev/sda too.

Check for files in /tmp. To not generate them, disable the random map.

Josh

>
> Here's excerpt from iostat output :
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD =EF=BF=BD r/s =EF=BF=BD =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =
=EF=BF=BD =EF=BF=BDwMB/s
> avgrq-sz avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sda =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD7300.20 =EF=BF=BD =EF=BF=BD0.00 =EF=BF=BD 73.60 =EF=BF=BD =
=EF=BF=BD 0.00 =EF=BF=BD =EF=BF=BD27.16
> 755.76 =EF=BF=BD 143.93 1950.19 =EF=BF=BD13.59 100.02
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD =EF=BF=BD0.00 =EF=BF=BD210.00 =EF=
=BF=BD =EF=BF=BD 0.00 =EF=BF=BD =EF=BF=BD 0.82
> 8.00 =EF=BF=BD =EF=BF=BD10.41 =EF=BF=BD 49.34 =EF=BF=BD 4.76 100.02
>
> I'll appreciate any insight into what can be causing these kind of
> accesses on the boot drive?
> Can these accesses affect overall performance results on the actual test =
drive?
>
> Thanks,
> Vikram.
>
> PS: I am using fio version 1.50
>
