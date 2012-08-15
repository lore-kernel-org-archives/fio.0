Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:35155 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2HOHwN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Aug 2012 03:52:13 -0400
Message-ID: <502B5528.3000102@cran.org.uk>
Date: Wed, 15 Aug 2012 08:52:08 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: How to do strict synchronous i/o on Windows?
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com> <201208142232.41100.Martin@lichtvoll.de> <CAHaS=QzFqSB_eo1fWCw4ddQjFfuhuuQaiU2VsV-7XSzSkCfp8A@mail.gmail.com> <201208142324.48504.Martin@lichtvoll.de> <CAHaS=QxneG_nUx9GBsDL1dVJTLd2X7scO_vjxvDxEibB1NMrCw@mail.gmail.com>
In-Reply-To: <CAHaS=QxneG_nUx9GBsDL1dVJTLd2X7scO_vjxvDxEibB1NMrCw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, fio@vger.kernel.org

On 15/08/2012 03:46, Greg Sullivan wrote:
> Thanks - that runs, but it's still queuing. As I said before, I can't
> use the sync engine - I receive an error. Is there a synchronous
> engine available for Windows? Perhaps that's the only problem.
> Can you check to see whether your system is queuing at the file
> system/device level when you run that test?

The sync ioengine doesn't work on Windows. You should be able to get the 
same behaviour by using sync=1 and direct=1 with windowsaio.

-- 
Bruce Cran
