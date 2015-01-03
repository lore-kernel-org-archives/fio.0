Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62743 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbbACSL4 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 3 Jan 2015 13:11:56 -0500
Message-ID: <54A830E7.5080509@fb.com>
Date: Sat, 3 Jan 2015 11:11:51 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] axmap: fix deadlock
References: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, fio@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>

On 01/03/2015 07:21 AM, Ming Lei wrote:
> axmap_first_free() is always called with axmap->lock held,
> so needn't to acquire the lock inside the function.
> 
> The deadlock is introduced in commit 12bde3697fc230d7a(axmap:
> ensure we lock down the maps for shared access).
> 
> Given axmap_first_free() is only called inside lib/axmap.c,
> this patch declares the function as static. In the future,
> if external users need the function, axmap lock can be
> considered at that time.

Thanks Ming, applied.

-- 
Jens Axboe

