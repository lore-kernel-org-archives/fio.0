Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60971 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2DZKPN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Apr 2012 06:15:13 -0400
Message-ID: <4F992021.7070805@kernel.dk>
Date: Thu, 26 Apr 2012 12:14:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: Add to cgroup if parameter "cgroup" is enabled.
References: <1335432265-5519-1-git-send-email-tm@tao.ma>
In-Reply-To: <1335432265-5519-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: fio@vger.kernel.org

On 04/26/2012 11:24 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, we only add the tasks to cgroup if cgroup_weight is set by
> the user. But if we want to test other blkcg parameters like block
> throttle, the fio tasks isn't added to the corresponding cgroup and
> it doesn't make sense.
> 
> So add the task to the corresponding cgroup if the cgroup name is given.

Thanks, applied.

-- 
Jens Axboe

