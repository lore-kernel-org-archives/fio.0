Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47121 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab0BJKIS (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Feb 2010 05:08:18 -0500
Date: Wed, 10 Feb 2010 11:08:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Integrate SPC-1 with fio, version 2 ready for options
Message-ID: <20100210100817.GC1025@kernel.dk>
References: <4B72792C.5030709@auckland.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B72792C.5030709@auckland.ac.nz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>
Cc: fio@vger.kernel.org, "Daniel, Steve" <Steve.Daniel@netapp.com>, Glen Ogilvie <gogilvie@oss.co.nz>

On Wed, Feb 10 2010, Michael O'Sullivan wrote:
> Hi everyone,
>
> Sorry for 2 posts in one day. I have edited my code since the last post  
> to make it easy to add options once I get some direction about using the  
> options and creating a parameter file. I have attached the patch. All  
> the configurable options are now set in set_spc1_options, which can be  
> modified to read a parameter file.

Never apologize for posting too often! :-)

This is very interesting, I'll take a gander at it soonish, I'd like to
get SPC-1 integrated. Some quick thoughts before I get a closer look:

- Fio has the --profile switch, which was meant for things like this.
  It's not very expanded yet, but it could be. I think that is the way
  to go. Then you probably want to add some --profile=foo specific
  options, for setting options that only apply to that profile type.
  That would be SPC-1 specific options.

- It would be a lot nicer if the IO generator was integrated, so you
  would not have to go through the iolog to store and retrieve work
  items.

-- 
Jens Axboe

