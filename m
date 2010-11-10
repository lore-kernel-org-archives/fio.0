Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:38629 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab0KJUE3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 15:04:29 -0500
Message-ID: <4CDAFAC5.9070608@fusionio.com>
Date: Wed, 10 Nov 2010 21:04:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <20101110185826.GJ28050@sebastiankayser.de> <C0509DB7-7B7F-4CB5-B10D-905E7580ACD8@gmail.com> <20101110195214.GK28050@sebastiankayser.de>
In-Reply-To: <20101110195214.GK28050@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-11-10 20:52, Sebastian Kayser wrote:
> * John Cagle <jcagle@gmail.com> wrote:
>> If the disk is 2TB, then your 100GB test is only using 5% of it-- thus
>> your observed IOPS will be a lot better than expected due to
>> short-stroking.  Right?
> 
> I don't know. The inital 80 IOPS (observed over about 2 full minutes)
> made me believe that 100GB would have covered a high enough percentage
> to at least eliminate track-to-track seeks. Are short-stroked seeks also
> that much faster compared to average seek times? And where would the
> steady increase in IOPS during the test come from?
> 
> But you are definitly right when it comes to the test setup. I just
> started a test with size=1800g. Looking foward to what that will show.

If you have the full device, you could just test on that instead of
using a filesystem and file. Just to get more 'raw' performance.

-- 
Jens Axboe

