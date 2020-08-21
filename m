Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgHUWQL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Aug 2020 18:16:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A522C061573
        for <fio@vger.kernel.org>; Fri, 21 Aug 2020 15:16:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t14so3186404wmi.3
        for <fio@vger.kernel.org>; Fri, 21 Aug 2020 15:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200811194445.GA152146@dione.lan>
In-Reply-To: <20200811194445.GA152146@dione.lan>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Aug 2020 23:15:44 +0100
Message-ID: <CALjAwxjOvFN2S0YhQyCkKhXUg3Uym1nPOOaPCLWrsbD3F+5bEQ@mail.gmail.com>
Subject: Re: [PATCH] Add fill_quota option
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Bukatovic <martin.bukatovic@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Tue, 11 Aug 2020 at 20:45, Martin Bukatovic
<martin.bukatovic@gmail.com> wrote:
>
<snip>
>
>  #define FIO_TOP_STR_MAX                256
> @@ -633,6 +635,8 @@ struct thread_options_pack {
>         uint32_t allow_mounted_write;
>
>         uint32_t zone_mode;
> +
> +       uint32_t fill_quota;
>  } __attribute__((packed));

If you're changing the wire format you'll have to bump FIO_SERVER_VER
in server.h;;;
>
>  extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
> --
> 2.26.2



-- 
Sitsofe | http://sucs.org/~sits/

