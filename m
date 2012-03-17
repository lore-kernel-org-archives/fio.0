Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2CQMQq (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 17 Mar 2012 08:16:46 -0400
Message-ID: <4F6480AC.90501@kernel.dk>
Date: Sat, 17 Mar 2012 13:16:44 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Added 99.95 and 99.99 default percentiles.
References: <CAAUT-yPxQ5obvo_cnkcZySRDHwx8K=tvDtc=v5cLNjZGMw4wLQ@mail.gmail.com>
In-Reply-To: <CAAUT-yPxQ5obvo_cnkcZySRDHwx8K=tvDtc=v5cLNjZGMw4wLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2012-03-17 00:47, Steven Lang wrote:
> Since there are 20 slots for percentiles, but not all used by default,
> I figure it doesn't hurt to add a couple extra percentiles to the
> default for tail latency capture.

Sure, why not! Added.

-- 
Jens Axboe

