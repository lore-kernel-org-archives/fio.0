Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53530 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0FYMfB (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jun 2010 08:35:01 -0400
Message-ID: <4C24A26F.5090502@fusionio.com>
Date: Fri, 25 Jun 2010 14:34:55 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fix 1000 vs kb_base confusion in show_run_stats.
References: <20100623023753.92DB271923@kuma.localdomain> <4C220292.4030100@fusionio.com>
In-Reply-To: <4C220292.4030100@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On 2010-06-23 14:48, Jens Axboe wrote:
> On 2010-06-23 04:37, YAMAMOTO Takashi wrote:
>> hi,
>>
>> please apply the following patch.
>>
>> YAMAMOTO Takashi
> 
> Thanks, applied.

On second though, this is wrong. The 1000 divisor is
for msec to sec, not from byte to kb.

-- 
Jens Axboe

