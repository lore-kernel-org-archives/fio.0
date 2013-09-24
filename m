Return-Path: <ms@teamix.de>
Date: Tue, 24 Sep 2013 09:59:35 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Message-ID: <1416283628.111018.1380009575092.JavaMail.zimbra@teamix.de>
In-Reply-To: <500349838.110961.1380009378087.JavaMail.zimbra@teamix.de>
Subject: new fio release?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
List-ID: <fio@vger.kernel.org>

Hi Jens!

Georg is currently packaging fio 2.1.2 for Ubuntu Precise, while I did 2.1.1 for Debian a while ago.

I already started packaging 2.1.2 for Debian as well and I think I was almost finished with it but I had:

ms@mango:~/lokal/Debian/fio> lintian -IE fio_2.1.2-1_amd64.changes
W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
W: fio: binary-without-manpage usr/bin/genfio

which as I looked are all fixed upstream already.

Since it is difficult to rename a upstream file in debian packaging without repacking upstream tarball, I'd rather build next package from a fio release with these issues fixed.


Can you do a fio 2.1.3 release?

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

