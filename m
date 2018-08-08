Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:35813 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730262AbeHIA70 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Aug 2018 20:59:26 -0400
Received: by mail-ua0-f172.google.com with SMTP id q12-v6so4235425ual.2
        for <fio@vger.kernel.org>; Wed, 08 Aug 2018 15:37:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqhaYynLHNQeoKGrdEo-0TZq7+dJiTkpoKV7jmhz51cjA@mail.gmail.com>
References: <CAKwzdDqhaYynLHNQeoKGrdEo-0TZq7+dJiTkpoKV7jmhz51cjA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 8 Aug 2018 23:37:10 +0100
Message-ID: <CALjAwxg_wM43mzMBu6V=zm6ThkCe2GjX_Y964KxCxsW8QN1-tA@mail.gmail.com>
Subject: Re: fio percentage_random query
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 7 August 2018 at 19:14, abhishek koundal <akoundal@gmail.com> wrote:
> Does the below syntax means that writes will be random 45% with 55%
> sequential rites?
> rw=randwrite
> percentage_random=0,45,0

Yes, I believe so. Do you see something otherwise?

-- 
Sitsofe | http://sucs.org/~sits/
