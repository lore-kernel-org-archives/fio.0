Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:56459 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbDYT4Y convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 25 Apr 2015 15:56:24 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: fio queue depth and windows build.
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>
Date: Sat, 25 Apr 2015 13:46:21 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk>
References: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Iuliu Rus <iuliur@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I've been meaning to investigate that build failure: it does, however get as far as creating the fio.exe binary so you can ignore the error.

-- 
Bruce

> On Apr 25, 2015, at 12:04, Iuliu Rus <iuliur@google.com> wrote:
> 
> Hello,
> Looking at fio for windows, we are pretty sure that the queue depth
> parameter is not working.
> We wanted to investigate this ourselves and prepare a fix, but the
> windows build is not working either. From a cygwin64 shell, make clean
> and make -j results in this:
> t/dedupe.c:13:23: fatal error: sys/ioctl.h: No such file or directory
> (although i see ioctl.h under cygwin64\usr\include\sys and under
> cygwin64\usr\i686-pc-cygwin\sys-root\usr\include\sys).
> Any idea why the build fails?
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
