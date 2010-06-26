Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0FZUvM (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 26 Jun 2010 16:51:12 -0400
Message-ID: <4C26683D.8010006@fusionio.com>
Date: Sat, 26 Jun 2010 22:51:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] gracefully handle full /tmp file system
References: <20100625152419.GA29790@w-gedwards.lhn.com>
In-Reply-To: <20100625152419.GA29790@w-gedwards.lhn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Edwards <greg.edwards@hp.com>
Cc: fio@vger.kernel.org

On 25/06/10 17.24, Greg Edwards wrote:
> If /tmp happens to be full, fio gives you a very unhelpful error:
> 
> # ./fio rand-write-256k-q256.job
> Bus error
> 
> Use posix_fallocate() to gracefully handle this condition.
> 
> Signed-off-by: Greg Edwards <greg.edwards@hp.com>

Thanks, that looks sane. As far as I remember, if the fs
doesn't do fallocate, then glibc will zero fill it. If
that is the case, then it should be safe.

I will apply it.

-- 
Jens Axboe

