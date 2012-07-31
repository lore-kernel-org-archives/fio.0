Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2GaSr0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 14:47:26 -0400
Message-ID: <5018283A.8060301@kernel.dk>
Date: Tue, 31 Jul 2012 20:47:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio for Android
References: <001301cd69cf$907e3770$b17aa650$@codeaurora.org>
In-Reply-To: <001301cd69cf$907e3770$b17aa650$@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: fio@vger.kernel.org

On 2012-07-24 21:07, Tanya Brokhman wrote:
> Hello All,
> 
> I'm new to fio and I have a small question: was it ever ported to Android? I
> searched the web but found no make file for android (Android.mk) for fio. I
> tried converting the existing Makefile to Android.mk myself, but it's not so
> trivial. 
> 
> I would appreciate any help/guidance on this issue.

Interesting question! Not that I know of, and I don't even know what
would be involved in the effort. Usually the easiest way is to find a
different open project that was ported to android, then take a look at
those changes. That should give you a rough idea of what would be
involved.

-- 
Jens Axboe

