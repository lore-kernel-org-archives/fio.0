Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:37932 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab1HAT7w (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 1 Aug 2011 15:59:52 -0400
Message-ID: <4E3705B3.6020602@fusionio.com>
Date: Mon, 1 Aug 2011 21:59:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: rdma ioengine
References: <CAG5pYQd_y=jMDfir8AXj0bqXB4aVLn9MPE79AqNx1J+XY0Vh2g@mail.gmail.com>
In-Reply-To: <CAG5pYQd_y=jMDfir8AXj0bqXB4aVLn9MPE79AqNx1J+XY0Vh2g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <renyufei83@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-01 20:56, Yufei Ren wrote:
> Thanks, Jens. That works. I did a little more code alignment for more
> comfortable reading, and it's attached. (Yahoo mail replaced the
> previous patch some white spaces :-)
> 
> Here is some sample test result. RDMA memory semantic is one side
> operation which means the remote side doesn't know what's the
> throughput without extra notification. Now, the client only send the
> finish message to the server side after transfer completion, so the
> server side statistics for memory semantic are empty.

Thanks, I will merge your examples and description into an appropriate
file. Please note that I merged your previous patch and ran indent on
it, so any further/new patches need to be based off the current git
tree.


-- 
Jens Axboe

