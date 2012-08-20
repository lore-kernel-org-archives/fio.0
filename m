Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52353 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2HTK6n (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Aug 2012 06:58:43 -0400
Message-ID: <50321835.8060608@kernel.dk>
Date: Mon, 20 Aug 2012 12:57:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Direct io on Ubuntu i386?
References: <CAHaS=Qwn2zxQWkvy=ZPQstwwOuX1P__=Gp1jw9WW3Jy6jpDWxA@mail.gmail.com>
In-Reply-To: <CAHaS=Qwn2zxQWkvy=ZPQstwwOuX1P__=Gp1jw9WW3Jy6jpDWxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 08/20/2012 02:57 AM, Greg Sullivan wrote:
> I'm trying to do direct io (to avoid the file system cache) on Ubuntu
> i386. I've tried direct=1, and tried the io engines sync and libaio -
> it always seems to use the cache.
> 
> Is there a way to bypass the file system cache on Ubuntu? I've got a
> vanilla install using the automated Ubuntu installer for Windows i386
> 32-bit (dual boot).

direct=1 will certainly bypass the cache on Linux, regardless of
version. What makes you suspect otherwise?

-- 
Jens Axboe

