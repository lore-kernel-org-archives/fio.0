Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34761 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753855AbeDTHQB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Apr 2018 03:16:01 -0400
Received: by mail-vk0-f43.google.com with SMTP id b64so4692267vkf.1
        for <fio@vger.kernel.org>; Fri, 20 Apr 2018 00:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 20 Apr 2018 08:15:29 +0100
Message-ID: <CALjAwxgej+e6vSgHf=Vfvx_dkqHoPR7eDMhz85D5Fof=pgRjgg@mail.gmail.com>
Subject: Re: Windows and TRIM support - files, not devices
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio <fio@vger.kernel.org>

Hi,

On 28 January 2017 at 01:05, Rebecca Cran <rebecca@bluestop.org> wrote:
> I've been looking at the TRIM support in Windows 8 and newer, and have come
> across a potential problem. Other OSes use TRIM on a physical/block device,
> but Windows only provides support for TRIM on files.

How far did you get with this? I recently attempted something over in
https://github.com/sitsofe/fio/commits/win_trim but I've found the
requirements to use mean the disk has to support deterministic read
after TRIM (DRAT) and read zero after TRIM (RZAT) which mean the it
works in less locations than things like Linux's TRIM. I've found the
occasional new SSD, Azure disks and things like mounted VHDs were the
only things it would work on...

-- 
Sitsofe | http://sucs.org/~sits/
