Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2ICDjp (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 2 Sep 2012 23:39:45 -0400
Message-ID: <5044267B.8060408@kernel.dk>
Date: Sun, 02 Sep 2012 21:39:39 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: verify with norandommap
References: <CAAyzu8gsSK+1n26FfKmAqJtBjbrMTufFMNo4f5D1U2J9B8Cp0w@mail.gmail.com> <CAAyzu8gnC9ukuSV5UUxPcp-x9Q-6sf5OV2nPpOVnchMZ5LqKDw@mail.gmail.com>
In-Reply-To: <CAAyzu8gnC9ukuSV5UUxPcp-x9Q-6sf5OV2nPpOVnchMZ5LqKDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gary Foster <gpfwestie@gmail.com>
Cc: fio@vger.kernel.org

On 2012-09-02 18:14, Gary Foster wrote:
> I realise most people are using Fio to do performance testing, ie
> replicating Windows IOMeter.
> 
> But surely there are some guys using Fio for data integrity testing,
> could you guys give me some help with this ?

It will work OK with norandommap for your workload. If you have mixed
block sizes, then you could run into verification failures if smaller
blocks overwrite parts of a bigger verification piece. With pattern
verification and a pattern size set to the smallest blocksize that
should work too, though.

If you see the 'V', it's definitely verifying. The comment on
norandommap refers to seeing spurious verification failures, not that it
wont verify at all. Your job file should be fine.

-- 
Jens Axboe

