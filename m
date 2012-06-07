Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab2FGPSM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Jun 2012 11:18:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Does ext4 better than raw device ?
References: <CAG1+85GoeaqNQ9vitHcq6be=XTWJ3jBtE=3gm7P1EcJX-7bj1g@mail.gmail.com>
Date: Thu, 07 Jun 2012 11:18:10 -0400
In-Reply-To: <CAG1+85GoeaqNQ9vitHcq6be=XTWJ3jBtE=3gm7P1EcJX-7bj1g@mail.gmail.com>
	(Homer Li's message of "Tue, 5 Jun 2012 14:07:18 +0800")
Message-ID: <x49vcj39mml.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Homer Li <01jay.ly@gmail.com>
Cc: fio@vger.kernel.org

Homer Li <01jay.ly@gmail.com> writes:

> ext4 write rewrite config:
> [global]
> rw=write
> ioengine=libaio
> size=40960m
> numjobs=1
> bssplit=128k/20:256k/20:512k/20:1024k/40
> nrfiles=2
> iodepth=128
> zero_buffers
> timeout=240
> thread
>
> [sdb]
> directory=/export/data0

When using libaio as the ioengine, you should also specify direct=1,
otherwise you won't truly get asynchronous operation.

Cheers,
Jeff
