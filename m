Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:60394 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab1AaKXE (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 31 Jan 2011 05:23:04 -0500
Message-ID: <4D468DA1.90106@fusionio.com>
Date: Mon, 31 Jan 2011 11:23:29 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Error while running fio on a samba share
References: <AANLkTim=h7b8_FRy8D=iYpXs6gdGp7_ReN8Gw5VaMQ0K@mail.gmail.com>
In-Reply-To: <AANLkTim=h7b8_FRy8D=iYpXs6gdGp7_ReN8Gw5VaMQ0K@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefano Doni <stefano.doni@gmail.com>
Cc: fio@vger.kernel.org

On 2011-01-28 23:34, Stefano Doni wrote:
> Hi Jens,
> 
> First of all many thanks for this great tool!
> 
> 
> I wanted to test the performance of a samba network share with fio,
> file server access pattern.
> 
> I can execute it on a local directory without any issue. Too bad, that
> is not the case when I run fio on a directory mounted from a samba
> share.
> 
> I get this error:
> 
> 
> ste@ubuntu:~/.gvfs/fio on localhost$ ~/Downloads/fio-1.50/fio
> ~/iometer-file-access-server.ro --timeout=120
> iometer: (g=0): rw=randread, bs=512-64K/512-64K, ioengine=sync, iodepth=64
> fio 1.50
> Starting 1 process
> fio: pid=4999, err=22/file:filesetup.c:495, func=open(iometer.1.0),
> error=Invalid argument
> 
> 
> Run status group 0 (all jobs):
> 
> 
> I even tried to use a normal sync engine, but the error is still there.

It looks like O_DIRECT is not supported for CIFS, since it fails on the
open. It will probably work if you change the direct=1 to direct=0 in
the job file you use.

-- 
Jens Axboe

