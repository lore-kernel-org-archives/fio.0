Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36119 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2HNRgf convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 14 Aug 2012 13:36:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to do strict synchronous i/o on Windows?
Date: Tue, 14 Aug 2012 19:36:34 +0200
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com> <502A4D22.3090200@kernel.dk> <CAHaS=Qz9b2UzcUegFBbFzdiy0j48JJ-DP_oFMqAWYhjYP3BQiA@mail.gmail.com> (sfid-20120814_181754_704406_36867A5F)
In-Reply-To: <CAHaS=Qz9b2UzcUegFBbFzdiy0j48JJ-DP_oFMqAWYhjYP3BQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201208141936.34301.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>, fio@vger.kernel.org

Hi Greg,=20

Please quote (http://learn.to/quote click "English")

Am Dienstag, 14. August 2012 schrieb Greg Sullivan:

> On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> >
> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> > > I need to simulate strict synchronous, round robin i/o to a group of
> > > files. I am on Windows 7 32-bit.
> > > fio is very nearly working, except that even with a queue depth of 1,
> > > it is still resulting in a disk queue that is > 1, because the
> > > "iodepth" parameter is not global - it is per thread. (correct?)
> > >
> > > I've tried using the "sync" engine, however that doesn't work at all -
> > > just spews out errors.
> >
> > That'll be the case for ANY platform and IO engine. If you have more
> > than 1 thread or process going, you can have > 1 depth at the device
> > side. The definition of a sync IO call is that the call doesn't return
> > until the IO is done. If you have overlapped calls due to more than 1
> > thread, then that is no longer true.
> >
> > What you are looking for is outside the scope of an application. You
> > would have to limit the queue depth on the operating system side to
> > achieve that. Or artificially limit fio in some way, which would not
> > make a lot of sense imho.

> Thanks Jens. I do in fact have an application that reads in exactly the
> manner I described. I have monitored the queue depth - it does not rise
> above 1.  It is a real time musical sample streamer.
>=20
> Please consider this a new feature request for fio - thankyou.

Is this application multithreaded? If so, are mutiple threads doing I/O
at the same time? If not I=EF=BF=BDd suggest just testing with one job.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
