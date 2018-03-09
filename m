Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34483 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeCIH2Q (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 02:28:16 -0500
Received: by mail-vk0-f54.google.com with SMTP id z190so1561470vkg.1
        for <fio@vger.kernel.org>; Thu, 08 Mar 2018 23:28:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiK8XcaUaCS+=31iowikHCHRO_js0+R8TYnzwhg4fbjiQ@mail.gmail.com>
References: <CALjAwxiK8XcaUaCS+=31iowikHCHRO_js0+R8TYnzwhg4fbjiQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 9 Mar 2018 07:27:45 +0000
Message-ID: <CALjAwxg-bfA2sia+sSynLKv9i6CgXj6h8sqZMGY2b7uFNUG2Ng@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=E7=AD=94=E5=A4=8D=3A_How_to_ensure_split_verification?=
        =?UTF-8?Q?_will_generate_the_same_configs_as_write_phase=3F?=
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vaughan <cxt9401@163.com>
Cc: fio <fio@vger.kernel.org>

On 9 March 2018 at 07:17, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Another question about write process with "rw=randwrite" and "bsrange=". If run it with "ioengine=libaio iodepth=16", will this async write get any overlap?
>
> Maybe (but you can check the "IO depths" output to see what was
> actually achieved)? Did you see the warning for libaio in the ioengine
> section of the HOWTO
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ioengine
> and look at the libaio heading)?

Perhaps I misunderstood what you mean by overlap and just in case I'll
check whether you've seen
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-norandommap
? When fio picks a random region to write by default it will ensure
that each "spot" is only picked once per loop pass and you would have
to set norandommap to turn this behaviour off. If you aren't randomly
writing multiple loop passes in the same job and you're not writing
without a randommap this is normally enough to stop the same region
being written by the concurrently submitted I/Os.

-- 
Sitsofe | http://sucs.org/~sits/
