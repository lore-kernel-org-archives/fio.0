Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36314 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab0IXG5c (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Sep 2010 02:57:32 -0400
Message-ID: <4C9C4BC4.9020503@fusionio.com>
Date: Fri, 24 Sep 2010 08:57:08 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio causes segfault after particular of random writes
References: <4C9B4A53.1080302@uni-rostock.de>
In-Reply-To: <4C9B4A53.1080302@uni-rostock.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nikolaus Jeremic <nikolaus.jeremic@uni-rostock.de>
Cc: fio@vger.kernel.org

On 2010-09-23 14:38, Nikolaus Jeremic wrote:
>  Hello,
> 
> I am using  fio for benchmarking of SSDs and noticed that fio causes a
> segfault after writing about 260000 MB with block size of 4069 bytes
> at random in one job. Writing the same or just bigger amount of data
> sequentially in 1 MB blocks works well. The situation is reproducible
> with several fio versions, i.e. 1.34, 1.41, 1.43, 1.43.2 as of
> 09/16/2010.

That's not good. To help me with this, please do:

- Edit the Makefile in fio, remove the -O2 in there.
- make clean && make
- Run ulimit -c10000000000 or something large like that
- Now reproduce the problem. Fio will segfault again, and produce
  a core file.
- compress the fio executable and core file and send them to me.

-- 
Jens Axboe

