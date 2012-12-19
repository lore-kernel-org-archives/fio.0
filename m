Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60176
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab2LSHAl (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 19 Dec 2012 02:00:41 -0500
Message-ID: <50D16616.20805@kernel.dk>
Date: Wed, 19 Dec 2012 08:00:38 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Latency spikes with 'thread' option
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com> <50C9D5CA.9000904@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com> <50D01990.7080102@kernel.dk> <50D02951.4030608@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A930031FB7@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A930031FB7@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Mike Berhan (mberhan)" <mberhan@micron.com>

On 2012-12-18 22:16, Sam Bradshaw (sbradshaw) wrote:
> 
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Tuesday, December 18, 2012 12:29 AM
>> To: Sam Bradshaw (sbradshaw)
>> Cc: fio@vger.kernel.org; Mike Berhan (mberhan)
>> Subject: Re: Latency spikes with 'thread' option
>>
>> On 2012-12-18 08:21, Jens Axboe wrote:
>>> Good analysis and I believe you are correct. It's not safely shared and
>>> should be thread local. A quick test here with the below seems to
>>> indicate that that is indeed the issue, I don't see any time weirdness
>>> with that applied.
>>
>> Bah, so that didn't work on all the supported platforms (notably OSX
>> does not have support for __thread). I've committed a patch that should
>> work across platforms, please give the current fio git a try (5d879392
>> or newer).
> 
> Works great.  No abnormal latency spikes, nor do our measurements of peak
> IOPs differ from prior releases.

Good!

> One tidbit though: fio_gettime() shows a much larger % of execution time
> with the default clocksource than the gettimeofday() clocksource.  In a
> 512b random read workload with gtod_reduce disabled, for example, up to 15% 
> of the userspace execution time was spent in fio_gettime() with the default
> clocksource vs. 5% with gettimeofday().  The latency is mostly incurred
> at the divisions that convert nsecs? to secs for populating the timeval
> struct.  I don't have a suggestion to replace the
> 
> usecs = t / cycles_per_usec 
> 
> division but the 
> 
> tp->tv_sec = usecs / 1000000
> 
> could be reduced by instead comparing "t" to "tv->last_cycles" to see if
> they differ by more than 1000000.  If so, do the division and capture
> secs in tv->tv_sec.  If not, just copy the last recorded tv->tv_sec into
> tp->tv_sec.  That way, the division in only incurred every second at a 
> minimum.

That would work, though I'm surprised the two divisions are that costly
for fixed point math. It would be a branch more, but since it'd hit most
of the time, should be easy enough for the branch predictor.

There's also the option of disabling some of the time keeping. Are you
interested only in completion latency? Then you could disable submission
latency measuring. That would reduce the time calls per IOP by 25%.

> I could put together a patch if you like; I just have limited ability
> to test the change on the multitude of platforms supported by fio.

For this particular case, the risk of platform breakage is small. So go
for it!

-- 
Jens Axboe

