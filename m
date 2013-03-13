Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37879 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3CMBPf (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 21:15:35 -0400
Received: by mail-vc0-f180.google.com with SMTP id fo13so248274vcb.25
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 18:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363072013-7562-1-git-send-email-olegmatcovsky@gmail.com>
References: <1363072013-7562-1-git-send-email-olegmatcovsky@gmail.com>
Date: Wed, 13 Mar 2013 12:15:34 +1100
Message-ID: <CAKCZDgmZkiTEtw178EZjqaWgrGyXUnD7kKbNM4ymZATeyHow2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] Conditionally include <sys/shm.h> based on OS
 support. Define missing MAP_HUGETLB for Android.
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: olegmatcovsky@gmail.com
Cc: fio@vger.kernel.org

On 12 March 2013 18:06,  <olegmatcovsky@gmail.com> wrote:
> From: Oleg <olegm@olegm-vmware.(none)>
>
> Signed-off-by: Oleg Matcovschi <olegmatcovsky@gmail.com>
> ---
>  backend.c       |    6 +++---
>  init.c          |    7 ++++---
>  memory.c        |    6 +++---
>  os/os-android.h |    4 ++++
>  4 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/backend.c b/backend.c
> index d1fe964..e482fb8 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -34,12 +34,12 @@
>  #include <sys/stat.h>
>  #include <sys/wait.h>
>  #include <sys/ipc.h>
> -#ifndef FIO_NO_HAVE_SHM_H
> -#include <sys/shm.h>
> -#endif
>  #include <sys/mman.h>
>
>  #include "fio.h"
> +#ifndef FIO_NO_HAVE_SHM_H
> +#include <sys/shm.h>
> +#endif
>  #include "hash.h"
>  #include "smalloc.h"
>  #include "verify.h"

Hmm, well that's broken the build.  The following should be applied to
avoid double definition.


diff --git a/configure b/configure
index d1f277d..1827e02 100755
--- a/configure
+++ b/configure
@@ -234,7 +234,7 @@ Android)
   output_sym "CONFIG_CLOCK_GETTIME"
   output_sym "CONFIG_CLOCK_MONOTONIC"
   echo "CC=$cc" >> $config_host_mak
-  echo "EXTFLAGS=$CFLAGS -include config-host.h -DFIO_NO_HAVE_SHM_H
-D_GNU_SOURCE" >> $config_host_mak
+  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >>
$config_host_mak
   exit 0
 esac
