Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2KNSKf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 13:10:35 -0500
Message-ID: <50A3DE92.3020509@kernel.dk>
Date: Wed, 14 Nov 2012 11:10:26 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211132323.qADNNb1I29385361@zion.americas.sgi.com> <50A3D823.4050707@kernel.dk> <50A3DABD.3020807@kernel.dk>
In-Reply-To: <50A3DABD.3020807@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Scott Emery <emery@sgi.com>
Cc: fio@vger.kernel.org

On 2012-11-14 10:54, Jens Axboe wrote:
> On 2012-11-14 10:42, Jens Axboe wrote:
>>> 	For a while it was totting things up after four clients,
>>> which kind of made sense... now it's stuck on three.  Back when
>>> it made more sense I thought that maybe handle_ts only dealt with
>>> the information from a single thread for each client rather than
>>> the aggregate of multiple thread jobs.  That part seems to hold
>>> true even when it doesn't have the info for all the clients.
>>>
>>> 	Is this reporting the aggregate as expected?
>>> 	Is there a parameter change that I need to make to get
>>> the output I expect?
>>
>> As the job file is written, it will not aggregate results from a single
>> "instance" of the server. You would want group_reporting=1 to do that.
>> However, that will still give you one set of outputs per connection, not
>> one for all of them. Right now fio does not support collecting outputs
>> from all connections, a higher level group reporting if you will.
> 
> Actually, I misremembered that and didn't check before replying. It
> _will_ sum all clients, if it has more than one connection. But there's
> a bug where we race on client exit and dec the expected client count.
> Does it work better with the below patch?

Note that you still need group_reporting=1 in your job file, the all
clients report depend on getting only one set of stats from each client.
I'll look into fixing that up, too.

-- 
Jens Axboe

