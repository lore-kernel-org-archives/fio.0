Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:55156 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1GWTFz (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jul 2011 15:05:55 -0400
Message-ID: <4E2B1B8F.5020202@fusionio.com>
Date: Sat, 23 Jul 2011 21:05:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: bsrange doesn't accept separate read,write values
References: <4E2B18C5.3090602@evernote.com> <4E2B1A16.20509@fusionio.com> <4E2B1B38.5060909@evernote.com>
In-Reply-To: <4E2B1B38.5060909@evernote.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dave Engberg <dengberg@evernote.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-07-23 21:04, Dave Engberg wrote:
> 
> Yes, it appears to work for me. E.g. if I use this:
> bsrange=512-23k,1k-42k
> 
> Then fio emits this at start-up:
> job1: (g=0): rw=randrw, bs=512-23K/1K-42K, ioengine=sync, iodepth=1

That's great. Perhaps you could look into simplifying the bssrange
option next, then :-)

I'll apply this one, thanks.

-- 
Jens Axboe

