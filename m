Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2HGNnZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Aug 2012 09:43:25 -0400
Message-ID: <50211B6A.2070505@kernel.dk>
Date: Tue, 07 Aug 2012 15:43:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: generating latency logs
References: <20120807010300.GD12248@splice>
In-Reply-To: <20120807010300.GD12248@splice>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mike Ryan <mike.ryan@inktank.com>
Cc: fio@vger.kernel.org

On 08/07/2012 03:03 AM, Mike Ryan wrote:
> I'm trying to generate a latency log, but no log file is ever created.
> I'm using the version tagged as fio-2.0.8 in git. This is how I'm
> invoking fio:
> 
>   fio --latency-log=/tmp/log --output=/tmp/log random_write.fio

The latency/bw logs are named from the job name, so you can't actually
give it a specific name with the (global) command line option. You'd
need to use the job option to do that.

That said, it does look broken in that we don't inherit the global
setting. Does the below make it work?

diff --git a/init.c b/init.c
index 3865d09..6aad492 100644
--- a/init.c
+++ b/init.c
@@ -1169,6 +1169,8 @@ static int fill_def_thread(void)
 
 	fio_getaffinity(getpid(), &def_thread.o.cpumask);
 	def_thread.o.timeout = def_timeout;
+	def_thread.o.write_lat_log = write_lat_log;
+	def_thread.o.write_bw_log = write_bw_log;
 
 	/*
 	 * fill default options

-- 
Jens Axboe

