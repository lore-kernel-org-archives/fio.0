Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59960 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0CaUyK (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Mar 2010 16:54:10 -0400
Date: Wed, 31 Mar 2010 22:54:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add an option "cgroup_nodelete" to not delete cgroups  after job completion
Message-ID: <20100331205408.GI23510@kernel.dk>
References: <20100331204652.GL14011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331204652.GL14011@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fio@vger.kernel.org

On Wed, Mar 31 2010, Vivek Goyal wrote:
> o Add an option cgroup_nodelete to not remove cgroups created by fio after
>   the job completion. This can help a user in inspecting various cgroup
>   files after fio job completion.

Thanks Vivek, added. And thanks for updating both the HOWTO and man
page.

-- 
Jens Axboe

