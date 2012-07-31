Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2GaSug (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 14:50:36 -0400
Message-ID: <501828F9.2060100@kernel.dk>
Date: Tue, 31 Jul 2012 20:50:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Client - Server(s?)
References: <201207021912.q62JCqDV26291886@zion.americas.sgi.com>
In-Reply-To: <201207021912.q62JCqDV26291886@zion.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Scott Emery <emery@sgi.com>
Cc: fio@vger.kernel.org

On 2012-07-02 21:12, Scott Emery wrote:
> Hullo Jens,
> 	I have enjoyed using fio, I find it to be easy to set up and
> run. 

Thanks!

> 	I have a question about the direction of client/server, which
> revolves around a situation I would like to benchmark.  I deal with
> a couple of clustered filesystems and would like to get aggregate
> performance values based on I/O from multiple filesystem clients.
> To that end I would like to drive a test from a single "location" to
> multiple filesystem clients. 
> 
> 	My understanding (?) of fio client/server semantics is that
> one client drives no more than one server.  With this understanding
> I would set up a fio server on each filesystem client that I want  to
> test and then run fio clients from my test location in parallel to
> each fio server/filesystem client.  I would then aggregate the
> statistics by hand.   This is certainly a huge step up from scripting
> something myself by hand. 
> 
> 	It would be convenient if I could have one client/set of clients
> work together to drive the fio servers and aggregate the statistics
> for me.  Is this where fio is going?

Yes, this is where fio is going, and in fact that should already work.
One fio client can drive multiple servers, you just give it the
hostnames. There's some non-intuitive ways around how it sends the same
config file and not one per server, but that's mainly parsing stuff.
It doesn't have anything to do with how fio functions, so it could
easily be changed.

Fio will also collect and sum the results, if you ask it to.

-- 
Jens Axboe

