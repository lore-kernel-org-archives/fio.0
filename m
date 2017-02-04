Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35179 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753709AbdBDHmF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Feb 2017 02:42:05 -0500
Received: by mail-vk0-f42.google.com with SMTP id x75so27453561vke.2
        for <fio@vger.kernel.org>; Fri, 03 Feb 2017 23:42:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <o73g1o$ioa$1@blaine.gmane.org>
References: <o72kkc$v07$2@blaine.gmane.org> <CALjAwxiuMVc3tMpb6U5Jw=i+szdj+hwY1gsV_5HmcW1mRr=AaA@mail.gmail.com>
 <o72pn8$7ip$1@blaine.gmane.org> <CALjAwxgStfwH=9kP95g+JctZpunRZ_+zWN2kbzLgXBXLD7ytwQ@mail.gmail.com>
 <o73g1o$ioa$1@blaine.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 4 Feb 2017 07:41:33 +0000
Message-ID: <CALjAwxiBCU0a0TMFGNO1-55W2c-ohXwOdX92K4s0_YMvT_hHbw@mail.gmail.com>
Subject: Re: fio exit run on timeout of device?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Slow bucks <frankwhitebe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

The answer to that is within the value "1s" itself :-) See
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max_latency
and http://fio.readthedocs.io/en/latest/fio_doc.html#parameter-types
for why.

On 4 February 2017 at 02:59, Slow bucks <frankwhitebe@gmail.com> wrote:
> max_latency=1s -> Is that in seconds or milliseconds?
>
> On 2017-02-03 22:44:31 +0000, Sitsofe Wheeler said:
>
>> max_latency=1s

-- 
Sitsofe | http://sucs.org/~sits/
