Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3JIPc7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Oct 2013 11:32:59 -0400
Message-ID: <525576F2.6070002@kernel.dk>
Date: Wed, 09 Oct 2013 09:32:02 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH v2] make ioengine specific command line options work
References: <1381330696-11143-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1381330696-11143-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, fio@vger.kernel.org

On 10/09/2013 08:58 AM, Akinobu Mita wrote:
> If the ioengine specific parameter is given on the command line,
> unrelated value in thread_data.o will be corrupted unexpectedly.
> Specifically, if libaio specific parameter userspace_reap is given
> on the command line, thread_data.o.description will be set to 1.
> 
> This fixes it by passing the correct pointer of ioengine specific
> options to the command line parser.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Thanks, applied!


-- 
Jens Axboe

