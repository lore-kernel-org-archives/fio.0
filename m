Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:46287 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeH1Cai (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Aug 2018 22:30:38 -0400
Received: by mail-vk0-f68.google.com with SMTP id b14-v6so295748vke.13
        for <fio@vger.kernel.org>; Mon, 27 Aug 2018 15:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 27 Aug 2018 23:41:33 +0100
Message-ID: <CALjAwxj2gkaHOd7XsvVGsqioc0orBc=tguVMfx_=ONYCbvc4LA@mail.gmail.com>
Subject: Re: [PATCH] engines/sg: improve error handling
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio <fio@vger.kernel.org>, Vincent Fu <Vincent.Fu@wdc.com>

On Mon, 27 Aug 2018 at 21:41, Vincent Fu <vincentfu@gmail.com> wrote:
>
> From: Vincent Fu <Vincent.Fu@wdc.com>
>
> The Linux sg driver accepts only 16 SCSI commands in flight
> at a time per file descriptor. fio does not exit gracefully
> when it attempts to queue up 17 or more trim commands via
> the sg ioengine. This patch improves error handling in the

Does this mean the engine should refuse iodepths greater than 16 in
general or are there multiple descriptors?

-- 
Sitsofe | http://sucs.org/~sits/

