Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3KPSTq (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 16 Nov 2013 13:19:46 -0500
Date: Sat, 16 Nov 2013 11:19:44 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Latency log, add filename to record
Message-ID: <20131116181944.GD8179@kernel.dk>
References: <CAHPXfP7PFPwAK=CbPYkL_XU5UfjCjvOyf0atdD0fL6e3BF6c3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHPXfP7PFPwAK=CbPYkL_XU5UfjCjvOyf0atdD0fL6e3BF6c3g@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: chris meyers <chris.meyers.fsu@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Nov 07 2013, chris meyers wrote:
> https://github.com/axboe/fio/pull/3
> The above patch modifies the CSV latency log (write_lat_log options)
> by appending the filename to which the record is related. Said
> differently, the filename to which the I/O was issued to. When I first
> set out to add this feature I had indended to create a new log file in
> order to distrubt the latency log file format as little as possible.
> This, however, was not easily doable given the structure of the fio
> code. Now, in order to still provide this feature while maintaining
> the legacy latency file format I propose two options.
> (1) A configuration options as an extention to write_lat_log. For example:
> write_lat_log=mylogfile:with_filename
> (2) As a seperate configuration option that modifies the write_lat_log
> format. For example:
> write_lat_log_with_filename=bool
> 
> This email is to start a discussion and solicit feedback on the
> proposed feature as well as the cooresponding configuration trigger.

Chris, sorry for being late on this! I'll get to this on Monday and give
you some constructive criticism.

-- 
Jens Axboe

