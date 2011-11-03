Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1KCLi2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Nov 2011 07:38:28 -0400
Message-ID: <4EB27D2F.1020502@kernel.dk>
Date: Thu, 03 Nov 2011 12:38:23 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: An alternative way to handle IO engine options
References: <CAAUT-yMDPw4x-g=6Ag0UQGHGPgbiqctim1OiP8WuuiYr3-PjqQ@mail.gmail.com> <4EB08371.2030904@kernel.dk> <CAAUT-yNFcw6+8L911TYcSEED==QToxTbJLXZ8pA7Kuv6A=LqZw@mail.gmail.com>
In-Reply-To: <CAAUT-yNFcw6+8L911TYcSEED==QToxTbJLXZ8pA7Kuv6A=LqZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-11-02 01:27, Steven Lang wrote:
> Alright I'll go ahead with finishing it.
> 
> For the issue of global options...  There are two possibilities I have
> in mind.  The first is to limit it to just an ioengine that is
> specified, and the options for that ioengine are the only ioengine
> options that are allowed.  That would probably be "good enough" for
> most cases.  However, for a load which used two different IO engines,
> it would limit the global options to only one of the ioengines.
> 
> The second option would be to have a way to specify options for
> different ioengines within the global section, then keep a copy of the
> config struct for each that is specified to use as a template.
> 
> What I don't like about the second option is that the conf syntax for
> it might be somewhat messy.
> 
> A third option would be to just parse the global options with respect
> to every known ioengine, or even just store the raw config values and
> parse them with each job.
> 
> I'm not sure which is the best option; however unless there's some
> justification for doing otherwise I may just go with the first
> (simplest) for now, and if it becomes an issue the rest can be patched
> in later.

That sounds like a reasonable approach, we need not over-design it.

-- 
Jens Axboe

