Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55298 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2HOXrf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Aug 2012 19:47:35 -0400
Received: by bkwj10 with SMTP id j10so719091bkw.19
        for <fio@vger.kernel.org>; Wed, 15 Aug 2012 16:47:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502BEEAF.8060708@cran.org.uk>
References: <CAHaS=Qz5Cvmj8692=8Z4G6Vsx0ByY2RSnGShN9Y=nXvVoLYy7Q@mail.gmail.com>
	<502BEEAF.8060708@cran.org.uk>
Date: Thu, 16 Aug 2012 09:47:33 +1000
Message-ID: <CAHaS=QwwfXPrwoYTtgq1z+KVs9qiK839J+8J4r7mfteE==3_3w@mail.gmail.com>
Subject: Re: "nanosleep is not implemented" messages (Win7)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 16 August 2012 04:47, Bruce Cran <bruce@cran.org.uk> wrote:
> On 15/08/2012 13:43, Greg Sullivan wrote:
>>
>> When I set a job rate (rate=<rate>), I'm receiving many "nanosleep is
>> not implemented" messages. Is this expected?
>
>
> I've uploaded a new build which fixes the problem to
> http://bluestop.org/fio/ .
>
> --
> Bruce Cran

Thanks Bruce, however it is not working at all for me. I receive the
following whenever I attempt to run fio:

C:\>fio test.ini
fio: this platform does not support process shared mutexes, forcing use of threa
ds. Use the 'thread' option to get rid of this warning.
read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=windowsaio, iodepth=1
fio-2.0.8-18-g525f
Starting 1 process
fio: job startup hung? exiting.
fio: 1 job failed to start

The INI file:
[global]
size=10M

[read]
rw=read

Downgrading to the previous version I had been running (2.0.8 X86)
fixes the problem.

Greg.
