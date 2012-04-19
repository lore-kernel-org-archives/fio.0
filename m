Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41396 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2DSFsH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Apr 2012 01:48:07 -0400
Message-ID: <4F8FA704.30006@kernel.dk>
Date: Thu, 19 Apr 2012 07:47:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com> <4F899663.8050406@kernel.dk> <4F8997E9.6090206@kernel.dk> <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com> <4F8D0E1A.2020004@kernel.dk> <CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com>
In-Reply-To: <CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 04/18/2012 11:37 PM, Suresh Dhanarajan wrote:
> Hi Jens,
> 
> Thanks for the patch.
> I checked with the patch given you and found that the offset is
> getting set to zero for every new job.

Are you sure? I hadn't tested the patch myself, until now. It seems to
work just fine here, group_thread_id is contigious until a stonewall is
seen. Works for new job entries and numjobs.

-- 
Jens Axboe

