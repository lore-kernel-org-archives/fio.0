Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2EHGvL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 May 2012 02:51:11 -0400
Message-ID: <4FA8C238.2020408@kernel.dk>
Date: Tue, 08 May 2012 08:50:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Creating random/sequential mix
References: <8C39003C166535489D52AF2C9D8C58BC1A32FFED@NTXBOIMBX04.micron.com>
In-Reply-To: <8C39003C166535489D52AF2C9D8C58BC1A32FFED@NTXBOIMBX04.micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Bill Hooper (whooper)" <whooper@micron.com>
Cc: fio <fio@vger.kernel.org>

On 05/03/2012 08:26 PM, Bill Hooper (whooper) wrote:
> I have a request to collect data with a 75%/25% random/sequential mix.
> I am having a difficult time figuring out how to get fio to do this.
> Any suggestions would be appreciated.

That's a good question. There's really no easy way to do that. For
random IO, you can do a number of sequential blocks for each random
offset generated. But that doesn't give you very fine control of the
percentages. For sequential IO, you can skip X bytes for every
sequential block read/written. That's really the flexibility that fio
has now.

Outside of that, you could perhaps use the flow option to have two
synchronized jobs with the given weights. But that would throttle one of
them, so not ideal if you just want a 75/25 random/sequential running at
full speed.

I don't think your situation is unique, it would be nice to be able to
support a mixed workload like that. One thing I've wanted before (but
never implemented) is somewhat related - the option to specify the size
of the hot part of the data set. For instance, operate on the full
device, but consider region X or size X the hot part which we'll read
repeatedly. Would be useful for testing caching.

Let me think about how we can best do what you want, and I'll get back
to you.

-- 
Jens Axboe

