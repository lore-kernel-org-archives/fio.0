Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:40896 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbeHaJtw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Aug 2018 05:49:52 -0400
Received: by mail-vk0-f46.google.com with SMTP id q184-v6so5086683vke.7
        for <fio@vger.kernel.org>; Thu, 30 Aug 2018 22:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20180821190824.29928-1-mcgrof@kernel.org> <20180821190824.29928-2-mcgrof@kernel.org>
In-Reply-To: <20180821190824.29928-2-mcgrof@kernel.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Aug 2018 06:43:42 +0100
Message-ID: <CALjAwxhGCZ7mP9uQ35ko-pPBU8gNu9bcRRoS5fB8b2wySh9h3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] client: respect terse output on client <--> backend relationship
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mcgrof@kernel.org
Cc: fio <fio@vger.kernel.org>, "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>

On Tue, 21 Aug 2018 at 20:31, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> You end up with different results if you run this terse output
> on a local system which also runs its own backend Vs running a
> client to connect to a remote server which is running fio as a
> backend only. The reason is the client ops handle printing of
> threads / disk utils separately. The terse output created *by*
> the backend is the right and expected output, so just use that,
> and we can piggy back off of the fact that the server will send
> its own output via FIO_NET_CMD_TEXT.
>
> Another solution is to address getting the disk util data sent
> to be cached locally, and then upon handle_ts() print that, but that
> would require significant re-architecturing.
>
> Terse output is supposed to be just that, terse. This implies
> that it will not be clear from what backend data came from, but
> for this the best strategy is to *extend* the terse version with
> yet another field, the remote hostname/ip address.
>

[...]

> diff --git a/stat.c b/stat.c
> index 82e79dfc..edf9ecf6 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -1922,6 +1922,8 @@ void __show_run_stats(void)
>                 if (is_backend) {
>                         fio_server_send_job_options(opt_lists[i], i);
>                         fio_server_send_ts(ts, rs);
> +                       if (output_format & FIO_OUTPUT_TERSE)
> +                               show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);

What stops the extra disk usage output being suppressed in the
sub-calls from show_thread_status_terse? Were all the early returns
just stop the client requesting things like disk stats periodically
and to just let the servers send it at the end?

-- 
Sitsofe | http://sucs.org/~sits/

