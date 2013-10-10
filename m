Return-Path: <gschoenberger@thomas-krenn.com>
Date: Thu, 10 Oct 2013 07:23:42 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Message-ID: <1375438822.629.1381382622441.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1475150.01GODAz1Il@merkaba>
Subject: Re: new fio release?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Martin and Fio Users,

> > > Georg is currently packaging fio 2.1.2 for Ubuntu Precise, while
> > > I did
> > > 2.1.1 for Debian a while ago.
> > > 
> > > I already started packaging 2.1.2 for Debian as well and I think
> > > I was
> > > almost finished with it but I had:
> > > 
> > > ms@mango:~/lokal/Debian/fio> lintian -IE
> > > fio_2.1.2-1_amd64.changes
> > > W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
> > > W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
> > > W: fio: binary-without-manpage usr/bin/genfio
> > > 
> > > which as I looked are all fixed upstream already.
> > > 
> > > Since it is difficult to rename a upstream file in debian
> > > packaging
> > > without repacking upstream tarball, I'd rather build next package
> > > from a
> > > fio release with these issues fixed.
> > > 
> > > 
> > > Can you do a fio 2.1.3 release?
> > 
> > Yeah, it's about that time anyway, and the short list of changes
> > between
> > 2.1.2 to now seems to indicate a decent point to do a new release.
> 
> I made a 2.1.3 fio package last week. Sven Hoexter already reviewed
> and
> uploaded it, so it is available in Debian Unstable.
> 
> I will consider a backport once this one enters testing.
> 
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> 

Do I have to consider special conditions if I rebuild Fio 2.1.3 and later on 2.1.4 under Ubuntu Precise?

Thanks, Georg

