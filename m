Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2KUJpy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 Nov 2012 04:45:54 -0500
Message-ID: <50ACA291.4000000@kernel.dk>
Date: Wed, 21 Nov 2012 10:44:49 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_u error using offsets
References: <46391624.39675.1353347182440.JavaMail.root@thomas-krenn.com>
In-Reply-To: <46391624.39675.1353347182440.JavaMail.root@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 2012-11-19 18:46, Georg Schönberger wrote:
> Hello,
> 
> I am trying to divide a 4TB hard disk into 128 equal parts. Therefore I divide the disk size (in Bytes) with 128 - this is my increment size. Then I start several fio job rounds with the offset increasing every round by the increment. Unfortunately I get an error for the first offset not equal to 0.
> I suppose this is an issue with the offsets not being correctly aligned.
> Here is my call to fio:
> $ sudo /usr/local/bin/fio --rw=randrw --name=wd --offset=31256148672 --direct=1 --bs=64k --filename=/dev/sdi --rwmixread=100 --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=16 --size=31256148672 --group_reporting --debug=all

You get the error because 31256148672 isn't a multiple of 512b (which
I'm assuming is your sector size), hence the IO will be unaligned.
Direct IO cannot be unaligned, that's why you get an EINVAL from the OS.

-- 
Jens Axboe

