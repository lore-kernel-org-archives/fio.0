Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:56997 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab3AJMTA (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 07:19:00 -0500
Message-ID: <50EEB1B0.9050007@fusionio.com>
Date: Thu, 10 Jan 2013 13:18:56 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Add a check avoid segfault.
References: <201301101936131638895@gmail.com>
In-Reply-To: <201301101936131638895@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 2013-01-10 12:36, majianpeng wrote:
> If new_size was zero or realloc failed, it would be segment fault.
> So add a check.

It's a drop in the bucket, fio basically does not alloc failure
checking. It'd be nice to improve on that, but you'd need a lot more
than the below to get near fixing that.

-- 
Jens Axboe

