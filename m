Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:36423 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965155AbcJRVJv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2016 17:09:51 -0400
Received: by mail-vk0-f42.google.com with SMTP id 2so8849071vkb.3
        for <fio@vger.kernel.org>; Tue, 18 Oct 2016 14:09:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <711335537.3644077.1476822675982.JavaMail.zimbra@redhat.com>
References: <CAOmo8DaQBEc6f0UdK+Ta-S919PzJXg_qe7fEN7UmdL=tH82maA@mail.gmail.com>
 <711335537.3644077.1476822675982.JavaMail.zimbra@redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 18 Oct 2016 22:09:49 +0100
Message-ID: <CALjAwxi8Wg05_a-0K6Fs4ABPOzUVeLBgpKcXgFdGgLpCs48Gdg@mail.gmail.com>
Subject: Re: Sequential workload with fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ben England <bengland@redhat.com>
Cc: Andrzej Jakowski <andrzej.jakowski@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 18 October 2016 at 21:31, Ben England <bengland@redhat.com> wrote:
> there is an option "--time_based" that does this, I think.
>
> fio --runtime=10 --filesize=25M --filename=/tmp/yyy.fio --bs=4k --name=x --rw=write --time_based

--loops or --io_limit
(https://github.com/axboe/fio/blob/fio-2.14/HOWTO#L498 ) are other
methods method to force wraparound.

-- 
Sitsofe | http://sucs.org/~sits/
