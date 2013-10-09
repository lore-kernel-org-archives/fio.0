Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: new fio release?
Date: Wed, 09 Oct 2013 13:02:30 +0200
Message-ID: <1475150.01GODAz1Il@merkaba>
In-Reply-To: <5241A4AF.7030504@kernel.dk>
References: <1416283628.111018.1380009575092.JavaMail.zimbra@teamix.de> <5241A4AF.7030504@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Georg =?ISO-8859-1?Q?Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
List-ID: <fio@vger.kernel.org>

Hi Jens, Georg, everyone,

Am Dienstag, 24. September 2013, 08:41:51 schrieb Jens Axboe:
> On 09/24/2013 01:59 AM, Martin Steigerwald wrote:
> > Hi Jens!
> > 
> > Georg is currently packaging fio 2.1.2 for Ubuntu Precise, while I did
> > 2.1.1 for Debian a while ago.
> > 
> > I already started packaging 2.1.2 for Debian as well and I think I was
> > almost finished with it but I had:
> > 
> > ms@mango:~/lokal/Debian/fio> lintian -IE fio_2.1.2-1_amd64.changes
> > W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
> > W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
> > W: fio: binary-without-manpage usr/bin/genfio
> > 
> > which as I looked are all fixed upstream already.
> > 
> > Since it is difficult to rename a upstream file in debian packaging
> > without repacking upstream tarball, I'd rather build next package from a
> > fio release with these issues fixed.
> > 
> > 
> > Can you do a fio 2.1.3 release?
> 
> Yeah, it's about that time anyway, and the short list of changes between
> 2.1.2 to now seems to indicate a decent point to do a new release.

I made a 2.1.3 fio package last week. Sven Hoexter already reviewed and 
uploaded it, so it is available in Debian Unstable.

I will consider a backport once this one enters testing.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

