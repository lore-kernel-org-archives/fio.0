Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2JELlG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Oct 2012 07:41:06 -0400
Message-ID: <506EC729.8040201@kernel.dk>
Date: Fri, 05 Oct 2012 13:40:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: IO Scheduler Diagrams
References: <1336570145.255301.1349430116859.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1336570145.255301.1349430116859.JavaMail.root@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 2012-10-05 11:41, Georg Schönberger wrote:
> Hello,
> 
> this topic is not directly connected to Fio but nevertheless reasonable for all Fio Users.
> I am currently working on IO Scheduler Diagrams explaining how they process IO requests.
> 
> Attached you find my first draft, I've already had some input from Christoph Hellwig. I would be happy
> if I get more feedback as I am not sure if everything is correct, especially with CFQ I had some problems drawing it.

Two comments:

- For deadline, the FIFO queues are just for tracking the ordering of
  the requests. They serve no other purpose than to restart the position
  inside the sorted tree (which is a tree, btw, it's not a linked list or
  FIFO as the diagram would lead you to believe).

- For CFQ, the async queues are per-disk and split in prio classes and
  priorities. The sync queues are per-process per-disk. Your graphic
  doesn't really show that, it's a fairly complex relationsship.

-- 
Jens Axboe

