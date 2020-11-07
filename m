Return-Path: <fio-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgKGSPU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Nov 2020 13:15:20 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 284B0F8AE5
        for <fio@vger.kernel.org>; Sat,  7 Nov 2020 12:15:10 -0600 (CST)
Subject: Re: [PATCH, RFC] list all available dynamic ioengines with --enghelp
From: Eric Sandeen <sandeen@sandeen.net>
References: <30a0bc27-4938-0ef3-ffa9-5e06fb8efb3c@redhat.com>
Message-ID: <b1864b03-e0fe-2ffd-7a33-5875b3c31760@sandeen.net>
Date: Sat, 7 Nov 2020 12:15:18 -0600
MIME-Version: 1.0
In-Reply-To: <30a0bc27-4938-0ef3-ffa9-5e06fb8efb3c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

On 11/6/20 4:07 PM, Eric Sandeen wrote:
> When dynamic engines are enabled, "fio --enghelp" does not list all
> available engines as the man page says it will:
> 
> 	If no ioengine is given, list all available ioengines.
> 
> Fix this by opening FIO_EXT_ENG_DIR and attempting dlopen_ioengine
> everything that's found there.

The last(?) thing that would be nice to fix for the dynamic engines is to
not hardcode FIO_EXT_ENG_DIR to /usr/lib/fio since many systems will
be using /usr/lib64, but I'm not really sure how to do that best in
the hardcoded configure world of fio ... I could hack something up.

-Eric

