Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([96.73.9.1]:38035 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755726AbeDTPqO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Apr 2018 11:46:14 -0400
Subject: Re: Windows and TRIM support - files, not devices
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
 <CALjAwxgej+e6vSgHf=Vfvx_dkqHoPR7eDMhz85D5Fof=pgRjgg@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <40890e19-4484-2265-8b24-ef98b6f61717@bluestop.org>
Date: Fri, 20 Apr 2018 09:46:13 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgej+e6vSgHf=Vfvx_dkqHoPR7eDMhz85D5Fof=pgRjgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 04/20/18 01:15, Sitsofe Wheeler wrote:

> On 28 January 2017 at 01:05, Rebecca Cran <rebecca@bluestop.org> wrote:
>> I've been looking at the TRIM support in Windows 8 and newer, and have come
>> across a potential problem. Other OSes use TRIM on a physical/block device,
>> but Windows only provides support for TRIM on files.
> 
> How far did you get with this?

I didn't do any more work on it after realizing it only worked on files.

-- 
Rebecca
