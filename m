Return-Path: <axboe@kernel.dk>
Subject: Re: Windows and TRIM support - files, not devices
References: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
 <CALjAwxgej+e6vSgHf=Vfvx_dkqHoPR7eDMhz85D5Fof=pgRjgg@mail.gmail.com>
 <40890e19-4484-2265-8b24-ef98b6f61717@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9495a910-beb6-76dd-2c1e-3f67c23ef59f@kernel.dk>
Date: Mon, 30 Apr 2018 14:24:21 -0600
MIME-Version: 1.0
In-Reply-To: <40890e19-4484-2265-8b24-ef98b6f61717@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 4/20/18 9:46 AM, Rebecca Cran wrote:
> On 04/20/18 01:15, Sitsofe Wheeler wrote:
> 
>> On 28 January 2017 at 01:05, Rebecca Cran <rebecca@bluestop.org> wrote:
>>> I've been looking at the TRIM support in Windows 8 and newer, and have come
>>> across a potential problem. Other OSes use TRIM on a physical/block device,
>>> but Windows only provides support for TRIM on files.
>>
>> How far did you get with this?
> 
> I didn't do any more work on it after realizing it only worked on files.

Missed this originally - files is totally fine, for what it's worth, on
Linux we could map this to hole punching too. So I don't think that's
a show stopper at all, it'd be perfectly possible to define trim based
workloads just on files. In fact, that's more flexible that what we
currently support on Linux.

-- 
Jens Axboe


