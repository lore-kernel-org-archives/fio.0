Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34798 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935111AbcLVIjU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 03:39:20 -0500
Received: by mail-ua0-f193.google.com with SMTP id i68so4422131uad.1
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 00:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161222060853.64104-10-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com> <20161222060853.64104-10-elliott@hpe.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 22 Dec 2016 08:39:19 +0000
Message-ID: <CALjAwxhYJbJ7ToYQiFqW4Z1qyV5s_WCf+BNksqMcGeRua=ZzUQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] Convert group_run_stats to use bytes instead of KiB/KB
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 22 December 2016 at 06:08, Robert Elliott <elliott@hpe.com> wrote:
> In group_run_stats, convert these fields:
> * io_kb (bytes transferred)
> * agg (aggregate average bandwidth)
> * min_bw
> * max_bw
>
> from tracking either KiB or KB depending on kb_base to simply tracking bytes.
> Rename io_kb to iobytes to match this new meaning.

It's hopefully unlikely but have you checked this change to see that
overflow isn't provoked during arithmetic? I spent a little while
getting rid of a few cases prior to this patch by using clang's
undefined behaviour sanitizer via -fsanitize=integer and they were
more likely to occur on 32 bit platforms (which was more of a pain as
linking the sanitizer on 32 bit x86 Linux was more difficult). Another
minor point is should the variable rename have gone to io_bytes rather
than iobytes?

> This will simplify computing quantities and bandwidth rates with both IEC
> binary and SI decimal unit prefixes (e.g., GiB/s and GB/s) in future patches.

-- 
Sitsofe | http://sucs.org/~sits/
