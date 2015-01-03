Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:57937 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbACOhg (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 3 Jan 2015 09:37:36 -0500
Received: by mail-we0-f175.google.com with SMTP id k11so5661023wes.20
        for <fio@vger.kernel.org>; Sat, 03 Jan 2015 06:37:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
References: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
Date: Sat, 3 Jan 2015 15:37:34 +0100
Message-ID: <CA+icZUVzP2vFjtoQvsELT7s_QB5KJyzksjLJQJ5Hz5uujyRMLQ@mail.gmail.com>
Subject: Re: [PATCH] axmap: fix deadlock
From: Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>, fio@vger.kernel.org

On Sat, Jan 3, 2015 at 3:21 PM, Ming Lei <ming.lei@canonical.com> wrote:
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
>
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
