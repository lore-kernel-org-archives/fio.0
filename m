Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36243 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdA1KOo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 05:14:44 -0500
Received: by mail-ua0-f170.google.com with SMTP id 96so221603314uaq.3
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 02:14:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Jan 2017 10:13:51 +0000
Message-ID: <CALjAwxiC91y8fXNDQ1a1sFeS_DQ1aVQ_jwWib+9xcr_oQ=5cgg@mail.gmail.com>
Subject: Re: Windows and TRIM support - files, not devices
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 28 January 2017 at 01:05, Rebecca Cran <rebecca@bluestop.org> wrote:
> I've been looking at the TRIM support in Windows 8 and newer, and have come
> across a potential problem. Other OSes use TRIM on a physical/block device,
> but Windows only provides support for TRIM on files.

What happens when using Hyper-V with raw disks that support thin
provisioning? Is there some secret kernel only method that converts
guest requests to the appropriate ATA/SCSI command in that case?

(https://msdn.microsoft.com/en-us/windows/hardware/drivers/storage/thin-provisioning
wasn't much help)

-- 
Sitsofe | http://sucs.org/~sits/
