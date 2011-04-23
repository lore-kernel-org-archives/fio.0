Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1DWJm1 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 23 Apr 2011 05:42:27 -0400
Received: by pzk9 with SMTP id 9so611030pzk.19
        for <fio@vger.kernel.org>; Sat, 23 Apr 2011 02:42:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com>
References: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com>
Date: Sat, 23 Apr 2011 11:42:26 +0200
Message-ID: <BANLkTimEzp135Me_SFbtYZBY00kD1SXrSQ@mail.gmail.com>
Subject: Re: [BUG] [PATCH] Undefined symbols: "_posix_memalign" on Mac OS X
From: Filip Sneppe <filip.sneppe@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Sat, Apr 23, 2011 at 5:57 AM, Filip Sneppe <filip.sneppe@gmail.com> wrot=
e:
> Hi,
>
> (I am not subscribed to this list, nor am I a Unix developer).
>
> I wanted to give fio a try on my OS X 10.5.8 machine, but
> this is the error I received when compiling:
>
> =EF=BF=BD =EF=BF=BDCC helpers.o
> =EF=BF=BD =EF=BF=BDCC engines/posixaio.o
> =EF=BF=BD =EF=BF=BDDEP depend
> =EF=BF=BD =EF=BF=BDCC fio
> Undefined symbols:
> =EF=BF=BD"_posix_memalign", referenced from:
> =EF=BF=BD =EF=BF=BD =EF=BF=BD_thread_main in fio.o
> ld: symbol(s) not found
> collect2: ld returned 1 exit status
> make: *** [fio] Error 1
>
> After some googling, I learned that OS X doesn't
> provide _posix_memalign, and that apparently it's not
> needed on this platform. I "fixed" my compile problem with the
> attached patch. You may find it useful to write a better fix for this.
>
For completeness I should say that this patch was wrong
(you can see I'm not a developer).

The function required:

*ptr =3D malloc(align * size);

for my workaround to work.

Best regards,
Filip
