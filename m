Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:40761 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeADHS4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jan 2018 02:18:56 -0500
Received: by mail-vk0-f48.google.com with SMTP id w75so424918vkd.7
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 23:18:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmTRuT8N78A8ZZF6BpHLDv=8WGEmupFhzmD=k0AgT6mYPg@mail.gmail.com>
References: <CALjAwxg0oUu7Lf235M-g1eZKJxCuSpnQJVBwTLYJ-ma0GJY+wg@mail.gmail.com>
 <CAPSTwmTRuT8N78A8ZZF6BpHLDv=8WGEmupFhzmD=k0AgT6mYPg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 4 Jan 2018 07:18:24 +0000
Message-ID: <CALjAwxg1ktpuj+GoLZCNXVdJme47-8buOT6fHsbVn_Epb95JRQ@mail.gmail.com>
Subject: Re: Verify mismatch with buffer_pattern and verify_pattern
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

buffer_pattern=0 but verify_pattern=0x1 - are you sure you want them
to be different?

On 4 January 2018 at 07:16, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Even with addition of --verify=pattern, I step into the failure
>
> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
> --iodepth=1 --name=bs128k_rwread_rsmixr0_qd256 --bs=4096
> --percentage_random=0 --rw=write --filename=/dev/nvme0n1 -o
> /home/temp.log --buffer_pattern=0 --size=409600
>
>
> $ sudo fio --thread --direct=1 --minimal --ioengine=libaio --numjobs=1
> --iodepth=1 --bs=4096 --percentage_random=0 --filename=/dev/nvme0n1 -o
> /home/temp.log --name=bs4096_rwverify_qd256 --size=409600 --rw=read
> --verify_pattern=0x1 --verify=pattern
> fio: got pattern '00', wanted '01'. Bad bits 1
> fio: bad pattern block offset 0
> pattern: verify failed at file /dev/nvme0n1 offset 0, length 0
> fio: verify type mismatch (0 media, 18 given)

-- 
Sitsofe | http://sucs.org/~sits/
