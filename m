Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3HEO7h (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 5 Aug 2013 10:59:37 -0400
Message-ID: <51FFBDAC.9090505@kernel.dk>
Date: Mon, 05 Aug 2013 08:58:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Make test for gnuplot work with empty strings.
References: <201303111622.57044.ms@teamix.de> <20130312121629.GO25165@kernel.dk> <232124889.843394.1375713642725.JavaMail.zimbra@teamix.de>
In-Reply-To: <232124889.843394.1375713642725.JavaMail.zimbra@teamix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, 700580@bugs.debian.org

On 08/05/2013 08:40 AM, Martin Steigerwald wrote:
> ----- Ursprüngliche Mail -----
>> On Mon, Mar 11 2013, Martin Steigerwald wrote:
>>> When I launch fio_generate_plots on a system where gnuplot is not installed
>>> I
>>> get this error :
>>>
>>> $ fio_generate_plots test
>>> Making bw logs
>>> /usr/bin/fio_generate_plots: 42: /usr/bin/fio_generate_plots: -: not found
>>>
>>> That's because the test checking whether gnuplot is installed is failing
>>> because of an empty variable :
>>> GNUPLOT=$(which gnuplot)
>>> if [ ! -x $GNUPLOT ]; then
>>>         echo You need gnuplot installed to generate graphs
>>>         exit 1
>>> fi
>>>
>>> Indeed the command "test -x" is exiting with code 0.
>>>
>>> To correct this we should enclose the variable with quotes :
>>> if [ ! -x "$GNUPLOT" ]; then
>>>
>>> Then the script is going into the test properly :
>>> $ fio_generate_plots test
>>> You need gnuplot installed to generate graphs
>>>
>>> I copied problem description by Hervé from the Debian bug report below.
>>>
>>> Fixes:
>>> Bug#700580: /usr/bin/fio_generate_plots: -: not found
>>> http://bugs.debian.org/700580
>>>
>>> Reported-By: Hervé Werner <hwerner@score-md.com>
>>> Tested-By: Hervé Werner <hwerner@score-md.com>
>>> Tested-By: Martin Steigerwald <ms@teamix.de>
>>> ---
>>>  fio_generate_plots |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fio_generate_plots b/fio_generate_plots
>>> index 4285415..5e2febd 100755
>>> --- a/fio_generate_plots
>>> +++ b/fio_generate_plots
>>> @@ -8,7 +8,7 @@ if [ "$1"x = "x" ]; then
>>>  fi
>>>  
>>>  GNUPLOT=$(which gnuplot)
>>> -if [ ! -x $GNUPLOT ]; then
>>> +if [ ! -x "$GNUPLOT" ]; then
>>>  	echo You need gnuplot installed to generate graphs
>>>  	exit 1
>>>  fi
>>
>> Thanks, obviously correct :-)
> 
> Still it doesn't seem you applied it as of
> 
> 428b4f6ba681dbb40c8e2213d0c6ae8f8049dcd5ESC
> 
> of git://git.kernel.dk/fio.git
> 
> Fixing locally in Debian package now.

Weird, I must have done it on the old workstation (that is still in
transit) and forgot to push it out. Rectified now!

-- 
Jens Axboe

