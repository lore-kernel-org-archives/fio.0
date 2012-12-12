Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55359
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab2LLHYQ (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 12 Dec 2012 02:24:16 -0500
Message-ID: <50C8311D.3060800@kernel.dk>
Date: Wed, 12 Dec 2012 08:24:13 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio --direct=1 and Linux page cache effects
References: <6e624hcpo4.fsf@just-testing.permabit.com> <50C108E9.4050408@kernel.dk> <50C1B02F.3000902@kernel.dk> <6evcc9bdxv.fsf@just-testing.permabit.com> <50C73545.90505@kernel.dk> <50C79326.8010903@permabit.com>
In-Reply-To: <50C79326.8010903@permabit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On 2012-12-11 21:10, Ken Raeburn wrote:
> On 12/11/12 08:29, Jens Axboe wrote:
>> You are right, blkid likely wont be done by then, so it's still down 
>> to timing whether it'll help or not. This is pretty annoying. This 
>> issue is due to the file being opened for write. But unfortunately we 
>> cannot open for read always, as fcntl() wont allow change of file 
>> access mode flags. So how about the below. Basically DON'T close the 
>> fd, defer that until we really close the file. This will keep one 
>> extra fd open until the original is closed, but I don't see that as 
>> being an issue.
> 
> This patch seems to be working just fine. I have reproduced the case 
> where it uses the shadow_fd field, but blkid doesn't run and the page 
> cache entries don't get loaded, and in my initial tests with dm-zero, it 
> looks like the bimodal performance distribution is gone.
> 
> Thanks!

Excellent, I think this is probably as good as it is going to get. I
have committed the fix. Thanks a lot for reporting it, especially in
such great detail. When a problem is fully understood, fixing it is then
the smallest part of the effort.

-- 
Jens Axboe

