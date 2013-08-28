Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44324 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3H1REc (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 28 Aug 2013 13:04:32 -0400
Message-ID: <521E2D91.80600@kernel.dk>
Date: Wed, 28 Aug 2013 11:04:17 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: filling buffers with data from block device
References: <CA+BkS8NTwrsKpDnPqzcEBZRtOeK8xtOT0ZqeemPH36bTXOdP8w@mail.gmail.com>
In-Reply-To: <CA+BkS8NTwrsKpDnPqzcEBZRtOeK8xtOT0ZqeemPH36bTXOdP8w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alket Memushaj <amemushaj@gmail.com>
Cc: fio@vger.kernel.org

On 08/27/2013 05:15 PM, Alket Memushaj wrote:
> is it possible to have fio fill the I/O buffers with data from a block
> device? when testing systems with both deduplication and compression
> enabled, it would be easier to fill the buffers with existing data.

It would not be impossible. But if you look at how fio allocates and
uses it's IO buffers, then you would need to continually fill them
before use since it reuses the same amount of them (defined by iodepth *
jobs).

It might be more feasible to analyze the data contents, and then improve
fio to be able to express that more easily.


-- 
Jens Axboe

