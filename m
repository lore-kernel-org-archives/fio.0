Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:58873
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab1JNNKx (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Oct 2011 09:10:53 -0400
Message-ID: <4E9834DC.9000200@kernel.dk>
Date: Fri, 14 Oct 2011 15:10:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: new developments
References: <4E8967BC.3050404@kernel.dk> <201110051415.42260.ms@teamix.de> <4E8C4BE3.10601@kernel.dk>
In-Reply-To: <4E8C4BE3.10601@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 2011-10-05 14:21, Jens Axboe wrote:
>>> One thing that I think would be very cool is a gtk2 frontend.
>>> Something that allows you to simply click and select options
>>> and then run the job, with graphical representation of the
>>> ETA and final output.
>>>
>>> If you have gtk development experience, or simply the desire
>>> to start this project for fio, then please do get in touch.
>>> Otherwise I'll start this myself, once I'm done with the
>>> basic frontend/backend funtionality.
>>
>> And/Or Qt ;)
> 
> For sure, or Qt. I think it'd be really cool for various reasons, some
> people find it a lot easier to visually see all the options and drop
> down menus as opposed to a CLI tool. Also great for demo purposes. Like
> iometer - it's a crap tool, but the spedometer thing really works for
> demo/show purposes.

Looking over the available options, pygtk looks like the best
alternative. It's a local application, should run on Linux/Win/OSX and
the BSDs too.

-- 
Jens Axboe

