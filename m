Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2JJOTd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Oct 2012 10:19:33 -0400
Message-ID: <507583EC.3070808@kernel.dk>
Date: Wed, 10 Oct 2012 08:19:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com> <50605FEF.5020103@cran.org.uk> <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com> <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk> <5066FBC0.5040508@cran.org.uk> <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk> <C8CA972100601A41AE302914E9CE194655F9DEF4@NTXBOIMBX03.micron.com> <507548FE.9010106@cran.org.uk> <507550DB.2000301@cran.org.uk> <50758306.7020807@kernel.dk> <507583A1.9030308@cran.org.uk>
In-Reply-To: <507583A1.9030308@cran.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-10-10 08:18, Bruce Cran wrote:
> On 10/10/2012 15:15, Jens Axboe wrote:
>> So where is this bug exactly? Is Windows reaping events from the head of
>> this list, and thus starving indefinitely potentially?
> 
> Yes - both windowsaio and posixaio read from the head of the list.

Gotcha, I did check windowsaio after sending the email. Patch is in, so
all should be well.

-- 
Jens Axboe

