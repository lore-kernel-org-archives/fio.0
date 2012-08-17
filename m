Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HQG0S (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 02:26:18 -0400
Message-ID: <502DE3E3.2050901@kernel.dk>
Date: Fri, 17 Aug 2012 08:25:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Suggestion: Add ramp-up for rate testing.
References: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
In-Reply-To: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 08/16/2012 05:24 PM, Greg Sullivan wrote:
> I suggest adding a ramp-up time parameter that can be used to prevent
> the rate testing from occurring until the ramp-up time has passed.
> This will more accurately model the throughput capacity of streaming
> systems that have a pre-load buffer to ride over the initial cache
> warm-up period.

There's already a ramp time setting, and the rate will not be checked
before that has passed. Not sure what extra setting you would like? A
ramp time, and then a rate ramp time after that?

-- 
Jens Axboe

