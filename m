Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3KNP7x (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Nov 2013 10:59:53 -0500
Message-ID: <5284F367.4010508@kernel.dk>
Date: Thu, 14 Nov 2013 08:59:35 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: What does "ddir" mean?
References: <CA+8ZFnh+CqzzqsMh=FQw_5pgiiOCQo58eDA4u02iUb7zv1mmcQ@mail.gmail.com>
In-Reply-To: <CA+8ZFnh+CqzzqsMh=FQw_5pgiiOCQo58eDA4u02iUb7zv1mmcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "xan.peng" <xanpeng@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 11/13/2013 06:49 PM, xan.peng wrote:
> Hi all,
> 
> When reading the code, I found DDIR_* and TD_DDIR_* in fio/io_ddir.h.
> Though I figured it out they are related with "rw" option, I'm still
> confused what does "DDIR" mean? DIR=directory? Then what's the first
> 'D'?

ddir is data direction.

-- 
Jens Axboe

