Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:52257 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbBDJSB convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 4 Feb 2015 04:18:01 -0500
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Bug#776701: ssd-test 1g file size too small
Date: Wed, 4 Feb 2015 10:10:38 +0100
Message-ID: <13200420.bigzCatb1k@merkaba>
In-Reply-To: <54CCD756.7000105@pocock.pro>
References: <54CCD756.7000105@pocock.pro>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Pocock <daniel@pocock.pro>, 776701@bugs.debian.org, fio@vger.kernel.org

﻿Hello Daniel, hi Jens,

Am Samstag, 31. Januar 2015, 14:23:34 schrieb Daniel Pocock:
> Package: fio
> Version: 2.1.11-2
> Severity: important
> 
> 
> In the ssd-test sample config:
> 
> https://sources.debian.net/src/fio/2.1.11-2/examples/ssd-test.fio/
> 
> 
> The test size is 1GB, this line:
> 
> size=1g
> 
> 
> There are SSDs that have 1g caches and this leads to unhelpful results.
> 
> One user I discussed this with had to use a 10g test file to get
> consistent and meaningful results.
> 
> Maybe bump the example to 10g or add a comment in front of that line.

As the examples are taken from the upstream tarball, I suggest taking this 
upstream. I put upstream in Cc, Jens, what do you think about this?

In any case, I don´t think its a release critical issue for Jessie. And I 
would like to avoid carrying a patch for this.

Also for SSD testing have a look at the (destructive, whole device) steady 
state test and

https://www.thomas-krenn.com/de/wiki/TKperf

I view the ssd-test.fio as a simple example that may serve to give a *first* 
idea, but is in no way complete in any way. Yes, it may be good to point 
this out in the comment that this is just a starting point.

And yes, its always good to check results for meaningfulness. No comment 
or warranty clause in an example file is going to cover for that. No 
benchmark can provide such a warranty for all cases. There are just too 
many factors at play.


Upstream version of fio is 2.1.14. I may look into packaging it, after I 
recovered from my recent disappointments with how listmasters in Debian 
handled discussions about systemd within Debian[1]. Feel free to be faster 
than me as, honestly, my motivation isn´t that high at the moment. I did 
not yet want to orphan the package in order to give it some time and pick 
it up again, but if you want, feel free to take over maintenance to speed 
things. Or as its on collab-maint anyway, just feel free to work on it. I 
think in some months, after Jessie release, I may look into my packagings 
again (while staying unsubscribed from certain mailing lists), as it used 
to be fun working on it.

I think what I have in the repo is current.

No need to discuss any of this in this bug report, this is just for your 
information.


[1] https://lists.debian.org/debian-devel/2014/12/msg00000.html (I still 
didn´t even look at any possible responses to what I wrote and I do not 
intend to do so.)

Thanks,
Martin

-- 
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller


***Nicht verpassen: TechDemo Hochverfügbare Storage-Infrastruktur***
Nürnberg 25.02.15 | München 26.02.15 | Jetzt anmelden unter: www.teamix.de/techdemo

