Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34971 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdA1NCR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 08:02:17 -0500
Received: by mail-vk0-f51.google.com with SMTP id x75so191595430vke.2
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 05:02:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiC91y8fXNDQ1a1sFeS_DQ1aVQ_jwWib+9xcr_oQ=5cgg@mail.gmail.com>
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk> <CALjAwxiC91y8fXNDQ1a1sFeS_DQ1aVQ_jwWib+9xcr_oQ=5cgg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Jan 2017 13:01:39 +0000
Message-ID: <CALjAwxhnUSjE3EsUz_Q9uOLb-qTWn0FJ5S+97NLxHRL9UYfx1w@mail.gmail.com>
Subject: Re: Windows and TRIM support - files, not devices
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 28 January 2017 at 10:13, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 28 January 2017 at 01:05, Rebecca Cran <rebecca@bluestop.org> wrote:
>> I've been looking at the TRIM support in Windows 8 and newer, and have come
>> across a potential problem. Other OSes use TRIM on a physical/block device,
>> but Windows only provides support for TRIM on files.
>
> What happens when using Hyper-V with raw disks that support thin
> provisioning? Is there some secret kernel only method that converts
> guest requests to the appropriate ATA/SCSI command in that case?
>
> (https://msdn.microsoft.com/en-us/windows/hardware/drivers/storage/thin-provisioning
> wasn't much help)

https://msdn.microsoft.com/en-us/library/windows/hardware/dn653576(v=vs.85).aspx
hints that "applications should use the DSM IOCTLs to perform
UNMAP/TRIM" but I've read elsewhere that "[DeviceDsmAction_Trim]
is not supported for user-mode applications" -
https://msdn.microsoft.com/en-us/library/windows/desktop/ee907416(v=vs.85).aspx
.

-- 
Sitsofe | http://sucs.org/~sits/
