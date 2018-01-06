Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:39836 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbeAFLhF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Jan 2018 06:37:05 -0500
Received: by mail-vk0-f45.google.com with SMTP id x64so4936298vkd.6
        for <fio@vger.kernel.org>; Sat, 06 Jan 2018 03:37:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmSN8HSC+Es6ps+yiAejPAQxewD=JfH26QfNjKtT+7NSHA@mail.gmail.com>
References: <CAPSTwmSN8HSC+Es6ps+yiAejPAQxewD=JfH26QfNjKtT+7NSHA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 6 Jan 2018 11:36:34 +0000
Message-ID: <CALjAwxgvfBOkDr2oXTyfm3K47Cgd3WFx6Nc0Lu_AfFHF3KDHKA@mail.gmail.com>
Subject: Re: Specify Start Lba
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

Hi,

On 4 January 2018 at 18:11, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> In FIO, is there an option to specify startLba i.e., the LBA from
> which the write/read should be started.
> Offset option seems to be near one to do this but wanted to confirm if
> there are other options

I'm not aware of any other option other than offset
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
) that controls
where fio starts its initial I/O when doing normal sequential I/O forwards. Be
aware fio often works in terms of bytes - it (usually)
has no awareness of LBAs or LBA sizes because the things it opens are
(usually) byte addressable.

I hesitate to ask but what was wrong with offset?

-- 
Sitsofe | http://sucs.org/~sits/
