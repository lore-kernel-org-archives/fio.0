Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28145 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727607AbgBFRww (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Feb 2020 12:52:52 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D18D1800D42
        for <fio@vger.kernel.org>; Thu,  6 Feb 2020 17:52:48 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC1210018FF
        for <fio@vger.kernel.org>; Thu,  6 Feb 2020 17:52:47 +0000 (UTC)
Subject: Re: [PATCH] fio: remove duplicate global definition of tsc_reliable
From: Eric Sandeen <sandeen@redhat.com>
References: <30587810-2ca6-2a7f-f89b-a4f820b28a11@redhat.com>
Message-ID: <3d8e7a16-3fad-6cbf-ea04-78a0010d200d@redhat.com>
Date: Thu, 6 Feb 2020 11:52:47 -0600
MIME-Version: 1.0
In-Reply-To: <30587810-2ca6-2a7f-f89b-a4f820b28a11@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

On 1/31/20 1:19 PM, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Newer gcc v10 complains about globals being defined twice due to
> a new default -fno-common flag. This causes build failures:

Ping?

Thanks,
-Eric

>   LINK t/fio-dedupe
> /usr/bin/ld: t/arch.o:(.bss+0x4): multiple definition of `tsc_reliable'; gettime.o:(.bss+0x4): first defined here
> collect2: error: ld returned 1 exit status
> make: *** [Makefile:499: t/fio-dedupe] Error 1
> 
> Each of the tests which call arch_init() to initialize tsc_reliable:
> 
>   File          Function       Line
> 1 t/dedupe.c    main           536 arch_init(argv);
> 2 t/lfsr-test.c main            37 arch_init(argv);
> 3 t/stest.c     main            86 arch_init(argv);
> 
> already link with gettime.o which defines tsc_reliable,
> so there is no need to provide it from t/arch.c
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I can't really tell if this is the right fix across all arches, but
> maybe someone smarter than me can sort it out? :)
> 
> diff --git a/t/arch.c b/t/arch.c
> index bd28a848..a72cef3a 100644
> --- a/t/arch.c
> +++ b/t/arch.c
> @@ -1,5 +1,4 @@
>  #include "../arch/arch.h"
>  
>  unsigned long arch_flags = 0;
> -bool tsc_reliable;
>  int arch_random;
> 


