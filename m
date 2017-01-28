Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34528 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdA1KTf (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 05:19:35 -0500
Received: by mail-vk0-f54.google.com with SMTP id r136so190514977vke.1
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 02:19:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPqbHXh4m_UgDRtj1Htb8DByZu2JJxQFB-w8wNZthOJkX64tHA@mail.gmail.com>
References: <CAPqbHXh4m_UgDRtj1Htb8DByZu2JJxQFB-w8wNZthOJkX64tHA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Jan 2017 10:10:04 +0000
Message-ID: <CALjAwxh90PZfHmn=0pQmJqF-tPkm=H90_B-Ndi9OCNqJiEA26A@mail.gmail.com>
Subject: Re: Offset in percentage rather than in LBA
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Prabhakaran <prabhugce@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 January 2017 at 21:58, Prabhakaran <prabhugce@gmail.com> wrote:
>
> Can offset be specified in percentage rather than in capacity value
> like gb or mb?

Not at the moment (fio-2.17) but being able to do this was also
requested over in https://github.com/axboe/fio/issues/89 .

-- 
Sitsofe | http://sucs.org/~sits/
