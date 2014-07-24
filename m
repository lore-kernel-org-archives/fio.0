Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbaGXOvf convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 24 Jul 2014 10:51:35 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Using libaio with buffered IO
References: <1528502860.42759.1406203872658.JavaMail.zimbra@thomas-krenn.com>
	<1997154026.44524.1406205729559.JavaMail.zimbra@thomas-krenn.com>
Date: Thu, 24 Jul 2014 10:51:20 -0400
In-Reply-To: <1997154026.44524.1406205729559.JavaMail.zimbra@thomas-krenn.com>
	("Georg \=\?utf-8\?Q\?Sch\=C3\=B6nberger\=22's\?\= message of "Thu, 24 Jul 2014
 14:42:09 +0200
	(CEST)")
Message-ID: <x494my64xp3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

Georg Schönberger <gschoenberger@thomas-krenn.com> writes:

> Hi Jens,
>
> in the fio man-page you are writing:
> "Even async engines my impose OS restrictions causing the desired
> depth not to be achieved.This may happen on Linux when using libaio
> and not setting direct=1, since buffered IO is not async on that OS."
> (there's also a typo, I think it should be "may" instead of "my")
>
> Nevertheless it is possible to use fio with libaio and buffered IO:
> $ fio --rw=write --name=test --size=20M --runtime=60 --time_based --iodepth=64 --ioengine=libaio
> [...]
> IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%
>
> Could you point out the limitations that come up with
> libaio<->buffered IO (page cache)?

The I/O is synchronous.  In other words, if you issue io_submit with 32
iocbs, io_submit will not return until all 32 I/Os are complete (or
there was an error).

Cheers,
Jeff
