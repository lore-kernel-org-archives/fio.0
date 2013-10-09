Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43759 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3JIPfD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Oct 2013 11:35:03 -0400
Message-ID: <52557767.1040101@kernel.dk>
Date: Wed, 09 Oct 2013 09:33:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: new fio release?
References: <1416283628.111018.1380009575092.JavaMail.zimbra@teamix.de> <5241A4AF.7030504@kernel.dk> <1475150.01GODAz1Il@merkaba>
In-Reply-To: <1475150.01GODAz1Il@merkaba>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org, =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>

On 10/09/2013 05:02 AM, Martin Steigerwald wrote:
> Hi Jens, Georg, everyone,
> 
> Am Dienstag, 24. September 2013, 08:41:51 schrieb Jens Axboe:
>> On 09/24/2013 01:59 AM, Martin Steigerwald wrote:
>>> Hi Jens!
>>>
>>> Georg is currently packaging fio 2.1.2 for Ubuntu Precise, while I did
>>> 2.1.1 for Debian a while ago.
>>>
>>> I already started packaging 2.1.2 for Debian as well and I think I was
>>> almost finished with it but I had:
>>>
>>> ms@mango:~/lokal/Debian/fio> lintian -IE fio_2.1.2-1_amd64.changes
>>> W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
>>> W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
>>> W: fio: binary-without-manpage usr/bin/genfio
>>>
>>> which as I looked are all fixed upstream already.
>>>
>>> Since it is difficult to rename a upstream file in debian packaging
>>> without repacking upstream tarball, I'd rather build next package from a
>>> fio release with these issues fixed.
>>>
>>>
>>> Can you do a fio 2.1.3 release?
>>
>> Yeah, it's about that time anyway, and the short list of changes between
>> 2.1.2 to now seems to indicate a decent point to do a new release.
> 
> I made a 2.1.3 fio package last week. Sven Hoexter already reviewed and 
> uploaded it, so it is available in Debian Unstable.
> 
> I will consider a backport once this one enters testing.

Just a headsup that 2.1.4 will be coming in the not-so-distant future.
2.1.2/3 is broken on Windows, would like to get that fixed up and cut a
new release.

-- 
Jens Axboe

