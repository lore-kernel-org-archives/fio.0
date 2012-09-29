Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2I2OVu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 29 Sep 2012 10:21:50 -0400
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com> <50605FEF.5020103@cran.org.uk> <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com> <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk> <5066FBC0.5040508@cran.org.uk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5066FBC0.5040508@cran.org.uk>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
Date: Sat, 29 Sep 2012 16:21:45 +0200
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 29/09/2012, at 15.46, Bruce Cran <bruce@cran.org.uk> wrote:

> On 29/09/2012 07:23, Jens Axboe wrote:
>> On 2012-09-26 18:32, Bruce Cran wrote:
>>> On 26/09/2012 17:30, Jeffrey McVay (jmcvay) wrote:
>>>> Any updates? Is there anything I can do to help? I have a personal
>>>> goal to convert our IOMeter testing to FIO.
>>> Sorry, I've not had any time to work on this yet - I'll work on it today.
>> Any news on this? What is the issue?
> 
> I've not found the problem yet, but I'm also seeing an assertion failure (io_u->flags & IO_U_F_FLIGHT)

That'd usually an OS or fio engine bug, it's a symptom of double completions. 

