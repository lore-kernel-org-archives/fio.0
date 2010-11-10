Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:33860 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0KJTwt (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 14:52:49 -0500
Message-ID: <4CDAF809.6010709@fusionio.com>
Date: Wed, 10 Nov 2010 20:52:41 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <20101110185826.GJ28050@sebastiankayser.de> <C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com>
In-Reply-To: <C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Cagle <jcagle@gmail.com>
Cc: Sebastian Kayser <sebastian@skayser.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-11-10 20:50, John Cagle wrote:
> If the disk is 2TB, then your 100GB test is only using 5% of it-- thus
> your observed IOPS will be a lot better than expected due to
> short-stroking.  Right?

That is also true, but probably not that much. See my previous email,
rotational latency should dominate here.

-- 
Jens Axboe

