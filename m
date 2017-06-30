Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33836 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdF3Xqi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Jun 2017 19:46:38 -0400
Received: by mail-vk0-f46.google.com with SMTP id r125so74300825vkf.1
        for <fio@vger.kernel.org>; Fri, 30 Jun 2017 16:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5fCYutXku8UKOy6r3FaeL_mMQoPmdscWMJsQxeZRM-Dh35qQ@mail.gmail.com>
References: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
 <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com> <CAO5fCYutXku8UKOy6r3FaeL_mMQoPmdscWMJsQxeZRM-Dh35qQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 1 Jul 2017 00:46:06 +0100
Message-ID: <CALjAwxhoX6TvTjpMeyisCst1wZaJQ_iohD1k+4DTw_-+KNk-yA@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nisha Miller <nisha43222@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 1 July 2017 at 00:06, Nisha Miller <nisha43222@gmail.com> wrote:
> Sorry, my previous reply was a bit confusing.
>
> I made the changes to client.c as per the patch. But that did not
> solve the problem. I still get just one terse output at the end of the
> test.

You're right - that patch doesn't solve the problem. Looking closer,
the way that client/server mode operates suggests you'd need to add a
brand new client/server command to arrange for each client to send the
cumulative information you're after to the server so it can print it
out. If so that work looks more involved than I have spare time for...

-- 
Sitsofe | http://sucs.org/~sits/
