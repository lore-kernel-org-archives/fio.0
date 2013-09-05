Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IEUKy (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Sep 2013 16:10:54 -0400
Message-ID: <5228E546.401@kernel.dk>
Date: Thu, 05 Sep 2013 14:10:46 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with ioengine=libaio
 enabled
References: <5228DDC8.9070201@kernel.dk> <1378410970250.8ab05bfc@Nodemailer>
In-Reply-To: <1378410970250.8ab05bfc@Nodemailer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Lam <brianclam@gmail.com>
Cc: fio@vger.kernel.org, Juergen Salk <juergen.salk@uni-ulm.de>

On 09/05/2013 01:56 PM, Brian Lam wrote:
> I experienced an error when trying to use libaio on local disks. I will
> check when I get back to my desk to see if it is similiar to your
> errors.  I vaguely remember getting a segfault so I am not sure if they
> are related. 

That sounds more like a build error, then. I'd make clean, configure,
and make again to be sure.

-- 
Jens Axboe

