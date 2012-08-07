Return-Path: <mike.ryan@inktank.com>
Date: Tue, 7 Aug 2012 07:47:21 -0700
From: Mike Ryan <mike.ryan@inktank.com>
Subject: Re: generating latency logs
Message-ID: <20120807144721.GF12248@splice>
References: <20120807010300.GD12248@splice>
 <50211B6A.2070505@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50211B6A.2070505@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Aug 07, 2012 at 03:43:06PM +0200, Jens Axboe wrote:
> >   fio --latency-log=/tmp/log --output=/tmp/log random_write.fio
> 
> The latency/bw logs are named from the job name, so you can't actually
> give it a specific name with the (global) command line option. You'd
> need to use the job option to do that.

The argument requires an option. It appears that option is discarded.

> That said, it does look broken in that we don't inherit the global
> setting. Does the below make it work?

Yes! The files are named log_lat.log, log_slat.log, and log_clat.log.
They are not named after the job.

