Return-Path: <axboe@kernel.dk>
Message-ID: <5363AE9C.7040505@kernel.dk>
Date: Fri, 02 May 2014 08:41:32 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <CF88FA61.5B099%ajoy@fastorsystems.com>
In-Reply-To: <CF88FA61.5B099%ajoy@fastorsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ajoy Aswadhati <ajoy@fastorsystems.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/02/2014 08:36 AM, Ajoy Aswadhati wrote:
> Hi Jens,
> With the new io_limit option, is it possible to do the following:
> Have the disk size be 1TB and use 1GB file size and make it use the 1TB
> space randomly and not confine to the first 1GB.
> I.e. Use the entire disk in a sparse and random order repeatedly for n
> iterations. If yes can you provide a config.

On the raw disk, you can do that with

size=1tb
io_limiut=1gb

and add loops=x for however many iterations you want.

If you mean from a file system, then you would need a 1TB file to
achieve (roughly) the same thing. Not sure what you mean here, but are
you referring to multiple 1GB files?

-- 
Jens Axboe


