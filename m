Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:35826
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1IIIhg (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Sep 2011 04:37:36 -0400
Message-ID: <4E69D04E.3090705@kernel.dk>
Date: Fri, 09 Sep 2011 10:37:34 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Added replay_rebase option to run multi-threaded
 log replay on different disk sectors.
References: <4E69A048.6050509@rakugaki.org>
In-Reply-To: <4E69A048.6050509@rakugaki.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Taisuke Yamada <tai@rakugaki.org>
Cc: fio@vger.kernel.org

On 2011-09-09 07:12, Taisuke Yamada wrote:
> Hi.
> 
> I'm now trying to run multi-threaded log replay, and noticed
> all threads are accessing same sector on a disk. Of course,
> this is an expected behavior of "replay".
> 
> But since I also wanted to have each thread accessing different
> parts of the disk to increase a load, but still following the
> access pattern of the original, I added "replay_rebase" option to
> shift offset of IO request for each thread.
> 
> Althrough there's "1/2" in the subject, this patch is complete
> by itself. Next one (2/2) is related, but handles different issue.

Thanks, I can see this being handy. I can apply this, but I would much
prefer if you resend it with the proper updates to HOWTO and fio.1
adding the new option. Otherwise nobody is going to learn about it.

-- 
Jens Axboe

