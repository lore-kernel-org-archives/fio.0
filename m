Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2IUMQD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 08:16:03 -0400
Message-ID: <505C5A6A.5020904@kernel.dk>
Date: Fri, 21 Sep 2012 14:15:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio 2.0.9 fails: shmget: No space left on device
References: <505C54AE.9010701@vpseer.com>
In-Reply-To: <505C54AE.9010701@vpseer.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Konstantin Boyandin <konstantin@vpseer.com>
Cc: fio@vger.kernel.org

On 09/21/2012 01:51 PM, Konstantin Boyandin wrote:
> Hello,
> 
> When trying to run the command line
> 
> fio --bs=4k --size=128m --direct=1 --runtime=10 --rw=randread
> --numjobs=32 --group_reporting --time_based --name=128m
> 
> I see only this:
> 
> shmget: No space left on device
> error: failed to setup shm segment

Hmmm. Can you send me the output of:

$ grep . /proc/sys/kernel/shm*
$ ipcs -l
$ ipcs -m


-- 
Jens Axboe

