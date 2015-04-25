Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33037 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbbDYUf3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Apr 2015 16:35:29 -0400
Received: by igbpi8 with SMTP id pi8so47384391igb.0
        for <fio@vger.kernel.org>; Sat, 25 Apr 2015 13:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk>
References: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>
	<8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk>
Date: Sat, 25 Apr 2015 13:35:29 -0700
Message-ID: <CAHA74uqeP9ntkHVABfdDPxSZK4tTLbm486b9FJm2YjdJPv8XKA@mail.gmail.com>
Subject: Re: fio queue depth and windows build.
From: Iuliu Rus <iuliur@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

It doesn't create fio.exe for me. I commented that include out since
it doesn't look like it's needed, but then linker complains about mmap
munmap and sysconfig.


On Sat, Apr 25, 2015 at 12:46 PM, Bruce Cran <bruce@cran.org.uk> wrote:
> I've been meaning to investigate that build failure: it does, however get as far as creating the fio.exe binary so you can ignore the error.
>
> --
> Bruce
>
>> On Apr 25, 2015, at 12:04, Iuliu Rus <iuliur@google.com> wrote:
>>
>> Hello,
>> Looking at fio for windows, we are pretty sure that the queue depth
>> parameter is not working.
>> We wanted to investigate this ourselves and prepare a fix, but the
>> windows build is not working either. From a cygwin64 shell, make clean
>> and make -j results in this:
>> t/dedupe.c:13:23: fatal error: sys/ioctl.h: No such file or directory
>> (although i see ioctl.h under cygwin64\usr\include\sys and under
>> cygwin64\usr\i686-pc-cygwin\sys-root\usr\include\sys).
>> Any idea why the build fails?
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
