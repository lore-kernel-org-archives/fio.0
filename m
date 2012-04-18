Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37501 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2DRSme (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 14:42:34 -0400
Message-ID: <4F8F0B18.806@kernel.dk>
Date: Wed, 18 Apr 2012 20:42:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segfault runninng fio against 2048 jobs
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCC6@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCC6@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@xyratex.com>
Cc: fio@vger.kernel.org

On 2012-04-18 20:16, Roger Sibert wrote:
> Hello Jens,
> 
> Not sure if this is a red herring or not.
> 
> I did a quick check using valgrind with its memcheck on the 1 job sample
> and noted that there appears to be a small memory leak which gets
> noticeably worse when you run against a larger job configuration.
> 
> All the leaks appear to be the same originating line of code so just a
> snippet of the valgrind output is included below.
> 
> 1 job configuration file
> ==19277== 168 bytes in 1 blocks are definitely lost in loss record 9 of
> 10
> ==19277==    at 0x4A0610C: malloc (vg_replace_malloc.c:195)
> ==19277==    by 0x408A44: load_ioengine (ioengines.c:148)
> ==19277==    by 0x409BE2: ioengine_load (init.c:694)
> ==19277==    by 0x409F79: add_job (init.c:765)
> ==19277==    by 0x40BD26: parse_jobs_ini (init.c:1135)
> ==19277==    by 0x40C059: parse_options (init.c:1602)
> ==19277==    by 0x4082F3: main (fio.c:104)
> ==19277==
> .
> .
> ==19277==
> ==19277== LEAK SUMMARY:
> ==19277==    definitely lost: 211 bytes in 6 blocks
> ==19277==    indirectly lost: 0 bytes in 0 blocks
> ==19277==      possibly lost: 272 bytes in 1 blocks
> ==19277==    still reachable: 12 bytes in 3 blocks
> ==19277==         suppressed: 0 bytes in 0 blocks
> ==19277== Reachable blocks (those to which a pointer was found) are not
> shown.
> ==19277== To see them, rerun with: --leak-check=full
> --show-reachable=yes
> 
> 
> 2048 job configuration file.
> ==19365== 50,618,216 (311,144 direct, 50,307,072 indirect) bytes in
> 2,047 blocks are definitely lost in loss record 22 of 22
> ==19365==    at 0x4A0610C: malloc (vg_replace_malloc.c:195)
> ==19365==    by 0x42DA03: setup_log (iolog.c:499)
> ==19365==    by 0x40A9DD: add_job (init.c:846)
> ==19365==    by 0x40BD26: parse_jobs_ini (init.c:1135)
> ==19365==    by 0x40C059: parse_options (init.c:1602)
> ==19365==    by 0x4082F3: main (fio.c:104)
> ==19365==
> ==19365== LEAK SUMMARY:
> ==19365==    definitely lost: 1,843,954 bytes in 22,523 blocks
> ==19365==    indirectly lost: 201,154,560 bytes in 8,185 blocks
> ==19365==      possibly lost: 73,728 bytes in 3 blocks
> ==19365==    still reachable: 580 bytes in 4 blocks
> ==19365==         suppressed: 0 bytes in 0 blocks

Yes, there are a few minor leaks that could grow based on number of
jobs. But it's only really a concern if you run fio as a server backend,
otherwise it's nicely freed when the job is done. And it's not leaking
while a job is running either, it's "just" some of the initialization
memory that isn't freed explicitly on exit.


-- 
Jens Axboe

