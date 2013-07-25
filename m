Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39833 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3GYOfH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 10:35:07 -0400
Message-ID: <51F13781.8000502@kernel.dk>
Date: Thu, 25 Jul 2013 08:34:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segmentation fault on power system
References: <20130723101359.GC2152@localhost.localdomain> <51EE5997.6070804@enovance.com> <51EE9E1C.3040708@kernel.dk> <20130724021019.GA2615@localhost.localdomain> <20130724062101.GB2615@localhost.localdomain>
In-Reply-To: <20130724062101.GB2615@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org

On 07/24/2013 12:21 AM, Han Pingtian wrote:
> I think I have found what's wrong. After 'make distclean' then 'make',
> the problem of segfault has gone. There were some object files 
> compiled on another machine. The recompilation fixed it. But looks like
> the ATBU call dosen't work on power7 system.

So the recompilation fixed the segfault, but not the illegal instruction
due to ATBU?

-- 
Jens Axboe

