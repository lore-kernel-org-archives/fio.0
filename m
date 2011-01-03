Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:35423 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab1ACOJl (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Jan 2011 09:09:41 -0500
Message-ID: <4D21D8FC.8070201@fusionio.com>
Date: Mon, 3 Jan 2011 15:11:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: What is random write of FIO?
References: <AANLkTim2bn_eg3ZyVkOyni4by2X6VjFB31hj0RzVsXE6@mail.gmail.com>
In-Reply-To: <AANLkTim2bn_eg3ZyVkOyni4by2X6VjFB31hj0RzVsXE6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Le <wb.danle@gmail.com>
Cc: fio@vger.kernel.org

On 2011-01-02 15:37, Dan Le wrote:
> Hi there,
> 
> I understand that FIO performs sequential writes of small files by
> just sequentially flushing them into the file system. But for random
> writes of either small or large files, how can FIO randomly write
> those files into the file system? I am confused because the manual
> does not clearly explain this feature.

The HOWTO has an explanation on the various service types that you can
use for multiple files. Did you read that one? If yes, then please
expand on your question with that in mind :-)

-- 
Jens Axboe

