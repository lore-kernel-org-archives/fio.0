Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f45.google.com ([209.85.128.45]:38509 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfDXFaV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Apr 2019 01:30:21 -0400
Received: by mail-wm1-f45.google.com with SMTP id w15so3068179wmc.3
        for <fio@vger.kernel.org>; Tue, 23 Apr 2019 22:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <c510fb93-776a-0655-26ad-b046d953fc3d@bluestop.org>
In-Reply-To: <c510fb93-776a-0655-26ad-b046d953fc3d@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 24 Apr 2019 06:30:19 +0100
Message-ID: <CALjAwxgzi+RGQDiMhJq=YSGFwcxFe130vVrMT3GQc-vffZg1nw@mail.gmail.com>
Subject: Re: fio fails to build on Solaris 11.4 x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Rebecca,

On Wed, 24 Apr 2019 at 00:44, Rebecca Cran <rebecca@bluestop.org> wrote:
>
> Since I've been doing a bit of work on Solaris 11.4 x86_64 recently, I
> decided to see if fio works on it.
>
> It turns out it fails to build (using gcc 7.3.0):
>
>
> bcran@solaris:~/workspace/fio$ gmake
>     CC stat.o
> In file included from os/os.h:46:0,
>                  from thread_options.h:5,
>                  from fio.h:18,
>                  from stat.c:7:
> stat.c: In function 'show_thread_status_normal':
> os/os-solaris.h:46:33: error: too many arguments to function 'ctime_r'
>  #define os_ctime_r(x, y, z)     ctime_r((x), (y), (z))
>                                  ^
> stat.c:804:2: note: in expansion of macro 'os_ctime_r'
>   os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
>   ^~~~~~~~~~
> In file included from /usr/include/sys/time.h:447:0,
>                  from /usr/include/sys/select.h:27,
>                  from /usr/include/sys/types.h:665,
>                  from /usr/include/string.h:15,
>                  from stat.c:2:
> /usr/include/time.h:265:14: note: declared here
>  extern char *ctime_r(const time_t *, char *);
>               ^~~~~~~
> In file included from os/os.h:46:0,
>                  from thread_options.h:5,
>                  from fio.h:18,
>                  from stat.c:7:
> stat.c: In function '__show_run_stats':
> os/os-solaris.h:46:33: error: too many arguments to function 'ctime_r'
>  #define os_ctime_r(x, y, z)     ctime_r((x), (y), (z))
>                                  ^
> stat.c:1969:3: note: in expansion of macro 'os_ctime_r'
>    os_ctime_r(&tv_sec, time_buf, sizeof(time_buf));
>    ^~~~~~~~~~
> In file included from /usr/include/sys/time.h:447:0,
>                  from /usr/include/sys/select.h:27,
>                  from /usr/include/sys/types.h:665,
>                  from /usr/include/string.h:15,
>                  from stat.c:2:
> /usr/include/time.h:265:14: note: declared here
>  extern char *ctime_r(const time_t *, char *);
>               ^~~~~~~
> gmake: *** [Makefile:369: stat.o] Error 1
>

I think this is https://github.com/axboe/fio/issues/714 which I never
got around to sending a patch for...


--
Sitsofe | http://sucs.org/~sits/

