Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:46983 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0KUMhs (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 21 Nov 2010 07:37:48 -0500
Message-ID: <4CE91297.9020702@fusionio.com>
Date: Sun, 21 Nov 2010 13:37:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: replay blktrace to different device
References: <AANLkTikuenKFYwi1E005vgFdiHsXAANCAAToip_7woMS@mail.gmail.com>
In-Reply-To: <AANLkTikuenKFYwi1E005vgFdiHsXAANCAAToip_7woMS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-11-20 08:34, Alireza Haghdoost wrote:
> Dear Sebastian
> 
> Did you find any way to reply trace on another device ?

You can do that with the replay_redirect option. See the man page or the
HOWTO. You need a fairly recent fio to do that.

-- 
Jens Axboe

