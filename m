Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32913 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbcDPKe4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 16 Apr 2016 06:34:56 -0400
Received: by mail-vk0-f65.google.com with SMTP id v68so17243179vka.0
        for <fio@vger.kernel.org>; Sat, 16 Apr 2016 03:34:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6970D64051BC6047987810C1EE37A0351B695F5F@SSIEXCH-MB3.ssi.samsung.com>
References: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxhD2PW239kH03uuOiaEgaeW8Gn+sFAOytHpUHXHgeXcFA@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B6957A9@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxiRaX5v=v00DhrX2=CS0GwsgHiiw62qgvb5NFumibb2xw@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B695F5F@SSIEXCH-MB3.ssi.samsung.com>
Date: Sat, 16 Apr 2016 11:34:55 +0100
Message-ID: <CALjAwxhktXN=-PqpebHOgq2RzhD6HrzDW101gpjArh=3J6o2pQ@mail.gmail.com>
Subject: Re: sector size other than 512 bytes
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "TK (Tzung-Kwang) Wang-SSI" <tk.wang@ssi.samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 15 April 2016 at 22:19, TK (Tzung-Kwang) Wang-SSI
<tk.wang@ssi.samsung.com> wrote:
> That shows 512 instead of 520,
>
> # cat /sys/block/sdb/queue/logical_block_size
> 512
> # sg_readcap /dev/sdb
> Read Capacity results:
>    Last logical block address=918552575 (0x36bfffff), Number of blocks=918552576
>    Logical block length=520 bytes
> Hence:
>    Device size: 477647339520 bytes, 455520.0 MiB, 477.65 GB

In that case I'd say the issue you're seeing is within the kernel
rather than in fio - the kernel block device is going to refuse
userspace accesses that aren't multiples of 512. Possibly raw SCSI
commands would work?

Is there anything in dmesg about "unsupported sector size" (see
https://github.com/torvalds/linux/blob/v4.5/drivers/scsi/sd.c#L2292
for the check that provokes that message)?

-- 
Sitsofe | http://sucs.org/~sits/
