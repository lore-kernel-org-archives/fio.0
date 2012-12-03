Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2LCSdq (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Dec 2012 13:33:46 -0500
Message-ID: <50BCF086.8040105@kernel.dk>
Date: Mon, 03 Dec 2012 19:33:42 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: I/O is issued twice at scsi level
References: <CAPDOW77bBKw7dm1e+jHdN+PXMnAddEzQOxnL6nPY25nZU2FCfQ@mail.gmail.com> <1582502590.159531.1354372015482.JavaMail.root@thomas-krenn.com> <CAPDOW77s0v6mrEr_DMUm1O4dBrFmD6aMbuDwj-Wsq6TiHU2Ysw@mail.gmail.com> <CAPDOW74vcyU6fj5xfL8rtbX1bRRXRv6KH0musfVEoq-GFm+aVQ@mail.gmail.com> <50BCAC6C.6010009@kernel.dk> <CANvN+e=iv05VXis+QzYScYE=ietfXhetq-KxZ8etBEi0igU9Fw@mail.gmail.com> <CAPDOW77MYSa8goV12f4A+RusQSgnP0hcw5GBD-a6D+VztkGmPw@mail.gmail.com>
In-Reply-To: <CAPDOW77MYSa8goV12f4A+RusQSgnP0hcw5GBD-a6D+VztkGmPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hiroyuki Yamada <mogwaing@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, =?ISO-8859-1?Q?Georg_Sch?= =?ISO-8859-1?Q?=F6nberger?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org

On 2012-12-03 18:09, Hiroyuki Yamada wrote:
> Sorry for update.
> I figured it out.
> It's from ext3's indirect block mapping.
> There is one mapping block in each 1024 blocks,
> so accessing a large file randomly has high chance of accessing the
> mapping block and the requested block.
> 
> Ext4 has different and more efficient addressing called extent (tree), and
> we can avoid the issue.

Ah, yes that makes sense. I thought we were talking about extra writes,
but it seems I misread the log since it clearly states FROM_DEVICE
transfers.

-- 
Jens Axboe

