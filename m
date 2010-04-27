Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0D0Gm0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Apr 2010 02:42:26 -0400
Date: Tue, 27 Apr 2010 08:42:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Using offsets in fio
Message-ID: <20100427064224.GX27497@kernel.dk>
References: <4BD62D8A.5050109@auckland.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD62D8A.5050109@auckland.ac.nz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>
Cc: fio@vger.kernel.org, DongJin Lee <dongjin.lee@auckland.ac.nz>

On Tue, Apr 27 2010, Michael O'Sullivan wrote:
> Hi everyone,
>
> We are using fio to emulate the SPC-1 benchmark (we hope to get this  
> included as a --profile in fio in the not too distant future). However,  
> we have noticed that when running our benchmark the disk we are testing  
> does not seem to be overly busy seeking to different locations on the  
> disk. When we run tests using Iometer we can hear the disk seeking to  
> different sections of the disk pretty much the whole time. We are using  
> io_u->offset to define the position in the file we wish to read/write  
> at, but it is not clear to us whether this is having the desired effect.  
> It doesn't seem so at this point... We have been using the sync and  
> libaio engines.

io_u->offset is the byte offset that the engine will seek to before
performing IO, so whatever you put in there will be the real offset. If
the disk doesn't sound as busy as it should, perhaps it's because
iometer drives a higher queue depth as well?

> Can someone please give us some advice to help us troubleshoot this  
> problem? Or point us to a tool that will let us see where fio is  
> reading/writing on the disk? Any help is greatly appreciated.

For shorter samples, you could always just strace fio and see what it's
doing. For a better view, you could use blktrace.

-- 
Jens Axboe

