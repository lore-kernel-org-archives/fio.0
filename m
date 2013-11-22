Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3KVDoo (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Nov 2013 22:44:44 -0500
Date: Thu, 21 Nov 2013 20:44:42 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Latency log, add filename to record
Message-ID: <20131122034442.GH28819@kernel.dk>
References: <CAHPXfP7PFPwAK=CbPYkL_XU5UfjCjvOyf0atdD0fL6e3BF6c3g@mail.gmail.com>
 <20131116181944.GD8179@kernel.dk>
 <20131122033602.GG28819@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122033602.GG28819@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: chris meyers <chris.meyers.fsu@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Nov 21 2013, Jens Axboe wrote:
> On Sat, Nov 16 2013, Jens Axboe wrote:
> > On Thu, Nov 07 2013, chris meyers wrote:
> > > https://github.com/axboe/fio/pull/3
> > > The above patch modifies the CSV latency log (write_lat_log options)
> > > by appending the filename to which the record is related. Said
> > > differently, the filename to which the I/O was issued to. When I first
> > > set out to add this feature I had indended to create a new log file in
> > > order to distrubt the latency log file format as little as possible.
> > > This, however, was not easily doable given the structure of the fio
> > > code. Now, in order to still provide this feature while maintaining
> > > the legacy latency file format I propose two options.
> > > (1) A configuration options as an extention to write_lat_log. For example:
> > > write_lat_log=mylogfile:with_filename
> > > (2) As a seperate configuration option that modifies the write_lat_log
> > > format. For example:
> > > write_lat_log_with_filename=bool
> > > 
> > > This email is to start a discussion and solicit feedback on the
> > > proposed feature as well as the cooresponding configuration trigger.
> > 
> > Chris, sorry for being late on this! I'll get to this on Monday and give
> > you some constructive criticism.
> 
> OK, finally got to it. One problem with adding to the log structure is
> that it grows in size. And we already have a problem with it eating too
> much memory. But I actually have a few ideas on how to 'compress' it, so
> lets not worry too much about that.
> 
> Lets add a new option to include the name. write_lat_log_with_filename
> sounds like a reasonable choice.

Also, another thing to consider is that the log is potentially
transmitted across the network, that's what happens for client/server
fio... You want to consider how best to handle that.

-- 
Jens Axboe

