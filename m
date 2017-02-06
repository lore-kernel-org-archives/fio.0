Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:51704 "EHLO
        mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdBFKdo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2017 05:33:44 -0500
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: Re: Removing *.py ending from python script filenames
Date: Mon, 6 Feb 2017 11:33:38 +0100
Message-ID: <1981963.mbOk0xVDbe@merkaba>
In-Reply-To: <8697CBF0E1940C48BC792ECE899B66420D15907E@ULS-OP-MBXIP05.sdcorp.global.sandisk.com>
References: <2172844.j6hkAc7SIx@merkaba> <8697CBF0E1940C48BC792ECE899B66420D15907E@ULS-OP-MBXIP05.sdcorp.global.sandisk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent Fu <Vincent.Fu@sandisk.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Ben England <bengland@redhat.com>, Karl Cronburg <karl.cronburg@gmail.com>, Jens Axboe <axboe@kernel.dk>, Sven Hoexter <hoexter@debian.org>

﻿Am Montag, 23. Januar 2017, 14:47:31 CET schrieb Vincent Fu:
> On 2017-1-23 7:17 AM, Martin Steigerwald wrote:
> > Hello Vincent, Mark, Ben, Karl, Jens,
> > 
> > I just prepared packaging for fio-2.17 and as I added some of the new
> > Python script I again came across the issues the file name ending "*.py"
> > creates within Debian.
> > 
> > ...
> 
> Martin, my ultimate intention is to provide a fio patch to eliminate the
> need for fio_latency2csv.py.

Okay, thank you.

Well for Debian Stretch I will settle with fio 2.16, so there is time… I may 
keep the current solution as is – i.e. stuffing it all into /usr/share/doc/fio –
especially as you plan to implement the script functionality into fio.

Thanks,

-- 
Martin Steigerwald  | Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller, Jakob Høholdt

teamix Support Hotline: +49 911 30999-112
 
 *** Bitte liken Sie uns auf Facebook: facebook.com/teamix ***

