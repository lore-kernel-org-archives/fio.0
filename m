Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49246 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACTj0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 3 Jan 2015 14:39:26 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so1124076wiv.13
        for <fio@vger.kernel.org>; Sat, 03 Jan 2015 11:39:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <54A830E7.5080509@fb.com>
References: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
	<54A830E7.5080509@fb.com>
Date: Sat, 3 Jan 2015 20:39:24 +0100
Message-ID: <CA+icZUWcafgFE27NbYPhKtjJ6Vqk_o4nmxKHhgXj7q3vNBvw7w@mail.gmail.com>
Subject: Re: [PATCH] axmap: fix deadlock
From: Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <ming.lei@canonical.com>, fio@vger.kernel.org

On Sat, Jan 3, 2015 at 7:11 PM, Jens Axboe <axboe@fb.com> wrote:
> On 01/03/2015 07:21 AM, Ming Lei wrote:
>> axmap_first_free() is always called with axmap->lock held,
>> so needn't to acquire the lock inside the function.
>>
>> The deadlock is introduced in commit 12bde3697fc230d7a(axmap:
>> ensure we lock down the maps for shared access).
>>
>> Given axmap_first_free() is only called inside lib/axmap.c,
>> this patch declares the function as static. In the future,
>> if external users need the function, axmap lock can be
>> considered at that time.
>
> Thanks Ming, applied.
>

Do you use the "Fixes:" tag in fio development [1]?

Fixes: 12bde3697fc2 ("axmap: ensure we lock down the maps for shared access")

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n159
