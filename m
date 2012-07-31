Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2GaSsP (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 14:48:15 -0400
Message-ID: <5018286D.5070000@kernel.dk>
Date: Tue, 31 Jul 2012 20:48:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Problem using --offset: fix call to fadvise64
References: <1375946309.2166899.1342780232840.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1375946309.2166899.1342780232840.JavaMail.root@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 2012-07-20 12:30, Georg Schönberger wrote:
> I have now figured out the problem: when testing with a whole
> partition "/dev/sdb1" and specifying an offset you have also to
> specify a size via "--size". I thought that if I am using an offset
> with a partition Fio would carry out the test starting at the offset
> until the end of the partition. But this is not the case, you have to
> explicitly give the rest of partition's size starting from the offset.
> This was my fault, Fio is doing everything correctly.

We could improve and have fio get the partition size in this case. The
problem is that if it's a block device, it'll get the full size. A bit
counter intuitive.

-- 
Jens Axboe

