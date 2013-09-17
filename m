Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:46917 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3IQJ7S convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 17 Sep 2013 05:59:18 -0400
Date: Tue, 17 Sep 2013 11:59:12 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1592394383.1141089.1379411952545.JavaMail.root@thomas-krenn.com>
In-Reply-To: <5220C427.9030806@kernel.dk>
Subject: Re: Running Fio under AIX 7
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

Hi Jens,

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Georg Schönberger" <gschoenberger@thomas-krenn.com>
> Cc: fio@vger.kernel.org
> Sent: Friday, 30 August, 2013 6:11:19 PM
> Subject: Re: Running Fio under AIX 7
> 
> On 08/30/2013 05:53 AM, Georg Schönberger wrote:
> > Hi fio users,
> > 
> > I am trying to run Fio under AIX 7 - according to the documentation
> > there shouldn't be any problem with it.
> > For now I am getting the following error, do you have any idea
> > what's the problem here (filesystem jfs/jfs2)?
> 
> Odd, so it's posix_fadvise() getting EINVAL. Most likely reason for
> that
> is that fio is not picking up the right values for it.
> 
> It finds them here, on this platform:
> 
> AIX aixbuild 3 5 00C1DC964C00
> 
> Does it need some other magic on AIX 7 to find them? You can bypass
> the
> error by setting invalidate_cache=0, but it would be great if you
> could
> dig around a bit in /usr/include and see what is up. Alternatively,
> if I
> can log into the machine, I can definitely fix it up.

Setting invalidate=0 did not fix the error. Or do I have to set it an other option?

# fio --rw=write --name=test --size=10M --invalidate=0
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.1.2
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 10MB)
fio: posix_fallocate fails: Invalid argument
fio: pid=0, err=22/file:filesetup.c:412, func=invalidate_cache, error=Invalid argument

What did you mean with digging around in /usr/include? I expect you mean to look at posix_fadvise, but what information do you exactly need?

Thanks a lot, Georg
