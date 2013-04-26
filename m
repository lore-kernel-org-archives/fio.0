Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3DZNmS (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 09:42:18 -0400
Date: Fri, 26 Apr 2013 07:42:16 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Random IO pattern ratios
Message-ID: <20130426134216.GO9563@kernel.dk>
References: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
 <20130426034452.GN9563@kernel.dk>
 <CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Williams <jwilliams4200@gmail.com>
Cc: Brian Carey <brian@careydrive.com>, fio@vger.kernel.org

On Thu, Apr 25 2013, John Williams wrote:
> Are there any plans to add %random / %sequential capability to fio?
> 
> That is the only feature IOMeter has that I miss in fio.

Sure, that'd be pretty easy to add. Let me take a look this morning.

-- 
Jens Axboe

