Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35142 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753304AbdE0IrU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 May 2017 04:47:20 -0400
Received: by mail-ua0-f193.google.com with SMTP id e28so2063722uah.2
        for <fio@vger.kernel.org>; Sat, 27 May 2017 01:47:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170519103922.GA27082@suselix.suse.de>
References: <20170519103922.GA27082@suselix.suse.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 May 2017 09:46:49 +0100
Message-ID: <CALjAwxgaWeV5usZ8N39FiqDTGz4dLqSqQURaDzf1ep3Nr-rT5A@mail.gmail.com>
Subject: Re: [PATCH]
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: Jens Axboe <axboe@fb.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Anatoly Pugachev <matorola@gmail.com>

On 19 May 2017 at 11:39, Andreas Herrmann <aherrmann@suse.com> wrote:
>
> Starting with 9e4438f ("stat: don't trust per_unit_log() if log is
> NULL") fio no longer provides basic bw information (e.g. min, max,
> p_agg, mean, stdev) when write_bw_log is not used. Thus you have to
> write a bw_log to obtain these values. (But in this case you can
> compute those values yourself.) I think this doesn't make sense.  Not
> writing entire bw log shouldn't prevent general sampling and
> calculation of bw stats.
>
> This patch reactivates sampling for bw and iops to be able to
> calculate basic stats for both independend of writing of entire
> {bw,iops}_logs.
>
> Also check for log that is really of interest in __add_samples() it
> doesn't make sense to check for bw_log if iops information needs to be
> written.
>
> Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
> ---
>  stat.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> I don't know the background why the original fix was required in its
> form and at which exact point the sigbus error happened on sparc. Was
> it in per_unit_log(td->bw_log) or somewhere in add_bw_samples or
> add_iops_samples? Maybe the original code version (just using
> !per_unit_log(td->bw_log)) was fine and the sigbus happened due to the
> bug in __add_samples (checking for the wrong log file)?

The sparc sigbus report seems to come from here:
https://lists.debian.org/debian-sparc/2016/08/msg00028.html
("[sparc64] fio bus error").

-- 
Sitsofe | http://sucs.org/~sits/
