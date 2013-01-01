Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54486 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3AAKAs (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Jan 2013 05:00:48 -0500
Message-ID: <50E2B3CC.5030709@kernel.dk>
Date: Tue, 01 Jan 2013 11:00:44 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio-2.0.12.2 doesn't build with ARCH_HAVE_CPU_CLOCK not defined
References: <1356905511.3343.24.camel@eagle.danny.cz>
In-Reply-To: <1356905511.3343.24.camel@eagle.danny.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?RGFuIEhvcsOhaw==?= <dan@danny.cz>
Cc: fio@vger.kernel.org

On 2012-12-30 23:11, Dan Horák wrote:
> Hi,
> 
> fio stopped to build on architectures that don't define
> ARCH_HAVE_CPU_CLOCK like s390/s390x (fixed in a patch I've already
> sent :-))
> 
> cc -o gettime.o -c -std=gnu99 -Wwrite-strings -Wall -O3 -g -O2 -g -pipe
> -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
> --param=ssp-buffer-size=4 -m31 -march=z9-109 -mtune=z10
> -DFIO_VERSION='"fio-2.0.12.2"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG gettime.c 
> gettime.c: In function 'fio_clock_init':
> gettime.c:317:6: error: 'tsc_reliable' undeclared (first use in this function)
> gettime.c:317:6: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [gettime.o] Error 1
> 
> seems commit fa80feae51 added the tsc_reliable variable

Fixed, tsc_reliable should be globally available (and not under the
ARCH_HAVE_CPU_CLOCK ifdef). Thanks for the report.

-- 
Jens Axboe

