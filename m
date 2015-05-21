Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36141 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbbEUUjn (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 May 2015 16:39:43 -0400
Received: by lbbqq2 with SMTP id qq2so26738469lbb.3
        for <fio@vger.kernel.org>; Thu, 21 May 2015 13:39:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555DEA42.8020209@nellans.org>
References: <555D9487.3040104@cnnic.cn>
	<555DEA42.8020209@nellans.org>
Date: Thu, 21 May 2015 21:39:42 +0100
Message-ID: <CALjAwxjz2qXivBru2HEch3Rsg_40rmZMvmD-fVknz6Ny1mrqqA@mail.gmail.com>
Subject: Re: Urgent problem while using Fio to test random write performance
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>
Cc: Nan WANG <wangnan@cnnic.cn>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 21 May 2015 at 15:22, David Nellans <david@nellans.org> wrote:
> you're randwrite to a raw partition. if you had a filesystem on that
> partition you were trying to use, then well, your data is gone/corrupted.
> without a filesystem on it, i'm not sure how you'd think that your disc
> usage has become "100%" without some xgui widgit warning you, so seems
> likely you did something you didn't mean to with regards to writing to
> /dev/sdb1 directly
>
> if you use fio on devices/partitions with a filesystem, you need to have it
> write to files or it will trash your filesystem

It's unlikely but it wasn't mentioned which partition became 100%
full. You should also make sure that /dev/sdb1 really exists as a
block device (e.g. via using file) otherwise you'll make/fill a
standard file called /dev/sdb1 .

-- 
Sitsofe | http://sucs.org/~sits/
