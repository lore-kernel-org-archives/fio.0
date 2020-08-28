Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgH1RaG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Aug 2020 13:30:06 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC8C061264
        for <fio@vger.kernel.org>; Fri, 28 Aug 2020 10:30:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o4so2024132wrn.0
        for <fio@vger.kernel.org>; Fri, 28 Aug 2020 10:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200827120722.GC6041@suselix> <20200827121533.GF6041@suselix>
In-Reply-To: <20200827121533.GF6041@suselix>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 28 Aug 2020 18:29:38 +0100
Message-ID: <CALjAwxhUcbqQoAKJQYoxeKzw+XfbAbiSe-yKSFHW85hzE0SEQw@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroup: Try to use blkio.bfq.weight if blkio.weight
 is not available
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: Jens Axboe <axboe@fb.com>, fio <fio@vger.kernel.org>

On Thu, 27 Aug 2020 at 13:26, Andreas Herrmann <aherrmann@suse.com> wrote:
>
> Newer kernels just provide blkio.bfq.weight for blkio contoller. Try
> to use this attribute when legacy file is not available.
>
> Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
> ---
>  cgroup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/cgroup.c b/cgroup.c
> index 43513733..6edb5b14 100644
> --- a/cgroup.c
> +++ b/cgroup.c
> @@ -218,8 +218,14 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
>                 }
>                 if (write_int_to_file(td, root, "blkio.weight",
>                                         td->o.cgroup_weight,
> -                                       "cgroup open weight"))
> -                       goto err;
> +                                       "cgroup open blkio.weight")) {
> +                       td_clear_error(td);
> +                       log_err("Trying to use blkio.bfq.weight\n");

It doesn't feel right to print an error just because you tried a
fallback. Maybe try both and print an error if neither works?

> +                       if (write_int_to_file(td, root, "blkio.bfq.weight",
> +                                               td->o.cgroup_weight,
> +                                               "cgroup open blkio.bfq.weight"))
> +                               goto err;
> +               }
>         }
>
>         if (!cgroup_write_pid(td, root, (*mnt)->cgroup2)) {
> --
> 2.28.0
>


-- 
Sitsofe | http://sucs.org/~sits/

