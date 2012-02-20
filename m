Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2BTJJw (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Feb 2012 04:09:52 -0500
Message-ID: <4F420D85.1090803@kernel.dk>
Date: Mon, 20 Feb 2012 10:08:21 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Formats for log files
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com> <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316D31@NTXBOIMBX04.micron.com>,<B53FFA03-CFB4-46BB-882A-602F045FAF24@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316DBD@NTXBOIMBX04.micron.com> <EF8C77A9-96EC-42F3-BC18-535FDDD9B0DF@joshcarter.com>
In-Reply-To: <EF8C77A9-96EC-42F3-BC18-535FDDD9B0DF@joshcarter.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Carter <public@joshcarter.com>
Cc: fio@vger.kernel.org, "Bill Hooper (whooper)" <whooper@micron.com>

On 02/16/2012 08:46 PM, Josh Carter wrote:
> Hi Bill,
> 
> Looking at the code, I believe you're correct, the bandwidth logging
> for mixed loads isn't right. While read and write logs are kept
> separate, only one direction's log will get flushed on each interval.
> Instead, fio should flush both directions.
> 
> I'm attaching a patch. Jens: could you take a look at this? I've
> tested both mixed and single-direction workloads, seems to work fine.

Patch looks good, applied. Thanks!

-- 
Jens Axboe

