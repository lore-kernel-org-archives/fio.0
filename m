Return-Path: <daniel.gollub@t-online.de>
Date: Thu, 13 Feb 2014 07:25:00 +0100
From: Daniel Gollub <daniel.gollub@t-online.de>
Subject: Re: [PATCH 2/2] engines/null: allow build as external C++ ioengine
Message-ID: <20140213072500.792e7a92@marvin>
In-Reply-To: <52FC465A.4060009@kernel.dk>
References: <1392232426-16152-1-git-send-email-d.gollub@telekom.de>
	<1392232426-16152-2-git-send-email-d.gollub@telekom.de>
	<52FC465A.4060009@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

On Wed, 12 Feb 2014 21:13:14 -0700, Jens Axboe wrote:
> On 2014-02-12 12:13, Daniel Gollub wrote:
> > In first place to have a simple test candidate for external
> > ioengines using get_ioengine() method for retriving the
> > io_engine struct.
> >
> > Can be compiled with:
> >
> > g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c
> > -DFIO_EXTERNAL_ENGINE
> 
> I'm assuming this is just an example of how you'd build your external 
> engine? Look OK to me with that in mind.
> 

Yes it is. I although thought about integrating the build (of the null
C++/external variant) as kind of a build/compile test (not by default)
so we can spot changes on fio.h (or headers which are included by fio.h)
which break builds for external C++ based ioengines.

Something like ./configure --example-external-ioengines which
would also build skeleton_external (plain C) and cpp_null.so (if g++ is
available).

-- 
Daniel Gollub

