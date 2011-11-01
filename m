Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1KAXke (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Nov 2011 19:40:34 -0400
Message-ID: <4EB08371.2030904@kernel.dk>
Date: Wed, 02 Nov 2011 00:40:33 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: An alternative way to handle IO engine options
References: <CAAUT-yMDPw4x-g=6Ag0UQGHGPgbiqctim1OiP8WuuiYr3-PjqQ@mail.gmail.com>
In-Reply-To: <CAAUT-yMDPw4x-g=6Ag0UQGHGPgbiqctim1OiP8WuuiYr3-PjqQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-11-01 21:16, Steven Lang wrote:
> This isn't quite ready to be a patch yet, but I wanted to get some
> feedback before I put in time polishing it to patch level.
> 
> The idea has been bouncing around in my head that some IO engines have
> unique parameters.  However, fio has no way to make engine specific
> parameters, aside from doing special cases in the options parsing, or
> using some option in a convoluted way it wasn't intended for.  For
> example, the libaio:userspace_reap option, and the net IO engine
> turning the filename into a series of fields you have to know the
> correct syntax and order for.
> 
> Neither of these options seem ideal to me; the first requires special
> casing and limits it to a single option, the second results in
> potentially cryptic requirements.
> 
> At the same time, though, there is only one place in the config
> parsing/management which assumes there is a single config
> (options_mem_dupe) - everything else is told what the options are and
> treats the data as a mostly opaque block of memory, even though it is
> just a single global variable and a fixed config structure.  This
> seems like it is just begging to be re-used within the IO engine
> framework to parse custom options.  So that is what I have done.  For
> now in this code just the libaio userspace_reap option has been
> changed, but it would make sense to apply the same treatment to the
> net IO engine.
> 
> The basic idea is it looks through the config section and makes note
> of any unrecognized options, rather than reporting them right away.
> Then it loads the requested IO engine and runs through the unknown
> options against the IO engine config.  At that point, any unknown
> options are reported.
> 
> There are a few things not finished yet...
> 1. Right now it is conf parsing only; command line parsing never sees
> the new options (But I have a plan, with the restriction that the IO
> engine must be named before its options can be used)
> 2. Documentation for the userspace_reap option will need to be changed.
> 3. There's currently no way to handle IO engine options in the [global] section.
> 
> Do you see any problems with this approach to handling options that
> are specific to a single IO engine?

I like this a lot, I've been thinking about private options in the past
and things like userspace_reap is indeed just a nasty hack. It would be
very nice to handle this in a more generic fashion. We would need to
solve the generic vs global name space problem though, otherwise that's
just a problem waiting to happen. Apart from that, I would not have any
problems merging this feature.

-- 
Jens Axboe

