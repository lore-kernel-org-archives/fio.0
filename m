Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2DDTuV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Apr 2012 15:50:21 -0400
Message-ID: <4F7CA5F1.2050309@kernel.dk>
Date: Wed, 04 Apr 2012 13:50:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de>
In-Reply-To: <4F7BEC92.8000100@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-04 00:39, Danny Kukawka wrote:
> Hi,
> 
> we try to run fio against raw RBD devices on a ceph cluster. Here are
> the parameter we use to run fio:
> 
> [test]
> filename=/dev/rbd0
> time_based
> runtime=3h
> rw=randrw
> rwmixread=80
> rwmixwrite=20
> blocksize_range=4k-1024k
> ioengine=libaio
> iodepth=64
> direct=1
> verify=crc32c-intel
> verify_fatal=1
> verify_async=16
> lockfile=exclusive
> 
> We see some problems:
> 
> 1) fio reports higher READ speeds than the used 1Gbit network interface
> could provide (the interface isn't even working to capacity in this
> situation). That happens if we use --rwmixread/rwmixwrite:
> 
>  READ: io=91560MB, aggrb=156206KB/s, minb=159955KB/s,
>         maxb=159955KB/s, mint=600216msec, maxt=600216msec
>  WRITE: io=22944MB, aggrb=39143KB/s, minb=40083KB/s, maxb=40083KB/s,
>         mint=600216msec, maxt=600216msec

OK that's very odd. How are these numbers matching up with watching
vmstat 1 while the job runs? I've never seen fio over-report before.

> 2) fio 2.0.6 and also the current git tends to fail with this error:
> 
>    fio 2.0.6
>    Starting 1 process
>    fio: iolog.c:242: log_io_piece: Assertion `ipo->len == __ipo->len'
>    failed.:08m:31s]
> 
> It seems that we can prevent it when we use the --size parameter, but we
> would like to prevent the usage of the parameter, if possible

Strangely, I had two reports of this today. Did a bit of digging, and
it's due to this commit:

commit c04e4661e4da3b6079f415897e4507cf8e610c54
Author: Daniel Ehrenberg <dehrenberg@google.com>
Date:   Fri Mar 16 18:54:15 2012 +0100

    time_based: Avoid restarting main I/O loop

I think what is going on here is that your job is time based, and when
we fail getting a new offset, we clear the offset bitmap. But we could
have verifies pending at this point, we'd need to prune this out as
well.

> 3) fio always reports minb == maxb and aggrb < minb as you can see
> above. From my understanding this would be false info.

Yeah, it's a cosmetic thing. I've never really taken the time to look at
that...

> 4) If we define rw=randrw, rwmixread=80, rwmixwrite=20 and the verify
> options, what does the READ process if there isn't enough data written
> out yet? Which data does READ read and verify?

If you have a split workload like that and are also doing verifies, the
read can be either a read verify or just an offset read. In the latter
case, it doesn't verify anything. It'll just read a block (or multiple
blocks) at some offset instead of writing it.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfKXtAAoJEPfTWPspceCmqeMP/1p+btObGgcYDgCDa5ohSi/D
usBx/MYkxhgyeleC8ketcC0QVl9qU9dW4krUso1Fe7lyYvjtS+vyvu/ayxISY6hp
CJ0c6m/py+jNDZNANgQQNR0bC8pZ03GbcJnAg0Ari8hewRu8oF2s6razcpr9PstT
nhg0wSrrx+1LNalfYk0GmQe7VDX8QNgOvcBp+gN2v1R9sxYjvR86F6MGBib19LeR
g6fwnQ/zBQRHHVCY3e6AQrozLJk47QOfdwF8pIKTkxVcOCK51Qynbi5YK6zxArto
jFaCgdbQ+DxvUSH6korIaQv3PLmf2wmokQz7TmTjxYQyz8Q6RMW3M/ZdcZlxqHhe
VkBIxC/JYaU97wpLI+Y4XqMDJr+3vrp8JaS4DPrlb7+hNY4sDMFqKH9MCRy3Th1v
12/WZy244SVtqIF9iboS4Gx9QbxfQzZfL5tpQcJaormknGKaTpP3YHZ//egeI/pK
tZvZ34l8CRHS58wfWyh4qPaYyy/hjwoojNJ0/CZGFQnUa6tH6hnWKhRX++oVsEP7
24FbqI2xLG3tBTDMeQIYg0/4SZo65D10vvLF8zzvyqy9hhaZJTon2AmnxpOsm+EA
pUSDWmB7OdpbnIPwA8PpK0sATxBUA638S8UmGFYjqubjwCWpKr5x6HPR6aVj+XN+
O5FfQel0Tz8w4g+ARjju
=cM7O
-----END PGP SIGNATURE-----
