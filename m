Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34556 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdAWTXi (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 14:23:38 -0500
Received: by mail-vk0-f52.google.com with SMTP id r136so97525355vke.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 11:23:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com> <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 23 Jan 2017 19:13:51 +0000
Message-ID: <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 23 January 2017 at 18:33, Tobias Oberstein
<tobias.oberstein@gmail.com> wrote:
>
> libaio is nowhere near what I get with engine=sync and high job counts. Mmh.
> Plus the strange behavior.

Have you tried batching the IOs and controlling how much are you
reaping at any one time? See
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth_batch_submit
for some of the options for controlling this...

-- 
Sitsofe | http://sucs.org/~sits/
